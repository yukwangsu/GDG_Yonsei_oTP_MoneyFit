class BadgeListModel {
  final List<BadgeModel> badgeList;

  BadgeListModel.fromJson(json)
      : badgeList = List<BadgeModel>.from(
            json.map((badgeJson) => BadgeModel.fromJson(badgeJson)));
}

class BadgeModel {
  final int id;
  final String badgeType;

  BadgeModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] ?? 0,
        badgeType = json['badgeType'] ?? '';
}
