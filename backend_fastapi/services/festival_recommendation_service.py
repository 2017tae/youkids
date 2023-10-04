import pymysql.cursors
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics.pairwise import cosine_similarity
from scipy.sparse import hstack
from models.festival_item import FestivalItem
# DataFrame을 객체의 리스트로 변환하는 함수
def dataframe_to_object_list(df):
    object_list = []
    for _, row in df.iterrows():
        festival_item = FestivalItem(**row.to_dict())
        object_list.append(festival_item)
    return object_list

def recomm_festival(cos_sim, festival, id, top=10):

    if cos_sim is None or festival is None:
        return {"error": "Initialization not complete"}
    
    target_festival_index = festival[festival['each_id'] == id].index[0]
    sim_scores = list(enumerate(cos_sim[target_festival_index]))
    sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
    # 자기 자신을 제외하고 상위 유사한 아이템 선택
    sim_scores = [x for x in sim_scores if x[0] != target_festival_index]
    sim_scores = sim_scores[:top]
    similar_festivals_indices = [i[0] for i in sim_scores]
    result = festival.iloc[similar_festivals_indices]
    return dataframe_to_object_list(result)