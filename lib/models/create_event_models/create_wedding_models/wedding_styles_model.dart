import 'dart:convert';

WeddingStylesModel weddingStylesModelFromJson(String str) => WeddingStylesModel.fromJson(json.decode(str));

String weddingStylesModelToJson(WeddingStylesModel data) => json.encode(data.toJson());

class WeddingStylesModel {
  List<WeddingStyleMasterList>? weddingStyleMasterList;
  bool? responseStatus;
  String? validationMessage;

  WeddingStylesModel({
    this.weddingStyleMasterList,
    this.responseStatus,
    this.validationMessage,
  });

  factory WeddingStylesModel.fromJson(Map<String, dynamic> json) => WeddingStylesModel(
    weddingStyleMasterList: json["weddingStyleMasterList"] == null ? [] : List<WeddingStyleMasterList>.from(json["weddingStyleMasterList"]!.map((x) => WeddingStyleMasterList.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "weddingStyleMasterList": weddingStyleMasterList == null ? [] : List<dynamic>.from(weddingStyleMasterList!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
  };
}

class WeddingStyleMasterList {
  int? weddingStyleMasterId;
  String? weddingStyleName;
  String? defaultImageUrl;
  String? language;
  bool? isActive;
  int? createdBy;
  DateTime? createdOn;
  dynamic modifiedBy;
  dynamic modifiedOn;

  WeddingStyleMasterList({
    this.weddingStyleMasterId,
    this.weddingStyleName,
    this.defaultImageUrl,
    this.language,
    this.isActive,
    this.createdBy,
    this.createdOn,
    this.modifiedBy,
    this.modifiedOn,
  });

  factory WeddingStyleMasterList.fromJson(Map<String, dynamic> json) => WeddingStyleMasterList(
    weddingStyleMasterId: json["weddingStyleMasterId"],
    weddingStyleName: json["weddingStyleName"],
    defaultImageUrl: json["defaultImageUrl"],
    language: json["language"],
    isActive: json["isActive"],
    createdBy: json["createdBy"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    modifiedBy: json["modifiedBy"],
    modifiedOn: json["modifiedOn"],
  );

  Map<String, dynamic> toJson() => {
    "weddingStyleMasterId": weddingStyleMasterId,
    "weddingStyleName": weddingStyleName,
    "defaultImageUrl": defaultImageUrl,
    "language": language,
    "isActive": isActive,
    "createdBy": createdBy,
    "createdOn": createdOn?.toIso8601String(),
    "modifiedBy": modifiedBy,
    "modifiedOn": modifiedOn,
  };
}
