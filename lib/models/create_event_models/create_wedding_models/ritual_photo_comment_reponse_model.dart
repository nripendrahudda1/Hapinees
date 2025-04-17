import 'dart:convert';

RitualPhotoCommentResponseModel ritualPhotoCommentResponseModelFromJson(String str) => RitualPhotoCommentResponseModel.fromJson(json.decode(str));

String ritualPhotoCommentResponseModelToJson(RitualPhotoCommentResponseModel data) => json.encode(data.toJson());

class RitualPhotoCommentResponseModel {
  int? weddingRitualPhotoId;
  String? comment;
  dynamic parentCommentId;
  DateTime? commentedOn;

  RitualPhotoCommentResponseModel({
    this.weddingRitualPhotoId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory RitualPhotoCommentResponseModel.fromJson(Map<String, dynamic> json) => RitualPhotoCommentResponseModel(
    weddingRitualPhotoId: json["weddingRitualPhotoId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotoId": weddingRitualPhotoId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}
