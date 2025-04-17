import 'dart:convert';

SetPersonalEventActivityPostModel setPersonalEventActivityPostModelFromJson(String str) => SetPersonalEventActivityPostModel.fromJson(json.decode(str));

String setPersonalEventActivityPostModelToJson(SetPersonalEventActivityPostModel data) => json.encode(data.toJson());

class SetPersonalEventActivityPostModel {
  int? personalEventHeaderId;
  int? personalEventActivityMasterId;
  String? activityName;
  String? aboutActivity;
  String? scheduleDate;
  String? venueAddress;
  String? venueLat;
  String? venueLong;
  int? visibility;
  String? createdOn;

  SetPersonalEventActivityPostModel({
    this.personalEventHeaderId,
    this.personalEventActivityMasterId,
    this.activityName,
    this.aboutActivity,
    this.scheduleDate,
    this.venueAddress,
    this.venueLat,
    this.venueLong,
    this.visibility,
    this.createdOn,
  });

  factory SetPersonalEventActivityPostModel.fromJson(Map<String, dynamic> json) => SetPersonalEventActivityPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventActivityMasterId: json["personalEventActivityMasterId"],
    activityName: json["activityName"],
    aboutActivity: json["aboutActivity"],
    scheduleDate: json["scheduleDate"],
    venueAddress: json["venueAddress"],
    venueLat: json["venueLat"],
    venueLong: json["venueLong"],
    visibility: json["visibility"],
    createdOn: json["createdOn"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId ?? 0,
    "personalEventActivityMasterId": personalEventActivityMasterId ?? 0,
    "activityName": activityName ?? "",
    "aboutActivity": aboutActivity ?? "",
    "scheduleDate": scheduleDate ?? "",
    "venueAddress": venueAddress ?? "",
    "venueLat": venueLat ?? "",
    "venueLong": venueLong ?? "",
    "visibility": visibility ?? 1,
    "createdOn": createdOn ?? "",
  };
}