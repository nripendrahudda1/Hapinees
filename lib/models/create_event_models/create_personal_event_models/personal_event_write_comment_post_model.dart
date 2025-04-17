import 'dart:convert';

PersonalEventWriteCommentPostModel personalEventWriteCommentPostModelFromJson(String str) => PersonalEventWriteCommentPostModel.fromJson(json.decode(str));

String personalEventWriteCommentPostModelToJson(PersonalEventWriteCommentPostModel data) => json.encode(data.toJson());

class PersonalEventWriteCommentPostModel {
  int? personalEventHeaderId;
  String? comment;
  int? parentCommentId;
  DateTime? commentedOn;

  PersonalEventWriteCommentPostModel({
    this.personalEventHeaderId,
    this.comment,
    this.parentCommentId,
    this.commentedOn,
  });

  factory PersonalEventWriteCommentPostModel.fromJson(Map<String, dynamic> json) => PersonalEventWriteCommentPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    comment: json["comment"],
    parentCommentId: json["parentCommentId"],
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "comment": comment,
    "parentCommentId": parentCommentId,
    "commentedOn": commentedOn?.toIso8601String(),
  };
}