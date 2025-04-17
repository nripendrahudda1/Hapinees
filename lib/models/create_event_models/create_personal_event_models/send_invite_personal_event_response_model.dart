import 'dart:convert';

SendPersonalEventInviteResponseModel sendPersonalEventInviteResponseModelFromJson(String str) => SendPersonalEventInviteResponseModel.fromJson(json.decode(str));

String sendPersonalEventInviteResponseModelToJson(SendPersonalEventInviteResponseModel data) => json.encode(data.toJson());

class SendPersonalEventInviteResponseModel {
  int? personalEventHeaderId;
  DateTime? invitedOn;
  List<PersonalEventInvite>? personalEventInvites;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  SendPersonalEventInviteResponseModel({
    this.personalEventHeaderId,
    this.invitedOn,
    this.personalEventInvites,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory SendPersonalEventInviteResponseModel.fromJson(Map<String, dynamic> json) => SendPersonalEventInviteResponseModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
    personalEventInvites: json["personalEventInvites"] == null ? [] : List<PersonalEventInvite>.from(json["personalEventInvites"]!.map((x) => PersonalEventInvite.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "invitedOn": invitedOn?.toIso8601String(),
    "personalEventInvites": personalEventInvites == null ? [] : List<dynamic>.from(personalEventInvites!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class PersonalEventInvite {
  int? inviteTo;
  String? email;
  String? mobile;
  bool? inviteStatus;
  String? validationMessage;

  PersonalEventInvite({
    this.inviteTo,
    this.email,
    this.mobile,
    this.inviteStatus,
    this.validationMessage,
  });

  factory PersonalEventInvite.fromJson(Map<String, dynamic> json) => PersonalEventInvite(
    inviteTo: json["inviteTo"],
    email: json["email"],
    mobile: json["mobile"],
    inviteStatus: json["inviteStatus"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "inviteTo": inviteTo,
    "email": email,
    "mobile": mobile,
    "inviteStatus": inviteStatus,
    "validationMessage": validationMessage,
  };
}