import 'dart:convert';

PersonalEventCreateMemoriesPhotoPostModel personalEventCreateMemoriesPhotoPostModelFromJson(
        String str) =>
    PersonalEventCreateMemoriesPhotoPostModel.fromJson(json.decode(str));

String personalEventCreateMemoriesPhotoPostModelToJson(
        PersonalEventCreateMemoriesPhotoPostModel data) =>
    json.encode(data.toJson());

class PersonalEventCreateMemoriesPhotoPostModel {
  int? personalEventHeaderId;
  int? personalEventPostId;
  int? personalEventActivityId;
  String? imageExtension;
  String? imageData;
  DateTime? createdOn;

  PersonalEventCreateMemoriesPhotoPostModel({
    this.personalEventHeaderId,
    this.personalEventPostId,
    this.personalEventActivityId,
    this.imageExtension,
    this.imageData,
    this.createdOn,
  });

  factory PersonalEventCreateMemoriesPhotoPostModel.fromJson(Map<String, dynamic> json) =>
      PersonalEventCreateMemoriesPhotoPostModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventPostId: json["personalEventPostId"],
        personalEventActivityId: json["personalEventActivityId"],
        imageExtension: json["imageExtension"],
        imageData: json["imageData"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "personalEventHeaderId": personalEventHeaderId,
        "personalEventPostId": personalEventPostId,
        "personalEventActivityId": personalEventActivityId,
        "imageExtension": imageExtension,
        "imageData": imageData,
        "createdOn": createdOn?.toIso8601String(),
      };
}
