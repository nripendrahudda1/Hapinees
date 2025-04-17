// To parse this JSON data, do
//
//     final weddingRitualsUpdateModel = weddingRitualsUpdateModelFromJson(jsonString);

import 'dart:convert';

WeddingRitualsUpdateModel weddingRitualsUpdateModelFromJson(String str) => WeddingRitualsUpdateModel.fromJson(json.decode(str));

String weddingRitualsUpdateModelToJson(WeddingRitualsUpdateModel data) => json.encode(data.toJson());

class WeddingRitualsUpdateModel {
  List<WeddingRitualUpdateList>? weddingRitualList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  WeddingRitualsUpdateModel({
    this.weddingRitualList,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory WeddingRitualsUpdateModel.fromJson(Map<String, dynamic> json) => WeddingRitualsUpdateModel(
    weddingRitualList: json["weddingRitualList"] == null ? [] : List<WeddingRitualUpdateList>.from(json["weddingRitualList"]!.map((x) => WeddingRitualUpdateList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualList": weddingRitualList == null ? [] : List<dynamic>.from(weddingRitualList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class WeddingRitualUpdateList {
  int? weddingRitualId;
  int? weddingHeaderId;
  dynamic weddingRitualMasterId;
  String? ritualName;
  dynamic aboutRitual;
  DateTime? scheduleDate;
  String? venueAddress;
  VenueL? venueLat;
  VenueL? venueLong;
  String? backgroundImageUrl;
  int? visibility;
  CreatedBy? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  WeddingRitualUpdateList({
    this.weddingRitualId,
    this.weddingHeaderId,
    this.weddingRitualMasterId,
    this.ritualName,
    this.aboutRitual,
    this.scheduleDate,
    this.venueAddress,
    this.venueLat,
    this.venueLong,
    this.backgroundImageUrl,
    this.visibility,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  factory WeddingRitualUpdateList.fromJson(Map<String, dynamic> json) => WeddingRitualUpdateList(
    weddingRitualId: json["weddingRitualId"],
    weddingHeaderId: json["weddingHeaderId"],
    weddingRitualMasterId: json["weddingRitualMasterId"],
    ritualName: json["ritualName"],
    aboutRitual: json["aboutRitual"],
    scheduleDate: json["scheduleDate"] == null ? null : DateTime.parse(json["scheduleDate"]),
    venueAddress: json["venueAddress"],
    venueLat: venueLValues.map[json["venueLat"]]!,
    venueLong: venueLValues.map[json["venueLong"]]!,
    backgroundImageUrl: json["backgroundImageUrl"],
    visibility: json["visibility"],
    createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    modifiedBy: json["modifiedBy"],
    modifiedOn: json["modifiedOn"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualId": weddingRitualId,
    "weddingHeaderId": weddingHeaderId,
    "weddingRitualMasterId": weddingRitualMasterId,
    "ritualName": ritualName,
    "aboutRitual": aboutRitual,
    "scheduleDate": scheduleDate?.toIso8601String(),
    "venueAddress": venueAddress,
    "venueLat": venueLValues.reverse[venueLat],
    "venueLong": venueLValues.reverse[venueLong],
    "backgroundImageUrl": backgroundImageUrl,
    "visibility": visibility,
    "createdBy": createdBy?.toJson(),
    "createdOn": createdOn?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn,
  };
}

class CreatedBy {
  int? userId;
  DisplayName? displayName;
  Email? email;
  dynamic contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  CreatedBy({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
    userId: json["userId"],
    displayName: displayNameValues.map[json["displayName"]]!,
    email: emailValues.map[json["email"]]!,
    contactNumber: json["contactNumber"],
    followStatus: json["followStatus"],
    followingStatus: json["followingStatus"],
    profileImageUrl: json["profileImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "displayName": displayNameValues.reverse[displayName],
    "email": emailValues.reverse[email],
    "contactNumber": contactNumber,
    "followStatus": followStatus,
    "followingStatus": followingStatus,
    "profileImageUrl": profileImageUrl,
  };
}

enum DisplayName {
  HOLEDA4105
}

final displayNameValues = EnumValues({
  "holeda4105": DisplayName.HOLEDA4105
});

enum Email {
  HOLEDA4105_NIMADIR_COM
}

final emailValues = EnumValues({
  "holeda4105@nimadir.com": Email.HOLEDA4105_NIMADIR_COM
});

enum VenueL {
  NULL
}

final venueLValues = EnumValues({
  "null": VenueL.NULL
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
