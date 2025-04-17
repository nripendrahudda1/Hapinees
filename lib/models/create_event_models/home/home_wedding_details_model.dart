// To parse this JSON data, do
//
//     final homeWeddingDetailsModel = homeWeddingDetailsModelFromJson(jsonString);

import 'dart:convert';

HomeWeddingDetailsModel homeWeddingDetailsModelFromJson(String str) =>
    HomeWeddingDetailsModel.fromJson(json.decode(str));

String homeWeddingDetailsModelToJson(HomeWeddingDetailsModel data) => json.encode(data.toJson());

class HomeWeddingDetailsModel {
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
  bool? guestVisibility;
  String? backgroundImageUrl;
  dynamic aboutTheWedding;
  dynamic venueAddress;
  String? venueLat;
  String? venueLong;
  dynamic invitationUrl;
  dynamic backgroundMusicUrl;
  bool? isActive;
  CreatedBy? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;
  int? views;
  int? likes;
  int? comments;
  int? videoStatus;
  dynamic videoUrl;
  List<WeddingInviteList>? weddingInviteList;
  List<WeddingRitualList>? weddingRitualList;
  bool? responseStatus;
  String? validationMessage;
  int? contributor;
  bool? selfRegistration;
  int? statusCode;

  HomeWeddingDetailsModel({
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
    this.guestVisibility,
    this.backgroundImageUrl,
    this.aboutTheWedding,
    this.venueAddress,
    this.venueLat,
    this.venueLong,
    this.invitationUrl,
    this.backgroundMusicUrl,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.views,
    this.likes,
    this.comments,
    this.videoStatus,
    this.videoUrl,
    this.weddingInviteList,
    this.weddingRitualList,
    this.responseStatus,
    this.validationMessage,
    this.contributor,
    this.selfRegistration,
    this.statusCode,
  });

  factory HomeWeddingDetailsModel.fromJson(Map<String, dynamic> json) => HomeWeddingDetailsModel(
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
        guestVisibility: json["guestVisibility"],
        backgroundImageUrl: json["backgroundImageUrl"],
        aboutTheWedding: json["aboutTheWedding"],
        venueAddress: json["venueAddress"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        invitationUrl: json["invitationUrl"],
        backgroundMusicUrl: json["backgroundMusicUrl"],
        isActive: json["isActive"],
        createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        views: json["views"],
        likes: json["likes"],
        comments: json["comments"],
        videoStatus: json["videoStatus"],
        videoUrl: json["videoUrl"],
        weddingInviteList: json["weddingInviteList"] == null
            ? []
            : List<WeddingInviteList>.from(
                json["weddingInviteList"]!.map((x) => WeddingInviteList.fromJson(x))),
        weddingRitualList: json["weddingRitualList"] == null
            ? []
            : List<WeddingRitualList>.from(
                json["weddingRitualList"]!.map((x) => WeddingRitualList.fromJson(x))),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        contributor: json["contributor"],
        selfRegistration: json["selfRegistration"],
        statusCode: json["statusCode"],
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
        "guestVisibility": guestVisibility,
        "backgroundImageUrl": backgroundImageUrl,
        "aboutTheWedding": aboutTheWedding,
        "venueAddress": venueAddress,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "invitationUrl": invitationUrl,
        "backgroundMusicUrl": backgroundMusicUrl,
        "isActive": isActive,
        "createdBy": createdBy?.toJson(),
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "views": views,
        "likes": likes,
        "comments": comments,
        "videoStatus": videoStatus,
        "videoUrl": videoUrl,
        "weddingInviteList": weddingInviteList == null
            ? []
            : List<dynamic>.from(weddingInviteList!.map((x) => x.toJson())),
        "weddingRitualList": weddingRitualList == null
            ? []
            : List<dynamic>.from(weddingRitualList!.map((x) => x.toJson())),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "contributor": contributor,
        "selfRegistration": selfRegistration,
        "statusCode": statusCode,
      };
}

class CreatedBy {
  int? userId;
  String? displayName;
  String? email;
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
        displayName: json["displayName"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        followStatus: json["followStatus"],
        followingStatus: json["followingStatus"],
        profileImageUrl: json["profileImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "displayName": displayName,
        "email": email,
        "contactNumber": contactNumber,
        "followStatus": followStatus,
        "followingStatus": followingStatus,
        "profileImageUrl": profileImageUrl,
      };
}

class WeddingInviteList {
  int? weddingInviteId;
  int? weddingHeaderId;
  CreatedBy? invitedBy;
  CreatedBy? inviteTo;
  DateTime? invitedOn;
  int? inviteVia;
  String? email;
  dynamic mobile;
  int? inviteStatus;
  dynamic acceptedRejectedOn;
  bool? isCoHost;

  WeddingInviteList({
    this.weddingInviteId,
    this.weddingHeaderId,
    this.invitedBy,
    this.inviteTo,
    this.invitedOn,
    this.inviteVia,
    this.email,
    this.mobile,
    this.inviteStatus,
    this.acceptedRejectedOn,
    this.isCoHost,
  });

  factory WeddingInviteList.fromJson(Map<String, dynamic> json) => WeddingInviteList(
        weddingInviteId: json["weddingInviteId"],
        weddingHeaderId: json["weddingHeaderId"],
        invitedBy: json["invitedBy"] == null ? null : CreatedBy.fromJson(json["invitedBy"]),
        inviteTo: json["inviteTo"] == null ? null : CreatedBy.fromJson(json["inviteTo"]),
        invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
        inviteVia: json["inviteVia"],
        email: json["email"],
        mobile: json["mobile"],
        inviteStatus: json["inviteStatus"],
        acceptedRejectedOn: json["acceptedRejectedOn"],
        isCoHost: json["isCoHost"],
      );

  Map<String, dynamic> toJson() => {
        "weddingInviteId": weddingInviteId,
        "weddingHeaderId": weddingHeaderId,
        "invitedBy": invitedBy?.toJson(),
        "inviteTo": inviteTo?.toJson(),
        "invitedOn": invitedOn?.toIso8601String(),
        "inviteVia": inviteVia,
        "email": email,
        "mobile": mobile,
        "inviteStatus": inviteStatus,
        "acceptedRejectedOn": acceptedRejectedOn,
        "isCoHost": isCoHost,
      };
}

class WeddingRitualList {
  int? weddingRitualId;
  int? weddingHeaderId;
  dynamic weddingRitualMasterId;
  String? ritualName;
  dynamic aboutRitual;
  DateTime? scheduleDate;
  dynamic venueAddress;
  String? venueLat;
  String? venueLong;
  String? backgroundImageUrl;
  int? visibility;
  CreatedBy? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  WeddingRitualList({
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

  factory WeddingRitualList.fromJson(Map<String, dynamic> json) => WeddingRitualList(
        weddingRitualId: json["weddingRitualId"],
        weddingHeaderId: json["weddingHeaderId"],
        weddingRitualMasterId: json["weddingRitualMasterId"],
        ritualName: json["ritualName"],
        aboutRitual: json["aboutRitual"],
        scheduleDate: json["scheduleDate"] == null ? null : DateTime.parse(json["scheduleDate"]),
        venueAddress: json["venueAddress"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
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
        "venueLat": venueLat,
        "venueLong": venueLong,
        "backgroundImageUrl": backgroundImageUrl,
        "visibility": visibility,
        "createdBy": createdBy?.toJson(),
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
      };
}
