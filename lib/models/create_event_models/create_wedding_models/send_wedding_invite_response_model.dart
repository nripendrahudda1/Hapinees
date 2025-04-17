// To parse this JSON data, do
//
//     final sendWeddingInviteResponseModel = sendWeddingInviteResponseModelFromJson(jsonString);

import 'dart:convert';

SendWeddingInviteResponseModel sendWeddingInviteResponseModelFromJson(String str) => SendWeddingInviteResponseModel.fromJson(json.decode(str));

String sendWeddingInviteResponseModelToJson(SendWeddingInviteResponseModel data) => json.encode(data.toJson());

class SendWeddingInviteResponseModel {
  int? weddingHeaderId;
  DateTime? invitedOn;
  List<WeddingInvite>? weddingInvites;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  SendWeddingInviteResponseModel({
    this.weddingHeaderId,
    this.invitedOn,
    this.weddingInvites,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory SendWeddingInviteResponseModel.fromJson(Map<String, dynamic> json) => SendWeddingInviteResponseModel(
    weddingHeaderId: json["weddingHeaderId"],
    invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
    weddingInvites: json["weddingInvites"] == null ? [] : List<WeddingInvite>.from(json["weddingInvites"]!.map((x) => WeddingInvite.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "invitedOn": invitedOn?.toIso8601String(),
    "weddingInvites": weddingInvites == null ? [] : List<dynamic>.from(weddingInvites!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingInvite {
  int? inviteTo;
  String? email;
  String? mobile;
  bool? inviteStatus;
  String? validationMessage;

  WeddingInvite({
    this.inviteTo,
    this.email,
    this.mobile,
    this.inviteStatus,
    this.validationMessage,
  });

  factory WeddingInvite.fromJson(Map<String, dynamic> json) => WeddingInvite(
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
