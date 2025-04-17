import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'dart:async';

import 'package:Happinest/common/common_imports/common_imports.dart';

class LocationManager {
  Future<LocationData?> initLocationService() async {
    var location = Location();
    LocationData locationData;
    LocationData? currentLocation;
    location.enableBackgroundMode(enable: true);
    String address = "";

    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) {
        return null;
      }
    }

//  var setting = await location.changeSettings();

    var permission = location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = location.requestPermission();
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

//
  Future<Position> _determinePosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //  pop abhay
      locationDialogue(context);

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}

class Coordinates {
  /// The geographic coordinate that specifies the north–south position of a point on the Earth's surface.
  final double latitude;

  /// The geographic coordinate that specifies the east-west position of a point on the Earth's surface.
  final double longitude;
  Coordinates(this.latitude, this.longitude);
  @override
  String toString() => "{$latitude,$longitude}";
}
