import 'package:Happinest/utility/preferenceutils.dart';

int? loginUserId = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));

class InviteToAndBy {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followerStatus;
  int? followingStatus;
  String? profileImageUrl;
  String? firstName;
  String? lastName;
  bool isCurrentUser; // Add this to check if it's the logged-in user

  InviteToAndBy({
    this.userId,
    this.displayName,
    this.email,
    this.contactNumber,
    this.followerStatus,
    this.followingStatus,
    this.profileImageUrl,
    this.firstName,
    this.lastName,
  }) : isCurrentUser = userId == loginUserId;

  // factory InviteToAndBy.fromJson(Map<String, dynamic> json) => InviteToAndBy(
  //       userId: json["userId"],
  //       displayName: json["displayName"],
  //       email: json["email"],
  //       contactNumber: json["contactNumber"],
  //       followStatus: json["followStatus"],
  //       followingStatus: json["followingStatus"],
  //       profileImageUrl: json["profileImageUrl"],
  //       firstName: json["firstName"],
  //       lastName: json["lastName"],
  //     );

  factory InviteToAndBy.fromJson(Map<String, dynamic> json) {
    int? userIdFromJson = json["userId"];
    return InviteToAndBy(
      userId: userIdFromJson,
      displayName: json["displayName"],
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      email: json["email"],
      contactNumber: json["contactNumber"],
      followerStatus: json["followerStatus"],
      followingStatus: json["followingStatus"],
      profileImageUrl: json["profileImageUrl"],
    )..isCurrentUser = userIdFromJson == loginUserId; // Set the flag
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "displayName": displayName,
        "email": email,
        "contactNumber": contactNumber,
        "followerStatus": followerStatus,
        "followingStatus": followingStatus,
        "profileImageUrl": profileImageUrl,
        "firstName": firstName,
        "lastName": lastName,
        "isCurrentUser": isCurrentUser,
      };
}
