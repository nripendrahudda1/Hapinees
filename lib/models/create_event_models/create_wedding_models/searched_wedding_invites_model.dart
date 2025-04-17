import 'dart:convert';

SearchedWeddingInvtesModel searchedWeddingInvtesModelFromJson(String str) => SearchedWeddingInvtesModel.fromJson(json.decode(str));

String searchedWeddingInvtesModelToJson(SearchedWeddingInvtesModel data) => json.encode(data.toJson());

class SearchedWeddingInvtesModel {
  List<InvitedGuests>? invitedGuests;
  List<AuthorYouFollow>? authorYouFollows;
  List<AuthorYouFollow>? traveloryAuthors;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  SearchedWeddingInvtesModel({
    this.invitedGuests,
    this.authorYouFollows,
    this.traveloryAuthors,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory SearchedWeddingInvtesModel.fromJson(Map<String, dynamic> json) => SearchedWeddingInvtesModel(
    invitedGuests: json["invitedGuests"] == null ? [] : List<InvitedGuests>.from(json["invitedGuests"]!.map((x) => InvitedGuests.fromJson(x))),
    authorYouFollows: json["authorYouFollows"] == null ? [] : List<AuthorYouFollow>.from(json["authorYouFollows"]!.map((x) => AuthorYouFollow.fromJson(x))),
    traveloryAuthors: json["traveloryAuthors"] == null ? [] : List<AuthorYouFollow>.from(json["traveloryAuthors"]!.map((x) => AuthorYouFollow.fromJson(x))),
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
  );

  Map<String, dynamic> toJson() => {
    "invitedGuests": invitedGuests == null ? [] : List<dynamic>.from(invitedGuests!.map((x) => x.toJson())),
    "authorYouFollows": authorYouFollows == null ? [] : List<dynamic>.from(authorYouFollows!.map((x) => x.toJson())),
    "traveloryAuthors": traveloryAuthors == null ? [] : List<dynamic>.from(traveloryAuthors!.map((x) => x.toJson())),
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
  };
}

class AuthorYouFollow {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  AuthorYouFollow({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory AuthorYouFollow.fromJson(Map<String, dynamic> json) => AuthorYouFollow(
    userId: json["userId"],
    displayName: json["displayName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    followStatus: json["followStatus"],
    followingStatus: json["followingStatus"],
    profileImageUrl: json["profileImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "displayName": displayName,
    "email": email,
    "contactNumber": contactNumber,
    "followStatus": followStatus,
    "followingStatus": followingStatus,
    "profileImageUrl": profileImageUrl,
  };
}

class InvitedGuests {
  UserEntity? userEntity;
  bool? isCoHost;
  int? inviteStatus;
  int? weddingInviteId;

  InvitedGuests({
    this.userEntity,
    this.isCoHost,
    this.inviteStatus,
    this.weddingInviteId
  });

  factory InvitedGuests.fromJson(Map<String, dynamic> json) => InvitedGuests(
    userEntity: json["userEntity"] == null ? null : UserEntity.fromJson(json["userEntity"]),
    isCoHost: json["isCoHost"],
    inviteStatus: json["inviteStatus"],
    weddingInviteId: json["weddingInviteId"]
  );

  Map<String, dynamic> toJson() => {
    "userEntity": userEntity?.toJson(),
    "isCoHost": isCoHost,
    "inviteStatus": inviteStatus,
    "weddingInviteId" : weddingInviteId
  };
}

class UserEntity {
  int? userId;
  String? displayName;
  String? email;
  dynamic contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  UserEntity({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    userId: json["userId"],
    displayName: json["displayName"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    followStatus: json["followStatus"],
    followingStatus: json["followingStatus"],
    profileImageUrl: json["profileImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "displayName": displayName,
    "email": email,
    "contactNumber": contactNumber,
    "followStatus": followStatus,
    "followingStatus": followingStatus,
    "profileImageUrl": profileImageUrl,
  };
}

