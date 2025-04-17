import 'dart:convert';

SendWeddingInvitePostModel sendWeddingInvitePostModelFromJson(String str) => SendWeddingInvitePostModel.fromJson(json.decode(str));

String sendWeddingInvitePostModelToJson(SendWeddingInvitePostModel data) => json.encode(data.toJson());

class SendWeddingInvitePostModel {
  int? weddingHeaderId;
  DateTime? invitedOn;
  List<WeddingInvite>? weddingInvites;

  SendWeddingInvitePostModel({
    this.weddingHeaderId,
    this.invitedOn,
    this.weddingInvites,
  });

  factory SendWeddingInvitePostModel.fromJson(Map<String, dynamic> json) => SendWeddingInvitePostModel(
    weddingHeaderId: json["weddingHeaderId"],
    invitedOn: json["invitedOn"] == null ? null : DateTime.parse(json["invitedOn"]),
    weddingInvites: json["weddingInvites"] == null ? [] : List<WeddingInvite>.from(json["weddingInvites"]!.map((x) => WeddingInvite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "weddingHeaderId": weddingHeaderId,
    "invitedOn": invitedOn?.toIso8601String(),
    "weddingInvites": weddingInvites == null ? [] : List<dynamic>.from(weddingInvites!.map((x) => x.toJson())),
  };
}

class WeddingInvite {
  int? inviteTo;
  String? email;
  String? mobile;

  WeddingInvite({
    this.inviteTo,
    this.email,
    this.mobile,
  });

  factory WeddingInvite.fromJson(Map<String, dynamic> json) => WeddingInvite(
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
