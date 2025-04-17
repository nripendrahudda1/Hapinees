import 'dart:async';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';
import '../../../../memories/location_model.dart';
import '../../../create_event/controllers/event_more_info_controller/info_venue_controller.dart';
import '../../controllers/common_update_event_more_info_expanded_controller.dart';

class UpdateInfoVenueWidget extends ConsumerStatefulWidget {
  final String venue;
  final LatLng location;
  final Function(String venue) venueText;
  final Function(LatLng venueLatLng) venueLatLng;
  final Function(String countryCode) countryCode;
  const UpdateInfoVenueWidget({
    super.key,
    required this.venue,
    required this.location,
    required this.venueText,
    required this.venueLatLng,
    required this.countryCode,
  });

  @override
  ConsumerState<UpdateInfoVenueWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<UpdateInfoVenueWidget> {
  final venueCtr = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  ModelLocationList? locationData;
  LocationsWithDetail? selectedText;
  bool isSelected = false;
  final Set<Marker> _markers = {};
  String? countryCode;

  Future<bool> searchLocation({required BuildContext context}) async {
    var url =
        '${ApiUrl.event}${venueCtr.text}/${venueCtr.text}/${ApiUrl.getLocationApi}';
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
    if (selectedText != null) {
      final lat = double.parse(selectedText?.locationLatitude ?? mapCtr.currentLocation.latitude.toString());
      final lng = double.parse(selectedText?.locationLongitude ?? mapCtr.currentLocation.longitude.toString());
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
      widget.countryCode(selectedText?.locationCountryCode.toString() ?? '');
      widget.venueText("${selectedText?.locationName}, ${selectedText?.locationAddress ?? ''}" ?? '');
      mapCtr.setInitialLocation(LatLng(lat, lng));
    } else {
      throw Exception('Invalid place data provided.');
    }
  }

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
            zoom: 16,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    venueCtr.text = widget.venue;
    initiallization();
  }

  initiallization() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(updateEventMoreInfoExpandedCtr).setVenueUnExpanded();
      _markers.add(
        Marker(
          markerId: const MarkerId('MyLocation'),
          position: LatLng(widget.location.latitude, widget.location.longitude),
        ),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    venueCtr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventMoreInfoExpandedCtr).venueExpanded) {
      ref.watch(updateEventMoreInfoExpandedCtr).setVenueUnExpanded();
    } else {
      ref.watch(updateEventMoreInfoExpandedCtr).setVenueExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: TAppColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border:
                  Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventMoreInfoExpandedCtr).venueExpanded
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(updateEventMoreInfoExpandedCtr).venueExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Venue",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
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
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  venueCtr.text,
                                  maxLines: 2,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              constraints: BoxConstraints(maxWidth: 311.w),
                              child: Text(
                                "Venue (Optional)",
                                style: getRegularStyle(
                                    fontSize: MyFonts.size14,
                                    color: TAppColors.text2Color),
                              ),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventMoreInfoExpandedCtr).venueExpanded)
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
                              selectedText = null;
                              searchLocation(context: context);
                            });
                          },
                          hintText: "Enter Address",
                          obscure: false,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Visibility(
                            visible: isSelected == true,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Container(
                                height: 0.25.sh,
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
                                            selectedText = locationData!
                                                .locationsWithDetail?[index];

                                            venueCtr.text =
                                            "${selectedText?.locationName}, ${selectedText?.locationAddress ?? ''}";
                                            isSelected = false;
                                          });
                                          _goToPlace();
                                        },
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TText(
                                                  maxLines: 1,
                                                  minFontSize: MyFonts.size14,
                                                  color: TAppColors.black
                                                      .withOpacity(0.7),
                                                  fontSize: MyFonts.size14,
                                                  "${locationData!.locationsWithDetail?[index].locationName ?? ''} - ${locationData!.locationsWithDetail?[index].locationCountryCode ?? ''}"),
                                              TText(
                                                  maxLines: 1,
                                                  minFontSize: MyFonts.size14,
                                                  color: TAppColors.greyText,
                                                  fontSize: MyFonts.size12,
                                                  locationData!
                                                          .locationsWithDetail?[
                                                              index]
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
                                    itemCount: locationData
                                            ?.locationsWithDetail?.length ??
                                        0,
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Consumer(builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          return SizedBox(
                              height: 303.h,
                              width: 309.w,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: CameraPosition(
                                      target: ref
                                                  .read(infoVenueController)
                                                  .initialCameraPosition !=
                                              null
                                          ? ref
                                              .read(infoVenueController)
                                              .initialCameraPosition!
                                          : ref
                                              .read(infoVenueController)
                                              .currentLocation,
                                      zoom: 16,
                                    ),
                                    onMapCreated:
                                        (GoogleMapController controller) {
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
