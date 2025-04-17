import 'dart:convert';

WeddingRitualsModel weddingRitualsModelFromJson(String str) => WeddingRitualsModel.fromJson(json.decode(str));

String weddingRitualsModelToJson(WeddingRitualsModel data) => json.encode(data.toJson());

class WeddingRitualsModel {
  List<WeddingRitualMasterList>? weddingRitualMasterList;
  bool? responseStatus;
  String? validationMessage;

  WeddingRitualsModel({
    this.weddingRitualMasterList,
    this.responseStatus,
    this.validationMessage,
  });

  factory WeddingRitualsModel.fromJson(Map<String, dynamic> json) => WeddingRitualsModel(
    weddingRitualMasterList: json["weddingRitualMasterList"] == null ? [] : List<WeddingRitualMasterList>.from(json["weddingRitualMasterList"]!.map((x) => WeddingRitualMasterList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualMasterList": weddingRitualMasterList == null ? [] : List<dynamic>.from(weddingRitualMasterList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
  };
}

class WeddingRitualMasterList {
  int? weddingRitualMasterId;
  int? weddingStyleMasterId;
  String? ritualName;
  String? defaultImageUrl;
  Language? language;
  bool? isActive;
  int? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  WeddingRitualMasterList({
    this.weddingRitualMasterId,
    this.weddingStyleMasterId,
    this.ritualName,
    this.defaultImageUrl,
    this.language,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  factory WeddingRitualMasterList.fromJson(Map<String, dynamic> json) => WeddingRitualMasterList(
    weddingRitualMasterId: json["weddingRitualMasterId"],
    weddingStyleMasterId: json["weddingStyleMasterId"],
    ritualName: json["ritualName"],
    defaultImageUrl: json["defaultImageUrl"],
    language: languageValues.map[json["language"]]!,
    isActive: json["isActive"],
    createdBy: json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    modifiedBy: json["modifiedBy"],
    modifiedOn: json["modifiedOn"],
  );

  Map<String, dynamic> toJson() => {
    "weddingRitualMasterId": weddingRitualMasterId,
    "weddingStyleMasterId": weddingStyleMasterId,
    "ritualName": ritualName,
    "defaultImageUrl": defaultImageUrl,
    "language": languageValues.reverse[language],
    "isActive": isActive,
    "createdBy": createdBy,
    "createdOn": createdOn?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn,
  };
}

enum Language {
  EN
}

final languageValues = EnumValues({
  "EN": Language.EN
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
