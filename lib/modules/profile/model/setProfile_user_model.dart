import 'dart:convert';

SetProfileModel profileModelFromJson(String str) => SetProfileModel.fromJson(json.decode(str));

String setProfilePostModelToJson(SetProfileModel data) => json.encode(data.toJson());

class SetProfileModel {
  String? userId;
  String? deviceTime;
  int? guestType;
  bool? isFavourite;

  SetProfileModel({
    this.userId,
    this.deviceTime,
    this.guestType,
    this.isFavourite,
  });

  factory SetProfileModel.fromJson(Map<String, dynamic> json) => SetProfileModel(
        userId: json["userId"],
        deviceTime: DateTime.now().toIso8601String(),
        guestType: json["guestType"],
        isFavourite: json["isFavourite"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceTime": deviceTime,
        "guestType": guestType,
        "isFavourite": isFavourite,
      };
}
