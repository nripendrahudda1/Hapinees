// To parse this JSON data, do
//
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  int? userId;
  int? serverUserId;
  String? displayName;
  String? firstName;
  String? lastName;
  String? mobile;
  String? email;
  dynamic password;
  String? address;
  dynamic city;
  dynamic state;
  dynamic gender;
  int? age;
  dynamic countryId;
  String? foodPreference;
  String? aboutUser;
  int? travelTypeId;
  String? registrationDate;
  int? modifiedBy;
  String? modifyDate;
  String? birthday;
  dynamic status;
  bool? isloggedIn;
  dynamic identificationMark;
  String? signUpSource;
  int? followersCount;
  int? followingCount;
  int? runningTripId;
  dynamic runningTripName;
  int? minDistanceForLocationTracking;
  int? minDurationForLocationTracking;
  String? userProfilePictureUrl;
  String? userBackgroundPictureUrl;
  dynamic errorResponse;
  dynamic token;
  bool? isAlreadySignedUp;
  dynamic deviceId;
  bool? overWriteExistingSession;
  dynamic authenticationSource;
  dynamic appleUserId;
  bool? toolTipsVisited;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  UserModel(
      {this.userId,
      this.serverUserId,
      this.displayName,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.password,
      this.address,
      this.city,
      this.state,
      this.gender,
      this.age,
      this.countryId,
      this.foodPreference,
      this.aboutUser,
      this.travelTypeId,
      this.registrationDate,
      this.modifiedBy,
      this.modifyDate,
      this.birthday,
      this.status,
      this.isloggedIn,
      this.identificationMark,
      this.signUpSource,
      this.followersCount,
      this.followingCount,
      this.runningTripId,
      this.runningTripName,
      this.minDistanceForLocationTracking,
      this.minDurationForLocationTracking,
      this.userProfilePictureUrl,
      this.userBackgroundPictureUrl,
      this.errorResponse,
      this.token,
      this.isAlreadySignedUp,
      this.deviceId,
      this.overWriteExistingSession,
      this.authenticationSource,
      this.appleUserId,
      this.toolTipsVisited,
      this.responseStatus,
      this.validationMessage,
      this.statusCode});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    serverUserId = json['serverUserId'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    gender = json['gender'];
    age = json['age'];
    countryId = json['countryId'];
    foodPreference = json['foodPreference'];
    aboutUser = json['aboutUser'];
    travelTypeId = json['travelTypeId'];
    registrationDate = json['registrationDate'];
    modifiedBy = json['modifiedBy'];
    modifyDate = json['modifyDate'];
    birthday = json['birthday'];
    status = json['status'];
    isloggedIn = json['isloggedIn'];
    identificationMark = json['identificationMark'];
    signUpSource = json['signUpSource'];
    followersCount = json['followersCount'];
    followingCount = json['followingCount'];
    runningTripId = json['runningTripId'];
    runningTripName = json['runningTripName'];
    minDistanceForLocationTracking = json['minDistanceForLocationTracking'];
    minDurationForLocationTracking = json['minDurationForLocationTracking'];
    userProfilePictureUrl = json['userProfilePictureUrl'];
    userBackgroundPictureUrl = json['userBackgroundPictureUrl'];
    errorResponse = json['errorResponse'];
    token = json['token'];
    isAlreadySignedUp = json['isAlreadySignedUp'];
    deviceId = json['deviceId'];
    overWriteExistingSession = json['overWriteExistingSession'];
    authenticationSource = json['authenticationSource'];
    appleUserId = json['appleUserId'];
    toolTipsVisited = json['toolTipsVisited'];
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['serverUserId'] = serverUserId;
    data['displayName'] = displayName;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['mobile'] = mobile;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['gender'] = gender;
    data['age'] = age;
    data['countryId'] = countryId;
    data['foodPreference'] = foodPreference;
    data['aboutUser'] = aboutUser;
    data['travelTypeId'] = travelTypeId;
    data['registrationDate'] = registrationDate;
    data['modifiedBy'] = modifiedBy;
    data['modifyDate'] = modifyDate;
    data['birthday'] = birthday;
    data['status'] = status;
    data['isloggedIn'] = isloggedIn;
    data['identificationMark'] = identificationMark;
    data['signUpSource'] = signUpSource;
    data['followersCount'] = followersCount;
    data['followingCount'] = followingCount;
    data['runningTripId'] = runningTripId;
    data['runningTripName'] = runningTripName;
    data['minDistanceForLocationTracking'] = minDistanceForLocationTracking;
    data['minDurationForLocationTracking'] = minDurationForLocationTracking;
    data['userProfilePictureUrl'] = userProfilePictureUrl;
    data['userBackgroundPictureUrl'] = userBackgroundPictureUrl;
    data['errorResponse'] = errorResponse;
    data['token'] = token;
    data['isAlreadySignedUp'] = isAlreadySignedUp;
    data['deviceId'] = deviceId;
    data['overWriteExistingSession'] = overWriteExistingSession;
    data['authenticationSource'] = authenticationSource;
    data['appleUserId'] = appleUserId;
    data['toolTipsVisited'] = toolTipsVisited;
    data['responseStatus'] = responseStatus;
    data['validationMessage'] = validationMessage;
    data['statusCode'] = statusCode;
    return data;
  }
}
