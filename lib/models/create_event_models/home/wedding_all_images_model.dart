import 'dart:convert';

WeddingAllImagesModel weddingAllImagesModelFromJson(String str) => WeddingAllImagesModel.fromJson(json.decode(str));

String weddingAllImagesModelToJson(WeddingAllImagesModel data) => json.encode(data.toJson());

class WeddingAllImagesModel {
  int? weddingHeaderId;
  List<WeddingPhotoList>? weddingPhotoList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  WeddingAllImagesModel({
    this.weddingHeaderId,
    this.weddingPhotoList,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory WeddingAllImagesModel.fromJson(Map<String, dynamic> json) => WeddingAllImagesModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingPhotoList: json["weddingPhotoList"] == null ? [] : List<WeddingPhotoList>.from(json["weddingPhotoList"]!.map((x) => WeddingPhotoList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingPhotoList": weddingPhotoList == null ? [] : List<dynamic>.from(weddingPhotoList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingPhotoList {
  String? imageUrl;

  WeddingPhotoList({
    this.imageUrl,
  });

  factory WeddingPhotoList.fromJson(Map<String, dynamic> json) => WeddingPhotoList(
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "imageUrl": imageUrl,
  };
}
