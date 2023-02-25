class UserModel {
  String? id;
  String? name;
  String? image;
  String? organizationId;
  String? designation;
  int? tokensLeft;
  int? tokensUsed;
  int? lastRedeemedOn;
  // List<int>? redeemedDates;
  int? createdAt;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.organizationId,
    this.designation,
    this.tokensLeft,
    this.tokensUsed,
    this.lastRedeemedOn,
    // this.redeemedDates,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      organizationId: json['organizationId'],
      designation: json['designation'],
      tokensLeft: json['tokensLeft'],
      tokensUsed: json['tokensUsed'] ?? 0,
      lastRedeemedOn: json['lastRedeemedOn'],
      // redeemedDates: json['redeemedDates'] != null
      //     ? (json['redeemedDates'] as List).map((e) => e as int).toList()
      //     : <int>[],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'organizationId': organizationId,
      'designation': designation,
      'tokensLeft': tokensLeft,
      'tokensUsed': tokensUsed,
      'lastRedeemedOn': lastRedeemedOn,
      // 'redeemedDates': redeemedDates,
      'createdAt': createdAt,
    };
  }
}
