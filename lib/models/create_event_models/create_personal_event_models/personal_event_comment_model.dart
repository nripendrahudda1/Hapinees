import 'dart:convert';

PersonalEventCommentModel personalEventCommentModelFromJson(String str) => PersonalEventCommentModel.fromJson(json.decode(str));

String personalEventCommentModelToJson(PersonalEventCommentModel data) => json.encode(data.toJson());

class PersonalEventCommentModel {
  List<Comment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventCommentModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventCommentModel.fromJson(Map<String, dynamic> json) => PersonalEventCommentModel(
    comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
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

class Comment {
  int? personalEventCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  List<Comment>? personalEventCommentReplies;

  Comment({
    this.personalEventCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.personalEventCommentReplies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    personalEventCommentId: json["personalEventCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    personalEventCommentReplies: json["personalEventCommentReplies"] == null ? [] : List<Comment>.from(json["personalEventCommentReplies"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "personalEventCommentId": personalEventCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "personalEventCommentReplies": personalEventCommentReplies == null ? [] : List<dynamic>.from(personalEventCommentReplies!.map((x) => x.toJson())),
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