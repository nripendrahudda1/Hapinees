import 'dart:convert';

OccasionEventAllMomentsModel occasionEventAllMomentsModelFromJson(String str) => OccasionEventAllMomentsModel.fromJson(json.decode(str));

String occasionEventAllMomentsModelToJson(OccasionEventAllMomentsModel data) => json.encode(data.toJson());

class OccasionEventAllMomentsModel {
  List<RitualFilter>? ritualFilters;
  List<Post>? posts;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  OccasionEventAllMomentsModel({
    this.ritualFilters,
    this.posts,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory OccasionEventAllMomentsModel.fromJson(Map<String, dynamic> json) => OccasionEventAllMomentsModel(
    ritualFilters: json["ritualFilters"] == null ? [] : List<RitualFilter>.from(json["ritualFilters"]!.map((x) => RitualFilter.fromJson(x))),
    posts: json["posts"] == null ? [] : List<Post>.from(json["posts"]!.map((x) => Post.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "ritualFilters": ritualFilters == null ? [] : List<dynamic>.from(ritualFilters!.map((x) => x.toJson())),
    "posts": posts == null ? [] : List<dynamic>.from(posts!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class Post {
  int? occasionPostId;
  int? eventTypeMasterId;
  int? occasionId;
  dynamic background;
  String? postNote;
  CreatedBy? createdBy;
  DateTime? createdOn;
  int? likes;
  int? comments;
  List<PostMedia>? postMedias;

  Post({
    this.occasionPostId,
    this.eventTypeMasterId,
    this.occasionId,
    this.background,
    this.postNote,
    this.createdBy,
    this.createdOn,
    this.likes,
    this.comments,
    this.postMedias,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    occasionPostId: json["occasionPostId"],
    eventTypeMasterId: json["eventTypeMasterId"],
    occasionId: json["occasionId"],
    background: json["background"],
    postNote: json["postNote"],
    createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    likes: json["likes"],
    comments: json["comments"],
    postMedias: json["postMedias"] == null ? [] : List<PostMedia>.from(json["postMedias"]!.map((x) => PostMedia.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "occasionPostId": occasionPostId,
    "eventTypeMasterId": eventTypeMasterId,
    "occasionId": occasionId,
    "background": background,
    "postNote": postNote,
    "createdBy": createdBy?.toJson(),
    "createdOn": createdOn?.toIso8601String(),
    "likes": likes,
    "comments": comments,
    "postMedias": postMedias == null ? [] : List<dynamic>.from(postMedias!.map((x) => x.toJson())),
  };
}

class CreatedBy {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  CreatedBy({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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

class PostMedia {
  int? occasionPostMediaId;
  int? weddingRitualId;
  String? ritualName;
  String? imageUrl;

  PostMedia({
    this.occasionPostMediaId,
    this.weddingRitualId,
    this.ritualName,
    this.imageUrl,
  });

  factory PostMedia.fromJson(Map<String, dynamic> json) => PostMedia(
    occasionPostMediaId: json["occasionPostMediaId"],
    weddingRitualId: json["weddingRitualId"],
    ritualName: json["ritualName"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "occasionPostMediaId": occasionPostMediaId,
    "weddingRitualId": weddingRitualId,
    "ritualName": ritualName,
    "imageUrl": imageUrl,
  };
}

class RitualFilter {
  int? weddingRitualId;
  String? ritualName;

  RitualFilter({
    this.weddingRitualId,
    this.ritualName,
  });

  factory RitualFilter.fromJson(Map<String, dynamic> json) => RitualFilter(
    weddingRitualId: json["weddingRitualId"],
    ritualName: json["ritualName"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualId": weddingRitualId,
    "ritualName": ritualName,
  };
}
