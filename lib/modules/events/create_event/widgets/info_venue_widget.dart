import 'dart:async';

import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../../../../utility/API/fetch_api.dart';
import '../../../memories/location_model.dart';
import '../controllers/event_more_info_controller/info_venue_controller.dart';
import '../controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';

class InfoVenueWidget extends ConsumerStatefulWidget {
  final Function(String venue) venueText;
  final Function(LatLng venueLatLng) venueLatLng;
  final Function(String countryCode) countryCode;
  const InfoVenueWidget({
    super.key,
    required this.venueText,
    required this.venueLatLng,
    required this.countryCode,
  });

  @override
  ConsumerState<InfoVenueWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<InfoVenueWidget> {
  final venueCtr = TextEditingController();
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initiallization();
    });
  }

  initiallization() async {
    final mapProvider = ref.watch(infoVenueController);
    await mapProvider.determinePosition();
    // venueCtr.text = mapProvider.currentLocationAddress;
    // _goToPlace();
  }

  ModelLocationList? locationData;
  bool isSelected = false;
  final Set<Marker> _markers = {};
  String placeName = "London, UK";
  String? countryCode;

  Future<bool> searchLocation({required BuildContext context}) async {
    var url = '${ApiUrl.event}${venueCtr.text}/${venueCtr.text}/${ApiUrl.getLocationApi}';
    print("API Calling ${url} --> Null");
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (res) {
        print("response ------------------ searchLocation \n$res");
        setState(() {
          locationData = ModelLocationList.fromJson(res);
        });
      },
    );
    return false;
  }

  Future<void> _goToPlace() async {
    final mapCtr = ref.watch(infoVenueController);
    final lat = double.parse(
        mapCtr.selectedText?.locationLatitude ?? mapCtr.currentLocation.latitude.toString());
    final lng = double.parse(
        mapCtr.selectedText?.locationLongitude ?? mapCtr.currentLocation.longitude.toString());
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 12,
        ),
      ),
    );
    _setMarker(LatLng(lat, lng));
    widget.venueLatLng(LatLng(lat, lng));
    widget.countryCode(
        mapCtr.selectedText?.locationCountryCode ?? mapCtr.countryCode.toString() ?? '');
    widget.venueText(mapCtr.selectedText?.locationName.toString() ?? '');
    mapCtr.setInitialLocation(LatLng(lat, lng));
  }

  /*Future<void> _goToPlace() async {
    final mapCtr = ref.watch(infoVenueController);
    if (selectedText != null) {
      final lat = double.parse(selectedText?.locationLatitude ?? '0');
      final lng = double.parse(selectedText?.locationLongitude ?? '0');

      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 18,
          ),
        ),
      );
      _setMarker(LatLng(lat, lng));
      widget.venueLatLng(LatLng(lat, lng));
      widget.countryCode(selectedText?.locationCountryCode.toString() ?? '');
      widget.venueText(selectedText?.locationName.toString() ?? '');
      mapCtr.setInitialLocation(LatLng(lat, lng));
    } else {
      throw Exception('Invalid place data provided.');
    }
  }*/

  _setMarker(LatLng point) async {
    _markers.add(
      Marker(
        markerId: const MarkerId('MyLocation'),
        position: LatLng(point.latitude, point.longitude),
      ),
    );
    await _moveCamera(point);
    setState(() {});
  }

  Future<void> _moveCamera(LatLng placeData) async {
    // final GoogleMapController controller = await
    _controller.future.then((value) {
      value.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: placeData,
            zoom: 12,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    venueCtr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(createEventMoreInfoExpandedCtr).venueExpanded) {
      ref.watch(createEventMoreInfoExpandedCtr).setVenueUnExpanded();
    } else {
      ref.watch(createEventMoreInfoExpandedCtr).setVenueExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: customColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(createEventMoreInfoExpandedCtr).venueExpanded
                    ? BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      )
              ]),
          child: ListTileTheme(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(createEventMoreInfoExpandedCtr).venueExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Venue",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color,
                                  fontSize: 16,
                                  fontWidth: FontWeightManager.regular),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : venueCtr.text.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Venue",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  venueCtr.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Container(
                              constraints: BoxConstraints(maxWidth: 311.w),
                              child: Text(
                                "Venue (Optional)",
                                style: getRegularStyle(
                                    fontSize: MyFonts.size14, color: customColors.text2Color),
                              ),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventMoreInfoExpandedCtr).venueExpanded)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        CustomTextField(
                          height: 32.h,
                          controller: venueCtr,
                          onFieldSubmitted: (val) {
                            _toggleExpansion();
                          },
                          tailingIcon: IconButton(
                              onPressed: () {
                                _toggleExpansion();
                              },
                              icon: Image.asset(
                                TImageName.tickIcon,
                                width: 24.w,
                                height: 24.h,
                              )),
                          onChanged: (val) {
                            isSelected = true;
                            widget.venueText(val);
                            setState(() {
                              ref.watch(infoVenueController).setSelectedTextLocation(null);
                              searchLocation(context: context);
                            });
                          },
                          hintText: "Enter Address",
                          obscure: false,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Visibility(
                            visible: isSelected == true,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                height: 0.30.sh,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            ref.watch(infoVenueController).setSelectedTextLocation(
                                                locationData!.locationsWithDetail?[index]);

                                            venueCtr.text =
                                                "${locationData!.locationsWithDetail?[index].locationName}, ${ref.read(infoVenueController).selectedText!.locationAddress ?? ''}";
                                            isSelected = false;
                                          });
                                          _goToPlace();
                                        },
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TText(
                                                  maxLines: 1,
                                                  minFontSize: MyFonts.size14,
                                                  color: TAppColors.black.withOpacity(0.7),
                                                  fontSize: MyFonts.size14,
                                                  "${locationData!.locationsWithDetail?[index].locationName ?? ''} - ${locationData!.locationsWithDetail?[index].locationCountryCode ?? ''}"),
                                              TText(
                                                  maxLines: 1,
                                                  minFontSize: MyFonts.size14,
                                                  color: TAppColors.greyText,
                                                  fontSize: MyFonts.size12,
                                                  locationData!.locationsWithDetail?[index]
                                                          .locationAddress ??
                                                      ''),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const Divider();
                                    },
                                    itemCount: locationData?.locationsWithDetail?.length ?? 0,
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          return SizedBox(
                              height: 303.h,
                              width: 309.w,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: ref.read(infoVenueController).initialCameraPosition !=
                                              null
                                          ? ref.read(infoVenueController).initialCameraPosition!
                                          : ref.read(infoVenueController).currentLocation,
                                      zoom: 16,
                                    ),
                                    onMapCreated: (GoogleMapController controller) {
                                      _controller.complete(controller);
                                    },
                                    myLocationEnabled: true,
                                    markers: _markers,
                                  )));
                        }),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
