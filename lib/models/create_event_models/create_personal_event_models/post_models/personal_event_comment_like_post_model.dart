import 'dart:convert';

LikePersonalEventCommentPostModel likePersonalEventCommentPostModelFromJson(String str) => LikePersonalEventCommentPostModel.fromJson(json.decode(str));

String likePersonalEventCommentPostModelToJson(LikePersonalEventCommentPostModel data) => json.encode(data.toJson());

class LikePersonalEventCommentPostModel {
  int? personalEventCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  LikePersonalEventCommentPostModel({
    this.personalEventCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikePersonalEventCommentPostModel.fromJson(Map<String, dynamic> json) => LikePersonalEventCommentPostModel(
    personalEventCommentId: json["personalEventCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventCommentId": personalEventCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}