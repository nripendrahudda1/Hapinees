import 'dart:convert';

DeleteWeddingRitualPostModel deleteWeddingRitualPostModelFromJson(String str) => DeleteWeddingRitualPostModel.fromJson(json.decode(str));

String deleteWeddingRitualPostModelToJson(DeleteWeddingRitualPostModel data) => json.encode(data.toJson());

class DeleteWeddingRitualPostModel {
  int? weddingHeaderId;
  int? weddingRitualId;

  DeleteWeddingRitualPostModel({
    this.weddingHeaderId,
    this.weddingRitualId,
  });

  factory DeleteWeddingRitualPostModel.fromJson(Map<String, dynamic> json) => DeleteWeddingRitualPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingRitualId: json["weddingRitualId"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingRitualId": weddingRitualId,
  };
}
