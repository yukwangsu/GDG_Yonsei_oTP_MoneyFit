import pandas as pd
from sklearn.ensemble import IsolationForest
import json
import os
from dotenv import load_dotenv
import psycopg2
from psycopg2.extras import RealDictCursor

# .env 파일 로드
load_dotenv()
# 데이터베이스 연결 정보 가져오기
db_config = {
    "dbname": os.getenv("DB_NAME"),
    "user": os.getenv("DB_USERNAME"),
    "password": os.getenv("DB_PASSWORD"),
    "host": os.getenv("DATABASE_URL").split("//")[1].split(":")[0],
    "port": os.getenv("PORT")
}

# postgre 데이터 가져오는 함수
def get_last_month_expenses(user_email):
    """
    주어진 사용자의 저번 달 소비 기록을 가져오는 함수.
    """
    try:
        # 데이터베이스 연결
        connection = psycopg2.connect(**db_config)
        cursor = connection.cursor(cursor_factory=RealDictCursor)  # 결과를 딕셔너리로 반환

        # 저번 달 소비 기록 조회
        query = """
        SELECT *
        FROM your_table_name
        WHERE member_email = %s
          AND date_time >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 month')
          AND date_time < DATE_TRUNC('month', CURRENT_DATE);
        """
        cursor.execute(query, (user_email,))  # 사용자 이메일을 바인딩하여 쿼리 실행
        rows = cursor.fetchall()

        # 결과 반환
        return rows

    except Exception as e:
        print(f"오류 발생: {e}")
        return None

    finally:
        # 연결 종료
        if 'cursor' in locals() and cursor:
            cursor.close()
        if 'connection' in locals() and connection:
            connection.close()

            

# 전월 데이터 가져오기
def update_model(rows):   
    # JSON 데이터를 데이터프레임으로 변환
    data = pd.DataFrame(rows)

    # 거래금액을 숫자로 변환
    data['expense_amount'] = data['expense_amount'].str.replace(',', '').astype(float)
    # 거래일시를 날짜로 변환
    data['date_time'] = pd.to_datetime(data['date_time'])
    
    # 카테고리별 모델 학습
    models = {}
    
    for category in data['upper_category_type'].unique():
        category_data = data[data['upper_category_type'] == category][['upper_category_type']]
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