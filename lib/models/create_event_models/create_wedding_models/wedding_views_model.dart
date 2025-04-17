import 'dart:convert';

WeddingViewsModel weddingViewsModelFromJson(String str) => WeddingViewsModel.fromJson(json.decode(str));

String weddingViewsModelToJson(WeddingViewsModel data) => json.encode(data.toJson());

class WeddingViewsModel {
  List<WeddingViewUser>? weddingViewUsers;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  WeddingViewsModel({
    this.weddingViewUsers,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory WeddingViewsModel.fromJson(Map<String, dynamic> json) => WeddingViewsModel(
    weddingViewUsers: json["weddingViewUsers"] == null ? [] : List<WeddingViewUser>.from(json["weddingViewUsers"]!.map((x) => WeddingViewUser.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingViewUsers": weddingViewUsers == null ? [] : List<dynamic>.from(weddingViewUsers!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingViewUser {
  int? userId;
  String? displayName;
  String? email;
  dynamic contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  WeddingViewUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory WeddingViewUser.fromJson(Map<String, dynamic> json) => WeddingViewUser(
    userId: json["userId"],
    displayName: json["displayName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    followStatus: json["followStatus"],
    followingStatus: json["followingStatus"],
    profileImageUrl: json["profileImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "displayName": displayName,
    "email": email,
    "contactNumber": contactNumber,
    "followStatus": followStatus,
    "followingStatus": followingStatus,
    "profileImageUrl": profileImageUrl,
  };
}
