import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

class LocationProvider {
  // StreamController<Position> _locStream = StreamController();
  // late StreamSubscription<Position> locationSubscription;

  String _deliveryAddress = '';
  double _currentLatitude = 0.0;
  double _currentLongitude = 0.0;

  String get deliveryAddress {
    return _deliveryAddress;
  }

  double get currentLatitude {
    return _currentLatitude;
  }

  double get currentLongitude {
    return _currentLongitude;
  }

  String? postCode;
  String? addressLine;
  String? locality;
  String? city;
  String? selectedState;

  // startLocation() {
  //   final positionStream = Geolocator.getPositionStream().handleError((error) {});
  //   locationSubscription = positionStream.listen((Position position) {
  //     _locStream.sink.add(position);
  //   });
  // }

  Future<void> getLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await _getGeoLocationPosition(context);
      print('Current Location Response: $position');
      print('Current LatitudeSSSSSSSSS: ${position.latitude}');
      print('Current LongitudeSSSSSSSSSS:${position.longitude}');
      _currentLatitude = position.latitude;
      _currentLongitude = position.longitude;

      //notifyListeners();
    } else {
      //  pop abhay
      locationDialogue(context);

      _currentLatitude = 0.0;
      _currentLongitude = 0.0;
      // notifyListeners();
    }

    // return position;
  }

  Future<Position> _getGeoLocationPosition(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await locationDialogue(context);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      //  pop abhay
      locationDialogue(context);

      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    if (permission == LocationPermission.always) {
      return Future.error('Location permissions are permanently always');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print('Placemarks $placemarks');
    Placemark place = placemarks[0];

    _deliveryAddress =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    postCode = place.postalCode!;
    addressLine = '${place.street} ${place.thoroughfare}';
    locality = place.subLocality!;
    city = place.locality!;
    selectedState = place.administrativeArea!;
    // setState(() {});
    // notifyListeners();
  }

  Future<void> newAddress(double latitude, double longitude) async {
    //This is where a new address is selected from
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    _deliveryAddress =
        '${place.street}, ${place.thoroughfare} ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea} ${place.country}';
    postCode = place.postalCode!;
    addressLine = '${place.street} ${place.thoroughfare}';
    locality = place.subLocality!;
    city = place.locality!;
    selectedState = place.administrativeArea!;
    print('Initial Address $postCode');
    print('Initial Address $addressLine');
    print('Initial Address $locality');
    print('Initial Address $city');
    print('Initial Address $selectedState');
    print('New Address $_deliveryAddress');
    // setState(() {});

    // notifyListeners();
  }
}
