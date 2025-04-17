// To parse this JSON data, do
//
//     final setPostCommentPostModel = setPostCommentPostModelFromJson(jsonString);

import 'dart:convert';

OccasionSetPostCommentPostModel occasionSetPostCommentPostModelFromJson(String str) => OccasionSetPostCommentPostModel.fromJson(json.decode(str));

String occasionSetPostCommentPostModelToJson(OccasionSetPostCommentPostModel data) => json.encode(data.toJson());

class OccasionSetPostCommentPostModel {
  int? occasionPostId;
  String? comment;
  int? parentCommentId;
  DateTime? commentedOn;

  OccasionSetPostCommentPostModel({
    this.occasionPostId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory OccasionSetPostCommentPostModel.fromJson(Map<String, dynamic> json) => OccasionSetPostCommentPostModel(
    occasionPostId: json["occasionPostId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "occasionPostId": occasionPostId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}
