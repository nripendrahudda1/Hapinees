import 'dart:convert';

OccasionCreatePostMemoryResponseModel occasionCreatePostMemoryResponseModelFromJson(String str) => OccasionCreatePostMemoryResponseModel.fromJson(json.decode(str));

String occasionCreatePostMemoryResponseModelToJson(OccasionCreatePostMemoryResponseModel data) => json.encode(data.toJson());

class OccasionCreatePostMemoryResponseModel {
  int? occasionPostId;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  OccasionCreatePostMemoryResponseModel({
    this.occasionPostId,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory OccasionCreatePostMemoryResponseModel.fromJson(Map<String, dynamic> json) => OccasionCreatePostMemoryResponseModel(
    occasionPostId: json["occasionPostId"],
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "occasionPostId": occasionPostId,
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}
