import 'dart:convert';

LikeActivityPhotoPostModel likeActivityPhotoPostModelFromJson(String str) => LikeActivityPhotoPostModel.fromJson(json.decode(str));

String likeActivityPhotoPostModelToJson(LikeActivityPhotoPostModel data) => json.encode(data.toJson());

class LikeActivityPhotoPostModel {
  int? personalEventActivityPhotoId;
  DateTime? likedOn;
  bool? isUnLike;

  LikeActivityPhotoPostModel({
    this.personalEventActivityPhotoId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikeActivityPhotoPostModel.fromJson(Map<String, dynamic> json) => LikeActivityPhotoPostModel(
    personalEventActivityPhotoId: json["personalEventActivityId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityId": personalEventActivityPhotoId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}