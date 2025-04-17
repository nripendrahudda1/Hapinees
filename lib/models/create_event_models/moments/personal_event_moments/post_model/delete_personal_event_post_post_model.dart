import 'dart:convert';

DeletePersonalEventPostModel deletePersonalEventPostModelFromJson(String str) => DeletePersonalEventPostModel.fromJson(json.decode(str));

String deletePersonalEventPostModelToJson(DeletePersonalEventPostModel data) => json.encode(data.toJson());

class DeletePersonalEventPostModel {
  int? personalEventHeaderId;
  int? personalEventPostId;

  DeletePersonalEventPostModel({
    this.personalEventHeaderId,
    this.personalEventPostId,
  });

  factory DeletePersonalEventPostModel.fromJson(Map<String, dynamic> json) => DeletePersonalEventPostModel(
    personalEventHeaderId: json["personalEventHeaderId"],
    personalEventPostId: json["personalEventPostId"],
  );

  Map<String, dynamic> toJson() => {
    "personalEventHeaderId": personalEventHeaderId,
    "personalEventPostId": personalEventPostId,
  };
}
