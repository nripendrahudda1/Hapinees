import 'dart:convert';

PersonalEventPostLikesUsersModel personalEventPostLikesUsersModelFromJson(String str) => PersonalEventPostLikesUsersModel.fromJson(json.decode(str));

String personalEventPostLikesUsersModelToJson(PersonalEventPostLikesUsersModel data) => json.encode(data.toJson());

class PersonalEventPostLikesUsersModel {
  List<PersonalEventPostLikeUser>? personalEventPostLikeUsers;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventPostLikesUsersModel({
    this.personalEventPostLikeUsers,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventPostLikesUsersModel.fromJson(Map<String, dynamic> json) => PersonalEventPostLikesUsersModel(
    personalEventPostLikeUsers: json["personalEventPostLikeUsers"] == null ? [] : List<PersonalEventPostLikeUser>.from(json["personalEventPostLikeUsers"]!.map((x) => PersonalEventPostLikeUser.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostLikeUsers": personalEventPostLikeUsers == null ? [] : List<dynamic>.from(personalEventPostLikeUsers!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class PersonalEventPostLikeUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  PersonalEventPostLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory PersonalEventPostLikeUser.fromJson(Map<String, dynamic> json) => PersonalEventPostLikeUser(
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