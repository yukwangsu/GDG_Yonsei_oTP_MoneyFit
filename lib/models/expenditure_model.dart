// import 'package:flutter/material.dart';

// class ExpenditureModel {
//   String svgIcon;
//   String category;
//   String date;
//   int spend;

//   ExpenditureModel({
//     required this.svgIcon,
//     required this.category,
//     required this.date,
//     required this.spend,
//   });
// }

class ExpenditureListModel {
  final List<ExpenditureModel> expenditureList;

  ExpenditureListModel.fromJson(json)
      : expenditureList = List<ExpenditureModel>.from(json.map(
            (expenditureJson) => ExpenditureModel.fromJson(expenditureJson)));
}

class ExpenditureModel {
  final int id, expenseAmount;
  final String memberEmail, upperCategoryType, dateTime;

  ExpenditureModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] ?? 0,
        expenseAmount = json['expenseAmount'] ?? 0,
        memberEmail = json['memberEmail'] ?? '',
        upperCategoryType = json['upperCategoryType'] ?? '',
        dateTime = json['dateTime'] ?? '';
}
