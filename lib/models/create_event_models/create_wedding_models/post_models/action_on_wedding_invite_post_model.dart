// To parse this JSON data, do
//
//     final actionOnWeddingInvitePostModel = actionOnWeddingInvitePostModelFromJson(jsonString);

import 'dart:convert';

ActionOnWeddingInvitePostModel actionOnWeddingInvitePostModelFromJson(String str) => ActionOnWeddingInvitePostModel.fromJson(json.decode(str));

String actionOnWeddingInvitePostModelToJson(ActionOnWeddingInvitePostModel data) => json.encode(data.toJson());

class ActionOnWeddingInvitePostModel {
  int? weddingHeaderId;
  int? weddingInviteId;
  bool? isAccepted;
  bool? isCancelRequest;
  DateTime? acceptedRejectedOn;

  ActionOnWeddingInvitePostModel({
    this.weddingHeaderId,
    this.weddingInviteId,
    this.isAccepted,
    this.isCancelRequest,
    this.acceptedRejectedOn,
  });

  factory ActionOnWeddingInvitePostModel.fromJson(Map<String, dynamic> json) => ActionOnWeddingInvitePostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingInviteId: json["weddingInviteId"],
    isAccepted: json["isAccepted"],
    isCancelRequest: json["isCancelRequest"],
    acceptedRejectedOn: json["acceptedRejectedOn"] == null ? null : DateTime.parse(json["acceptedRejectedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingInviteId": weddingInviteId,
    "isAccepted": isAccepted,
    "isCancelRequest": isCancelRequest,
    "acceptedRejectedOn": acceptedRejectedOn?.toIso8601String(),
  };
}
