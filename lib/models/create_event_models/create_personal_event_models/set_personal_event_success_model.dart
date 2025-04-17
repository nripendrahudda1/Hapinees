import 'dart:convert';

SetPersonalEventSuccessModel setPersonalEventSuccessModelFromJson(String str) => SetPersonalEventSuccessModel.fromJson(json.decode(str));

String setPersonalEventSuccessModelToJson(SetPersonalEventSuccessModel data) => json.encode(data.toJson());

class SetPersonalEventSuccessModel {
  int? personalEventHeaderId;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  SetPersonalEventSuccessModel({
    this.personalEventHeaderId,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory SetPersonalEventSuccessModel.fromJson(Map<String, dynamic> json) => SetPersonalEventSuccessModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}