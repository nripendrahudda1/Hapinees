import 'dart:convert';

import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';

import '../create_personal_event_models/get_all_personal_event_invited_users_model.dart';

HomePersonalEventDetailsModel homePersonalEventDetailsModelFromJson(String str) =>
    HomePersonalEventDetailsModel.fromJson(json.decode(str));

String homePersonalEventDetailsModelToJson(HomePersonalEventDetailsModel data) =>
    json.encode(data.toJson());

class HomePersonalEventDetailsModel {
  int? personalEventHeaderId;
  dynamic personalEventThemeMasterId;
  String? personalEventThemeName;
  String? title;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool? multipleDayEvent;
  int? visibility;
  bool? guestVisibility;
  String? backgroundImageUrl;
  String? aboutThePersonalEvent;
  String? venueAddress;
  String? venueLat;
  String? venueLong;
  String? invitationUrl;
  String? backgroundMusicUrl;
  bool? isActive;
  CreatedBy? createdBy;
  DateTime? createdOn;
  CreatedBy? modifiedBy;
  DateTime? modifiedOn;
  int? views;
  int? likes;
  int? comments;
  int? videoStatus;
  dynamic videoUrl;
  String? eventTypeCode;
  int? eventTypeId;
  String? eventIcon;
  List<PersonalEventInviteList>? personalEventInviteList;
  List<PersonalEventActivityList>? personalEventActivityList;
  bool? responseStatus;
  String? validationMessage;
  int? contributor;
  bool? selfRegistration;
  int? inviteStatus;
  int? statusCode;
  bool? isContributor;
  int? personalEventInviteId;

  HomePersonalEventDetailsModel({
    this.personalEventHeaderId,
    this.personalEventThemeMasterId,
    this.personalEventThemeName,
    this.title,
    this.startDateTime,
    this.endDateTime,
    this.multipleDayEvent,
    this.visibility,
    this.guestVisibility,
    this.backgroundImageUrl,
    this.aboutThePersonalEvent,
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
    this.eventTypeCode,
    this.eventTypeId,
    this.eventIcon,
    this.personalEventInviteList,
    this.personalEventActivityList,
    this.responseStatus,
    this.validationMessage,
    this.contributor,
    this.selfRegistration,
    this.inviteStatus,
    this.isContributor,
    this.statusCode,
    this.personalEventInviteId,
  });

  factory HomePersonalEventDetailsModel.fromJson(Map<String, dynamic> json) =>
      HomePersonalEventDetailsModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventThemeMasterId: json["personalEventThemeMasterId"],
        personalEventThemeName: json["personalEventThemeName"],
        title: json["title"],
        startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
        multipleDayEvent: json["multipleDayEvent"],
        visibility: json["visibility"],
        guestVisibility: json["guestVisibility"],
        backgroundImageUrl: json["backgroundImageUrl"],
        aboutThePersonalEvent: json["aboutThePersonalEvent"],
        venueAddress: json["venueAddress"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        invitationUrl: json["invitationUrl"],
        backgroundMusicUrl: json["backgroundMusicUrl"],
        isActive: json["isActive"],
        createdBy: json["createdBy"] == null ? null : CreatedBy.fromJson(json["createdBy"]),
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"] == null ? null : CreatedBy.fromJson(json["modifiedBy"]),
        modifiedOn: json["modifiedOn"] == null ? null : DateTime.parse(json["modifiedOn"]),
        views: json["views"],
        likes: json["likes"],
        comments: json["comments"],
        videoStatus: json["videoStatus"],
        videoUrl: json["videoUrl"],
        eventTypeCode: json["eventTypeCode"],
        eventTypeId: json["eventTypeId"],
        eventIcon: json["eventIcon"],
        personalEventInviteList: json["personalEventInviteList"],
        personalEventActivityList: json["personalEventActivityList"],
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        contributor: json["contributor"] ?? 0,
        selfRegistration: json["selfRegistration"] ?? true,
        inviteStatus: json["inviteStatus"],
        isContributor: json["isContributor"],
        statusCode: json["statusCode"],
        personalEventInviteId: json["personalEventInviteId"] ?? 0,
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
        "guestVisibility": guestVisibility,
        "backgroundImageUrl": backgroundImageUrl,
        "aboutThePersonalEvent": aboutThePersonalEvent,
        "venueAddress": venueAddress,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "invitationUrl": invitationUrl,
        "backgroundMusicUrl": backgroundMusicUrl,
        "isActive": isActive,
        "createdBy": createdBy?.toJson(),
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy?.toJson(),
        "modifiedOn": modifiedOn?.toIso8601String(),
        "views": views,
        "likes": likes,
        "comments": comments,
        "videoStatus": videoStatus,
        "videoUrl": videoUrl,
        "eventTypeCode": eventTypeCode,
        "eventTypeId": eventTypeId,
        "eventIcon": eventIcon,
        "personalEventInviteList": personalEventInviteList,
        "personalEventActivityList": personalEventActivityList,
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "contributor": contributor,
        "selfRegistration": selfRegistration,
        "inviteStatus": inviteStatus,
        "isContributor": isContributor,
        "statusCode": statusCode,
        "personalEventInviteId": personalEventInviteId,
      };
}

class CreatedBy {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followerStatus;
  int? followingStatus;
  String? profileImageUrl;

  CreatedBy({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followerStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        userId: json["userId"],
        displayName: json["displayName"],
        email: json["email"],
        contactNumber: json["contactNumber"],
        followerStatus: json["followerStatus"],
        followingStatus: json["followingStatus"],
        profileImageUrl: json["profileImageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "displayName": displayName,
        "email": email,
        "contactNumber": contactNumber,
        "followerStatus": followerStatus,
        "followingStatus": followingStatus,
        "profileImageUrl": profileImageUrl,
      };
}

PersonalEventActivitiesList personalEventActivitiesListFromJson(String str) =>
    PersonalEventActivitiesList.fromJson(json.decode(str));

String personalEventActivitiesListToJson(PersonalEventActivitiesList data) =>
    json.encode(data.toJson());

class PersonalEventActivitiesList {
  List<PersonalEventActivityList>? personalEventActivityList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventActivitiesList({
    this.personalEventActivityList,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventActivitiesList.fromJson(Map<String, dynamic> json) =>
      PersonalEventActivitiesList(
        personalEventActivityList: json["personalEventActivityList"] == null
            ? []
            : List<PersonalEventActivityList>.from(json["personalEventActivityList"]!
                .map((x) => PersonalEventActivityList.fromJson(x))),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventActivityList": personalEventActivityList == null
            ? []
            : List<dynamic>.from(personalEventActivityList!.map((x) => x.toJson())),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "statusCode": statusCode,
      };
}

class PersonalEventActivityList {
  int? personalEventActivityId;
  int? personalEventHeaderId;
  int? personalEventActivityMasterId;
  String? activityName;
  String? aboutActivity;
  DateTime? scheduleDate;
  dynamic venueAddress;
  dynamic venueLat;
  dynamic venueLong;
  dynamic backgroundImageUrl;
  int? visibility;
  int? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  PersonalEventActivityList({
    this.personalEventActivityId,
    this.personalEventHeaderId,
    this.personalEventActivityMasterId,
    this.activityName,
    this.aboutActivity,
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

  factory PersonalEventActivityList.fromJson(Map<String, dynamic> json) =>
      PersonalEventActivityList(
        personalEventActivityId: json["personalEventActivityId"],
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventActivityMasterId: json["personalEventActivityMasterId"],
        activityName: json["activityName"],
        aboutActivity: json["aboutActivity"],
        scheduleDate: json["scheduleDate"] == null ? null : DateTime.parse(json["scheduleDate"]),
        venueAddress: json["venueAddress"],
        venueLat: json["venueLat"],
        venueLong: json["venueLong"],
        backgroundImageUrl: json["backgroundImageUrl"],
        visibility: json["visibility"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventActivityId": personalEventActivityId,
        "personalEventHeaderId": personalEventHeaderId,
        "personalEventActivityMasterId": personalEventActivityMasterId,
        "activityName": activityName,
        "aboutActivity": aboutActivity,
        "scheduleDate": scheduleDate?.toIso8601String(),
        "venueAddress": venueAddress,
        "venueLat": venueLat,
        "venueLong": venueLong,
        "backgroundImageUrl": backgroundImageUrl,
        "visibility": visibility,
        "createdBy": createdBy,
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
      };
}
