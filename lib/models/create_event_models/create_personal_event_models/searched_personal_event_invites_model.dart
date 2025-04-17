import 'dart:convert';

import '../../../common/common_model/common_invite_by_and_to_model.dart';
import '../../../utility/preferenceutils.dart';

SearchedPersonalEventInvitesModel searchedPersonalEventInvitesModelFromJson(String str) =>
    SearchedPersonalEventInvitesModel.fromJson(json.decode(str));

String searchedPersonalEventInvitesModelToJson(SearchedPersonalEventInvitesModel data) =>
    json.encode(data.toJson());

class SearchedPersonalEventInvitesModel {
  List<PersonalEventInvitedGuest>? personalEventInvitedGuests;
  List<HappinestAuthor>? happinestAuthors;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  SearchedPersonalEventInvitesModel({
    this.personalEventInvitedGuests,
    this.happinestAuthors,
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
  });

  factory SearchedPersonalEventInvitesModel.fromJson(Map<String, dynamic> json) =>
      SearchedPersonalEventInvitesModel(
        personalEventInvitedGuests: json["personalEventInvitedGuests"] == null
            ? []
            : List<PersonalEventInvitedGuest>.from(json["personalEventInvitedGuests"]!
                .map((x) => PersonalEventInvitedGuest.fromJson(x))),
        happinestAuthors: json["happinestAuthors"] == null
            ? []
            : List<HappinestAuthor>.from(
                json["happinestAuthors"]!.map((x) => HappinestAuthor.fromJson(x))),
        responseStatus: json["responseStatus"],
        validationMessage: json["validationMessage"],
        statusCode: json["statusCode"],
      );

  Map<String, dynamic> toJson() => {
        "personalEventInvitedGuests": personalEventInvitedGuests == null
            ? []
            : List<dynamic>.from(personalEventInvitedGuests!.map((x) => x.toJson())),
        "happinestAuthors": happinestAuthors == null
            ? []
            : List<dynamic>.from(happinestAuthors!.map((x) => x.toJson())),
        "responseStatus": responseStatus,
        "validationMessage": validationMessage,
        "statusCode": statusCode,
      };
}

int? loginUserId = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));

class HappinestAuthor {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;
  String? firstName;
  String? lastName;
  bool isCurrentUser; // Add this to check if it's the logged-in user

  HappinestAuthor({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followStatus,
    this.followingStatus,
    this.profileImageUrl,
    this.firstName,
    this.lastName,
  }) : isCurrentUser = userId == loginUserId; // Compare userId with loginUserId

  factory HappinestAuthor.fromJson(Map<String, dynamic> json) {
    int? userIdFromJson = json["userId"];
    return HappinestAuthor(
      userId: userIdFromJson,
      displayName: json["displayName"],
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      email: json["email"],
      contactNumber: json["contactNumber"],
      followStatus: json["followStatus"],
      followingStatus: json["followingStatus"],
      profileImageUrl: json["profileImageUrl"],
    )..isCurrentUser = userIdFromJson == loginUserId; // Set the flag
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "displayName": displayName,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "contactNumber": contactNumber,
        "followStatus": followStatus,
        "followingStatus": followingStatus,
        "profileImageUrl": profileImageUrl,
        "isCurrentUser": isCurrentUser, // Add to JSON if needed
      };
}

// class HappinestAuthor {
//   int? userId;
//   String? displayName;
//   String? email;
//   String? contactNumber;
//   int? followStatus;
//   int? followingStatus;
//   String? profileImageUrl;

//   HappinestAuthor({
//     this.userId,
//     this.displayName,
//     this.email,
//     this.contactNumber,
//     this.followStatus,
//     this.followingStatus,
//     this.profileImageUrl,
//   });

//   factory HappinestAuthor.fromJson(Map<String, dynamic> json) => HappinestAuthor(
//     userId: json["userId"],
//     displayName: json["displayName"],
//     email: json["email"],
//     contactNumber: json["contactNumber"],
//     followStatus: json["followStatus"],
//     followingStatus: json["followingStatus"],
//     profileImageUrl: json["profileImageUrl"],
//   );

//   Map<String, dynamic> toJson() => {
//     "userId": userId,
//     "displayName": displayName,
//     "email": email,
//     "contactNumber": contactNumber,
//     "followStatus": followStatus,
//     "followingStatus": followingStatus,
//     "profileImageUrl": profileImageUrl,
//   };
// }

class PersonalEventInvitedGuest {
  HappinestAuthor? userEntity;
  int? personalEventInviteId;
  bool? isCoHost;
  int? inviteStatus;

  PersonalEventInvitedGuest({
    this.userEntity,
    this.personalEventInviteId,
    this.isCoHost,
    this.inviteStatus,
  });

  factory PersonalEventInvitedGuest.fromJson(Map<String, dynamic> json) =>
      PersonalEventInvitedGuest(
        userEntity:
            json["userEntity"] == null ? null : HappinestAuthor.fromJson(json["userEntity"]),
        personalEventInviteId: json["personalEventInviteId"],
        isCoHost: json["isCoHost"],
        inviteStatus: json["inviteStatus"],
      );

  Map<String, dynamic> toJson() => {
        "userEntity": userEntity?.toJson(),
        "personalEventInviteId": personalEventInviteId,
        "isCoHost": isCoHost,
        "inviteStatus": inviteStatus,
      };
}
