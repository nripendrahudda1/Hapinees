// To parse this JSON data, do
//
//     final ritualPhotoCommenLikePostModel = ritualPhotoCommenLikePostModelFromJson(jsonString);

import 'dart:convert';

RitualPhotoCommenLikePostModel ritualPhotoCommenLikePostModelFromJson(String str) => RitualPhotoCommenLikePostModel.fromJson(json.decode(str));

String ritualPhotoCommenLikePostModelToJson(RitualPhotoCommenLikePostModel data) => json.encode(data.toJson());

class RitualPhotoCommenLikePostModel {
  int? weddingRitualPhotoCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  RitualPhotoCommenLikePostModel({
    this.weddingRitualPhotoCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory RitualPhotoCommenLikePostModel.fromJson(Map<String, dynamic> json) => RitualPhotoCommenLikePostModel(
    weddingRitualPhotoCommentId: json["weddingRitualPhotoCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotoCommentId": weddingRitualPhotoCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
