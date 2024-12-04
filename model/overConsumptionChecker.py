import pandas as pd
from sklearn.ensemble import IsolationForest
import json

# 전월 데이터 가져오기
def update_model(prev_month_path):
    with open(prev_month_path, 'r', encoding='utf-8') as json_file:
        json_data = json.load(json_file)
    
    # JSON 데이터를 데이터프레임으로 변환
    data = pd.DataFrame(json_data)

    # 거래금액을 숫자로 변환
    data['거래금액'] = data['거래금액'].str.replace(',', '').astype(float)
    # 거래일시를 날짜로 변환
    data['거래일시'] = pd.to_datetime(data['거래일시'])
    
    # 카테고리별 모델 학습
    models = {}
    
    for category in data['카테고리'].unique():
        category_data = data[data['카테고리'] == category][['거래금액']]
        model = IsolationForest(contamination=0.1, random_state=42)
        model.fit(category_data)  # 카테고리별로 모델 학습
        models[category] = model
        
    return models


def is_overConsumption(new_data, models):
    category = new_data['카테고리']
    if category in models:
        model = models[category]
        new_data_value = pd.DataFrame([[float(new_data['거래금액'].replace(",", ""))]], columns=['거래금액'])
        new_data['is_outlier'] = model.predict(new_data_value)[0]  # -1: 이상치, 1: 정상치
        new_data['anomaly_score'] = model.decision_function(new_data_value)[0]  # 정상성 점수
    else:
        new_data['is_outlier'] = None
        new_data['anomaly_score'] = None
        print(f"카테고리 '{category}'에 대한 데이터가 부족하여 평가할 수 없습니다.")
        
    is_outlier = True if new_data['is_outlier'] == -1 else False
    outlier_score = round(new_data['anomaly_score'], 4)
    
    return is_outlier, outlier_score