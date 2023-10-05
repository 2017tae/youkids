import pymysql
import pandas as pd
import numpy as np
import boto3
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import MinMaxScaler
from scipy.sparse import hstack
from sklearn.metrics.pairwise import cosine_similarity
from services.festival_recommendation_service import recomm_festival
from services.place_recommendation_service import cal_preds_place
from fastapi import FastAPI, HTTPException
from decouple import config

app = FastAPI()

# 모듈 수준의 변수를 사용하여 상태를 유지
category_cos_sim = None
festival_dto_df = None
place_df = None

# AWS 자격 증명 설정 (Access Key ID와 Secret Access Key)
aws_access_key_id = config('AWS_ACCESS_KEY')
aws_secret_access_key = config('AWS_SECRET_ACCESS_KEY')
aws_region = config('AWS_REGION')  # AWS 지역 설정

# DynamoDB 리소스 생성
dynamodb = boto3.resource('dynamodb',
                        aws_access_key_id=aws_access_key_id,
                        aws_secret_access_key=aws_secret_access_key,
                        region_name=aws_region)

# DynamoDB 테이블 연결
table = dynamodb.Table('ClickCounts')

# MySQL 환경변수 가져오기
MYSQL_HOST = config('MYSQL_HOST')
MYSQL_PORT = config('MYSQL_PORT', default=3306, cast=int)
MYSQL_USER = config('MYSQL_USER')
MYSQL_PWD = config('MYSQL_PWD')
MYSQL_DB = config('MYSQL_DB')

# SQL 연결
connection = pymysql.connect(host=MYSQL_HOST, port=MYSQL_PORT, user=MYSQL_USER,
                            password=MYSQL_PWD, db=MYSQL_DB,
                            charset='utf8', autocommit=False,
                            cursorclass=pymysql.cursors.DictCursor)

cursor = connection.cursor()

def cal_similarity():
    global category_cos_sim, festival_dto_df, connection, cursor

    # festival_child의 값을 가져오기
    sql = "select * from festival_child"
    cursor.execute(sql)
    result = cursor.fetchall()

    # festival_child DataFrame화
    festival = pd.DataFrame(result)

    # 주요 컬럼으로 데이터 프레임 생성
    col_list = ['festival_child_id', 'each_id', 'name', 'start_date', 'end_date', 'state', 'category', 'open_run', 'poster', 'run_time', 'age', 'latitude', 'longitude', 'address']
    festival_df = festival[col_list]
    
    col_list = ['festival_child_id', 'each_id', 'name', 'start_date', 'end_date', 'state', 'category', 'open_run', 'poster', 'place_name']
    festival_dto_df = festival[col_list]

    # ngram_range : 단어를 숫자로 계산할 때 고려하는 단어의 수에 대한 range
    # i love python
    # ngram이 1인 경우 : 'i', 'love', 'python'
    # 2인 경우 : 'i love', 'love python'
    # 3인 경우 : 'i love python'
    count_vector = CountVectorizer(ngram_range=(1, 3))
    c_vector_category = count_vector.fit_transform(festival_df['category'])

    # age, latitude, longitude NaN값 없애기
    festival_df['age'].fillna(festival_df['age'].mean(), inplace=True)
    festival_df['latitude'].fillna(festival_df['latitude'].mean(), inplace=True)
    festival_df['longitude'].fillna(festival_df['longitude'].mean(), inplace=True)

    # age, latitude, longitude 컬럼 벡터화(정규화)
    scaler = MinMaxScaler()
    age_normalized = scaler.fit_transform(festival_df[['age']])
    lat_normalized = scaler.fit_transform(festival_df[['latitude']])
    lng_normalized = scaler.fit_transform(festival_df[['longitude']])

    # 숫자 데이터 합치기
    combined_numeric_features = np.hstack((age_normalized, lat_normalized, lng_normalized))

    # 벡터 데이터 합치기
    combined_features_matrix = hstack([c_vector_category, combined_numeric_features])

    # 코사인 유사도를 구한 벡터를 미리 저장
    category_cos_sim = cosine_similarity(combined_features_matrix, combined_features_matrix)

@app.on_event("startup")
def startup_event():
    # 서버 시작 시 cal_similarity 함수 실행
    cal_similarity()
    
    # Place 데이터 조회
    global place_df
    sql = "SELECT p.place_id, p.name, p.address, p.category, (SELECT pi.url FROM place_image pi WHERE pi.place_id = p.place_id LIMIT 1) AS image_url\
        FROM place p;"
    cursor.execute(sql)
    result = cursor.fetchall()
    place_df = pd.DataFrame(result)

# festival 추천
@app.get("/festival/{festival_id}")
def recommend_festival(festival_id: int):
    global category_cos_sim, festival_dto_df

    recommended_festival = recomm_festival(cos_sim=category_cos_sim, festival=festival_dto_df, id=festival_id)
    return {"recommended_festival": recommended_festival}

# place 추천
@app.get("/place/{user_id}")
def recommend_place(user_id: str):
    global table, place_df
    
    # click 데이터 조회
    response = table.scan()
    items = response['Items']
    click_df = pd.DataFrame(items)
    
    recommended_place = cal_preds_place(place_df, click_df, user_id)
    # cal_preds_place(place_df, click_df, user_id)
    return {"recommended_place": recommended_place}

# 클릭 수 Update 
@app.put("/clicks/{user_id}/{place_id}")
def update_click_count(user_id: str, place_id: int):
    global table
    try:
        # 기존 아이템을 조회
        existing_item = table.get_item(Key={'user_id': user_id, 'place_id': place_id}).get('Item')
        updated_click_count = 1

        if existing_item:
            # 기존 아이템이 있는 경우 click_count를 1 올린 후 업데이트
            updated_click_count = existing_item['click_count'] + 1
            # click_count가 1000을 넘지 않는 경우에만 업데이트
            condition_expression = 'click_count < :max_count'
            expression_attribute_values = {':val': updated_click_count, ':max_count': 1000}
            table.update_item(
                Key={'user_id': user_id, 'place_id': place_id},
                UpdateExpression='SET click_count = :val',
                ConditionExpression=condition_expression,
                ExpressionAttributeValues=expression_attribute_values,
                ReturnValues='UPDATED_NEW'
            )
        else:
            # 기존 아이템이 없는 경우 새로운 아이템 추가
            table.put_item(
                Item={
                    'user_id': user_id,
                    'place_id': place_id,
                    'click_count': 1
                }
            )

        return {"user_id": user_id, "place_id": place_id, "click_count": updated_click_count}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
