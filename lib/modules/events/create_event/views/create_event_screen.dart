import 'dart:io';

import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_post_model.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_more_info_controller/info_venue_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/baby_shower_themes_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/personal_event_activity_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_who_can_post_controller.dart';
import 'package:Happinest/modules/events/create_event/widgets/info_venue_widget.dart';
import 'package:Happinest/modules/events/create_event/widgets/location_search_widget.dart';
import 'package:Happinest/modules/events/create_event/widgets/personal_event/personal_themes_widget.dart';
import 'package:Happinest/modules/events/create_event/widgets/visible_who_can_post_widget.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import 'package:Happinest/modules/events/create_event/widgets/event_join_widget.dart';
import 'package:Happinest/utility/show_alert.dart';
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../../../common/common_functions/datetime_functions.dart';
import '../../../../common/common_functions/topPadding.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/iconButton.dart';
import '../../../../models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import '../../../../utility/Image Upload Bottom Sheets/bulk_image_upload_event.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';
import '../widgets/wedding_event/couple_widget.dart';
import '../controllers/personal_event_controller/baby_shower_visibility_controller.dart';
import '../controllers/visible_to_controller.dart';
import '../controllers/wedding_controllers/wedding_couple_controller.dart';
import '../controllers/create_event_expanded_controller.dart';
import '../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import '../controllers/event_dates_controller.dart';
import '../controllers/title_controller.dart';
import '../widgets/chose_occassion_widget.dart';
import '../widgets/wedding_event/chose_wedding_style.dart';
import '../widgets/personal_event/personnal_activity_widget.dart';
import '../widgets/wedding_event/rituals_widget.dart';
import '../widgets/visible_to_widget.dart';
import '../widgets/wedding_dates_widget.dart';
import '../widgets/wedding_title_widget.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  Map<DateTime, List<AssetEntity>?>? photosBetweeenDays;

  @override
  void initState() {
    super.initState();
  }

  Widget _errorUI() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: const Center(
        child: Text("Failed to load images. Please try again."),
      ),
    );
  }

  Widget _loadingUI() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    print("eventTypeName ${ref.watch(createEventController).eventTypeName}");
    print("hasThemes ${ref.watch(createEventController).hasThemes}");
    print("selectOccassionId ${ref.watch(createEventController).selectOccassionId}");
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          topPadding(topPadding: 8.h, offset: 30.h),
          CustomAppBar(
            onTap: () {
              if (ref.watch(weddingCreateEventVisibilityCtr).occasionSelected) {
                if (ref.watch(eventTitleCtr).title.isEmpty) {
                  clearAllData(ref);
                  ref.watch(createEventExpandedCtr).setOccasionExpanded();
                } else {
                  showAlertMessage(context, ref);
                }
                // final wedTitleCtr = ref.watch(eventTitleCtr);
                // final wedDateCtr = ref.watch(eventDatesCtr);
              } else {
                Navigator.pop(context);
              }
              // Navigator.pop(context);
            },
            hasSuffix: true,
            title: TNavigationTitleStrings.createAnEvent,
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                child: Column(
                  children: [
                    const ChoseYourOccassionWidget(),
                    SizedBox(
                      height: 15.h,
                    ),
                    // Visibility(
                    //     visible: ref.watch(weddingCreateEventVisibilityCtr).occasionSelected &&
                    //         ref.watch(createEventController).hasThemes &&
                    //         ref.watch(createEventController).eventTypeName == "Wedding",
                    //     child: Column(
                    //       children: [
                    //         const ChoseWeddingStyleWidget(),
                    //         SizedBox(
                    //           height: 15.h,
                    //         ),
                    //       ],
                    //     )),
                    // Visibility(
                    //   visible: ref.watch(createEventController).hasThemes &&
                    //       ref.watch(createEventController).eventTypeName == "Wedding" &&
                    //       ref.watch(weddingCreateEventVisibilityCtr).weddingStyleSelected,
                    //   child: const RitualsWidget(),
                    // ),
                    // Visibility(
                    //   visible: ref.watch(createEventController).hasThemes &&
                    //       ref.watch(createEventController).eventTypeName == "Wedding",
                    //   child: SizedBox(
                    //     height: 15.h,
                    //   ),
                    // ),
                    Visibility(
                        visible: ref.watch(weddingCreateEventVisibilityCtr).occasionSelected &&
                            ref.watch(createEventController).hasThemes,
                        // ref.watch(createEventController).selectOccassionId != 1,
                        child: Column(
                          children: [
                            const PersonalThemesWidget(),
                            SizedBox(
                              height: 15.h,
                            )
                          ],
                        )),
                    Visibility(
                        visible: ref.watch(weddingCreateEventVisibilityCtr).occasionSelected &&
                            ref.watch(createEventController).hasThemes &&
                            ref.watch(personalEventVisibilityCtr).themesSelected &&
                            ref.watch(personalEventThemesCtr).themeMasterId != null,
                        child: Column(
                          children: [
                            const PersonnalActivityWidget(),
                            SizedBox(
                              height: 15.h,
                            )
                          ],
                        )),
                    Visibility(
                      visible: (ref.watch(createEventController).hasThemes)
                          ? ref.watch(personalEventVisibilityCtr).themesSelected &&
                              ref.watch(personalEventThemesCtr).themeMasterId != null &&
                              ref.watch(personalEventActivityCtr).selectedActivity.isNotEmpty &&
                              (ref.watch(weddingCreateEventVisibilityCtr).occasionSelected)
                          : !ref.watch(createEventController).hasThemes &&
                              (ref.watch(weddingCreateEventVisibilityCtr).occasionSelected),
                      child: Column(
                        children: [
                          Visibility(
                            visible: ref.watch(createEventController).hasThemes &&
                                ref.watch(createEventController).eventTypeName == "Wedding",
                            child: Column(
                              children: [
                                const CoupleWidget(),
                                SizedBox(
                                  height: 15.h,
                                ),
                              ],
                            ),
                          ),
                          const WeddingTitleWidget(),
                          SizedBox(
                            height: 15.h,
                          ),
                          const WeddingDatesWidget(),
                          SizedBox(
                            height: 15.h,
                          ),
                          InfoVenueWidget(
                            venueText: (val) {
                              print(
                                  "(infoVenueController).selectedText ${ref.watch(infoVenueController).selectedText}");
                              // setState(() {
                              //   final infoVenue = ref.watch(infoVenueController);
                              //   infoVenue.selectedText?.locationName = val;
                              //   infoVenue.selectedText?.locationAddress = val;

                              //   print('Venue Name: $val');
                              // });
                            },
                            venueLatLng: (val) {
                              // final infoVenue = ref.watch(infoVenueController);
                            },
                            countryCode: (val) {
                              // final infoVenue = ref.watch(infoVenueController);
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          const VisibleToWidget(),
                          SizedBox(
                            height: 15.h,
                          ),
                          const WhoCanPostVisibleToWidget(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Visibility(
                      visible: !ref.watch(weddingCreateEventVisibilityCtr).occasionSelected,
                      child: InkWell(
                        child: const EventJoinWidget(),
                        onTap: () {
                          showAlertJoinWithCode(context, ref);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: (ref.watch(createEventController).isBefore == false),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 60),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final wedCoupleCtr = ref.watch(weddingCoupleCtr);
                  final eventTitlename = ref.watch(eventTitleCtr);
                  final eventDateCtr = ref.watch(eventDatesCtr);
                  final eventThemeCtr = ref.watch(personalEventThemesCtr);
                  final eventActivityCtr = ref.watch(personalEventActivityCtr);
                  return (((ref.watch(createEventController).hasThemes)
                          ? ((eventTitlename.title == '') ||
                                  (eventDateCtr.isMultipleDay
                                      ? eventDateCtr.date1 == 'Start Date' ||
                                          eventDateCtr.date2 == 'End Date'
                                      : eventDateCtr.date1 == 'Start Date' &&
                                          eventDateCtr.date2 == 'End Date') ||
                                  (eventThemeCtr.selectedTheme == '') ||
                                  (eventActivityCtr.selectedActivity.isEmpty &&
                                      eventActivityCtr.writeByHandActivity.isEmpty)
                              //  ||
                              //(venueCtr.selectedText == null)
                              )
                          : (ref.watch(createEventController).hasThemes == false)
                              ? ((eventTitlename.title == '') ||
                                  (eventDateCtr.isMultipleDay
                                      ? eventDateCtr.date1 == 'Start Date' ||
                                          eventDateCtr.date2 == 'End Date'
                                      : eventDateCtr.date1 == 'Start Date' &&
                                          eventDateCtr.date2 == 'End Date'))
                              //         ||/// Nripendra Enable Next button without Address
                              // (venueCtr.selectedText == null))
                              : (true)))
                      ? const SizedBox()
                      : TButton(
                          onPressed: () {
                            if ((ref.watch(createEventController).hasThemes)) {
                              if (eventThemeCtr.selectedTheme == '') {
                                TMessaging.showSnackBar(context, 'Select Event Style!');
                                return;
                              }

                              if (eventActivityCtr.selectedActivity.isEmpty) {
                                TMessaging.showSnackBar(context, 'Select Activities!');
                                return;
                              }

                              if (wedCoupleCtr.couple1Name == '' ||
                                  wedCoupleCtr.couple2Name == '') {
                                TMessaging.showSnackBar(context, 'Couple name missing!');
                                return;
                              }

                              if (eventTitlename.title == '') {
                                TMessaging.showSnackBar(context, 'Enter Event Title!');
                                return;
                              }

                              if (eventDateCtr.isMultipleDay
                                  ? eventDateCtr.date1 == 'Start Date' ||
                                      eventDateCtr.date2 == 'End Date'
                                  : eventDateCtr.date1 == 'Start Date' &&
                                      eventDateCtr.date2 == 'End Date') {
                                TMessaging.showSnackBar(context, 'Enter Date!');
                                return;
                              }
                            } else if (!ref.watch(createEventController).hasThemes) {
                              if (eventTitlename.title == '') {
                                TMessaging.showSnackBar(context, 'Enter Event Title!');
                                return;
                              }
                              if (eventDateCtr.isMultipleDay
                                  ? eventDateCtr.date1 == 'Start Date' ||
                                      eventDateCtr.date2 == 'End Date'
                                  : eventDateCtr.date1 == 'Start Date' &&
                                      eventDateCtr.date2 == 'End Date') {
                                TMessaging.showSnackBar(context, 'Enter Date!');
                                return;
                              }
                            }

                            Navigator.pushNamed(context, Routes.eventMoreInfoScreen);
                          },
                          title: TButtonLabelStrings.nextButton,
                          fontSize: MyFonts.size14,
                          buttonBackground: TAppColors.themeColor);
                },
              ),
            ),
          ),
          /* Visibility(
            visible: (ref.watch(personalOthersCreateEventController).isBefore == false && ref
                .watch(personalOthersCreateEventController)
                .selectOccassionId == 11),
            child: Padding(
              padding: const EdgeInsets.only(top: 5,right: 15, left: 15, bottom: 60),
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref,
                    Widget? child) {
                  final wedTitleCtr = ref.watch(personalOthersTitleCtr);
                  final wedDateCtr = ref.watch(personalOthersDatesCtr);
                  return
                    (wedTitleCtr.title == '') ||
                        (wedDateCtr.isMultipleDay
                            ? wedDateCtr.date1 == 'Start Date' || wedDateCtr.date2 == 'End Date'
                            : wedDateCtr.date1 == 'Start Date' && wedDateCtr.date2 == 'End Date') ?
                    const SizedBox():

                    TButton(
                        onPressed: () {

                          if (wedTitleCtr.title == '') {
                            TMessaging.showSnackBar(context, 'Enter Event Title!');
                            return;
                          }

                          if (wedDateCtr.isMultipleDay
                              ? wedDateCtr.date1 == 'Start Date' || wedDateCtr.date2 == 'End Date'
                              : wedDateCtr.date1 == 'Start Date' && wedDateCtr.date2 == 'End Date') {
                            TMessaging.showSnackBar(context, 'Enter Date!');
                            return;
                          }

                          Navigator.pushNamed(context, Routes.eventMoreInfoScreen);
                        },

                        title: TButtonLabelStrings.nextButton,
                        fontSize: MyFonts.size14,
                        buttonBackground: TAppColors.themeColor);
                },
              ),
            ),
          ),*/
          Visibility(
            visible: (ref.watch(createEventController).hasThemes) &&
                    (ref.watch(createEventController).isBefore)
                ? ((ref.watch(eventTitleCtr).title != '') ||
                        (ref.watch(eventDatesCtr).isMultipleDay
                            ? ref.watch(eventDatesCtr).date1 == 'Start Date' ||
                                ref.watch(eventDatesCtr).date2 == 'End Date'
                            : ref.watch(eventDatesCtr).date1 == 'Start Date' &&
                                ref.watch(eventDatesCtr).date2 == 'End Date') ||
                        (ref.watch(personalEventThemesCtr).selectedTheme == '') ||
                        (ref.watch(personalEventActivityCtr).selectedActivity.isEmpty &&
                            ref.watch(personalEventActivityCtr).writeByHandActivity.isEmpty)
                    //  ||
                    //(venueCtr.selectedText == null)
                    )
                : (ref.watch(createEventController).isBefore) &&
                    // (ref.watch(infoVenueController).selectedText != null) &&
                    (ref.watch(eventTitleCtr).title != ''),
            child: Padding(
              padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 60),
              child: TButton(
                  onPressed: () async {
                    final wedDateCtr = ref.watch(eventDatesCtr);
                    final infoVenue = ref.watch(infoVenueController);

                    DateFormat format = DateFormat("MMM d yyyy");
                    DateTime date1 = format.parse(wedDateCtr.date1);
                    DateTime date2 = format.parse(wedDateCtr.date1);
                    if (wedDateCtr.date2 != 'End Date') {
                      date2 = format.parse(wedDateCtr.date2);
                    }
                    // DateTime sDate = DateTime(2000);
                    // DateTime lDate = DateTime.now();
                    // EasyLoading.show(status: 'Fetching images...');
                    // photosBetweeenDays =
                    //     await ImagePickerBottomSheet.getImagesForTripDays(date1, date2);
                    final wedVisibilityCtr = ref.watch(visibleToCtr);
                    final themesCtr = ref.watch(personalEventThemesCtr);
                    final activityCtr = ref.watch(personalEventActivityCtr);
                    final postVisibilityCtr = ref.watch(visibleWhoPostCtr);
                    List<PersonalEventActivities> personalEventActivities = [];
                    List<PersonalEventActivityMasterList>? personalEventActivity = ref
                            .watch(personalEventActivityCtr)
                            .eventActivitiesModel
                            ?.personalEventActivityMasterList ??
                        [];
                    for (var activity in activityCtr.selectedActivity) {
                      var activityObj = personalEventActivity
                          .where((i) => i.activityName == activity)
                          .toList()
                          .first;
                      PersonalEventActivities model = PersonalEventActivities(
                        activityName: activityObj.activityName ?? '',
                        personalEventActivityMasterId:
                            activityObj.personalEventActivityMasterId ?? 0,
                        aboutActivity: "",
                      );
                      personalEventActivities.add(model);
                    }
                    showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(24.0),
                          topLeft: Radius.circular(24.0),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return FutureBuilder<Map<DateTime, List<AssetEntity>?>>(
                              future: ImagePickerBottomSheet.getImagesForTripDays(
                                  date1, date2), // Fetch images
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return _loadingUI(); // Show a loading indicator while fetching images
                                } else if (snapshot.hasError) {
                                  return _errorUI(); // Handle error case
                                } else {
                                  // ignore: avoid_types_as_parameter_names
                                  return BulkImagePicker(
                                      listOfBulkPhotos: snapshot.data!,
                                      tripName: ref.watch(eventTitleCtr).title,
                                      onUpload: (Map<int, List<AssetEntity>>? selectedImages,
                                          List<File?>? fileImage) {
                                        // if (ref.watch(createEventController).selectOccassionId ==
                                        //     1) {
                                        //   final wedStyleCtr = ref.watch(weddingStylesCtr);
                                        //   final wedRitualCtr = ref.watch(weddingActivityCtr);
                                        //   final wedCoupleCtr = ref.watch(weddingCoupleCtr);
                                        //   final wedTitleCtr = ref.watch(eventTitleCtr);
                                        //   final wedDateCtr = ref.watch(eventDatesCtr);
                                        //   final wedVisibilityCtr = ref.watch(visibleToCtr);
                                        //   final infoVenue = ref.watch(infoVenueController);

                                        //   List<WeddingRitual> weddingRituals = [];
                                        //   int index = 0;
                                        //   for (var ritual in wedRitualCtr.selectedRituals) {
                                        //     WeddingRitual model = WeddingRitual(
                                        //       ritualName: ritual,
                                        //     );

                                        //     index = index + 1;
                                        //     weddingRituals.add(model);
                                        //   }

                                        //   for (var ritual in wedRitualCtr.writeByHandRitualss) {
                                        //     WeddingRitual model = WeddingRitual(
                                        //       ritualName: ritual,
                                        //     );

                                        //     index = index + 1;
                                        //     weddingRituals.add(model);
                                        //   }
                                        //   SetWeddingPostModel model = SetWeddingPostModel(
                                        //     countryCode: infoVenue.countryCode ?? "",
                                        //     weddingStyleMasterId:
                                        //         wedStyleCtr.weddingStyleMasterId != null
                                        //             ? int.parse(wedStyleCtr.weddingStyleMasterId!)
                                        //             : null,
                                        //     title: wedTitleCtr.title,
                                        //     aboutTheWedding: "",
                                        //     backgroundImageData: "",
                                        //     backgroundImageExtention: "",
                                        //     backgroundMusicData: "",
                                        //     backgroundMusicExtention: "",
                                        //     endDateTime: wedDateCtr.date2 != "End Date"
                                        //         ? convertStringToDateTime(wedDateCtr.date2)
                                        //         : convertStringToDateTime(wedDateCtr.date1),
                                        //     startDateTime:
                                        //         convertStringToDateTime(wedDateCtr.date1),
                                        //     invitationData: "",
                                        //     invitationExtention: "",
                                        //     multipleDayEvent: wedDateCtr.isMultipleDay,
                                        //     partner1: wedCoupleCtr.couple1Name,
                                        //     partner2: wedCoupleCtr.couple2Name,
                                        //     venueAddress: infoVenue.selectedText?.locationName ??
                                        //         infoVenue.currentLocationAddress ??
                                        //         "",
                                        //     createdOn: DateTime.now(),
                                        //     venueLat: infoVenue.selectedText?.locationLatitude ??
                                        //         infoVenue.currentLocation.latitude.toString(),
                                        //     venueLong: infoVenue.selectedText?.locationLongitude ??
                                        //         infoVenue.currentLocation.longitude.toString(),
                                        //     visibility: wedVisibilityCtr.public
                                        //         ? 1
                                        //         : wedVisibilityCtr.private
                                        //             ? 2
                                        //             : 3,
                                        //     weddigStyleName: wedStyleCtr.selectedStyles != ''
                                        //         ? wedStyleCtr.selectedStyles
                                        //         : wedStyleCtr.writeByHandStyles,
                                        //     weddingRituals: weddingRituals,
                                        //     contributor: postVisibilityCtr.public
                                        //         ? 1
                                        //         : postVisibilityCtr.onlyHost
                                        //             ? 2
                                        //             : 3,
                                        //     selfRegistration: wedVisibilityCtr.selfRegistration,
                                        //   );
                                        //   print("Model ****** ${setWeddingPostModelToJson(model)}");
                                        //   ref.read(createEventController).setWedding(
                                        //       context: context,
                                        //       ref: ref,
                                        //       setWeddingPostModel: model,
                                        //       isAddPhotos: false,
                                        //       images: selectedImages,
                                        //       files: fileImage);
                                        // } else {
                                        SetPersonalEventPostModel model = SetPersonalEventPostModel(
                                          eventTypeMasterId:
                                              ref.watch(createEventController).selectOccassionId,
                                          aboutThePersonalEvent: "",
                                          countryCode: infoVenue.countryCode ?? "",
                                          createdOn: DateTime.now(),
                                          endDateTime: wedDateCtr.date2 != "End Date"
                                              ? convertStringToDateTime(wedDateCtr.date2)
                                              : convertStringToDateTime(wedDateCtr.date1),
                                          startDateTime: convertStringToDateTime(wedDateCtr.date1),
                                          multipleDayEvent: wedDateCtr.isMultipleDay,
                                          title: ref.watch(eventTitleCtr).title,
                                          venueLat: infoVenue.selectedText?.locationLatitude ??
                                              infoVenue.currentLocation.latitude.toString(),
                                          venueLong: infoVenue.selectedText?.locationLongitude ??
                                              infoVenue.currentLocation.longitude.toString(),
                                          visibility: wedVisibilityCtr.public
                                              ? 1
                                              : wedVisibilityCtr.private
                                                  ? 2
                                                  : 3,
                                          guestVisibility: wedVisibilityCtr.showGuest,
                                          invitationData: "",
                                          invitationExtention: "",
                                          personalEventActivities: personalEventActivities,
                                          personalEventThemeId:
                                              int.parse(themesCtr.themeMasterId ?? '0'),
                                          backgroundImageData: "",
                                          backgroundImageExtention: null,
                                          backgroundMusicData: "",
                                          backgroundMusicExtention: "",
                                          personalEventThemeName: themesCtr.selectedTheme,
                                          venueAddress: infoVenue.selectedText?.locationName ??
                                              infoVenue.currentLocationAddress,
                                          contributor: postVisibilityCtr.public
                                              ? 1
                                              : postVisibilityCtr.onlyHost
                                                  ? 2
                                                  : 3,
                                          selfRegistration: wedVisibilityCtr.selfRegistration,
                                        );
                                        print(' guestVisibility  : ${model.guestVisibility}');
                                        ref.watch(createEventController).setPersonalEvents(
                                            setPersonalEventPostModel: model,
                                            context: context,
                                            ref: ref,
                                            isAddPhotos: true,
                                            images: selectedImages,
                                            files: fileImage);
                                        // }
                                      }); // Display images when loaded
                                }
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  title: TButtonLabelStrings.addPhotos,
                  fontSize: MyFonts.size14,
                  buttonBackground: TAppColors.themeColor),
            ),
          ),
        ],
      ),
    );
  }

  void clearAllData(WidgetRef ref) {
    ref.read(weddingStylesCtr).clearStyles();
    ref.read(weddingActivityCtr).clearRitualss();
    ref.read(weddingCoupleCtr).clearCoupleNames();
    ref.read(eventTitleCtr).clearTitle();
    ref.read(createEventController).resetAllData();
    ref.read(eventDatesCtr).clearDates();
    ref.read(infoVenueController).resetData();
    ref.read(weddingCreateEventVisibilityCtr).resetSelection();
    ref.read(personalEventVisibilityCtr).resetSelection();
    ref.read(personalEventActivityCtr).clearActivity();
    ref.read(personalEventThemesCtr).clearThemes();
  }

  void showAlertMessage(BuildContext context, WidgetRef ref) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              bodyText: TMessageStrings.dataDropFrom,
              onActionPressed: () {
                clearAllData(ref);
                ref.watch(createEventExpandedCtr).resetExpand();
                // Navigator.pop(context);
              },
            ));
  }

  final errorMessageProvider = StateProvider<String?>((ref) => null);

  void showAlertJoinWithCode(BuildContext context, WidgetRef ref) {
    TextEditingController eventCodeController = TextEditingController();
    BuildContext mainContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Consumer(
                builder: (context, ref, _) {
                  final errorMessage = ref.watch(errorMessageProvider);

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF31B2F7),
                        style: BorderStyle.solid,
                        width: 2.0,
                      ),
                    ),
                    // Adjust height dynamically based on error message presence
                    height: errorMessage == null ? 200.h : 260.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            TText(
                              "Enter Event Code",
                              fontSize: MyFonts.size20,
                              color: TAppColors.text1Color,
                              fontWeight: FontWeightManager.semiBold,
                            ),
                            iconButton(
                              padding: 0,
                              radius: 24.w,
                              onPressed: () {
                                ref.read(errorMessageProvider.notifier).state = null;
                                Navigator.pop(context);
                              },
                              iconPath: TImageName.cancelIcon,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TTextField(
                          inputboxBoder: Colors.black12,
                          controller: eventCodeController,
                          textInputType: TextInputType.name,
                          hintText: "Enter Event Code",
                          onChanged: (code) {
                            // Clear error message on text change
                            ref.read(errorMessageProvider.notifier).state = null;
                          },
                          onTapOutside: (p0) {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TText(
                              errorMessage,
                              color: Colors.red,
                              fontSize: MyFonts.size16,
                            ),
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 40,
                          child: TBounceAction(
                            onPressed: () async {
                              if (eventCodeController.text.isEmpty) {
                                ref.read(errorMessageProvider.notifier).state =
                                    "Field is blank. Please enter the event code.";
                              } else {
                                Navigator.pop(context);
                                ref.read(errorMessageProvider.notifier).state = null;
                                await ref.read(createEventController).joinEvent(
                                      eventID: eventCodeController.text,
                                      context: mainContext,
                                      ref: ref,
                                    );
                              }
                            },
                            child: TCard(
                              radius: 100,
                              color: TAppColors.themeColor,
                              child: Center(
                                child: TText(
                                  'JOIN',
                                  fontSize: 14,
                                  fontWeight: FontWeightManager.semiBold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
