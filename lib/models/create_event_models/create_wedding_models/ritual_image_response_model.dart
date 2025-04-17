// To parse this JSON data, do
//
//     final ritualImagesResponseModel = ritualImagesResponseModelFromJson(jsonString);

import 'dart:convert';

RitualImagesResponseModel ritualImagesResponseModelFromJson(String str) => RitualImagesResponseModel.fromJson(json.decode(str));

String ritualImagesResponseModelToJson(RitualImagesResponseModel data) => json.encode(data.toJson());

class RitualImagesResponseModel {
  List<WeddingRitualPhoto>? weddingRitualPhotos;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  RitualImagesResponseModel({
    this.weddingRitualPhotos,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory RitualImagesResponseModel.fromJson(Map<String, dynamic> json) => RitualImagesResponseModel(
    weddingRitualPhotos: json["weddingRitualPhotos"] == null ? [] : List<WeddingRitualPhoto>.from(json["weddingRitualPhotos"]!.map((x) => WeddingRitualPhoto.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotos": weddingRitualPhotos == null ? [] : List<dynamic>.from(weddingRitualPhotos!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingRitualPhoto {
  int? weddingRitualPhotoId;
  String? imageUrl;
  bool? isLikedBySelf;
  int? totalLikes;
  int? totalComments;

  WeddingRitualPhoto({
    this.weddingRitualPhotoId,
    this.imageUrl,
    this.isLikedBySelf,
    this.totalLikes,
    this.totalComments,
  });

  factory WeddingRitualPhoto.fromJson(Map<String, dynamic> json) => WeddingRitualPhoto(
    weddingRitualPhotoId: json["weddingRitualPhotoId"],
    imageUrl: json["imageUrl"],
    isLikedBySelf: json["isLikedBySelf"],
    totalLikes: json["totalLikes"],
    totalComments: json["totalComments"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotoId": weddingRitualPhotoId,
    "imageUrl": imageUrl,
    "isLikedBySelf": isLikedBySelf,
    "totalLikes": totalLikes,
    "totalComments": totalComments,
  };
}
