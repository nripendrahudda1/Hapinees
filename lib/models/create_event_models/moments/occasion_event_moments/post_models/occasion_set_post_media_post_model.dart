import 'dart:convert';

OccasionSetPostMediaPostModel occasionSetPostMediaPostModelFromJson(String str) => OccasionSetPostMediaPostModel.fromJson(json.decode(str));

String occasionSetPostMediaPostModelToJson(OccasionSetPostMediaPostModel data) => json.encode(data.toJson());

class OccasionSetPostMediaPostModel {
  int? occasionPostId;
  String? mediaData;
  String? mediaExtention;
  DateTime? createdOn;

  OccasionSetPostMediaPostModel({
    this.occasionPostId,
    this.mediaData,
    this.mediaExtention,
    this.createdOn,
  });

  factory OccasionSetPostMediaPostModel.fromJson(Map<String, dynamic> json) => OccasionSetPostMediaPostModel(
    occasionPostId: json["occasionPostId"],
    mediaData: json["mediaData"],
    mediaExtention: json["mediaExtention"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "occasionPostId": occasionPostId,
    "mediaData": mediaData,
    "mediaExtention": mediaExtention,
    "createdOn": createdOn?.toIso8601String(),
  };
}
