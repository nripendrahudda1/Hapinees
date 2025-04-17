import 'dart:convert';

OccasionCreatePostMemoryPostModel occasionCreatePostMemoryPostModelFromJson(String str) => OccasionCreatePostMemoryPostModel.fromJson(json.decode(str));

String occasionCreatePostMemoryPostModelToJson(OccasionCreatePostMemoryPostModel data) => json.encode(data.toJson());

class OccasionCreatePostMemoryPostModel {
  int? eventTypeMasterId;
  int? occasionId;
  int? background;
  String? postNote;
  DateTime? createdOn;

  OccasionCreatePostMemoryPostModel({
    this.eventTypeMasterId,
    this.occasionId,
    this.background,
    this.postNote,
    this.createdOn,
  });

  factory OccasionCreatePostMemoryPostModel.fromJson(Map<String, dynamic> json) => OccasionCreatePostMemoryPostModel(
    eventTypeMasterId: json["eventTypeMasterId"],
    occasionId: json["occasionId"],
    background: json["background"],
    postNote: json["postNote"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "eventTypeMasterId": eventTypeMasterId,
    "occasionId": occasionId,
    "background": background,
    "postNote": postNote,
    "createdOn": createdOn?.toIso8601String(),
  };
}
