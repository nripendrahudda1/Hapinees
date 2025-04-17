import 'dart:convert';

RitualPhotoCommentPostModel ritualPhotoCommentPostModelFromJson(String str) => RitualPhotoCommentPostModel.fromJson(json.decode(str));

String ritualPhotoCommentPostModelToJson(RitualPhotoCommentPostModel data) => json.encode(data.toJson());

class RitualPhotoCommentPostModel {
  int? weddingRitualPhotoId;
  String? comment;
  dynamic parentCommentId;
  DateTime? commentedOn;

  RitualPhotoCommentPostModel({
    this.weddingRitualPhotoId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory RitualPhotoCommentPostModel.fromJson(Map<String, dynamic> json) => RitualPhotoCommentPostModel(
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
