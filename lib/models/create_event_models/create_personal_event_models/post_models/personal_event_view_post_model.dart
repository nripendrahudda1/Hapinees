import 'dart:convert';

PersonalEventViewPostModel personalEventViewPostModelFromJson(String str) => PersonalEventViewPostModel.fromJson(json.decode(str));

String personalEventViewPostModelToJson(PersonalEventViewPostModel data) => json.encode(data.toJson());

class PersonalEventViewPostModel {
  int? personalEventHeaderId;
  DateTime? viewDate;

  PersonalEventViewPostModel({
    this.personalEventHeaderId,
    this.viewDate,
  });

  factory PersonalEventViewPostModel.fromJson(Map<String, dynamic> json) => PersonalEventViewPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    viewDate: json["viewDate"] == null ? null : DateTime.parse(json["viewDate"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "viewDate": viewDate?.toIso8601String(),
  };
}
