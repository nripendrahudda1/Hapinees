import 'dart:convert';

SetWeddingRitualPhotoPostModel setWeddingRitualPhotoPostModelFromJson(String str) => SetWeddingRitualPhotoPostModel.fromJson(json.decode(str));

String setWeddingRitualPhotoPostModelToJson(SetWeddingRitualPhotoPostModel data) => json.encode(data.toJson());

class SetWeddingRitualPhotoPostModel {
  int? weddingHeaderId;
  int? weddingRitualId;
  String? imageExtention;
  String? imageData;
  DateTime? createdOn;

  SetWeddingRitualPhotoPostModel({
    this.weddingHeaderId,
    this.weddingRitualId,
    this.imageExtention,
    this.imageData,
    this.createdOn,
  });

  factory SetWeddingRitualPhotoPostModel.fromJson(Map<String, dynamic> json) => SetWeddingRitualPhotoPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingRitualId: json["weddingRitualId"],
    imageExtention: json["imageExtention"],
    imageData: json["imageData"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingRitualId": weddingRitualId,
    "imageExtention": imageExtention,
    "imageData": imageData,
    "createdOn": createdOn?.toIso8601String(),
  };
}
