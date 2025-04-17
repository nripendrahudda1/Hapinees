import 'dart:convert';

RitualPhotoUserLikesModel ritualPhotoUserLikesModelFromJson(String str) => RitualPhotoUserLikesModel.fromJson(json.decode(str));

String ritualPhotoUserLikesModelToJson(RitualPhotoUserLikesModel data) => json.encode(data.toJson());

class RitualPhotoUserLikesModel {
  List<RitualPhotoLikeUser>? ritualPhotoLikeUsers;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  RitualPhotoUserLikesModel({
    this.ritualPhotoLikeUsers,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory RitualPhotoUserLikesModel.fromJson(Map<String, dynamic> json) => RitualPhotoUserLikesModel(
    ritualPhotoLikeUsers: json["ritualPhotoLikeUsers"] == null ? [] : List<RitualPhotoLikeUser>.from(json["ritualPhotoLikeUsers"]!.map((x) => RitualPhotoLikeUser.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "ritualPhotoLikeUsers": ritualPhotoLikeUsers == null ? [] : List<dynamic>.from(ritualPhotoLikeUsers!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class RitualPhotoLikeUser {
  int? userId;
  String? displayName;
  String? email;
  dynamic contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  RitualPhotoLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory RitualPhotoLikeUser.fromJson(Map<String, dynamic> json) => RitualPhotoLikeUser(
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
