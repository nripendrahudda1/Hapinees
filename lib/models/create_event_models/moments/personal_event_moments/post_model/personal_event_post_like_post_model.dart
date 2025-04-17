import 'dart:convert';

PersonalEventSetLikePostModel personalEventSetLikePostModelFromJson(String str) => PersonalEventSetLikePostModel.fromJson(json.decode(str));

String personalEventSetLikePostModelToJson(PersonalEventSetLikePostModel data) => json.encode(data.toJson());

class PersonalEventSetLikePostModel {
  int? personalEventPostId;
  DateTime? likedOn;
  bool? isUnLike;

  PersonalEventSetLikePostModel({
    this.personalEventPostId,
    this.likedOn,
    this.isUnLike,
  });

  factory PersonalEventSetLikePostModel.fromJson(Map<String, dynamic> json) => PersonalEventSetLikePostModel(
    personalEventPostId: json["personalEventPostId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostId": personalEventPostId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}