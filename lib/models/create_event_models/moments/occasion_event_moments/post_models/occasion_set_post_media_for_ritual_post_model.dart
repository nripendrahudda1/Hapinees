import 'dart:convert';

OccasionSetPostMediaForRitualPostModel occasionSetPostMediaForRitualPostModelFromJson(String str) => OccasionSetPostMediaForRitualPostModel.fromJson(json.decode(str));

String occasionSetPostMediaForRitualPostModelToJson(OccasionSetPostMediaForRitualPostModel data) => json.encode(data.toJson());

class OccasionSetPostMediaForRitualPostModel {
  int? weddingHeaderId;
  int? weddingRitualId;
  int? occasionPostId;
  int? occasionPostMediaId;
  DateTime? createdOn;

  OccasionSetPostMediaForRitualPostModel({
    this.weddingHeaderId,
    this.weddingRitualId,
    this.occasionPostId,
    this.occasionPostMediaId,
    this.createdOn,
  });

  factory OccasionSetPostMediaForRitualPostModel.fromJson(Map<String, dynamic> json) => OccasionSetPostMediaForRitualPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingRitualId: json["weddingRitualId"],
    occasionPostId: json["occasionPostId"],
    occasionPostMediaId: json["occasionPostMediaId"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingRitualId": weddingRitualId,
    "occasionPostId": occasionPostId,
    "occasionPostMediaId": occasionPostMediaId,
    "createdOn": createdOn?.toIso8601String(),
  };
}
