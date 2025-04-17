import 'dart:convert';

PersonalEventAllMomentsModel personalEventAllMomentsModelFromJson(String str) =>
    PersonalEventAllMomentsModel.fromJson(json.decode(str));

String personalEventAllMomentsModelToJson(PersonalEventAllMomentsModel data) =>
    json.encode(data.toJson());

class PersonalEventAllMomentsModel {
  List<PersonalEventPost>? personalEventPosts;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventAllMomentsModel({
    this.personalEventPosts,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });
// UPDATED fromJson method to sort posts by date
  factory PersonalEventAllMomentsModel.fromJson(Map<String, dynamic> json) {
    List<PersonalEventPost> posts = json["personalEventPosts"] == null
        ? []
        : List<PersonalEventPost>.from(
            json["personalEventPosts"]!.map((x) => PersonalEventPost.fromJson(x)));
    // Sort posts by createdOn in descending order (newest first)
    posts.sort((a, b) => (b.createdOn ?? DateTime(0)).compareTo(a.createdOn ?? DateTime(0)));
    return PersonalEventAllMomentsModel(
      personalEventPosts: posts,
      responseStatus: json["responseStatus"],
      validationMessage: json["validationMessage"],
      statusCode: json["statusCode"],
    );
  }
  // factory PersonalEventAllMomentsModel.fromJson(Map<String, dynamic> json) => PersonalEventAllMomentsModel(
  //   personalEventPosts: json["personalEventPosts"] == null ? [] : List<PersonalEventPost>.from(json["personalEventPosts"]!.map((x) => PersonalEventPost.fromJson(x))),
  //   responseStatus: json["responseStatus"],
  //   validationMessage: json["validationMessage"],
  //   statusCode: json["statusCode"],
  // );

  Map<String, dynamic> toJson() => {
        "personalEventPosts": personalEventPosts == null
            ? []
            : List<dynamic>.from(personalEventPosts!.map((x) => x.toJson())),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "statusCode": statusCode,
      };
}

class PersonalEventPost {
  bool? isActivity;
  int? personalEventPostId;
  String? aboutPost;
  String? activityName;
  CreatedBy? createdBy;
  DateTime? createdOn;
  int? likes;
  int? comments;
  String? description;
  bool? isContributor;
  List<PersonalEventPhoto>? personalEventPhotos;

  PersonalEventPost({
    this.isActivity,
    this.personalEventPostId,
    this.aboutPost,
    this.activityName,
    this.createdBy,
    this.createdOn,
    this.likes,
    this.comments,
    this.personalEventPhotos,
    this.description,
    this.isContributor,
  });

  factory PersonalEventPost.fromJson(Map<String, dynamic> json) => PersonalEventPost(
        isActivity: json["isActivity"],
        personalEventPostId: json["personalEventPostId"],
        aboutPost: json["aboutPost"],
        activityName: json["activityName"],
        createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        likes: json["likes"],
        comments: json["comments"],
        isContributor: json["isContributor"],
        personalEventPhotos: List<PersonalEventPhoto>.from(
            json["personalEventPhotos"].map((x) => PersonalEventPhoto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isActivity": isActivity,
        "personalEventPostId": personalEventPostId,
        "aboutPost": aboutPost,
        "activityName": activityName,
        "createdBy": createdBy?.toJson(),
        "createdOn": createdOn?.toIso8601String(),
        "likes": likes,
        "comments": comments,
        "contributorsId": isContributor,
        "personalEventPhotos": personalEventPhotos != null
            ? List<dynamic>.from(personalEventPhotos!.map((x) => x.toJson()))
            : [],
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

class PersonalEventPhoto {
  String photo;
  int personalEventPhotoId;

  PersonalEventPhoto({
    required this.photo,
    required this.personalEventPhotoId,
  });

  factory PersonalEventPhoto.fromJson(Map<String, dynamic> json) => PersonalEventPhoto(
        photo: json["photo"],
        personalEventPhotoId: json["personalEventPhotoId"],
      );

  Map<String, dynamic> toJson() => {
        "photo": photo,
        "personalEventPhotoId": personalEventPhotoId,
      };

  startsWith(String urlPathWithoutFolderName) {}
}
