import 'dart:convert';

ActivityPhotoResponseModel activityPhotoResponseModelFromJson(String str) => ActivityPhotoResponseModel.fromJson(json.decode(str));

String activityPhotoResponseModelToJson(ActivityPhotoResponseModel data) => json.encode(data.toJson());

class ActivityPhotoResponseModel {
  List<PersonalEventActivityPhoto>? personalEventActivityPhotos;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  ActivityPhotoResponseModel({
    this.personalEventActivityPhotos,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory ActivityPhotoResponseModel.fromJson(Map<String, dynamic> json) => ActivityPhotoResponseModel(
    personalEventActivityPhotos: json["personalEventActivityPhotos"] == null ? [] : List<PersonalEventActivityPhoto>.from(json["personalEventActivityPhotos"]!.map((x) => PersonalEventActivityPhoto.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityPhotos": personalEventActivityPhotos == null ? [] : List<dynamic>.from(personalEventActivityPhotos!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class PersonalEventActivityPhoto {
  int? personalEventActivityPhotoId;
  String? imageUrl;
  bool? isLikedBySelf;
  int? totalLikes;
  int? totalComments;

  PersonalEventActivityPhoto({
    this.personalEventActivityPhotoId,
    this.imageUrl,
    this.isLikedBySelf,
    this.totalLikes,
    this.totalComments,
  });

  factory PersonalEventActivityPhoto.fromJson(Map<String, dynamic> json) => PersonalEventActivityPhoto(
    personalEventActivityPhotoId: json["personalEventActivityPhotoId"],
    imageUrl: json["imageUrl"],
    isLikedBySelf: json["isLikedBySelf"],
    totalLikes: json["totalLikes"],
    totalComments: json["totalComments"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityPhotoId": personalEventActivityPhotoId,
    "imageUrl": imageUrl,
    "isLikedBySelf": isLikedBySelf,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
  };
}
