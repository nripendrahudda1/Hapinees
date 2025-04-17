import 'dart:convert';

PersonalEventCreateMemoriesModel personalEventCreateMemoriesModelFromJson(String str) => PersonalEventCreateMemoriesModel.fromJson(json.decode(str));

String personalEventCreateMemoriesModelToJson(PersonalEventCreateMemoriesModel data) => json.encode(data.toJson());

class PersonalEventCreateMemoriesModel {
  int? personalEventPostId;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventCreateMemoriesModel({
    this.personalEventPostId,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventCreateMemoriesModel.fromJson(Map<String, dynamic> json) => PersonalEventCreateMemoriesModel(
    personalEventPostId: json["personalEventPostId"],
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostId": personalEventPostId,
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}