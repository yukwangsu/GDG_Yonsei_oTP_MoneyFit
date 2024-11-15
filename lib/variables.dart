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

// Map<String, List<int>> categoryIconLocationMap = {
//   '쇼핑': [0, 0],
//   '이동': [0, 1],
//   '식비': [0, 2],
//   '의료': [0, 3],
//   '생활': [1, 0],
//   '여행': [1, 1],
//   '주거': [1, 2],
//   '선물': [1, 3],
//   '자녀': [2, 0],
//   '학습': [2, 1],
//   '취미': [2, 2],
//   '기타': [2, 3],
// };
