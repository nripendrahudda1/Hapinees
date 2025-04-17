// To parse this JSON data, do
//
//     final weddingViewPostModel = weddingViewPostModelFromJson(jsonString);

import 'dart:convert';

WeddingViewPostModel weddingViewPostModelFromJson(String str) => WeddingViewPostModel.fromJson(json.decode(str));

String weddingViewPostModelToJson(WeddingViewPostModel data) => json.encode(data.toJson());

class WeddingViewPostModel {
  int? weddingHeaderId;
  DateTime? viewDate;

  WeddingViewPostModel({
    this.weddingHeaderId,
    this.viewDate,
  });

  factory WeddingViewPostModel.fromJson(Map<String, dynamic> json) => WeddingViewPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    viewDate: json["viewDate"] == null ? null : DateTime.parse(json["viewDate"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "viewDate": viewDate?.toIso8601String(),
  };
}
