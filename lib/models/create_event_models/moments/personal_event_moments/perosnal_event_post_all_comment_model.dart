import 'dart:convert';

PersonalEventPostAllCommentsModel personalEventPostAllCommentsModelFromJson(String str) => PersonalEventPostAllCommentsModel.fromJson(json.decode(str));

String personalEventPostAllCommentsModelToJson(PersonalEventPostAllCommentsModel data) => json.encode(data.toJson());

class PersonalEventPostAllCommentsModel {
  List<PersonalEventPostComment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventPostAllCommentsModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventPostAllCommentsModel.fromJson(Map<String, dynamic> json) => PersonalEventPostAllCommentsModel(
    comments: json["comments"] == null ? [] : List<PersonalEventPostComment>.from(json["comments"]!.map((x) => PersonalEventPostComment.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "comments": comments == null ? [] : List<PersonalEventPostComment>.from(comments!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class PersonalEventPostComment {
  int? personalEventCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  dynamic personalEventPostCommentReplies;

  PersonalEventPostComment({
    this.personalEventCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.personalEventPostCommentReplies,
  });

  factory PersonalEventPostComment.fromJson(Map<String, dynamic> json) => PersonalEventPostComment(
    personalEventCommentId: json["personalEventCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    personalEventPostCommentReplies: json["personalEventPostCommentReplies"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventCommentId": personalEventCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "personalEventPostCommentReplies": personalEventPostCommentReplies,
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
}