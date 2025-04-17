import 'dart:convert';

PersonalEventPostCommentPostModel personalEventPostCommentPostModelFromJson(String str) => PersonalEventPostCommentPostModel.fromJson(json.decode(str));

String personalEventPostCommentPostModelToJson(PersonalEventPostCommentPostModel data) => json.encode(data.toJson());

class PersonalEventPostCommentPostModel {
  int? personalEventPostId;
  String? comment;
  int? parentCommentId;
  DateTime? commentedOn;

  PersonalEventPostCommentPostModel({
    this.personalEventPostId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory PersonalEventPostCommentPostModel.fromJson(Map<String, dynamic> json) => PersonalEventPostCommentPostModel(
    personalEventPostId: json["personalEventPostId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostId": personalEventPostId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}