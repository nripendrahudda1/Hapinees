import 'package:Happinest/modules/memories/location_model.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../models/create_event_models/create_wedding_models/location_model.dart';
import '../../../../../utility/preferenceutils.dart';

final infoVenueController = ChangeNotifierProvider((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return InfoVenueController(dioClient: dioClient);
});

class InfoVenueController extends ChangeNotifier {
  final DioClient dioClient;
  InfoVenueController({required this.dioClient});
  String countryCode = 'UK';
  // LocationsWithDetail? selectedText;

  LocationsWithDetail? _selectedText;
  LocationsWithDetail? get selectedText => _selectedText;
  setSelectedTextLocation(LocationsWithDetail? selected) {
    _selectedText = selected;
    notifyListeners();
  }

  String _currentLocationAddress = "London, UK";
  String get currentLocationAddress => _currentLocationAddress;
  setCurrentAddress(String address) {
    _currentLocationAddress = address;
    notifyListeners();
  }

  LatLng _currentLocation = const LatLng(	51.509865, -0.118092);
  LatLng get currentLocation => _currentLocation;
  setCurrentLocation(LatLng val) {
    _currentLocation = val;
    notifyListeners();
  }

  LatLng? _initialCameraPosition;
  LatLng? get initialCameraPosition => _initialCameraPosition;
  setInitialLocation(LatLng val) {
    _initialCameraPosition = val;
    notifyListeners();
  }

  LocationModel? _myLocation;
  LocationModel? get myLocation => _myLocation;
  setMyLocation({required LocationModel model}) {
    _myLocation = model;
    notifyListeners();
  }

  resetData() {
    _selectedText = null;
    _currentLocationAddress = '';
    _currentLocation = const LatLng(	51.509865, -0.118092);
    _initialCameraPosition = null;
    notifyListeners();
  }

  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  Future<void> getAddressFromLatLong(double latitude, double longitude) async {
    print("getAddressFromLatLong *****************");
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude, longitude);
    print('Placemarks $placemarks');
    if(placemarks.isNotEmpty) {
      Placemark place = placemarks[0];
      print("getAddressFromLatLong ***************** ${place}");
      countryCode = place.isoCountryCode ?? '';
      setCurrentAddress(
          '${place.street != null && place.street != '' ? '${place.street}, ' : ''}${place
              .subLocality != null && place.subLocality != '' ? '${place.subLocality}, ' : ''}${place
              .locality != null && place.locality != '' ? '${place.locality}, ' : ''}${place
              .postalCode != null && place.postalCode != '' ? '${place.postalCode}, ' : ''}${place
              .country}');
      print("countryCode ***************** $countryCode");
      print("setCurrentAddress ***************** $currentLocationAddress");
    }
  }

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setMyLocation(
          model: LocationModel(
              currentLocation.latitude, currentLocation.longitude));
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    print("permission ***************** $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setMyLocation(
            model: LocationModel(
                currentLocation.latitude, currentLocation.longitude));
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setMyLocation(
          model: LocationModel(
              currentLocation.latitude, currentLocation.longitude));
      throw Exception('Location permissions are permanently denied.');
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      final Position location = await _getCurrentLocation();
      setCurrentLocation(LatLng(location.latitude, location.longitude));
      await getAddressFromLatLong(location.latitude, location.longitude);
      setInitialLocation(LatLng(location.latitude, location.longitude));
      setMyLocation(model: LocationModel(location.latitude, location.longitude));
    }
  }

}
