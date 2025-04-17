// To parse this JSON data, do
//
//     final updateEventPostModel = updateEventPostModelFromJson(jsonString);

import 'dart:convert';

UpdateWeddingEventPostModel updateWeddingEventPostModelFromJson(String str) =>
    UpdateWeddingEventPostModel.fromJson(json.decode(str));

String updateWeddingEventPostModelToJson(UpdateWeddingEventPostModel data) =>
    json.encode(data.toJson());

class UpdateWeddingEventPostModel {
  int? weddingHeaderId;
  int? weddingStyleMasterId;
  String? weddigStyleName;
  String? title;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool? multipleDayEvent;
  String? partner1;
  String? partner2;
  int? visibility;
  bool? isActive;
  String? aboutTheWedding;
  String? venueAddress;
  String? countryCode;
  String? venueLat;
  String? venueLong;
  DateTime? modifiedOn;
  List<Ritual>? rituals;
  String? backgroundImageExtention;
  String? backgroundImageData;
  String? invitationExtention;
  String? invitationData;
  String? backgroundMusicExtention;
  String? backgroundMusicData;
  bool? selfRegistration;
  int? contributor;

  UpdateWeddingEventPostModel({
    this.weddingHeaderId,
    this.weddingStyleMasterId,
    this.weddigStyleName,
    this.title,
    this.startDateTime,
    this.endDateTime,
    this.multipleDayEvent,
    this.partner1,
    this.partner2,
    this.visibility,
    this.isActive,
    this.aboutTheWedding,
    this.venueAddress,
    this.countryCode,
    this.venueLat,
    this.venueLong,
    this.modifiedOn,
    this.rituals,
    this.backgroundImageExtention,
    this.backgroundImageData,
    this.invitationExtention,
    this.invitationData,
    this.backgroundMusicExtention,
    this.backgroundMusicData,
    this.contributor,
    this.selfRegistration,
  });

  factory UpdateWeddingEventPostModel.fromJson(Map<String, dynamic> json) =>
      UpdateWeddingEventPostModel(
        weddingHeaderId: json["weddingHeaderId"],
        weddingStyleMasterId: json["weddingStyleMasterId"],
        weddigStyleName: json["weddigStyleName"],
        title: json["title"],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
        multipleDayEvent: json["multipleDayEvent"],
        partner1: json["partner1"],
        partner2: json["partner2"],
        visibility: json["visibility"],
        isActive: json["isActive"],
        aboutTheWedding: json["aboutTheWedding"],
        venueAddress: json["venueAddress"],
        countryCode: json["countryCode"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
        rituals: json["rituals"] == null
            ? []
            : List<Ritual>.from(json["rituals"]!.map((x) => Ritual.fromJson(x))),
        backgroundImageExtention: json["backgroundImageExtention"],
        backgroundImageData: json["backgroundImageData"],
        invitationExtention: json["invitationExtention"],
        invitationData: json["invitationData"],
        backgroundMusicExtention: json["backgroundMusicExtention"],
        backgroundMusicData: json["backgroundMusicData"],
        selfRegistration: json["selfRegistration"],
        contributor: json["contributor"],
      );

  Map<String, dynamic> toJson() => {
        "weddingHeaderId": weddingHeaderId,
        "weddingStyleMasterId": weddingStyleMasterId,
        "weddigStyleName": weddigStyleName,
        "title": title,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "multipleDayEvent": multipleDayEvent,
        "partner1": partner1,
        "partner2": partner2,
        "visibility": visibility,
        "isActive": isActive,
        "aboutTheWedding": aboutTheWedding,
        "venueAddress": venueAddress,
        "countryCode": countryCode,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "modifiedOn": modifiedOn?.toIso8601String(),
        "rituals": rituals == null ? [] : List<dynamic>.from(rituals!.map((x) => x.toJson())),
        "backgroundImageExtention": backgroundImageExtention,
        "backgroundImageData": backgroundImageData,
        "invitationExtention": invitationExtention,
        "invitationData": invitationData,
        "backgroundMusicExtention": backgroundMusicExtention,
        "backgroundMusicData": backgroundMusicData,
        "contributor": contributor,
        "selfRegistration": selfRegistration,
      };
}

class Ritual {
  int? weddingRitualId;
  int? weddingRitualMasterId;
  String? ritualName;

  Ritual({
    this.weddingRitualId,
    this.weddingRitualMasterId,
    this.ritualName,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) => Ritual(
        weddingRitualId: json["weddingRitualId"],
        weddingRitualMasterId: json["weddingRitualMasterId"],
        ritualName: json["ritualName"],
      );

  Map<String, dynamic> toJson() => {
        "weddingRitualId": weddingRitualId,
        "weddingRitualMasterId": weddingRitualMasterId,
        "ritualName": ritualName,
      };
}
