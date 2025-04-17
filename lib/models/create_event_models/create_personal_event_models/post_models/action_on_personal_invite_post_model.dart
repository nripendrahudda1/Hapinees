import 'dart:convert';

ActionOnPersonalEventInvitePostModel actionOnPersonalEventInvitePostModelFromJson(String str) => ActionOnPersonalEventInvitePostModel.fromJson(json.decode(str));

String actionOnPersonalEventInvitePostModelToJson(ActionOnPersonalEventInvitePostModel data) => json.encode(data.toJson());

class ActionOnPersonalEventInvitePostModel {
  int? personalEventHeaderId;
  int? personalEventInviteId;
  bool? isAccepted;
  bool? isCancelRequest;
  DateTime? acceptedRejectedOn;

  ActionOnPersonalEventInvitePostModel({
    this.personalEventHeaderId,
    this.personalEventInviteId,
    this.isAccepted,
    this.isCancelRequest,
    this.acceptedRejectedOn,
  });

  factory ActionOnPersonalEventInvitePostModel.fromJson(Map<String, dynamic> json) => ActionOnPersonalEventInvitePostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventInviteId: json["personalEventInviteId"],
    isAccepted: json["isAccepted"],
    isCancelRequest: json["isCancelRequest"],
    acceptedRejectedOn: json["acceptedRejectedOn"] == null ? null : DateTime.parse(json["acceptedRejectedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "personalEventInviteId": personalEventInviteId,
    "isAccepted": isAccepted,
    "isCancelRequest": isCancelRequest,
    "acceptedRejectedOn": acceptedRejectedOn?.toIso8601String(),
  };
}
