import 'dart:convert';

PersonalEventLikeUsersModel personalEventLikeUsersModelFromJson(String str) => PersonalEventLikeUsersModel.fromJson(json.decode(str));

String personalEventLikeUsersModelToJson(PersonalEventLikeUsersModel data) => json.encode(data.toJson());

class PersonalEventLikeUsersModel {
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;
  List<PersonalEventLikeUser>? personalEventLikeUsers;

  PersonalEventLikeUsersModel({
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
    this.personalEventLikeUsers,
  });

  factory PersonalEventLikeUsersModel.fromJson(Map<String, dynamic> json) => PersonalEventLikeUsersModel(
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
    personalEventLikeUsers: json["personalEventLikeUsers"] == null ? [] : List<PersonalEventLikeUser>.from(json["personalEventLikeUsers"]!.map((x) => PersonalEventLikeUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
    "personalEventLikeUsers": personalEventLikeUsers == null ? [] : List<dynamic>.from(personalEventLikeUsers!.map((x) => x.toJson())),
  };
}

class PersonalEventLikeUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  PersonalEventLikeUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory PersonalEventLikeUser.fromJson(Map<String, dynamic> json) => PersonalEventLikeUser(
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