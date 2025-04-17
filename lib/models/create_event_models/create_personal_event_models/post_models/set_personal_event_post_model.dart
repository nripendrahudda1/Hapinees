import 'dart:convert';

SetPersonalEventPostModel setPersonalEventPostModelFromJson(String str) =>
    SetPersonalEventPostModel.fromJson(json.decode(str));

String setPersonalEventPostModelToJson(SetPersonalEventPostModel data) =>
    json.encode(data.toJson());

class SetPersonalEventPostModel {
  int? eventTypeMasterId;
  int? personalEventThemeId;
  String? personalEventThemeName;
  String? title;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool? multipleDayEvent;
  int? visibility;
  bool? guestVisibility;
  String? aboutThePersonalEvent;
  String? venueAddress;
  String? countryCode;
  String? venueLat;
  String? venueLong;
  DateTime? createdOn;
  List<PersonalEventActivities>? personalEventActivities;
  String? backgroundImageExtention;
  String? backgroundImageData;
  String? invitationExtention;
  String? invitationData;
  String? backgroundMusicExtention;
  String? backgroundMusicData;
  bool? selfRegistration;
  int? contributor;

  SetPersonalEventPostModel(
      {this.eventTypeMasterId,
      this.personalEventThemeId,
      this.personalEventThemeName,
      this.title,
      this.startDateTime,
      this.endDateTime,
      this.multipleDayEvent,
      this.visibility,
      this.guestVisibility,
      this.aboutThePersonalEvent,
      this.venueAddress,
      this.countryCode,
      this.venueLat,
      this.venueLong,
      this.createdOn,
      this.personalEventActivities,
      this.backgroundImageExtention,
      this.backgroundImageData,
      this.invitationExtention,
      this.invitationData,
      this.backgroundMusicExtention,
      this.backgroundMusicData,
      this.selfRegistration,
      this.contributor});

  factory SetPersonalEventPostModel.fromJson(Map<String, dynamic> json) =>
      SetPersonalEventPostModel(
        eventTypeMasterId: json['eventTypeMasterId'],
        personalEventThemeId: json['personalEventThemeId'],
        personalEventThemeName: json['personalEventThemeName'],
        title: json['title'],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
        multipleDayEvent: json['multipleDayEvent'],
        visibility: json['visibility'],
        guestVisibility: json['guestVisibility'],
        aboutThePersonalEvent: json['aboutThePersonalEvent'],
        venueAddress: json['venueAddress'],
        countryCode: json['countryCode'],
        venueLat: json['venueLat'],
        venueLong: json['venueLong'],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        personalEventActivities: json["personalEventActivities"] == null
            ? []
            : List<PersonalEventActivities>.from(
                json["personalEventActivities"]!.map((x) => PersonalEventActivities.fromJson(x))),
        backgroundImageExtention: json['backgroundImageExtention'],
        backgroundImageData: json['backgroundImageData'],
        invitationExtention: json['invitationExtention'],
        invitationData: json['invitationData'],
        backgroundMusicExtention: json['backgroundMusicExtention'],
        backgroundMusicData: json['backgroundMusicData'],
        selfRegistration: json['selfRegistration'],
        contributor: json['contributor'],
      );

  Map<String, dynamic> toJson() => {
        'eventTypeMasterId': eventTypeMasterId,
        'personalEventThemeId': personalEventThemeId,
        'personalEventThemeName': personalEventThemeName,
        'title': title,
        'startDateTime': startDateTime?.toIso8601String(),
        'endDateTime': endDateTime?.toIso8601String(),
        'multipleDayEvent': multipleDayEvent,
        'visibility': visibility,
        'guestVisibility': guestVisibility,
        'aboutThePersonalEvent': aboutThePersonalEvent ?? "",
        'venueAddress': venueAddress ?? "",
        'countryCode': countryCode ?? "",
        'venueLat': venueLat ?? "",
        'venueLong': venueLong ?? "",
        'createdOn': createdOn?.toIso8601String(),
        "personalEventActivities": personalEventActivities == null
            ? []
            : List<dynamic>.from(personalEventActivities!.map((x) => x.toJson())),
        'backgroundImageExtention': backgroundImageExtention ?? "",
        'backgroundImageData': backgroundImageData ?? "",
        'invitationExtention': invitationExtention ?? "",
        'invitationData': invitationData ?? "",
        'backgroundMusicExtention': backgroundMusicExtention ?? "",
        'backgroundMusicData': backgroundMusicData ?? "",
        "selfRegistration": selfRegistration,
        "contributor": contributor,
      };
}

class PersonalEventActivities {
  int? personalEventActivityMasterId;
  String? activityName;
  String? aboutActivity;

  PersonalEventActivities(
      {this.personalEventActivityMasterId, this.activityName, this.aboutActivity});

  PersonalEventActivities.fromJson(Map<String, dynamic> json) {
    personalEventActivityMasterId = json['personalEventActivityMasterId'];
    activityName = json['activityName'];
    aboutActivity = json['aboutActivity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personalEventActivityMasterId'] = this.personalEventActivityMasterId;
    data['activityName'] = this.activityName;
    data['aboutActivity'] = this.aboutActivity;
    return data;
  }
}
