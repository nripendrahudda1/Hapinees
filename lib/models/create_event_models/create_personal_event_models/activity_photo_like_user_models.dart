import 'dart:convert';

ActivityPhotoLikeUserModel activityPhotoLikeUserModelFromJson(String str) => ActivityPhotoLikeUserModel.fromJson(json.decode(str));

String activityPhotoLikeUserModelToJson(ActivityPhotoLikeUserModel data) => json.encode(data.toJson());

class ActivityPhotoLikeUserModel {
  List<ActivityPhotoLikeUser>? activityPhotoLikeUsers;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  ActivityPhotoLikeUserModel({
    this.activityPhotoLikeUsers,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory ActivityPhotoLikeUserModel.fromJson(Map<String, dynamic> json) => ActivityPhotoLikeUserModel(
    activityPhotoLikeUsers: json["activityPhotoLikeUsers"] == null ? [] : List<ActivityPhotoLikeUser>.from(json["activityPhotoLikeUsers"]!.map((x) => ActivityPhotoLikeUser.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "activityPhotoLikeUsers": activityPhotoLikeUsers == null ? [] : List<dynamic>.from(activityPhotoLikeUsers!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class ActivityPhotoLikeUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  ActivityPhotoLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory ActivityPhotoLikeUser.fromJson(Map<String, dynamic> json) => ActivityPhotoLikeUser(
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
