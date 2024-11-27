class CategoryExpenditureListModel {
  final List<CategoryExpenditureModel> monthlyCategoryExpenditureList;

  CategoryExpenditureListModel.fromJson(json)
      : monthlyCategoryExpenditureList = List<CategoryExpenditureModel>.from(
            json.map((expenditureJson) =>
                CategoryExpenditureModel.fromJson(expenditureJson)));
}

class CategoryExpenditureModel {
  final int totalExpense;
  final String category;

  CategoryExpenditureModel.fromJson(Map<dynamic, dynamic> json)
      : totalExpense = json['totalExpense'] ?? 0,
        category = json['category'] ?? '';
}
