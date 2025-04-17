import 'dart:convert';

OccasionPostAllCommentsModel occasionPostAllCommentsModelFromJson(String str) => OccasionPostAllCommentsModel.fromJson(json.decode(str));

String occasionPostAllCommentsModelToJson(OccasionPostAllCommentsModel data) => json.encode(data.toJson());

class OccasionPostAllCommentsModel {
  List<OccasionPostComment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  OccasionPostAllCommentsModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory OccasionPostAllCommentsModel.fromJson(Map<String, dynamic> json) => OccasionPostAllCommentsModel(
    comments: json["comments"] == null ? [] : List<OccasionPostComment>.from(json["comments"]!.map((x) => OccasionPostComment.fromJson(x))),
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

class OccasionPostComment {
  int? occasionPostCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  List<OccasionPostComment>? occasionPostCommentReplies;

  OccasionPostComment({
    this.occasionPostCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.occasionPostCommentReplies,
  });

  factory OccasionPostComment.fromJson(Map<String, dynamic> json) => OccasionPostComment(
    occasionPostCommentId: json["occasionPostCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    occasionPostCommentReplies: json["occasionPostCommentReplies"] == null ? [] : List<OccasionPostComment>.from(json["occasionPostCommentReplies"]!.map((x) => OccasionPostComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "occasionPostCommentId": occasionPostCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "occasionPostCommentReplies": occasionPostCommentReplies == null ? [] : List<dynamic>.from(occasionPostCommentReplies!.map((x) => x.toJson())),
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
