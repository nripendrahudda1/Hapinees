import 'dart:convert';

PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModelFromJson(
        String str) =>
    PersonalEventCreateMemoriesTextPostModel.fromJson(json.decode(str));

String personalEventCreateMemoriesTextPostModelToJson(
        PersonalEventCreateMemoriesTextPostModel data) =>
    json.encode(data.toJson());

class PersonalEventCreateMemoriesTextPostModel {
  int? personalEventHeaderId;
  int? personalEventActivityId;
  String? aboutPost;
  DateTime? createdOn;
  int? personalEventPostId;

  PersonalEventCreateMemoriesTextPostModel({
    this.personalEventHeaderId,
    this.personalEventActivityId,
    this.aboutPost,
    this.createdOn,
    this.personalEventPostId,
  });

  factory PersonalEventCreateMemoriesTextPostModel.fromJson(Map<String, dynamic> json) =>
      PersonalEventCreateMemoriesTextPostModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventActivityId: json["personalEventActivityId"],
        aboutPost: json["aboutPost"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        personalEventPostId: json["personalEventPostId"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventHeaderId": personalEventHeaderId,
        "personalEventActivityId": personalEventActivityId,
        "aboutPost": aboutPost,
        "createdOn": createdOn?.toIso8601String(),
        "personalEventPostId": personalEventPostId,
      };

  //   Map<String, dynamic> toJson() {
  // final Map<String, dynamic> data = {
  //   "personalEventHeaderId": personalEventHeaderId,
  //   "aboutPost": aboutPost,
  //   "createdOn": createdOn?.toIso8601String(),
  // };
  // if (personalEventPostId != null) {
  //   data["personalEventPostId"] = personalEventPostId;
  // }

  // return data;
  //}
}
