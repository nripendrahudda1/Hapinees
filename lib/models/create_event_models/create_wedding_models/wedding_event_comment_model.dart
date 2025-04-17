import 'dart:convert';

WeddingEventCommentModel eventCommentModelFromJson(String str) => WeddingEventCommentModel.fromJson(json.decode(str));

String eventCommentModelToJson(WeddingEventCommentModel data) => json.encode(data.toJson());

class WeddingEventCommentModel {
  List<Comment>? comments;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  WeddingEventCommentModel({
    this.comments,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory WeddingEventCommentModel.fromJson(Map<String, dynamic> json) => WeddingEventCommentModel(
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
  int? weddingCommentId;
  String? comment;
  CommentedBy? commentedBy;
  DateTime? commentedOn;
  int? totalLikes;
  bool? isLikedBySelf;
  List<Comment>? weddingCommentReplies;

  Comment({
    this.weddingCommentId,
    this.comment,
    this.commentedBy,
    this.commentedOn,
    this.totalLikes,
    this.isLikedBySelf,
    this.weddingCommentReplies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    weddingCommentId: json["weddingCommentId"],
    comment: json["comment"],
    commentedBy: json["commentedBy"] == null ? null : CommentedBy.fromJson(json["commentedBy"]),
    commentedOn: json["commentedOn"] == null ? null : DateTime.parse(json["commentedOn"]),
    totalLikes: json["totalLikes"],
    isLikedBySelf: json["isLikedBySelf"],
    weddingCommentReplies: json["weddingCommentReplies"] == null ? [] : List<Comment>.from(json["weddingCommentReplies"]!.map((x) => Comment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weddingCommentId": weddingCommentId,
    "comment": comment,
    "commentedBy": commentedBy?.toJson(),
    "commentedOn": commentedOn?.toIso8601String(),
    "totalLikes": totalLikes,
    "isLikedBySelf": isLikedBySelf,
    "weddingCommentReplies": weddingCommentReplies == null ? [] : List<dynamic>.from(weddingCommentReplies!.map((x) => x.toJson())),
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
