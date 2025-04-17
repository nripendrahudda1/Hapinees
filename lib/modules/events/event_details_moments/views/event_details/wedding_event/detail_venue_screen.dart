import 'dart:async';

import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/event_details_moments/widgets/venue_card.dart';

class WeddingEventDetailVenueScreen extends ConsumerStatefulWidget {
  const WeddingEventDetailVenueScreen({super.key});

  @override
  ConsumerState<WeddingEventDetailVenueScreen> createState() => _WeddingEventDetailVenueScreenState();
}

class _WeddingEventDetailVenueScreenState extends ConsumerState<WeddingEventDetailVenueScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};

  _setMarker(LatLng point) async {
    _markers.add(
      Marker(
        markerId: const MarkerId('MyLocation'),
        position: LatLng(point.latitude, point.longitude),
      ),
    );
    // await _moveCamera(point);
    // setState(() {});
  }

  Future<void> _moveCamera(LatLng placeData) async {
    // final GoogleMapController controller = await
    _controller.future.then((value) {
      value.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: placeData,
            zoom: 16,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize()async{
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final weddincCtr = ref.watch(weddingEventHomeController);
      if( weddincCtr.homeWeddingDetails?.venueLat != 'null'){
        _setMarker(LatLng(
            double.parse(
                weddincCtr.homeWeddingDetails?.venueLat ??
                    '0.0'),
            double.parse(
                weddincCtr.homeWeddingDetails?.venueLong ??
                    '0.0')));
        setState(() {

        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final weddincCtr = ref.watch(weddingEventHomeController);
        return Stack(
          children: [
            Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final weddincCtr = ref.watch(weddingEventHomeController);
              return Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: weddincCtr.homeWeddingDetails?.venueLat != 'null'
                              ? LatLng(
                              double.parse(
                                  weddincCtr.homeWeddingDetails?.venueLat ??
                                      '0.0'),
                              double.parse(
                                  weddincCtr.homeWeddingDetails?.venueLong ??
                                      '0.0'))
                              : const LatLng(0.0, 0.0),
                          zoom: 16,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        myLocationEnabled: true,
                        markers: _markers,
                      )));
            }),
            weddincCtr.homeWeddingDetails?.venueAddress != null?
            Positioned(
              top: 0.h,
              child: VenueCard(
                venue: weddincCtr.homeWeddingDetails?.venueAddress ?? '',
              ),
            ): const SizedBox(),
          ],
        );
      },
    );
  }
}
