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
    'title': '배지 1',
    'description': '회원가입 완료!',
    'image': 'assets/images/badge/badge1_color.png',
    'whiteImage': 'assets/images/badge/badge1_color.png',
  },
  {
    'title': '배지 2',
    'description': '친구 3명에게 공유하기 완료!',
    'image': 'assets/images/badge/badge2_color.png',
    'whiteImage': 'assets/images/badge/badge2_color.png',
  },
  {
    'title': '배지 3',
    'description': '첫 목표 추가 완료!',
    'image': 'assets/images/badge/badge3_color.png',
    'whiteImage': 'assets/images/badge/badge3_color.png',
  },
  {
    'title': '배지 4',
    'description': '첫 목표 달성 완료!',
    'image': 'assets/images/badge/badge4_black.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
  },
  {
    'title': '배지 5',
    'description': '첫 뽑기 시도 완료!',
    'image': 'assets/images/badge/badge4_black.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
  },
  {
    'title': '배지 6',
    'description': '첫 뽑기 성공 완료!',
    'image': 'assets/images/badge/badge4_black.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
  },
  {
    'title': '배지 7',
    'description': '11월 목표 달성 완료!',
    'image': 'assets/images/badge/badge4_black.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
  },
  {
    'title': '배지 8',
    'description': '2개월 연속 목표 달성 완료!',
    'image': 'assets/images/badge/badge4_black.png',
    'whiteImage': 'assets/images/badge/badge4_black.png',
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

// 요일(숫자) - point
Map<int, int> attendanceReward = {
  1: 40, // 월
  2: 40, // 화
  3: 80,
  4: 80,
  5: 120,
  6: 160,
  7: 200,
};
