import 'dart:convert';

LikeRitualPhotoPostModel likeRitualPhotoPostModelFromJson(String str) => LikeRitualPhotoPostModel.fromJson(json.decode(str));

String likeRitualPhotoPostModelToJson(LikeRitualPhotoPostModel data) => json.encode(data.toJson());

class LikeRitualPhotoPostModel {
  int? weddingRitualPhotoId;
  DateTime? likedOn;
  bool? isUnLike;

  LikeRitualPhotoPostModel({
    this.weddingRitualPhotoId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikeRitualPhotoPostModel.fromJson(Map<String, dynamic> json) => LikeRitualPhotoPostModel(
    weddingRitualPhotoId: json["weddingRitualPhotoId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualPhotoId": weddingRitualPhotoId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
