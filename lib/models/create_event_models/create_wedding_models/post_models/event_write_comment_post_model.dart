// To parse this JSON data, do
//
//     final eventWriteCommentPostModel = eventWriteCommentPostModelFromJson(jsonString);

import 'dart:convert';

WeddingEventWriteCommentPostModel eventWriteCommentPostModelFromJson(String str) => WeddingEventWriteCommentPostModel.fromJson(json.decode(str));

String eventWriteCommentPostModelToJson(WeddingEventWriteCommentPostModel data) => json.encode(data.toJson());

class WeddingEventWriteCommentPostModel {
  int? weddingHeaderId;
  String? comment;
  int? parentCommentId;
  DateTime? commentedOn;

  WeddingEventWriteCommentPostModel({
    this.weddingHeaderId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory WeddingEventWriteCommentPostModel.fromJson(Map<String, dynamic> json) => WeddingEventWriteCommentPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}
