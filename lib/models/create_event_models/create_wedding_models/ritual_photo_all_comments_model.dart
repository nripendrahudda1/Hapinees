// To parse this JSON data, do
//
//     final ritualPhotoAllCommentsModel = ritualPhotoAllCommentsModelFromJson(jsonString);

import 'dart:convert';

RitualPhotoAllCommentsModel ritualPhotoAllCommentsModelFromJson(String str) => RitualPhotoAllCommentsModel.fromJson(json.decode(str));

String ritualPhotoAllCommentsModelToJson(RitualPhotoAllCommentsModel data) => json.encode(data.toJson());

class RitualPhotoAllCommentsModel {
  List<RitualComment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  RitualPhotoAllCommentsModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory RitualPhotoAllCommentsModel.fromJson(Map<String, dynamic> json) => RitualPhotoAllCommentsModel(
    comments: json["comments"] == null ? [] : List<RitualComment>.from(json["comments"]!.map((x) => RitualComment.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class RitualComment {
  int? weddingRitualPhotoCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  List<RitualComment>? ritualPhotoCommentReplies;

  RitualComment({
    this.weddingRitualPhotoCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.ritualPhotoCommentReplies,
  });

  factory RitualComment.fromJson(Map<String, dynamic> json) => RitualComment(
    weddingRitualPhotoCommentId: json["weddingRitualPhotoCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    ritualPhotoCommentReplies: json["ritualPhotoCommentReplies"] == null ? [] : List<RitualComment>.from(json["ritualPhotoCommentReplies"]!.map((x) => RitualComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotoCommentId": weddingRitualPhotoCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "ritualPhotoCommentReplies": ritualPhotoCommentReplies == null ? [] : List<dynamic>.from(ritualPhotoCommentReplies!.map((x) => x.toJson())),
  };
}

class CommentedBy {
  int? userId;
  String? displayName;
  String? email;
  dynamic contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  CommentedBy({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory CommentedBy.fromJson(Map<String, dynamic> json) => CommentedBy(
    userId: json["userId"],
    displayName: json["displayName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    followStatus: json["followStatus"],
    followingStatus: json["followingStatus"],
    profileImageUrl: json["profileImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "displayName": displayName,
    "email": email,
    "contactNumber": contactNumber,
    "followStatus": followStatus,
    "followingStatus": followingStatus,
    "profileImageUrl": profileImageUrl,
  };
}
