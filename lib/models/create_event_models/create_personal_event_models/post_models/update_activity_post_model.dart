import 'dart:convert';

UpdateActivityPostModel updateActivityPostModelFromJson(String str) => UpdateActivityPostModel.fromJson(json.decode(str));

String updateActivityPostModelToJson(UpdateActivityPostModel data) => json.encode(data.toJson());

class UpdateActivityPostModel {
  int? personalEventHeaderId;
  int? personalEventActivityId;
  int? personalEventActivityMasterId;
  String? activityName;
  String? aboutActivity;
  DateTime? scheduleDate;
  String? venueAddress;
  String? venueLat;
  String? venueLong;
  int? visibility;
  bool? isActive;
  DateTime? modifiedOn;

  UpdateActivityPostModel({
    this.personalEventHeaderId,
    this.personalEventActivityId,
    this.personalEventActivityMasterId,
    this.activityName,
    this.aboutActivity,
    this.scheduleDate,
    this.venueAddress,
    this.venueLat,
    this.venueLong,
    this.visibility,
    this.isActive,
    this.modifiedOn,
  });

  factory UpdateActivityPostModel.fromJson(Map<String, dynamic> json) => UpdateActivityPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventActivityId: json["personalEventActivityId"],
    personalEventActivityMasterId: json["personalEventActivityMasterId"],
    activityName: json["activityName"],
    aboutActivity: json["aboutActivity"],
    scheduleDate: json["scheduleDate"] == null ? null : DateTime.parse(json["scheduleDate"]),
    venueAddress: json["venueAddress"],
    venueLat: json["venueLat"],
    venueLong: json["venueLong"],
    visibility: json["visibility"],
    isActive: json["isActive"],
    modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "personalEventActivityId": personalEventActivityId,
    "personalEventActivityMasterId": personalEventActivityMasterId,
    "activityName": activityName,
    "aboutActivity": aboutActivity,
    "scheduleDate": scheduleDate?.toIso8601String(),
    "venueAddress": venueAddress,
    "venueLat": venueLat,
    "venueLong": venueLong,
    "visibility": visibility,
    "isActive": isActive,
    "modifiedOn": modifiedOn?.toIso8601String(),
  };
}