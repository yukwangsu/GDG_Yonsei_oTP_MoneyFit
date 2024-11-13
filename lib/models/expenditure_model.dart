import 'package:flutter/material.dart';

class ExpenditureModel {
  String svgIcon;
  String category;
  String date;
  int spend;

  ExpenditureModel({
    required this.svgIcon,
    required this.category,
    required this.date,
    required this.spend,
  });
}
