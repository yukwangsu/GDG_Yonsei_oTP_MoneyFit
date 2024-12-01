class GoalListModel {
  final List<GoalModel> goalList;

  GoalListModel.fromJson(Map<dynamic, dynamic> json)
      : goalList = List<GoalModel>.from(
            json['list'].map((goalJson) => GoalModel.fromJson(goalJson)));
}

class GoalModel {
  final int id, expenseLimit, spentAmount;
  final String upperCategoryType;

  GoalModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] ?? 0,
        expenseLimit = json['expenseLimit'] ?? 0,
        spentAmount = json['spentAmount'] ?? 0,
        upperCategoryType = json['upperCategoryType'] ?? '';
}
