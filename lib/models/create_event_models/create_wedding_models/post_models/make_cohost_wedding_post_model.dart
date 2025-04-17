// To parse this JSON data, do
//
//     final makeCoHostPostModel = makeCoHostPostModelFromJson(jsonString);

import 'dart:convert';

MakeCoHostWeddingPostModel makeCoHostPostModelFromJson(String str) => MakeCoHostWeddingPostModel.fromJson(json.decode(str));

String makeCoHostPostModelToJson(MakeCoHostWeddingPostModel data) => json.encode(data.toJson());

class MakeCoHostWeddingPostModel {
  int? weddingHeaderId;
  int? weddingInviteId;
  bool? isCoHost;

  MakeCoHostWeddingPostModel({
    this.weddingHeaderId,
    this.weddingInviteId,
    this.isCoHost,
  });

  factory MakeCoHostWeddingPostModel.fromJson(Map<String, dynamic> json) => MakeCoHostWeddingPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingInviteId: json["weddingInviteId"],
    isCoHost: json["isCoHost"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingInviteId": weddingInviteId,
    "isCoHost": isCoHost,
  };
}
