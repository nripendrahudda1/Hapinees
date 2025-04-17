class OccasionDashboardModel {
  List<TrendingOccasions>? trendingOccasions;
  List<TrendingOccasions>? popularOccasions;
  List<TrendingOccasions>? recommendedOccasions;
  List<TrendingOccasions>? recentOccasions;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  OccasionDashboardModel(
      {this.trendingOccasions,
      this.popularOccasions,
      this.recommendedOccasions,
      this.recentOccasions,
      this.responseStatus,
      this.validationMessage,
      this.statusCode});

  OccasionDashboardModel.fromJson(Map<String, dynamic> json) {
    if (json['trendingOccasions'] != null) {
      trendingOccasions = <TrendingOccasions>[];
      json['trendingOccasions'].forEach((v) {
        trendingOccasions!.add(TrendingOccasions.fromJson(v));
      });
    }
    if (json['popularOccasions'] != null) {
      popularOccasions = <TrendingOccasions>[];
      json['popularOccasions'].forEach((v) {
        popularOccasions!.add(TrendingOccasions.fromJson(v));
      });
    }
    if (json['recommendedOccasions'] != null) {
      recommendedOccasions = <TrendingOccasions>[];
      json['recommendedOccasions'].forEach((v) {
        recommendedOccasions!.add(TrendingOccasions.fromJson(v));
      });
    }
    if (json['recentOccasions'] != null) {
      recentOccasions = <TrendingOccasions>[];
      json['recentOccasions'].forEach((v) {
        recentOccasions!.add(TrendingOccasions.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trendingOccasions != null) {
      data['trendingOccasions'] = trendingOccasions!.map((v) => v.toJson()).toList();
    }
    if (popularOccasions != null) {
      data['popularOccasions'] = popularOccasions!.map((v) => v.toJson()).toList();
    }
    if (recommendedOccasions != null) {
      data['recommendedOccasions'] = recommendedOccasions!.map((v) => v.toJson()).toList();
    }
    if (recentOccasions != null) {
      data['recentOccasions'] = recentOccasions!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = responseStatus;
    data['validationMessage'] = validationMessage;
    data['statusCode'] = statusCode;
    return data;
  }
}

class TrendingOccasions {
  int? eventTypeMasterId;
  String? eventTypeName;
  String? eventTypeMasterIcon;
  // String? eventTypeCode;
  int? occasionId;
  String? title;
  String? backgroundImageUrl;
  int? countryId;
  String? countryFlag;
  CreatedBy? createdBy;
  String? createdOn;
  String? endDate;
  String? startDateTime;
  String? likedBySelf;
  int? occasionLikes;
  int? occasionViews;
  int? guestCount;
  bool? isVisible;
  int? visibility;

  TrendingOccasions(
      {this.eventTypeMasterId,
      this.eventTypeName,
      this.eventTypeMasterIcon,
      // this.eventTypeCode,
      this.occasionId,
      this.title,
      this.backgroundImageUrl,
      this.countryId,
      this.countryFlag,
      this.createdBy,
      this.createdOn,
      this.endDate,
      this.startDateTime,
      this.likedBySelf,
      this.occasionLikes,
      this.occasionViews,
      this.guestCount,
      this.isVisible,
      this.visibility});

  TrendingOccasions.fromJson(Map<String, dynamic> json) {
    eventTypeMasterId = json['eventTypeMasterId'];
    eventTypeName = json['eventTypeName'];
    eventTypeMasterIcon = json['eventTypeMasterIcon'];
    // eventTypeCode = json['eventTypeCode'];
    occasionId = json['occasionId'];
    title = json['title'];
    backgroundImageUrl = json['backgroundImageUrl'];
    countryId = json['countryId'];
    countryFlag = json['countryFlag'];
    createdBy = json['createdBy'] != null ? CreatedBy.fromJson(json['createdBy']) : null;
    createdOn = json['createdOn'];
    startDateTime = json['startDateTime'] ?? json['startDate'];
    endDate = json['endDate'];
    likedBySelf = json['likedBySelf'];
    occasionLikes = json['occasionLikes'];
    occasionViews = json['occasionViews'];
    guestCount = json['guestCount'];
    isVisible = json['isVisible'];
    visibility = json['visibility'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventTypeMasterId'] = eventTypeMasterId;
    data['eventTypeName'] = eventTypeName;
    data['eventTypeMasterIcon'] = eventTypeMasterIcon;
    // data['eventTypeCode'] = eventTypeCode;
    data['occasionId'] = occasionId;
    data['title'] = title;
    data['backgroundImageUrl'] = backgroundImageUrl;
    data['countryId'] = countryId;
    data['countryFlag'] = countryFlag;
    if (createdBy != null) {
      data['createdBy'] = createdBy!.toJson();
    }
    data['createdOn'] = createdOn;
    data['startDate'] = startDateTime;
    data['endDate'] = endDate;
    data['startDateTime'] = startDateTime;
    data['likedBySelf'] = likedBySelf;
    data['occasionLikes'] = occasionLikes;
    data['occasionViews'] = occasionViews;
    data['guestCount'] = guestCount;
    data['isVisible'] = isVisible;
    data['visibility'] = visibility;
    return data;
  }
}

class CreatedBy {
  int? userId;
  String? displayName;
  String? email;
  String? contactNumber;
  int? followStatus;
  int? followingStatus;
  String? profileImageUrl;

  CreatedBy(
      {this.userId,
      this.displayName,
      this.email,
      this.contactNumber,
      this.followStatus,
      this.followingStatus,
      this.profileImageUrl});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    displayName = json['displayName'];
    email = json['email'];
    contactNumber = json['contactNumber'];
    followStatus = json['followStatus'];
    followingStatus = json['followingStatus'];
    profileImageUrl = json['profileImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['displayName'] = displayName;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['followStatus'] = followStatus;
    data['followingStatus'] = followingStatus;
    data['profileImageUrl'] = profileImageUrl;
    return data;
  }
}
