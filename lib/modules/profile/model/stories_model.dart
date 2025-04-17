class Stories {
  int? eventTypeMasterId;
  String? eventTypeName;
  String? eventTypeMasterIcon;
  String? storyMarker;
  int? storyId;
  String? storyTypeName;
  String? title;
  String? backgroundImageUrl;
  UserModelClass? createdBy;
  String? createdOn;
  String? startDate;
  String? endDate;
  String? likedBySelf;
  int? storyLikes;
  int? storyViews;
  int? guestCount;
  int? storyDays;
  String? storyLat;
  String? storyLong;
  int? visibility;
  int? coHosts;
  bool? isVisible;

  List<VisitiedCountryMasters>? visitiedCountryMasters;

  Stories(
      {this.eventTypeMasterId,
      this.eventTypeName,
      this.eventTypeMasterIcon,
      this.storyMarker,
      this.storyId,
      this.storyTypeName,
      this.title,
      this.backgroundImageUrl,
      this.createdBy,
      this.createdOn,
      this.startDate,
      this.endDate,
      this.likedBySelf,
      this.storyLikes,
      this.storyViews,
      this.guestCount,
      this.storyDays,
      this.storyLat,
      this.storyLong,
      this.visibility,
      this.isVisible,
      this.coHosts,
      this.visitiedCountryMasters});

  Stories.fromJson(Map<String, dynamic> json) {
    eventTypeMasterId = json['eventTypeMasterId'];
    eventTypeName = json['eventTypeName'];
    eventTypeMasterIcon = json['eventTypeMasterIcon'];
    storyMarker = json['storyMarker'];
    storyId = json['storyId'];
    storyTypeName = json['storyTypeName'];
    title = json['title'];
    backgroundImageUrl = json['backgroundImageUrl'];
    createdBy = json['createdBy'] != null ? UserModelClass.fromJson(json['createdBy']) : null;
    createdOn = json['createdOn'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    likedBySelf = json['likedBySelf'];
    storyLikes = json['storyLikes'];
    storyViews = json['storyViews'];
    guestCount = json['guestCount'];
    storyDays = json['storyDays'];
    storyLat = json['storyLat'];
    storyLong = json['storyLong'];
    visibility = json['visibility'];
    isVisible = json['isVisible'];
    coHosts = json['coHosts'];

    if (json['visitiedCountryMasters'] != null) {
      visitiedCountryMasters = <VisitiedCountryMasters>[];
      json['visitiedCountryMasters'].forEach((v) {
        visitiedCountryMasters!.add(new VisitiedCountryMasters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventTypeMasterId'] = this.eventTypeMasterId;
    data['eventTypeName'] = eventTypeName;
    data['eventTypeMasterIcon'] = eventTypeMasterIcon;
    data['storyMarker'] = storyMarker;
    data['storyId'] = storyId;
    data['storyTypeName'] = storyTypeName;
    data['title'] = title;
    data['backgroundImageUrl'] = backgroundImageUrl;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['createdOn'] = createdOn;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['likedBySelf'] = likedBySelf;
    data['storyLikes'] = storyLikes;
    data['storyViews'] = storyViews;
    data['guestCount'] = guestCount;
    data['storyDays'] = storyDays;
    data['storyLat'] = storyLat;
    data['storyLong'] = storyLong;
    data['visibility'] = visibility;
    data['isVisible'] = isVisible;
    data['coHosts'] = coHosts;
    if (visitiedCountryMasters != null) {
      data['visitiedCountryMasters'] = visitiedCountryMasters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitiedCountryMasters {
  int? id;
  String? countryCode;
  dynamic countryIsdCode;
  String? countryName;
  String? countryFlagUrl;
  String? countryImageUrl;
  dynamic emergencyContact;

  VisitiedCountryMasters(
      {this.id,
      this.countryCode,
      this.countryIsdCode,
      this.countryName,
      this.countryFlagUrl,
      this.countryImageUrl,
      this.emergencyContact});

  VisitiedCountryMasters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['countryCode'];
    countryIsdCode = json['countryIsdCode'];
    countryName = json['countryName'];
    countryFlagUrl = json['countryFlagUrl'];
    countryImageUrl = json['countryImageUrl'];
    emergencyContact = json['emergencyContact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['countryCode'] = countryCode;
    data['countryIsdCode'] = countryIsdCode;
    data['countryName'] = countryName;
    data['countryFlagUrl'] = countryFlagUrl;
    data['countryImageUrl'] = countryImageUrl;
    data['emergencyContact'] = emergencyContact;
    return data;
  }
}

class UserModelClass {
  num? userId;
  String? displayName;
  String? email;
  dynamic contactNumber;
  num? followerStatus;
  num? followingStatus;
  String? profileImageUrl;
  String? requestedDate; 

  UserModelClass(
      {this.userId,
      this.displayName,
      this.email,
      this.contactNumber,
      this.followerStatus,
      this.followingStatus,
      this.profileImageUrl,
      this.requestedDate});

  UserModelClass.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    displayName = json['displayName'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    followerStatus = json['followerStatus'];
    followingStatus = json['followingStatus'];
    profileImageUrl = json['profileImageUrl'];
    requestedDate = json['requestedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['displayName'] = displayName;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['followerStatus'] = followerStatus;
    data['followingStatus'] = followingStatus;
    data['profileImageUrl'] = profileImageUrl;
    data['requestedDate'] = requestedDate;
    return data;
  }
}
