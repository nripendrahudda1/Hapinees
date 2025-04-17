// To parse this JSON data, do
//
//     final setWeddingPostModel = setWeddingPostModelFromJson(jsonString);

import 'dart:convert';

SetWeddingPostModel setWeddingPostModelFromJson(String str) =>
    SetWeddingPostModel.fromJson(json.decode(str));

String setWeddingPostModelToJson(SetWeddingPostModel data) => json.encode(data.toJson());

class SetWeddingPostModel {
  int? weddingStyleMasterId;
  String? weddigStyleName;
  String? title;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool? multipleDayEvent;
  String? partner1;
  String? partner2;
  int? visibility;
  String? aboutTheWedding;
  String? venueAddress;
  String? venueLat;
  String? venueLong;
  String? countryCode;
  DateTime? createdOn;
  List<WeddingRitual>? weddingRituals;
  String? backgroundImageExtention;
  String? backgroundImageData;
  String? invitationExtention;
  String? invitationData;
  String? backgroundMusicExtention;
  String? backgroundMusicData;
  bool? selfRegistration;
  int? contributor;

  SetWeddingPostModel({
    this.weddingStyleMasterId,
    this.weddigStyleName,
    this.title,
    this.startDateTime,
    this.endDateTime,
    this.multipleDayEvent,
    this.partner1,
    this.partner2,
    this.visibility,
    this.aboutTheWedding,
    this.venueAddress,
    this.venueLat,
    this.countryCode,
    this.venueLong,
    this.createdOn,
    this.weddingRituals,
    this.backgroundImageExtention,
    this.backgroundImageData,
    this.invitationExtention,
    this.invitationData,
    this.backgroundMusicExtention,
    this.backgroundMusicData,
    this.contributor,
    this.selfRegistration,
  });

  factory SetWeddingPostModel.fromJson(Map<String, dynamic> json) => SetWeddingPostModel(
        weddingStyleMasterId: json["weddingStyleMasterId"],
        weddigStyleName: json["weddigStyleName"],
        countryCode: json["countryCode"],
        title: json["title"],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
        multipleDayEvent: json["multipleDayEvent"],
        partner1: json["partner1"],
        partner2: json["partner2"],
        visibility: json["visibility"],
        aboutTheWedding: json["aboutTheWedding"],
        venueAddress: json["venueAddress"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        weddingRituals: json["weddingRituals"] == null
            ? []
            : List<WeddingRitual>.from(
                json["weddingRituals"]!.map((x) => WeddingRitual.fromJson(x))),
        backgroundImageExtention: json["backgroundImageExtention"],
        backgroundImageData: json["backgroundImageData"],
        invitationExtention: json["invitationExtention"],
        invitationData: json["invitationData"],
        backgroundMusicExtention: json["backgroundMusicExtention"],
        backgroundMusicData: json["backgroundMusicData"],
        contributor: json["contributor"],
        selfRegistration: json["selfRegistration"],
      );

  Map<String, dynamic> toJson() => {
        "weddingStyleMasterId": weddingStyleMasterId,
        "weddigStyleName": weddigStyleName,
        "countryCode": countryCode,
        "title": title,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "multipleDayEvent": multipleDayEvent,
        "partner1": partner1,
        "partner2": partner2,
        "visibility": visibility,
        "aboutTheWedding": aboutTheWedding,
        "venueAddress": venueAddress,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "createdOn": createdOn?.toIso8601String(),
        "weddingRituals": weddingRituals == null
            ? []
            : List<dynamic>.from(weddingRituals!.map((x) => x.toJson())),
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

class WeddingRitual {
  int? weddingRitualMasterId;
  String? ritualName;

  WeddingRitual({
    this.weddingRitualMasterId,
    this.ritualName,
  });

  factory WeddingRitual.fromJson(Map<String, dynamic> json) => WeddingRitual(
        weddingRitualMasterId: json["weddingRitualMasterId"],
        ritualName: json["ritualName"],
      );

  Map<String, dynamic> toJson() => {
        "weddingRitualMasterId": weddingRitualMasterId,
        "ritualName": ritualName,
      };
}
