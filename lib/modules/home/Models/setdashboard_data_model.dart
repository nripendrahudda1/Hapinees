import 'dart:convert';

SetDashboardgetModel dashboradModelFromJson(String str) =>
    SetDashboardgetModel.fromJson(json.decode(str));

String setDashboardPostModelToJson(SetDashboardgetModel data) =>
    json.encode(data.toJson());

class SetDashboardgetModel {
  int? offset;
  int? noOfRecords;
  String? deviceId;
  String? sortEventsBy;
  int? moduleId;

  SetDashboardgetModel({
    this.offset,
    this.noOfRecords,
    this.deviceId,
    this.sortEventsBy,
    this.moduleId,
  });

  factory SetDashboardgetModel.fromJson(Map<String, dynamic> json) => SetDashboardgetModel(
        offset: json["offset"],
        noOfRecords: json["noOfRecords"],
        deviceId: json["deviceId"],
        sortEventsBy: json["sortEventsBy"],
        moduleId: json["moduleId"],
      );

  Map<String, dynamic> toJson() => {
        "offset": offset,
        "noOfRecords": noOfRecords,
        "deviceId": deviceId,
        "sortEventsBy": sortEventsBy,
        "moduleId": moduleId,
      };
}
