import 'package:Happinest/common/common_model/common_invite_by_and_to_model.dart';

class GetAllPersonalEventInvitedUsers {
  List<PersonalEventInviteList>? personalEventInviteList;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  GetAllPersonalEventInvitedUsers(
      {this.personalEventInviteList, this.responseStatus, this.validationMessage, this.statusCode});

  GetAllPersonalEventInvitedUsers.fromJson(Map<String, dynamic> json) {
    if (json['personalEventInviteList'] != null) {
      personalEventInviteList = <PersonalEventInviteList>[];
      json['personalEventInviteList'].forEach((v) {
        personalEventInviteList!.add(new PersonalEventInviteList.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.personalEventInviteList != null) {
      data['personalEventInviteList'] =
          this.personalEventInviteList!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = this.responseStatus;
    data['validationMessage'] = this.validationMessage;
    data['statusCode'] = this.statusCode;
    return data;
  }
}

class PersonalEventInviteList {
  int? personalEventInviteId;
  int? personalEventHeaderId;
  InviteToAndBy? invitedBy;
  InviteToAndBy? inviteTo;
  String? invitedOn;
  int? inviteVia;
  String? email;
  String? mobile;
  int? inviteStatus;
  dynamic acceptedRejectedOn;
  bool? isCoHost;

  PersonalEventInviteList(
      {this.personalEventInviteId,
      this.personalEventHeaderId,
      this.invitedBy,
      this.inviteTo,
      this.invitedOn,
      this.inviteVia,
      this.email,
      this.mobile,
      this.inviteStatus,
      this.acceptedRejectedOn,
      this.isCoHost});

  PersonalEventInviteList.fromJson(Map<String, dynamic> json) {
    personalEventInviteId = json['personalEventInviteId'];
    personalEventHeaderId = json['personalEventHeaderId'];
    invitedBy = json['invitedBy'] != null ? new InviteToAndBy.fromJson(json['invitedBy']) : null;
    inviteTo = json['inviteTo'] != null ? new InviteToAndBy.fromJson(json['inviteTo']) : null;
    invitedOn = json['invitedOn'];
    inviteVia = json['inviteVia'];
    email = json['email'];
    mobile = json['mobile'];
    inviteStatus = json['inviteStatus'];
    acceptedRejectedOn = json['acceptedRejectedOn'];
    isCoHost = json['isCoHost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['personalEventInviteId'] = this.personalEventInviteId;
    data['personalEventHeaderId'] = this.personalEventHeaderId;
    if (this.invitedBy != null) {
      data['invitedBy'] = this.invitedBy!.toJson();
    }
    if (this.inviteTo != null) {
      data['inviteTo'] = this.inviteTo!.toJson();
    }
    data['invitedOn'] = this.invitedOn;
    data['inviteVia'] = this.inviteVia;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['inviteStatus'] = this.inviteStatus;
    data['acceptedRejectedOn'] = this.acceptedRejectedOn;
    data['isCoHost'] = this.isCoHost;

    return data;
  }
}
