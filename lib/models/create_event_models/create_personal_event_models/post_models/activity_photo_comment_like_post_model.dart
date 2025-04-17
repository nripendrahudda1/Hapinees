/*
import 'dart:convert';

ActivityPhotoCommentLikePostModel activityPhotoCommentLikePostModelFromJson(String str) => ActivityPhotoCommentLikePostModel.fromJson(json.decode(str));

String activityPhotoCommentLikePostModelToJson(ActivityPhotoCommentLikePostModel data) => json.encode(data.toJson());

class ActivityPhotoCommentLikePostModel {
  int? personalEventActivityPhotoCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  ActivityPhotoCommentLikePostModel({
    this.personalEventActivityPhotoCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory ActivityPhotoCommentLikePostModel.fromJson(Map<String, dynamic> json) => ActivityPhotoCommentLikePostModel(
    personalEventActivityPhotoCommentId: json["personalEventActivityPhotoCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityPhotoCommentId": personalEventActivityPhotoCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}*/
