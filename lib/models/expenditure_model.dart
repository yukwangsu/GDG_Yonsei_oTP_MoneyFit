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
