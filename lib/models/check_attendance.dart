class CheckAttendanceModel {
  final int consecutiveDaysBeforeGetAttendancePoints;
  final bool doesGetPointsToday;
  // final List<CategoryExpenditureModel> monthlyCategoryExpenditureList;

  CheckAttendanceModel.fromJson(json)
      : consecutiveDaysBeforeGetAttendancePoints =
            json['consecutiveDaysBeforeGetAttendancePoints'],
        doesGetPointsToday = json['doesGetPointsToday'];

  // monthlyCategoryExpenditureList = List<CategoryExpenditureModel>.from(
  //       json.map((expenditureJson) =>
  //           CategoryExpenditureModel.fromJson(expenditureJson)));
}

// class CategoryExpenditureModel {
//   final int totalExpense;
//   final String category;

//   CategoryExpenditureModel.fromJson(Map<dynamic, dynamic> json)
//       : totalExpense = json['totalExpense'] ?? 0,
//         category = json['category'] ?? '';
// }
