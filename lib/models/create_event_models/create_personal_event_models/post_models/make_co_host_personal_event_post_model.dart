import 'dart:convert';

MakeCoHostPersonalEventPostModel makeCoHostPersonalEventPostModelFromJson(String str) => MakeCoHostPersonalEventPostModel.fromJson(json.decode(str));

String makeCoHostPersonalEventPostModelToJson(MakeCoHostPersonalEventPostModel data) => json.encode(data.toJson());

class MakeCoHostPersonalEventPostModel {
  int? personalEventHeaderId;
  int? personalEventInviteId;
  bool? isCoHost;

  MakeCoHostPersonalEventPostModel({
    this.personalEventHeaderId,
    this.personalEventInviteId,
    this.isCoHost,
  });

  factory MakeCoHostPersonalEventPostModel.fromJson(Map<String, dynamic> json) => MakeCoHostPersonalEventPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventInviteId: json["personalEventInviteId"],
    isCoHost: json["isCoHost"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "personalEventInviteId": personalEventInviteId,
    "isCoHost": isCoHost,
  };
}