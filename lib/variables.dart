import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<Color> pieChartColorList = [
  const Color(0xFF8EACCD),
  const Color(0xFFDEE5D4),
  const Color(0xFFFEF9D9),
  const Color(0xFFF8D7DA),
  const Color(0xFFB5B9C2),
];

List<String> categoryList = [
  '쇼핑',
  '이동',
  '식비',
  '의료',
  '생활',
  '여행',
  '주거',
  '선물',
  '자녀',
  '학습',
  '취미',
  '기타',
];

Map<String, String> categoryIconNameMap = {
  '쇼핑': 'shopping',
  '이동': 'transportation',
  '식비': 'food',
  '의료': 'medical',
  '생활': 'living',
  '여행': 'travel',
  '주거': 'housing',
  '선물': 'present',
  '자녀': 'children',
  '학습': 'learning',
  '취미': 'hobby',
  '기타': 'etc',
};

Map<String, String> categoryToUpperMap = {
  '쇼핑': 'SHOPPING',
  '이동': 'TRANSPORTATION',
  '식비': 'FOOD',
  '의료': 'MEDICAL',
  '생활': 'LIVING',
  '여행': 'TRAVEL',
  '주거': 'HOUSING',
  '선물': 'FAMILY_EVENT_OR_PRESENT',
  '자녀': 'CHILDREN',
  '학습': 'LEARNING',
  '취미': 'HOBBY',
  '기타': 'ETC',
};

Map<String, String> upperToCategoryMap = {
  'SHOPPING': '쇼핑',
  'TRANSPORTATION': '이동',
  'FOOD': '식비',
  'MEDICAL': '의료',
  'LIVING': '생활',
  'TRAVEL': '여행',
  'HOUSING': '주거',
  'FAMILY_EVENT_OR_PRESENT': '선물',
  'CHILDREN': '자녀',
  'LEARNING': '학습',
  'HOBBY': '취미',
  'ETC': '기타',
};

// 업적 배지
List<Map<String, String>> badgeList = [
  {
    'name': 'SIGN_UP_COMPLETE',
    'title': '배지 1',
    'description': '회원가입 완료!',
    'image': 'assets/images/badge/badge1_color.png',
    'whiteImage': 'assets/images/badge/badge1_black.png',
  },
  {
    'name': 'SHARED_TO_THREE_FRIENDS',
    'title': '배지 2',
    'description': '친구 3명에게 공유하기 완료!',
    'image': 'assets/images/badge/badge2_color.png',
    'whiteImage': 'assets/images/badge/badge2_black.png',
  },
  {
    'name': 'FIRST_EXPENSE_OBJECTIVE_ADD',
    'title': '배지 3',
    'description': '첫 목표 추가 완료!',
    'image': 'assets/images/badge/badge3_color.png',
    'whiteImage': 'assets/images/badge/badge3_black.png',
  },
  {
    'name': 'FIRST_EXPENSE_OBJECTIVE_ACHIEVE',
    'title': '배지 4',
    'description': '첫 목표 달성 완료!',
    'image': 'assets/images/badge/badge4_color.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
  },
  {
    'name': 'FIRST_RANDOM_BOX_TRIAL',
    'title': '배지 5',
    'description': '첫 뽑기 시도 완료!',
    'image': 'assets/images/badge/badge5_color.png',
    'whiteImage': 'assets/images/badge/badge5_black.png',
  },
  {
    'name': 'FIRST_RANDOM_BOX_SUCCESS',
    'title': '배지 6',
    'description': '첫 뽑기 성공 완료!',
    'image': 'assets/images/badge/badge6_color.png',
    'whiteImage': 'assets/images/badge/badge6_black.png',
  },
  {
    'name': 'CONSECUTIVE_EXPENSE_OBJECTIVE_ACHIEVE',
    'title': '배지 7',
    'description': '11월 목표 달성 완료!',
    'image': 'assets/images/badge/badge7_color.png',
    'whiteImage': 'assets/images/badge/badge7_black.png',
  },
  {
    'name': 'SPECIFIC_MONTH_EXPENSE_OBJECTIVE_ACHIEVE',
    'title': '배지 8',
    'description': '2개월 연속 목표 달성 완료!',
    'image': 'assets/images/badge/badge8_color.png',
    'whiteImage': 'assets/images/badge/badge8_black.png',
  },
];

// 요일(숫자) - 요일(문자)
Map<int, String> dayText = {
  1: '월',
  2: '화',
  3: '수',
  4: '목',
  5: '금',
  6: '토',
  7: '일',
};

// // 요일(숫자) - point
// Map<int, int> attendanceReward = {
//   1: 40, // 월
//   2: 40, // 화
//   3: 80,
//   4: 80,
//   5: 120,
//   6: 160,
//   7: 200,
// };

// 출석 포인트
Map<int, int> attendanceReward = {
  1: 20, // 연속 1일차
  2: 30, // 연속 2일차 ...
  3: 40,
  4: 50,
  5: 60,
};

Map<int, Map<String, int>> spendingByAgeCategory = {
  30: {
    'SHOPPING': 113000, // 의류-신발
    'TRANSPORTATION': 211000, // 교통
    'FOOD': 136000 + 398000, // 식료품-비주류음료, 음식-숙박
    'MEDICAL': 83000, // 보건
    'LIVING': 35000 + 69000 + 84000, // 주류-담배, 가정용품-가사서비스, 통신
    'TRAVEL': 0, // 없음
    'HOUSING': 290000, // 주거-수도-광열
    'FAMILY_EVENT_OR_PRESENT': 0, // 없음
    'CHILDREN': 0, // 없음
    'LEARNING': 51000, // 교육
    'HOBBY': 165000, //오락-문화
    'ETC': 134000, // 기타상품-서비스
    'MAX': 136000 + 398000, // *최댓값*
  },
  40: {
    'SHOPPING': 96000, // 의류-신발
    'TRANSPORTATION': 247000, // 교통
    'FOOD': 192000 + 342000, // 식료품-비주류음료, 음식-숙박
    'MEDICAL': 145000, // 보건
    'LIVING': 57000 + 74000 + 94000, // 주류-담배, 가정용품-가사서비스, 통신
    'TRAVEL': 0, // 없음
    'HOUSING': 287000, // 주거-수도-광열
    'FAMILY_EVENT_OR_PRESENT': 0, // 없음
    'CHILDREN': 0, // 없음
    'LEARNING': 27000, // 교육
    'HOBBY': 138000, //오락-문화
    'ETC': 155000, // 기타상품-서비스
    'MAX': 192000 + 342000, // *최댓값*
  },
  50: {
    'SHOPPING': 64000, // 의류-신발
    'TRANSPORTATION': 236000, // 교통
    'FOOD': 216000 + 259000, // 식료품-비주류음료, 음식-숙박
    'MEDICAL': 143000, // 보건
    'LIVING': 49000 + 59000 + 77000, // 주류-담배, 가정용품-가사서비스, 통신
    'TRAVEL': 0, // 없음
    'HOUSING': 290000, // 주거-수도-광열
    'FAMILY_EVENT_OR_PRESENT': 0, // 없음
    'CHILDREN': 0, // 없음
    'LEARNING': 18000, // 교육
    'HOBBY': 95000, //오락-문화
    'ETC': 137000, // 기타상품-서비스
    'MAX': 216000 + 259000, // *최댓값*
  },
  60: {
    'SHOPPING': 40000, // 의류-신발
    'TRANSPORTATION': 84000, // 교통
    'FOOD': 254000 + 123000, // 식료품-비주류음료, 음식-숙박
    'MEDICAL': 166000, // 보건
    'LIVING': 21000 + 58000 + 37000, // 주류-담배, 가정용품-가사서비스, 통신
    'TRAVEL': 0, // 없음
    'HOUSING': 240000, // 주거-수도-광열
    'FAMILY_EVENT_OR_PRESENT': 0, // 없음
    'CHILDREN': 0, // 없음
    'LEARNING': 4000, // 교육
    'HOBBY': 41000, //오락-문화
    'ETC': 81000, // 기타상품-서비스
    'MAX': 254000 + 123000, // *최댓값*
  },
};
