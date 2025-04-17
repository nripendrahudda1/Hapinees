// To parse this JSON data, do
//
//     final likeCommentPostmodel = likeCommentPostmodelFromJson(jsonString);

import 'dart:convert';

LikeWeddingCommentPostModel likeCommentPostmodelFromJson(String str) => LikeWeddingCommentPostModel.fromJson(json.decode(str));

String likeCommentPostmodelToJson(LikeWeddingCommentPostModel data) => json.encode(data.toJson());

class LikeWeddingCommentPostModel {
  int? weddingCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  LikeWeddingCommentPostModel({
    this.weddingCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikeWeddingCommentPostModel.fromJson(Map<String, dynamic> json) => LikeWeddingCommentPostModel(
    weddingCommentId: json["weddingCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "weddingCommentId": weddingCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
