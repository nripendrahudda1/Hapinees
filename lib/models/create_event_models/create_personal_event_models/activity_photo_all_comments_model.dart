/*
import 'dart:convert';

ActivityPhotoAllCommentsModel activityPhotoAllCommentsModelFromJson(String str) => ActivityPhotoAllCommentsModel.fromJson(json.decode(str));

String activityPhotoAllCommentsModelToJson(ActivityPhotoAllCommentsModel data) => json.encode(data.toJson());

class ActivityPhotoAllCommentsModel {
  List<ActivityComment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  ActivityPhotoAllCommentsModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory ActivityPhotoAllCommentsModel.fromJson(Map<String, dynamic> json) => ActivityPhotoAllCommentsModel(
    comments: json["comments"] == null ? [] : List<ActivityComment>.from(json["comments"]!.map((x) => ActivityComment.fromJson(x))),
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

class ActivityComment {
  int? personalEventActivityPhotoCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  List<ActivityComment>? activityPhotoCommentReplies;

  ActivityComment({
    this.personalEventActivityPhotoCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.activityPhotoCommentReplies,
  });

  factory ActivityComment.fromJson(Map<String, dynamic> json) => ActivityComment(
    personalEventActivityPhotoCommentId: json["personalEventActivityPhotoCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    activityPhotoCommentReplies: json["activityPhotoCommentReplies"] == null ? [] : List<ActivityComment>.from(json["activityPhotoCommentReplies"]!.map((x) => ActivityComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityPhotoCommentId": personalEventActivityPhotoCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "activityPhotoCommentReplies": activityPhotoCommentReplies == null ? [] : List<dynamic>.from(activityPhotoCommentReplies!.map((x) => x.toJson())),
  };
}

class CommentedBy {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
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
}*/
