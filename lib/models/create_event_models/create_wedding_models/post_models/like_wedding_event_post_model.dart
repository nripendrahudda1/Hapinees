import 'dart:convert';

LikeWeddingPostModel likeWeddingPostModelFromJson(String str) => LikeWeddingPostModel.fromJson(json.decode(str));

String likeWeddingPostModelToJson(LikeWeddingPostModel data) => json.encode(data.toJson());

class LikeWeddingPostModel {
  int? weddingHeaderId;
  DateTime? likedOn;
  bool? isUnLike;

  LikeWeddingPostModel({
    this.weddingHeaderId,
    this.likedOn,
    this.isUnLike,
  });

  factory LikeWeddingPostModel.fromJson(Map<String, dynamic> json) => LikeWeddingPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    likedOn: json["likedOn"] == null ? null : DateTime.parse(json["likedOn"]),
    isUnLike: json["isUnLike"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "likedOn": likedOn?.toIso8601String(),
    "isUnLike": isUnLike,
  };
}
