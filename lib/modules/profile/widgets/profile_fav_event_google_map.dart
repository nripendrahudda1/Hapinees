import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'dart:ui' as ui;
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../explore/explore_google_map.dart';
import '../controller/profile_controller.dart';
import '../model/stories_model.dart';

class ProfileFavEventMap extends ConsumerStatefulWidget {
  const ProfileFavEventMap({super.key, required this.stories});
  final List<Stories> stories;
  @override
  ConsumerState<ProfileFavEventMap> createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<ProfileFavEventMap> {
  GoogleMapController? _mapController;

  LatLng _initialPosition =
  const LatLng(45.4380528374478, 12.3359325528145); // San Francisco, CA

  final List<Marker> _markers = [];
  String? isMarkerTap;
  int dayID = 0;
  LatLngBounds? bounds;
  bool isAnimating = false;
  List<int> noOfLocations = [];
  bool isMarkerGenerated = false;
  List<bool> haveMarkers = [];
  var style = '''[
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "administrative.land_parcel",
      "elementType": "labels",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "poi",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "road",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.icon",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "road.local",
      "elementType": "labels",
      "stylers": [
        {"visibility": "off"}
      ]
    },
    {
      "featureType": "transit",
      "stylers": [
        {"visibility": "off"}
      ]
    }
  ]''';

  @override
  void initState() {
    setState(() {
      addMarkers();
    });
    super.initState();
  }

  Future<Uint8List> getBytesFromNetworkImage(
      String imageUrl, int width, int height) async {
    try {
      Dio dio = Dio();
      Response<List<int>> response = await dio.get<List<int>>(imageUrl,
          options: Options(responseType: ResponseType.bytes));

      if (response.statusCode == 200) {
        final ByteData data =
        ByteData.view(Uint8List.fromList(response.data!).buffer);
        final ui.Codec codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
          targetWidth: width,
          targetHeight: height,
        );
        final ui.FrameInfo fi = await codec.getNextFrame();
        return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
      } else {
        throw Exception('Failed to load image: $imageUrl');
      }
    } catch (error) {
      throw Exception('Error loading image: $error');
    }
  }

  Future<Uint8List> getBytesFromAsset(
      String path, int width, int height) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
      targetHeight: height,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> addMarkers() async {
    _markers.clear();
    if (widget.stories.isNotEmpty) {
      for (var i = 0; i < widget.stories.length; i++) {
        await _addMarkers(widget.stories[i], i);
      }
    }
    EasyLoading.dismiss();
    setState(() {
      isMarkerGenerated = true;
      haveMarkers[0] ? _fitMarkers([_markers[0]]) : null;
    });
  }

  Future _addMarkers(Stories data, int i) async {
    var lat = data.storyLat.toString() == "string" || data.storyLat == "0.0" ? null :data.storyLat;
    var long = data.storyLong.toString() == "string" || data.storyLong == "0.0" ? null :data.storyLong;
    if (lat != null && long != null && lat != 'null' && long != 'null') {
      haveMarkers.add(true);
      double lati = double.parse(lat.toString());
      double longi = double.parse(long.toString());
      if(i == 0) {
        setState(() {
          _initialPosition = LatLng(lati, longi);
        });
      }
      final icon = await getBitmapDescriptorFromAssetBytes(TImageName.pinMarker, 120);
      _markers.add(
        Marker(
          markerId: MarkerId(data.storyId.toString()),
          position: LatLng(lati, longi),
          flat: true,
          infoWindow: InfoWindow.noText,
          icon: icon,
          onTap: () {
            int index = widget.stories.indexOf(data);
            final _ = ref.read(profileCtr);
            _.currFavEventsPage = index;
            _.animateToFavEventPage(index);
            _.notifyListeners();
          },
        ),
      );

      /*await getBytesFromNetworkImage("https://test.traveloryapp.com/traveloryimages/StoryMarker/Travel_Marker.png",
              (0.1 * dheight!).toInt(), (0.13 * dheight!).toInt())
          .then((markerIcon) {
        _markers.add(
          Marker(
            markerId: MarkerId(data.storyId.toString()),
            position: LatLng(lati, longi),
            flat: true,
            infoWindow: InfoWindow.noText,
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: () {
              print("markerIcon ********* $index");
              final _ = ref.read(profileCtr);
              _.currFavEventsPage = index;
              _.pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              _.notifyListeners();
            },
          ),
        );
      });*/

    } else {
      // _markers.add(
      //   Marker(
      //       markerId: MarkerId(index.toString()),
      //       onTap: (){
      //         final _ = ref.read(profileCtr);
      //         _.currFavEventsPage = index;
      //         _.animateToFavEventPage(index);
      //         _.notifyListeners();
      //       }
      //   ),
      // );
      haveMarkers.add(false);
    }
  }

  void _fitMarkers(List<Marker> mrkr) async {
    if (mrkr.isNotEmpty) {
      double minLat = mrkr[0].position.latitude;
      double maxLat = mrkr[0].position.latitude;
      double minLng = mrkr[0].position.longitude;
      double maxLng = mrkr[0].position.longitude;

      for (Marker marker in mrkr) {
        double lat = marker.position.latitude;
        double lng = marker.position.longitude;
        minLat = min(minLat, lat);
        maxLat = max(maxLat, lat);
        minLng = min(minLng, lng);
        maxLng = max(maxLng, lng);
      }
      setState(() {
        bounds = LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        );
      });
    } else {
      setState(() {
        bounds = null;
      });
    }
    bounds != null
        ? await _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        extendBoundsByDistance(bounds!, 0.7),
        50,
      ),
    )
        : null;
  }

  LatLngBounds extendBoundsByDistance(
      LatLngBounds bounds, double distanceInKm) {
    // Constants for conversion
    const double degreeToKm = 111.32; // Approximately 111.32 km per degree

    // Calculate latitude and longitude extensions
    double latExtension = distanceInKm / degreeToKm;
    double lonExtension = distanceInKm /
        (degreeToKm * cos(pi * bounds.northeast.latitude / 180.0));

    LatLng southwest = LatLng(
      bounds.southwest.latitude - latExtension,
      bounds.southwest.longitude - lonExtension,
    );

    LatLng northeast = LatLng(
      bounds.northeast.latitude + latExtension,
      bounds.northeast.longitude + lonExtension,
    );

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.read(profileCtr);

    if (isMarkerGenerated) {
      if (dayID != _.currFavEventsPage && haveMarkers[_.currFavEventsPage]) {
        Stories data = widget.stories[_.currFavEventsPage];
        int index = _markers.indexWhere((element) => element.markerId.value == data.storyId.toString());
        dayID = index;
        _fitMarkers([_markers[index]]);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          isMarkerGenerated
              ? GoogleMap(
            buildingsEnabled: false,
            indoorViewEnabled: false,
            trafficEnabled: false,
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 8.0,
            ),
            onCameraMove: (position) {
              isAnimating
                  ? null
                  : setState(() {
                isMarkerTap = null;
              });
            },
            polylines: const <Polyline>{},
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            markers: Set.from(_markers),
            // haveMarkers[_.currPage] ? {_markers[_.currPage]} : {},
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
                _mapController?.setMapStyle(style);
                haveMarkers[0] ? _fitMarkers([_markers[0]]) : null;
                // _fitMarkers(finalList);
              });
            },
          )
              : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 6,
                  ),
                  TText('Map Loading..', color: Colors.black),
                  const SizedBox(height: 80)
                ],
              )),
          const Align(
            child: SizedBox(),
          )
        ],
      ),
    );
  }
}