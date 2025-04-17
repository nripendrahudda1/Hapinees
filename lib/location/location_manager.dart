// import 'package:flutter_geocoder/geocoder.dart';

import 'package:location/location.dart';
import 'dart:async';

class LocationManager {
  Future<LocationData?> initLocationService() async {
    var location = Location();
    LocationData locationData;
    LocationData? currentLocation;
    String address = "";

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return null;
      }
    }

    var setting = await location.changeSettings();

    var permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      await location.enableBackgroundMode();
      permission = await location.requestPermission();
      if (permission != PermissionStatus.granted) {
        return null;
      }
    }
    locationData = await location.getLocation();
    currentLocation = locationData;
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      // print("----location-----${currentLocation.latitude}");
      locationData = currentLocation;
    });

    return locationData;
  }

  Future<LocationData?> getLocation() async {
    LocationData? currentLocation;
    initLocationService().then((value) {
      LocationData? location = value;

      currentLocation = location;
    });

    return (currentLocation);
  }

  // static Future<String> getAddress(double? lat, double? lang) async {
  //   if (lat == null || lang == null) return "";
  //   GeoCode geoCode = GeoCode();
  //   //  print("----lat----${lat}");
  //   //  print("----lang----${lang}");
  //   return "";
  // }
}

// class Coordinates {
//   /// Latitude coordinate value.
//   double? latitude;

//   /// Longitude coordinate value.
//   double? longitude;

//   Coordinates({this.latitude, this.longitude});

//   factory Coordinates.fromJson(Map<String, dynamic> coordinates) => Coordinates(
//       latitude: double.tryParse(tryParse(coordinates['latt']) ?? ''),
//       longitude: double.tryParse(tryParse(coordinates['longt']) ?? ''));

//   @override
//   String toString() => "GEOCODE: longitude=$longitude, latitude=$latitude";
// }
class Coordinates {
  /// The geographic coordinate that specifies the north–south position of a point on the Earth's surface.
  final double latitude;

  /// The geographic coordinate that specifies the east-west position of a point on the Earth's surface.
  final double longitude;

  Coordinates(this.latitude, this.longitude);

  /// Creates coordinates from a map containing its properties.
  // Coordinates.fromMap(Map map) :
  //       this.latitude = map["latitude"],
  //       this.longitude = map["longitude"];

  // /// Creates a map from the coordinates properties.
  // Map toMap() => {
  //   "latitude": this.latitude,
  //   "longitude": this.longitude,
  // };

  @override
  String toString() => "{$latitude,$longitude}";
}
