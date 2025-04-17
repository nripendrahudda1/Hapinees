import 'dart:convert';

SendPersonalEventInvitePostModel sendPersonalEventInvitePostModelFromJson(String str) =>
    SendPersonalEventInvitePostModel.fromJson(json.decode(str));

String sendPersonalEventInvitePostModelToJson(SendPersonalEventInvitePostModel data) =>
    json.encode(data.toJson());

class SendPersonalEventInvitePostModel {
  int? personalEventHeaderId;
  int? personalEventInviteId;
  int? inviteStatus;
  int? invitedBy;
  DateTime? invitedOn;
  List<PersonalEventInvite>? personalEventInvites;

  SendPersonalEventInvitePostModel({
    this.personalEventHeaderId,
    this.invitedOn,
    this.personalEventInvites,
    this.personalEventInviteId,
    this.inviteStatus,
    this.invitedBy,
  });

  factory SendPersonalEventInvitePostModel.fromJson(Map<String, dynamic> json) =>
      SendPersonalEventInvitePostModel(
        personalEventHeaderId: json["personalEventHeaderId"],
        personalEventInviteId: json["personalEventInviteId"] ?? 0,
        inviteStatus: json["inviteStatus"] ?? 1,
        invitedBy: json["invitedBy"] ?? 0,
        invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
        personalEventInvites: json["personalEventInvites"] == null
            ? []
            : List<PersonalEventInvite>.from(
                json["personalEventInvites"]!.map((x) => PersonalEventInvite.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "personalEventHeaderId": personalEventHeaderId,
        "personalEventInviteId": personalEventInviteId ?? 0,
        "inviteStatus": inviteStatus ?? 1,
        "invitedBy": invitedBy ?? 0,
        "invitedOn": invitedOn?.toIso8601String(),
        "personalEventInvites": personalEventInvites == null
            ? []
            : List<dynamic>.from(personalEventInvites!.map((x) => x.toJson())),
      };
}

class PersonalEventInvite {
  int? inviteTo;
  String? email;
  String? mobile;

  PersonalEventInvite({
    this.inviteTo,
    this.email,
    this.mobile,
  });

  factory PersonalEventInvite.fromJson(Map<String, dynamic> json) => PersonalEventInvite(
        inviteTo: json["inviteTo"],
        email: json["email"],
        mobile: json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "inviteTo": inviteTo,
        "email": email,
        "mobile": mobile,
      };
}
