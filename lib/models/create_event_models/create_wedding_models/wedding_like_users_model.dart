import 'dart:convert';

WeddingLikeUsersModel weddingLikeUsersModelFromJson(String str) => WeddingLikeUsersModel.fromJson(json.decode(str));

String weddingLikeUsersModelToJson(WeddingLikeUsersModel data) => json.encode(data.toJson());

class WeddingLikeUsersModel {
  List<WeddingLikeUser>? weddingLikeUsers;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  WeddingLikeUsersModel({
    this.weddingLikeUsers,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory WeddingLikeUsersModel.fromJson(Map<String, dynamic> json) => WeddingLikeUsersModel(
    weddingLikeUsers: json["weddingLikeUsers"] == null ? [] : List<WeddingLikeUser>.from(json["weddingLikeUsers"]!.map((x) => WeddingLikeUser.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingLikeUsers": weddingLikeUsers == null ? [] : List<dynamic>.from(weddingLikeUsers!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingLikeUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  WeddingLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory WeddingLikeUser.fromJson(Map<String, dynamic> json) => WeddingLikeUser(
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
