import '../../../models/country_model.dart';

class ModelDashboardTripData {
  List<TrendingTrips>? trendingTrips;
  List<TrendingTrips>? popularTrips;
  List<TrendingTrips>? recommendedTrips;
  List<TrendingTrips>? recentTrips;
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;

  ModelDashboardTripData(
      {this.trendingTrips,
      this.popularTrips,
      this.recommendedTrips,
      this.recentTrips,
      this.responseStatus,
      this.validationMessage,
      this.statusCode});

  ModelDashboardTripData.fromJson(Map<String, dynamic> json) {
    if (json['trendingTrips'] != null) {
      trendingTrips = <TrendingTrips>[];
      json['trendingTrips'].forEach((v) {
        trendingTrips!.add(TrendingTrips.fromJson(v));
      });
    }
    if (json['popularTrips'] != null) {
      popularTrips = <TrendingTrips>[];
      json['popularTrips'].forEach((v) {
        popularTrips!.add(TrendingTrips.fromJson(v));
      });
    }
    if (json['recommendedTrips'] != null) {
      recommendedTrips = <TrendingTrips>[];
      json['recommendedTrips'].forEach((v) {
        recommendedTrips!.add(TrendingTrips.fromJson(v));
      });
    }
    if (json['recentTrips'] != null) {
      recentTrips = <TrendingTrips>[];
      json['recentTrips'].forEach((v) {
        recentTrips!.add(TrendingTrips.fromJson(v));
      });
    }
    responseStatus = json['responseStatus'];
    validationMessage = json['validationMessage'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (trendingTrips != null) {
      data['trendingTrips'] = trendingTrips!.map((v) => v.toJson()).toList();
    }
    if (popularTrips != null) {
      data['popularTrips'] = popularTrips!.map((v) => v.toJson()).toList();
    }
    if (recommendedTrips != null) {
      data['recommendedTrips'] =
          recommendedTrips!.map((v) => v.toJson()).toList();
    }
    if (recentTrips != null) {
      data['recentTrips'] = recentTrips!.map((v) => v.toJson()).toList();
    }
    data['responseStatus'] = responseStatus;
    data['validationMessage'] = validationMessage;
    data['statusCode'] = statusCode;
    return data;
  }
}

class TrendingTrips {
  String? userFirstName;
  String? userLastName;
  String? userFullName;
  String? userEmail;
  String? travelTypeDesc;
  String? userProfilePictureUrl;
  String? displayName;
  bool? canView;
  int? coAuthorsCount;
  int? commentsCount;
  int? tripDays;
  dynamic travelType;
  dynamic displayPicture;
  String? startLocationImage;
  List<CountryModel>? visitiedCountries;
  dynamic eventIds;
  int? tripId;
  int? userId;
  String? tripName;
  dynamic travelTypeId;
  String? startTime;
  String? endTime;
  String? startLocationName;
  dynamic endLocationName;
  dynamic tripLocations;
  dynamic startLocationCoordinateLongitude;
  dynamic startLocationCoordinateLatitude;
  dynamic endLocationCoordinateLongitude;
  dynamic endLocationCoordinateLatitude;
  dynamic endLocationImage;
  dynamic contactPerson;
  int? contactPersonCountryId;
  int? tripVisibility;
  bool? isReported;
  int? tripViewCount;
  int? tripLikeCount;
  String? tripDaysCount;
  bool? tripLikedBySelf;
  int? createdBy;
  String? createdDate;
  int? modifiedBy;
  String? modifiedDate;
  int? tripStepsCount;
  int? tripStairsCount;

  TrendingTrips(
      {this.userFirstName,
      this.userLastName,
      this.userFullName,
      this.userEmail,
      this.travelTypeDesc,
      this.userProfilePictureUrl,
      this.displayName,
      this.canView,
      this.coAuthorsCount,
      this.commentsCount,
      this.tripDays,
      this.travelType,
      this.displayPicture,
      this.startLocationImage,
      this.visitiedCountries,
      this.eventIds,
      this.tripId,
      this.userId,
      this.tripName,
      this.travelTypeId,
      this.startTime,
      this.endTime,
      this.startLocationName,
      this.endLocationName,
      this.tripLocations,
      this.startLocationCoordinateLongitude,
      this.startLocationCoordinateLatitude,
      this.endLocationCoordinateLongitude,
      this.endLocationCoordinateLatitude,
      this.endLocationImage,
      this.contactPerson,
      this.contactPersonCountryId,
      this.tripVisibility,
      this.isReported,
      this.tripViewCount,
      this.tripLikeCount,
      this.tripDaysCount,
      this.tripLikedBySelf,
      this.createdBy,
      this.createdDate,
      this.modifiedBy,
      this.modifiedDate,
      this.tripStepsCount,
      this.tripStairsCount});

  TrendingTrips.fromJson(Map<String, dynamic> json) {
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
    userFullName = json['userFullName'];
    userEmail = json['userEmail'];
    travelTypeDesc = json['travelTypeDesc'];
    userProfilePictureUrl = json['userProfilePictureUrl'];
    displayName = json['displayName'];
    canView = json['canView'];
    coAuthorsCount = json['coAuthorsCount'];
    commentsCount = json['commentsCount'];
    tripDays = json['tripDays'];
    travelType = json['travelType'];
    displayPicture = json['displayPicture'];
    startLocationImage = json['startLocationImage'];
    if (json['visitiedCountries'] != null) {
      visitiedCountries = <CountryModel>[];
      json['visitiedCountries'].forEach((v) {
        visitiedCountries!.add(CountryModel.fromJson(v));
      });
    }
    eventIds = json['eventIds'];
    tripId = json['tripId'];
    userId = json['userId'];
    tripName = json['tripName'];
    travelTypeId = json['travelTypeId'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    startLocationName = json['startLocationName'];
    endLocationName = json['endLocationName'];
    tripLocations = json['tripLocations'];
    startLocationCoordinateLongitude = json['startLocationCoordinateLongitude'];
    startLocationCoordinateLatitude = json['startLocationCoordinateLatitude'];
    endLocationCoordinateLongitude = json['endLocationCoordinateLongitude'];
    endLocationCoordinateLatitude = json['endLocationCoordinateLatitude'];
    endLocationImage = json['endLocationImage'];
    contactPerson = json['contactPerson'];
    contactPersonCountryId = json['contactPersonCountryId'];
    tripVisibility = json['tripVisibility'];
    isReported = json['isReported'];
    tripViewCount = json['tripViewCount'];
    tripLikeCount = json['tripLikeCount'];
    tripDaysCount = json['tripDaysCount'];
    tripLikedBySelf = json['tripLikedBySelf'];
    createdBy = json['createdBy'];
    createdDate = json['createdDate'];
    modifiedBy = json['modifiedBy'];
    modifiedDate = json['modifiedDate'];
    tripStepsCount = json['tripStepsCount'];
    tripStairsCount = json['tripStairsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userFirstName'] = userFirstName;
    data['userLastName'] = userLastName;
    data['userFullName'] = userFullName;
    data['userEmail'] = userEmail;
    data['travelTypeDesc'] = travelTypeDesc;
    data['userProfilePictureUrl'] = userProfilePictureUrl;
    data['displayName'] = displayName;
    data['canView'] = canView;
    data['coAuthorsCount'] = coAuthorsCount;
    data['commentsCount'] = commentsCount;
    data['tripDays'] = tripDays;
    data['travelType'] = travelType;
    data['displayPicture'] = displayPicture;
    data['startLocationImage'] = startLocationImage;
    if (visitiedCountries != null) {
      data['visitiedCountries'] =
          visitiedCountries!.map((v) => v.toJson()).toList();
    }
    data['eventIds'] = eventIds;
    data['tripId'] = tripId;
    data['userId'] = userId;
    data['tripName'] = tripName;
    data['travelTypeId'] = travelTypeId;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['startLocationName'] = startLocationName;
    data['endLocationName'] = endLocationName;
    data['tripLocations'] = tripLocations;
    data['startLocationCoordinateLongitude'] = startLocationCoordinateLongitude;
    data['startLocationCoordinateLatitude'] = startLocationCoordinateLatitude;
    data['endLocationCoordinateLongitude'] = endLocationCoordinateLongitude;
    data['endLocationCoordinateLatitude'] = endLocationCoordinateLatitude;
    data['endLocationImage'] = endLocationImage;
    data['contactPerson'] = contactPerson;
    data['contactPersonCountryId'] = contactPersonCountryId;
    data['tripVisibility'] = tripVisibility;
    data['isReported'] = isReported;
    data['tripViewCount'] = tripViewCount;
    data['tripLikeCount'] = tripLikeCount;
    data['tripDaysCount'] = tripDaysCount;
    data['tripLikedBySelf'] = tripLikedBySelf;
    data['createdBy'] = createdBy;
    data['createdDate'] = createdDate;
    data['modifiedBy'] = modifiedBy;
    data['modifiedDate'] = modifiedDate;
    data['tripStepsCount'] = tripStepsCount;
    data['tripStairsCount'] = tripStairsCount;
    return data;
  }
}
