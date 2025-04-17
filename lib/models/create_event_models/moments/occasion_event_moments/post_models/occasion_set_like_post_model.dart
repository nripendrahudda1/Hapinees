
// To parse this JSON data, do
//
//     final likeWeddingPostModel = likeWeddingPostModelFromJson(jsonString);

import 'dart:convert';

OccasionSetLikePostModel occasionSetLikePostModelFromJson(String str) => OccasionSetLikePostModel.fromJson(json.decode(str));

String occasionSetLikePostModelToJson(OccasionSetLikePostModel data) => json.encode(data.toJson());

class OccasionSetLikePostModel {
  int? occasionPostId;
  DateTime? likedOn;
  bool? isUnLike;

  OccasionSetLikePostModel({
    this.occasionPostId,
    this.likedOn,
    this.isUnLike,
  });

  factory OccasionSetLikePostModel.fromJson(Map<String, dynamic> json) => OccasionSetLikePostModel(
    occasionPostId: json["occasionPostId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "occasionPostId": occasionPostId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
