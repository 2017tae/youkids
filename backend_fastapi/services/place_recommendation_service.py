import pandas as pd
import numpy as np
import random
from scipy.sparse.linalg import svds
from models.place_item import PlaceItem

def dataframe_to_object_list(df):
    object_list = []
    for _, row in df.iterrows():
        # if row['image_url'] == None: row['image_url'] = ''
        place_item = PlaceItem(**row.to_dict())
        object_list.append(place_item)
    return object_list

def get_recommendations_by_category(recommendations, category, count, num, ratio):
    category_recommendations = recommendations[recommendations['category'] == category]
    start_idx = int(count * num * ratio)
    end_idx = int((count + 1) * num * ratio)
    
    if start_idx >= len(category_recommendations):
        return []
    
    if end_idx > len(category_recommendations):
        end_idx = len(category_recommendations)
        
    return dataframe_to_object_list(category_recommendations[start_idx:end_idx])

def get_recommend_place(df_svd_preds: pd.DataFrame, user_id: str, place, click, count, num=40):

    # 최종적으로 만든 pred_df에서 사용자 index에 따라 장소 데이터 정렬 -> 장소 별점이 높은 순으로 정렬됨
    sorted_user_predictions = df_svd_preds.loc[user_id].sort_values(ascending=False)

    # 원본 리뷰 데이터에서 user_id에 해당하는 데이터를 뽑아냄
    user_data = click[click.user_id == user_id]

    # 위에서 뽑은 user_data와 원본 장소 데이터를 합침
    user_history = user_data.merge(place, on='place_id').sort_values(['click_count'], ascending=False)

    # 원본 장소 데이터에서 사용자가 참여한 장소 데이터를 제외한 데이터를 추출
    recommendations = place[~place['place_id'].isin(user_history['place_id'])]
    # 사용자의 별점이 높은 순으로 정렬된 데이터와 위 recommendations를 합침
    recommendations = recommendations.merge(pd.DataFrame(sorted_user_predictions).reset_index(), on='place_id')
    # 컬럼 이름 바꾸고 정렬
    recommendations = recommendations.rename(columns={user_id: 'Predictions'}).sort_values('Predictions', ascending=False)
    # 'Predictions' 컬럼 삭제
    recommendations = recommendations.drop('Predictions', axis=1)
    
    kids_cafe_ratio = 0.5
    theme_park_ratio = 0.25
    museum_ratio = 0.25
    
    kids_cafe_recommendations = get_recommendations_by_category(recommendations, '키즈카페', count, num, kids_cafe_ratio)
    theme_park_recommendations = get_recommendations_by_category(recommendations, '테마파크', count, num, theme_park_ratio)
    museum_recommendations = get_recommendations_by_category(recommendations, '박물관', count, num, museum_ratio)
    
    result_list = kids_cafe_recommendations + theme_park_recommendations + museum_recommendations
    random.shuffle(result_list)
    return result_list

def cal_preds_place(place_df, click_df):
    # place 데이터와 click 데이터를 조인함
    user_place_click = pd.merge(place_df, click_df, on='place_id', how='left')
    # pivot_table 생성 (sparse matrix)
    # NaN 값을 0으로 치환
    click_pivot = user_place_click.pivot(index='user_id', columns='place_id', values='click_count').fillna(0)
    
    # matrix : pivot_table을 numpy matrix로 바꾼 것
    matrix = click_pivot.to_numpy().astype(float)
    matrix = matrix[1:]
    
    # user_click_mean은 사용자의 평균 클릭 수
    user_click_mean = np.mean(matrix, axis=1)
    
    # R_user_mean은 사용자-장소에 대해 사용자 평균 평점을 뺀 것
    matrix_user_mean = matrix - user_click_mean.reshape(-1, 1)
    
    # scipy에서 제공해주는 svd
    # k는 함께 파라미터로 전달되는 배열 A의 row크기보다 작아야 함, 따라서 양수 중 최대 12로 조정
    U, sigma, Vt = svds(matrix_user_mean, k = min(max(matrix_user_mean.shape[0]-1, 0), 12))
    
    sigma = np.diag(sigma)
    
    # 역계산
    svd_user_predicted_clicks = np.dot(np.dot(U, sigma), Vt) + user_click_mean.reshape(-1, 1)
    df_svd_preds = pd.DataFrame(svd_user_predicted_clicks, columns = click_pivot.columns, index = click_pivot.index[1:])
    
    return df_svd_preds
    