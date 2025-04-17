import 'dart:convert';

PersonalEventPostSetCommentModel personalEventPostSetCommentModelFromJson(String str) => PersonalEventPostSetCommentModel.fromJson(json.decode(str));

String personalEventPostSetCommentModelToJson(PersonalEventPostSetCommentModel data) => json.encode(data.toJson());

class PersonalEventPostSetCommentModel {
  int? personalEventPostCommentId;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  PersonalEventPostSetCommentModel({
    this.personalEventPostCommentId,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory PersonalEventPostSetCommentModel.fromJson(Map<String, dynamic> json) => PersonalEventPostSetCommentModel(
    personalEventPostCommentId: json["personalEventPostCommentId"],
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventPostCommentId": personalEventPostCommentId,
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}