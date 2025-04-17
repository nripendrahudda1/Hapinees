import 'dart:convert';

DeletePersonalEventPostMomentPhotoModel deletePersonalEventPostMomentPhotoModelFromJson(
        String str) =>
    DeletePersonalEventPostMomentPhotoModel.fromJson(json.decode(str));

String deletePersonalEventPostMomentPhotoModelToJson(
        DeletePersonalEventPostMomentPhotoModel data) =>
    json.encode(data.toJson());

class DeletePersonalEventPostMomentPhotoModel {
  int? personalEventHeaderId;
  int? personalEventPostPhotoId;

  DeletePersonalEventPostMomentPhotoModel({
    this.personalEventHeaderId,
    this.personalEventPostPhotoId,
  });

  factory DeletePersonalEventPostMomentPhotoModel.fromJson(Map<String, dynamic> json) =>
      DeletePersonalEventPostMomentPhotoModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventPostPhotoId: json["PersonalEventPostPhotoId"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventHeaderId": personalEventHeaderId,
        "PersonalEventPostPhotoId": personalEventPostPhotoId,
      };
}
