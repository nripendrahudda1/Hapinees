/*
import 'dart:convert';

ActivityPhotoCommentPostModel activityPhotoCommentPostModelFromJson(String str) => ActivityPhotoCommentPostModel.fromJson(json.decode(str));

String activityPhotoCommentPostModelToJson(ActivityPhotoCommentPostModel data) => json.encode(data.toJson());

class ActivityPhotoCommentPostModel {
  int? personalEventActivityPhotoId;
  String? comment;
  int? parentCommentId;
  DateTime? commentedOn;

  ActivityPhotoCommentPostModel({
    this.personalEventActivityPhotoId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory ActivityPhotoCommentPostModel.fromJson(Map<String, dynamic> json) => ActivityPhotoCommentPostModel(
    personalEventActivityPhotoId: json["personalEventActivityPhotoId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityPhotoId": personalEventActivityPhotoId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}*/
