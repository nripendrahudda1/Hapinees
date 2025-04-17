import 'dart:convert';

SetWeddingSuccessModel setWeddingSuccessModelFromJson(String str) => SetWeddingSuccessModel.fromJson(json.decode(str));

String setWeddingSuccessModelToJson(SetWeddingSuccessModel data) => json.encode(data.toJson());

class SetWeddingSuccessModel {
  int? weddingHeaderId;
  bool? responseStatus;
  String? validationMessage;

  SetWeddingSuccessModel({
    this.weddingHeaderId,
    this.responseStatus,
    this.validationMessage,
  });

  factory SetWeddingSuccessModel.fromJson(Map<String, dynamic> json) => SetWeddingSuccessModel(
    weddingHeaderId: json["weddingHeaderId"],
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
  };
}
