import 'dart:convert';

GeneralResponseModel generalResponseModelFromJson(String str) => GeneralResponseModel.fromJson(json.decode(str));

String generalResponseModelToJson(GeneralResponseModel data) => json.encode(data.toJson());

class GeneralResponseModel {
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  GeneralResponseModel({
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory GeneralResponseModel.fromJson(Map<String, dynamic> json) => GeneralResponseModel(
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}
