import 'dart:convert';

PersonalEventActivityModel personalEventActivityModelFromJson(String str) => PersonalEventActivityModel.fromJson(json.decode(str));

String personalEventActivityModelToJson(PersonalEventActivityModel data) => json.encode(data.toJson());

class PersonalEventActivityModel {
  List<PersonalEventActivityMasterList>? personalEventActivityMasterList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventActivityModel({
    this.personalEventActivityMasterList,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventActivityModel.fromJson(Map<String, dynamic> json) => PersonalEventActivityModel(
    personalEventActivityMasterList: json["personalEventActivityMasterList"] == null ? [] : List<PersonalEventActivityMasterList>.from(json["personalEventActivityMasterList"]!.map((x) => PersonalEventActivityMasterList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityMasterList": personalEventActivityMasterList == null ? [] : List<dynamic>.from(personalEventActivityMasterList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class PersonalEventActivityMasterList {
  int? personalEventActivityMasterId;
  int? personalEventThemeMasterId;
  String? activityName;
  String? defaultImageUrl;
  String? language;
  bool? isActive;
  int? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  PersonalEventActivityMasterList({
    this.personalEventActivityMasterId,
    this.personalEventThemeMasterId,
    this.activityName,
    this.defaultImageUrl,
    this.language,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  factory PersonalEventActivityMasterList.fromJson(Map<String, dynamic> json) => PersonalEventActivityMasterList(
    personalEventActivityMasterId: json["personalEventActivityMasterId"],
    personalEventThemeMasterId: json["personalEventThemeMasterId"],
    activityName: json["activityName"],
    defaultImageUrl: json["defaultImageUrl"],
    language: json["language"],
    isActive: json["isActive"],
    createdBy: json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    modifiedBy: json["modifiedBy"],
    modifiedOn: json["modifiedOn"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventActivityMasterId": personalEventActivityMasterId,
    "personalEventThemeMasterId": personalEventThemeMasterId,
    "activityName": activityName,
    "defaultImageUrl": defaultImageUrl,
    "language": language,
    "isActive": isActive,
    "createdBy": createdBy,
    "createdOn": createdOn?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn,
  };
}