import 'dart:convert';

PersonalEventViewsModel personalEventViewsModelFromJson(String str) => PersonalEventViewsModel.fromJson(json.decode(str));

String personalEventViewsModelToJson(PersonalEventViewsModel data) => json.encode(data.toJson());

class PersonalEventViewsModel {
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;
  List<PersonalEventViewUser>? personalEventViewUsers;

  PersonalEventViewsModel({
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
    this.personalEventViewUsers,
  });

  factory PersonalEventViewsModel.fromJson(Map<String, dynamic> json) => PersonalEventViewsModel(
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
    personalEventViewUsers: json["personalEventViewUsers"] == null ? [] : List<PersonalEventViewUser>.from(json["personalEventViewUsers"]!.map((x) => PersonalEventViewUser.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
    "personalEventViewUsers": personalEventViewUsers == null ? [] : List<dynamic>.from(personalEventViewUsers!.map((x) => x.toJson())),
  };
}

class PersonalEventViewUser {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  PersonalEventViewUser({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory PersonalEventViewUser.fromJson(Map<String, dynamic> json) => PersonalEventViewUser(
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