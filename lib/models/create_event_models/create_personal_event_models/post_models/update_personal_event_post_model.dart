import 'dart:convert';

UpdatePersonalEventPostModel updatePersonalEventPostModelFromJson(String str) =>
    UpdatePersonalEventPostModel.fromJson(json.decode(str));

String updatePersonalEventPostModelToJson(UpdatePersonalEventPostModel data) =>
    json.encode(data.toJson());

class UpdatePersonalEventPostModel {
  int? personalEventHeaderId;
  int? personalEventThemeMasterId;
  String? personalEventThemeName;
  String? title;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool? multipleDayEvent;
  int? visibility;
  bool? isActive;
  String? aboutThePersonalEvent;
  String? venueAddress;
  String? countryCode;
  String? venueLat;
  String? venueLong;
  DateTime? modifiedOn;
  List<Activity>? activities;
  String? backgroundImageExtention;
  String? backgroundImageData;
  String? invitationExtention;
  String? invitationData;
  String? backgroundMusicExtention;
  String? backgroundMusicData;
  bool? selfRegistration;
  bool? guestVisibility;
  int? contributor;

  UpdatePersonalEventPostModel(
      {this.personalEventHeaderId,
      this.personalEventThemeMasterId,
      this.personalEventThemeName,
      this.title,
      this.startDateTime,
      this.endDateTime,
      this.multipleDayEvent,
      this.visibility,
      this.isActive,
      this.aboutThePersonalEvent,
      this.venueAddress,
      this.countryCode,
      this.venueLat,
      this.venueLong,
      this.modifiedOn,
      this.activities,
      this.backgroundImageExtention,
      this.backgroundImageData,
      this.invitationExtention,
      this.invitationData,
      this.backgroundMusicExtention,
      this.backgroundMusicData,
      this.selfRegistration,
      this.guestVisibility,
      this.contributor});

  factory UpdatePersonalEventPostModel.fromJson(Map<String, dynamic> json) =>
      UpdatePersonalEventPostModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventThemeMasterId: json["personalEventThemeMasterId"],
        personalEventThemeName: json["personalEventThemeName"],
        title: json["title"],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
        multipleDayEvent: json["multipleDayEvent"],
        visibility: json["visibility"],
        isActive: json["isActive"],
        aboutThePersonalEvent: json["aboutThePersonalEvent"],
        venueAddress: json["venueAddress"],
        countryCode: json["countryCode"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
        activities: json["activities"] == null
            ? []
            : List<Activity>.from(json["activities"]!.map((x) => Activity.fromJson(x))),
        backgroundImageExtention: json["backgroundImageExtention"],
        backgroundImageData: json["backgroundImageData"],
        invitationExtention: json["invitationExtention"],
        invitationData: json["invitationData"],
        backgroundMusicExtention: json["backgroundMusicExtention"],
        backgroundMusicData: json["backgroundMusicData"],
        selfRegistration: json["selfRegistration"],
        guestVisibility: json["guestVisibility"],
        contributor: json["contributor"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventHeaderId": personalEventHeaderId,
        "personalEventThemeMasterId": personalEventThemeMasterId,
        "personalEventThemeName": personalEventThemeName,
        "title": title,
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "multipleDayEvent": multipleDayEvent,
        "visibility": visibility,
        "isActive": isActive,
        "aboutThePersonalEvent": aboutThePersonalEvent,
        "venueAddress": venueAddress,
        "countryCode": countryCode,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "modifiedOn": modifiedOn?.toIso8601String(),
        "activities":
            activities == null ? [] : List<dynamic>.from(activities!.map((x) => x.toJson())),
        "backgroundImageExtention": backgroundImageExtention,
        "backgroundImageData": backgroundImageData,
        "invitationExtention": invitationExtention,
        "invitationData": invitationData,
        "backgroundMusicExtention": backgroundMusicExtention,
        "backgroundMusicData": backgroundMusicData,
        "selfRegistration": selfRegistration,
        "guestVisibility": guestVisibility,
        "contributor": contributor,
      };
}

class Activity {
  int? personalEventActivityId;
  int? personalEventActivityMasterId;
  String? activityName;

  Activity({
    this.personalEventActivityId,
    this.personalEventActivityMasterId,
    this.activityName,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        personalEventActivityId: json["personalEventActivityId"],
        personalEventActivityMasterId: json["personalEventActivityMasterId"],
        activityName: json["activityName"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventActivityId": personalEventActivityId,
        "personalEventActivityMasterId": personalEventActivityMasterId,
        "activityName": activityName,
      };
}
