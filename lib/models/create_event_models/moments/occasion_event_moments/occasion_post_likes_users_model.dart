import 'dart:convert';

OccasionPostLikesUsersModel occasionPostLikesUsersModelFromJson(String str) => OccasionPostLikesUsersModel.fromJson(json.decode(str));

String occasionPostLikesUsersModelToJson(OccasionPostLikesUsersModel data) => json.encode(data.toJson());

class OccasionPostLikesUsersModel {
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;
  List<OccasionPostLikeUser>? occasionPostLikeUsers;

  OccasionPostLikesUsersModel({
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
    this.occasionPostLikeUsers,
  });

  factory OccasionPostLikesUsersModel.fromJson(Map<String, dynamic> json) => OccasionPostLikesUsersModel(
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
    occasionPostLikeUsers: json["occasionPostLikeUsers"] == null ? [] : List<OccasionPostLikeUser>.from(json["occasionPostLikeUsers"]!.map((x) => OccasionPostLikeUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
    "occasionPostLikeUsers": occasionPostLikeUsers == null ? [] : List<dynamic>.from(occasionPostLikeUsers!.map((x) => x.toJson())),
  };
}

class OccasionPostLikeUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  OccasionPostLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory OccasionPostLikeUser.fromJson(Map<String, dynamic> json) => OccasionPostLikeUser(
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
