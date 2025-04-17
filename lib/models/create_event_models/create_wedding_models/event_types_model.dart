import 'dart:convert';

EventTypesModel eventTypesModelFromJson(String str) => EventTypesModel.fromJson(json.decode(str));

String eventTypesModelToJson(EventTypesModel data) => json.encode(data.toJson());

class EventTypesModel {
  List<EventTypeMasterList>? eventTypeMasterList;
  bool? responseStatus;
  String? validationMessage;

  EventTypesModel({
    this.eventTypeMasterList,
    this.responseStatus,
    this.validationMessage,
  });

  factory EventTypesModel.fromJson(Map<String, dynamic> json) => EventTypesModel(
        eventTypeMasterList: json["eventTypeMasterList"] == null
            ? []
            : List<EventTypeMasterList>.from(
                json["eventTypeMasterList"]!.map((x) => EventTypeMasterList.fromJson(x))),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
      );

  Map<String, dynamic> toJson() => {
        "eventTypeMasterList": eventTypeMasterList == null
            ? []
            : List<dynamic>.from(eventTypeMasterList!.map((x) => x.toJson())),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
      };
}

class EventTypeMasterList {
  bool? hasThemes;
  int? eventTypeMasterId;
  String? eventTypeName;
  // int? eventCategoryMasterId;
  String? icon;
  String? language;
  String? eventTypeCode;
  bool? isActive;
  int? createdBy;
  DateTime? createdOn;
  int? modifiedBy;
  dynamic modifiedOn;
  int? eventModuleID;
  String? eventModuleName;
  String? eventIconBlue;
  String? eventIconWhite;
  String? eventPinOrange;

  EventTypeMasterList({
    this.hasThemes,
    this.eventTypeMasterId,
    this.eventTypeName,
    // this.eventCategoryMasterId,
    this.icon,
    this.eventTypeCode,
    this.language,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
    this.eventModuleID,
    this.eventModuleName,
    this.eventIconBlue,
    this.eventIconWhite,
    this.eventPinOrange,
  });

  factory EventTypeMasterList.fromJson(Map<String, dynamic> json) => EventTypeMasterList(
        hasThemes: json["hasThemes"],
        eventTypeMasterId: json["eventTypeMasterId"],
        eventTypeName: json["eventTypeName"],
        // eventCategoryMasterId: json["eventCategoryMasterId"],
        icon: json["icon"],
        eventIconBlue: json["eventIconBlue"],
        eventIconWhite: json["eventIconWhite"],
        eventPinOrange: json["eventPinOrange"],
        eventTypeCode: json["eventTypeCode"],
        language: json["language"],
        isActive: json["isActive"],
        createdBy: json["createdBy"],
        createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
        modifiedBy: json["modifiedBy"],
        modifiedOn: json["modifiedOn"],
        eventModuleID: json["eventModuleID"],
        eventModuleName: json["eventModuleName"],
      );

  Map<String, dynamic> toJson() => {
        "hasThemes": hasThemes,
        "eventTypeMasterId": eventTypeMasterId,
        "eventTypeName": eventTypeName,
        // "eventCategoryMasterId": eventCategoryMasterId,
        "icon": icon,
        "eventIconBlue": eventIconBlue,
        "language": language,
        "isActive": isActive,
        "createdBy": createdBy,
        "createdOn": createdOn?.toIso8601String(),
        "modifiedBy": modifiedBy,
        "modifiedOn": modifiedOn,
        "eventModuleID": eventModuleID,
        "eventModuleName": eventModuleName,
        "eventIconWhite": eventIconWhite,
        "eventPinOrange": eventPinOrange,
      };
}
