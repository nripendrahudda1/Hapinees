import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../../../widgets/venue_card.dart';

class PersonalEventDetailVenueScreen extends ConsumerStatefulWidget {
  const PersonalEventDetailVenueScreen({super.key});

  @override
  ConsumerState<PersonalEventDetailVenueScreen> createState() => _PersonalEventDetailVenueScreenState();
}

class _PersonalEventDetailVenueScreenState extends ConsumerState<PersonalEventDetailVenueScreen> {
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
      final personalEventCtr = ref.watch(personalEventHomeController);
      if( personalEventCtr.homePersonalEventDetailsModel?.venueLat != 'null'){
        _setMarker(LatLng(
            double.parse(
                personalEventCtr.homePersonalEventDetailsModel?.venueLat ??
                    '0.0'),
            double.parse(
                personalEventCtr.homePersonalEventDetailsModel?.venueLong ??
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
        final personalEventCtr = ref.watch(personalEventHomeController);
        return Stack(
          children: [
            Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final personalEventCtr = ref.watch(personalEventHomeController);
              return Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: personalEventCtr.homePersonalEventDetailsModel?.venueLat != 'null'
                              ? LatLng(
                              double.parse(
                                  personalEventCtr.homePersonalEventDetailsModel?.venueLat ??
                                      '0.0'),
                              double.parse(
                                  personalEventCtr.homePersonalEventDetailsModel?.venueLong ??
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
            personalEventCtr.homePersonalEventDetailsModel?.venueAddress != null?
            Positioned(
              top: 0.h,
              child: VenueCard(
                venue: personalEventCtr.homePersonalEventDetailsModel?.venueAddress ?? '',
              ),
            ): const SizedBox(),
          ],
        );
      },
    );
  }
}
