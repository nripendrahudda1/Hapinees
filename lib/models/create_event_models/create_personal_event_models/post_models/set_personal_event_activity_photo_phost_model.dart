import 'dart:convert';

SetPersonalEventActivityPhotoPostModel setPersonalEventActivityPhotoPostModelFromJson(String str) => SetPersonalEventActivityPhotoPostModel.fromJson(json.decode(str));

String setPersonalEventActivityPhotoPostModelToJson(SetPersonalEventActivityPhotoPostModel data) => json.encode(data.toJson());

class SetPersonalEventActivityPhotoPostModel {
  int? personalEventHeaderId;
  int? personalEventActivityId;
  String? imageExtention;
  String? imageData;
  DateTime? createdOn;

  SetPersonalEventActivityPhotoPostModel({
    this.personalEventHeaderId,
    this.personalEventActivityId,
    this.imageExtention,
    this.imageData,
    this.createdOn,
  });

  factory SetPersonalEventActivityPhotoPostModel.fromJson(Map<String, dynamic> json) => SetPersonalEventActivityPhotoPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventActivityId: json["personalEventActivityId"],
    imageExtention: json["imageExtension"],
    imageData: json["imageData"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "personalEventActivityId": personalEventActivityId,
    "imageExtension": imageExtention,
    "imageData": imageData,
    "createdOn": createdOn?.toIso8601String(),
  };
}