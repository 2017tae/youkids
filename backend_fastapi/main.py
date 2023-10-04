import pymysql
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import MinMaxScaler
from scipy.sparse import hstack
from sklearn.metrics.pairwise import cosine_similarity
from services.festival_recommendation_service import recomm_festival
from models.festival_item import FestivalItem

from fastapi import FastAPI

app = FastAPI()

# 모듈 수준의 변수를 사용하여 상태를 유지
category_cos_sim = None
festival_dto_df = None

def cal_similarity():
    global category_cos_sim, festival_dto_df
    
    # SQL 연결
    connection = pymysql.connect(host='j9a604.p.ssafy.io', port=3306, user='root',
                                password='xhfldhkwlsdldhkzhzh', db='S09P22A604',
                                charset='utf8', autocommit=False,
                                cursorclass=pymysql.cursors.DictCursor)

    cursor = connection.cursor()

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

@app.get("/fastapi/festival/{festival_id}")
def recommend_festival(festival_id: str):
    global category_cos_sim, festival_dto_df

    recommended_festival = recomm_festival(cos_sim=category_cos_sim, festival=festival_dto_df, id=festival_id)
    return {"recommended_festival": recommended_festival}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
