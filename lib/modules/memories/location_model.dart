import 'dart:convert';

ModelLocationList modelLocationListFromJson(String str) => ModelLocationList.fromJson(json.decode(str));

String modelLocationListToJson(ModelLocationList data) => json.encode(data.toJson());

class ModelLocationList {
  bool? responseStatus;
  String? validationMessage;
  int? statusCode;
  List<Location>? locations;
  List<LocationsWithDetail>? locationsWithDetail;

  ModelLocationList({
    this.responseStatus,
    this.validationMessage,
    this.statusCode,
    this.locations,
    this.locationsWithDetail,
  });

  factory ModelLocationList.fromJson(Map<String, dynamic> json) => ModelLocationList(
    responseStatus: json["responseStatus"],
    validationMessage: json["validationMessage"],
    statusCode: json["statusCode"],
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
    locationsWithDetail: json["locationsWithDetail"] == null ? [] : List<LocationsWithDetail>.from(json["locationsWithDetail"]!.map((x) => LocationsWithDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "responseStatus": responseStatus,
    "validationMessage": validationMessage,
    "statusCode": statusCode,
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
    "locationsWithDetail": locationsWithDetail == null ? [] : List<dynamic>.from(locationsWithDetail!.map((x) => x.toJson())),
  };
}

class Location {
  String? locationId;
  String? locationName;
  String? locationAddress;

  Location({
    this.locationId,
    this.locationName,
    this.locationAddress,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    locationId: json["locationId"],
    locationName: json["locationName"],
    locationAddress: json["locationAddress"],
  );

  Map<String, dynamic> toJson() => {
    "locationId": locationId,
    "locationName": locationName,
    "locationAddress": locationAddress,
  };
}

class LocationsWithDetail {
  String? locationId;
  String? locationName;
  String? locationAddress;
  String? locationLongitude;
  String? locationLatitude;
  String? locationCity;
  String? locationCountry;
  String? locationCountryCode;
  String? locationCategory;
  int? fsParentCategoryId;

  LocationsWithDetail({
    this.locationId,
    this.locationName,
    this.locationAddress,
    this.locationLongitude,
    this.locationLatitude,
    this.locationCity,
    this.locationCountry,
    this.locationCountryCode,
    this.locationCategory,
    this.fsParentCategoryId,
  });

  factory LocationsWithDetail.fromJson(Map<String, dynamic> json) => LocationsWithDetail(
    locationId: json["locationId"],
    locationName: json["locationName"],
    locationAddress: json["locationAddress"],
    locationLongitude: json["locationLongitude"],
    locationLatitude: json["locationLatitude"],
    locationCity: json["locationCity"],
    locationCountry: json["locationCountry"],
    locationCountryCode: json["locationCountryCode"],
    locationCategory: json["locationCategory"],
    fsParentCategoryId: json["fsParentCategoryId"],
  );

  Map<String, dynamic> toJson() => {
    "locationId": locationId,
    "locationName": locationName,
    "locationAddress": locationAddress,
    "locationLongitude": locationLongitude,
    "locationLatitude": locationLatitude,
    "locationCity": locationCity,
    "locationCountry": locationCountry,
    "locationCountryCode": locationCountryCode,
    "locationCategory": locationCategory,
    "fsParentCategoryId": fsParentCategoryId,
  };
}