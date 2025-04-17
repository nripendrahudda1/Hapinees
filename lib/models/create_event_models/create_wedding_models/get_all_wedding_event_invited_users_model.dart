// To parse this JSON data, do
//
//     final getAllInvitedUsers = getAllInvitedUsersFromJson(jsonString);

import 'dart:convert';

import 'package:Happinest/common/common_model/common_invite_by_and_to_model.dart';

GetAllWeddingEventInvitedUsers getAllWeddingEventInvitedUsersFromJson(String str) => GetAllWeddingEventInvitedUsers.fromJson(json.decode(str));

String getAllWeddingEventInvitedUsersToJson(GetAllWeddingEventInvitedUsers data) => json.encode(data.toJson());

class GetAllWeddingEventInvitedUsers {
  List<WeddingInviteList>? weddingInviteList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  GetAllWeddingEventInvitedUsers({
    this.weddingInviteList,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory GetAllWeddingEventInvitedUsers.fromJson(Map<String, dynamic> json) => GetAllWeddingEventInvitedUsers(
    weddingInviteList: json["weddingInviteList"] == null ? [] : List<WeddingInviteList>.from(json["weddingInviteList"]!.map((x) => WeddingInviteList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingInviteList": weddingInviteList == null ? [] : List<dynamic>.from(weddingInviteList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingInviteList {
  int? weddingInviteId;
  int? weddingHeaderId;
  InviteToAndBy? invitedBy;
  InviteToAndBy? inviteTo;
  DateTime? invitedOn;
  int? inviteVia;
  String? email;
  String? mobile;
  int? inviteStatus;
  dynamic acceptedRejectedOn;
  bool? isCoHost;

  WeddingInviteList({
    this.weddingInviteId,
    this.weddingHeaderId,
    this.invitedBy,
    this.inviteTo,
    this.invitedOn,
    this.inviteVia,
    this.email,
    this.mobile,
    this.inviteStatus,
    this.acceptedRejectedOn,
    this.isCoHost,
  });

  factory WeddingInviteList.fromJson(Map<String, dynamic> json) => WeddingInviteList(
    weddingInviteId: json["weddingInviteId"],
    weddingHeaderId: json["weddingHeaderId"],
    invitedBy: json["invitedBy"] == null ? null : InviteToAndBy.fromJson(json["invitedBy"]),
    inviteTo: json["inviteTo"] == null ? null : InviteToAndBy.fromJson(json["inviteTo"]),
    invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
    inviteVia: json["inviteVia"],
    email: json["email"],
    mobile: json["mobile"],
    inviteStatus: json["inviteStatus"],
    acceptedRejectedOn: json["acceptedRejectedOn"],
    isCoHost: json["isCoHost"],
  );

  Map<String, dynamic> toJson() => {
    "weddingInviteId": weddingInviteId,
    "weddingHeaderId": weddingHeaderId,
    "invitedBy": invitedBy?.toJson(),
    "inviteTo": inviteTo?.toJson(),
    "invitedOn": invitedOn?.toIso8601String(),
    "inviteVia": inviteVia,
    "email": email,
    "mobile": mobile,
    "inviteStatus": inviteStatus,
    "acceptedRejectedOn": acceptedRejectedOn,
    "isCoHost": isCoHost,
  };
}
