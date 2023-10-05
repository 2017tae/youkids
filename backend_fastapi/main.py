import pymysql
import pandas as pd
import numpy as np
import boto3
from datetime import datetime
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import MinMaxScaler
from scipy.sparse import hstack
from sklearn.metrics.pairwise import cosine_similarity
from services.festival_recommendation_service import recomm_festival
from services.place_recommendation_service import cal_preds_place, get_recommend_place, dataframe_to_object_list
from models.region_data import RegionData
from fastapi import FastAPI, HTTPException
from decouple import config

app = FastAPI()

# 모듈 수준의 변수를 사용하여 상태를 유지
category_cos_sim = None
festival_dto_df = None

# 각 인덱스는 각각의 지역에 대한 place 데이터, click 데이터, click 데이터 갱신 날짜, dynamoDB 테이블을 포함
region_data = [RegionData() for _ in range(6)]

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
for i in range(1, 6):
    region_data[i].table = f'ClickCounts{i}'

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
    global region_data
    for i in range(1, 6):
        sql = f"SELECT p.place_id, p.name, p.address, p.category, p.visited_review_num, (SELECT pi.url FROM place_image pi WHERE pi.place_id = p.place_id LIMIT 1) AS image_url\
            FROM place p where visited_review_num = {i};"
        cursor.execute(sql)
        result = cursor.fetchall()
        region_data[i].place_df = result
# festival 추천
@app.get("/festival/{festival_id}")
def recommend_festival(festival_id: int):
    global category_cos_sim, festival_dto_df

    recommended_festival = recomm_festival(cos_sim=category_cos_sim, festival=festival_dto_df, id=festival_id)
    return {"recommended_festival": recommended_festival}

# place 추천
@app.get("/place/{region_code}/{user_id}/{count}")
def recommend_place(region_code: int, user_id: str, count: int):
    global region_data, dynamodb
    data = region_data[region_code]
    table = dynamodb.Table(data.table)
    
    if (data.click_df == None) or (data.svd_preds_df == None) or (data.update_date != datetime.today()):
        # click_df or svd_preds_df 값이 없거나 갱신한 날짜가 지났으면 갱신 작업
        response = table.scan()
        items = response['Items']
        data.click_df = items
        data.svd_preds_df = cal_preds_place(pd.DataFrame(data.place_df), pd.DataFrame(data.click_df)).to_dict(orient='records')
        data.update_date = datetime.today()
    
    click = pd.DataFrame(data.click_df)
    place = pd.DataFrame(data.place_df)
    
    # 유저가 클릭한 장소의 개수로 판별
    recommended_place = None
    user_click_count = count_user_clicks(user_id, click)
    
    if user_click_count >= 5:
        df_svd_preds = pd.DataFrame(data.svd_preds_df, index=click['user_id'].drop_duplicates(), columns=place['place_id'])
        recommended_place = get_recommend_place(df_svd_preds=df_svd_preds, click=click, place=place, user_id=user_id, count=count)
    else:
        total_users_clicks = calculate_total_users_clicks(click)
        sorted_places = total_users_clicks.sort_values(by='total_users_clicks', ascending=False)
        merged_places = sorted_places.merge(place, on='place_id', how='right').fillna(0).sort_values(['total_users_clicks'], ascending=False)
        
        start_idx = count * 40
        end_idx = (count + 1) * 40
        
        if start_idx >= len(merged_places):
            recommended_place = []
        
        else:
            if end_idx > len(merged_places):
                end_idx = len(merged_places)
            
            recommended_place = dataframe_to_object_list(merged_places[start_idx:end_idx])
    
    return {"recommended_place": recommended_place}

# 클릭 수 Update 
@app.put("/clicks/{region_code}/{user_id}/{place_id}")
def update_click_count(region_code: int, user_id: str, place_id: int):
    
    if user_id is None:
        return
    
    global region_data, dynamodb
    table = dynamodb.Table(region_data[region_code].table)
    try:
        # 기존 아이템을 조회
        existing_item = table.get_item(Key={'user_id': user_id, 'place_id': place_id}).get('Item')
        updated_click_count = 1

        if existing_item:
            # 기존 아이템이 있는 경우 click_count를 1 올린 후 업데이트
            updated_click_count = existing_item['click_count'] + 1
            # click_count가 1000을 넘지 않는 경우에만 업데이트
            condition_expression = 'click_count < :max_count'
            expression_attribute_values = {':val': updated_click_count, ':max_count': 100}
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

# 1. 특정 유저가 클릭한 place의 개수를 세는 함수
def count_user_clicks(user_id, click_df):
    return len(click_df[click_df['user_id'] == user_id])

# 2. 모든 장소에 대해 클릭한 총 유저의 수를 계산하는 함수
def calculate_total_users_clicks(click_df):
    total_users_clicks = click_df.groupby('place_id').size().reset_index(name='total_users_clicks')
    return total_users_clicks

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
