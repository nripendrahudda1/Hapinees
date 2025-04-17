import 'dart:convert';

OccasionSetPostCommentLikePostModel occasionSetPostCommentLikePostModelFromJson(String str) => OccasionSetPostCommentLikePostModel.fromJson(json.decode(str));

String occasionSetPostCommentLikePostModelToJson(OccasionSetPostCommentLikePostModel data) => json.encode(data.toJson());

class OccasionSetPostCommentLikePostModel {
  int? occasionPostCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  OccasionSetPostCommentLikePostModel({
    this.occasionPostCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory OccasionSetPostCommentLikePostModel.fromJson(Map<String, dynamic> json) => OccasionSetPostCommentLikePostModel(
    occasionPostCommentId: json["occasionPostCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "occasionPostCommentId": occasionPostCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
