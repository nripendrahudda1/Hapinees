import 'dart:convert';

LikePersonalEventPostModel likePersonalEventPostModelFromJson(String str) => LikePersonalEventPostModel.fromJson(json.decode(str));

String likePersonalEventPostModelToJson(LikePersonalEventPostModel data) => json.encode(data.toJson());

class LikePersonalEventPostModel {
  int? personalEventHeaderId;
  DateTime? likedOn;
  bool? isUnLike;

  LikePersonalEventPostModel({
    this.personalEventHeaderId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikePersonalEventPostModel.fromJson(Map<String, dynamic> json) => LikePersonalEventPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}