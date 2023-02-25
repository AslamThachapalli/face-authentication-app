class DateModel {
  int? date;
  List<String>? tokenUsersId;

  DateModel({
    this.date,
    this.tokenUsersId,
  });

  factory DateModel.fromJson(Map<String, dynamic> json) => DateModel(
        date: json['date'],
        tokenUsersId: ((json['tokenUsersId'] ?? []) as List)
            .map((e) => e.toString())
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'date': date,
        'tokenUsersId': tokenUsersId,
      };
}
