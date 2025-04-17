import 'dart:convert';

UpdateRitualPostModel updateRitualPostModelFromJson(String str) => UpdateRitualPostModel.fromJson(json.decode(str));

String updateRitualPostModelToJson(UpdateRitualPostModel data) => json.encode(data.toJson());

class UpdateRitualPostModel {
  int? weddingHeaderId;
  int? weddingRitualId;
  int? weddingRitualMasterId;
  String? ritualName;
  String? aboutRitual;
  DateTime? scheduleDate;
  String? venueAddress;
  String? venueLat;
  String? venueLong;
  int? visibility;
  bool? isActive;
  DateTime? modifiedOn;

  UpdateRitualPostModel({
    this.weddingHeaderId,
    this.weddingRitualId,
    this.weddingRitualMasterId,
    this.ritualName,
    this.aboutRitual,
    this.scheduleDate,
    this.venueAddress,
    this.venueLat,
    this.venueLong,
    this.visibility,
    this.isActive,
    this.modifiedOn,
  });

  factory UpdateRitualPostModel.fromJson(Map<String, dynamic> json) => UpdateRitualPostModel(
    weddingHeaderId: json["weddingHeaderId"],
    weddingRitualId: json["weddingRitualId"],
    weddingRitualMasterId: json["weddingRitualMasterId"],
    ritualName: json["ritualName"],
    aboutRitual: json["aboutRitual"],
    scheduleDate: json["scheduleDate"] == null ? null : DateTime.parse(json["scheduleDate"]),
    venueAddress: json["venueAddress"],
    venueLat: json["venueLat"],
    venueLong: json["venueLong"],
    visibility: json["visibility"],
    isActive: json["isActive"],
    modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "weddingRitualId": weddingRitualId,
    "weddingRitualMasterId": weddingRitualMasterId,
    "ritualName": ritualName,
    "aboutRitual": aboutRitual,
    "scheduleDate": scheduleDate?.toIso8601String(),
    "venueAddress": venueAddress,
    "venueLat": venueLat,
    "venueLong": venueLong,
    "visibility": visibility,
    "isActive": isActive,
    "modifiedOn": modifiedOn?.toIso8601String(),
  };
}
