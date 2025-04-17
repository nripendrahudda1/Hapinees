import 'dart:convert';

PersonalEventSetPostCommentLikeModel personalEventSetPostCommentLikeModelFromJson(String str) => PersonalEventSetPostCommentLikeModel.fromJson(json.decode(str));

String personalEventSetPostCommentLikeModelToJson(PersonalEventSetPostCommentLikeModel data) => json.encode(data.toJson());

class PersonalEventSetPostCommentLikeModel {
  int? personalEventPostCommentId;
  DateTime? likedOn;
  bool? isUnLike;

  PersonalEventSetPostCommentLikeModel({
    this.personalEventPostCommentId,
    this.likedOn,
    this.isUnLike,
  });

  factory PersonalEventSetPostCommentLikeModel.fromJson(Map<String, dynamic> json) => PersonalEventSetPostCommentLikeModel(
    personalEventPostCommentId: json["personalEventPostCommentId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostCommentId": personalEventPostCommentId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}