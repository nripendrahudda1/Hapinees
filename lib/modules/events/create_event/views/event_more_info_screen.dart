import 'package:Happinest/modules/events/create_event/controllers/event_more_info_controller/info_venue_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/personal_event_activity_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_who_can_post_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_post_model.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_controller.dart';

import '../../../../common/common_functions/datetime_functions.dart';
import '../../../../common/common_functions/topPadding.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/appbar.dart';
import '../../../../common/widgets/custom_dialog.dart';
import '../../../../common/widgets/event_app_bar.dart';
import '../../../../common/widgets/iconButton.dart';
import '../../../../models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import '../../../../models/create_event_models/create_personal_event_models/post_models/set_personal_event_post_model.dart';
import '../controllers/personal_event_controller/baby_shower_themes_controller.dart';
import '../controllers/wedding_controllers/wedding_couple_controller.dart';
import '../controllers/create_event_expanded_controller.dart';
import '../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import '../controllers/event_dates_controller.dart';
import '../controllers/wedding_controllers/wedding_activity_controller.dart';
import '../controllers/wedding_controllers/wedding_style_controller.dart';
import '../controllers/title_controller.dart';
import '../controllers/visible_to_controller.dart';
import '../widgets/info_message_from_host_widget.dart';
import '../widgets/info_backeground_image_widget.dart';
import '../widgets/info_upload_audio_widget.dart';
import '../widgets/info_upload_invitation_widget.dart';
import '../widgets/info_venue_widget.dart';

class EventMoreInfoScreen extends ConsumerStatefulWidget {
  const EventMoreInfoScreen({super.key});

  @override
  ConsumerState<EventMoreInfoScreen> createState() => _EventMoreInfoScreenState();
}

class _EventMoreInfoScreenState extends ConsumerState<EventMoreInfoScreen> {
  String? bgImage;
  String? bgExtension;
  String? invitationImage;
  String? invitationExtension;
  String? audio;
  String? audioExtension;
  String? aboutEvent;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Scaffold(
            backgroundColor: TAppColors.white,
            body: Column(
              children: [
                topPadding(topPadding: 0.h, offset: 30.h),
                Consumer(
                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                    final couplectr = ref.watch(eventTitleCtr);
                    return CustomAppBar(
                      onTap: () {
                        showAlertMessage(context);
                      },
                      title: TNavigationTitleStrings.createAnEvent,
                      hasSubTitle: true,
                      subtitle: couplectr.title,
                      prefixWidget: iconButton(
                        bgColor: TAppColors.text4Color,
                        iconPath: TImageName.back,
                        radius: 24.h,
                        onPressed: () {
                          Navigator.pop(context);
                          //showAlertMessage(context);
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 010.h),
                      child: Column(
                        children: [
                          InfoBackgroundImageWidget(
                            bgExt: (val) {
                              setState(() {
                                bgExtension = val;
                              });
                            },
                            bgImage: (val) {
                              setState(() {
                                bgImage = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          InfoMessageFromHostWidget(
                            aboutText: (val) {
                              setState(() {
                                aboutEvent = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          InfoUploadInvitationWidget(
                            invitationExt: (val) {
                              setState(() {
                                invitationExtension = val;
                              });
                            },
                            invitationPath: (val) {
                              setState(() {
                                invitationImage = val;
                                print(invitationImage);
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          InfoUploadAudioWidget(
                            audioExt: (val) {
                              setState(() {
                                audioExtension = val;
                                print('audioExt : $audioExtension');
                              });
                            },
                            audioPath: (val) {
                              setState(() {
                                audio = val;
                                print('audio : $val');
                              });
                            },
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 55),
                  child: Consumer(
                    builder: (BuildContext context, ref, Widget? child) {
                      final wedStyleCtr = ref.watch(weddingStylesCtr);
                      final wedRitualCtr = ref.watch(weddingActivityCtr);
                      final wedCoupleCtr = ref.watch(weddingCoupleCtr);
                      final wedTitleCtr = ref.watch(eventTitleCtr);
                      final wedDateCtr = ref.watch(eventDatesCtr);
                      final wedVisibilityCtr = ref.watch(visibleToCtr);
                      final infoVenue = ref.watch(infoVenueController);
                      final themesCtr = ref.watch(personalEventThemesCtr);
                      final activityCtr = ref.watch(personalEventActivityCtr);
                      return TButton(
                          onPressed: () async {
                            print("Save event click start");
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

                            if (ref.watch(createEventController).hasThemes) {
                              SetPersonalEventPostModel model = SetPersonalEventPostModel(
                                eventTypeMasterId:
                                    ref.watch(createEventController).selectOccassionId,
                                aboutThePersonalEvent: aboutEvent,
                                countryCode: infoVenue.countryCode ?? "UK",
                                createdOn: DateTime.now(),
                                endDateTime: wedDateCtr.date2 != "End Date"
                                    ? convertStringToDateTime(wedDateCtr.date2)
                                    : convertStringToDateTime(wedDateCtr.date1),
                                startDateTime: convertStringToDateTime(wedDateCtr.date1),
                                multipleDayEvent: wedDateCtr.isMultipleDay,
                                title: wedTitleCtr.title,
                                venueLat: infoVenue.selectedText?.locationLatitude ??
                                    infoVenue.currentLocation.latitude.toString(),
                                venueLong: infoVenue.selectedText?.locationLongitude ??
                                    infoVenue.currentLocation.longitude.toString(),
                                visibility: wedVisibilityCtr.public
                                    ? 1
                                    : wedVisibilityCtr.private
                                        ? 2
                                        : 3,
                                guestVisibility: wedVisibilityCtr.public
                                    ? false
                                    : wedVisibilityCtr.private
                                        ? false
                                        : true,
                                invitationData: invitationImage,
                                invitationExtention: invitationExtension,
                                personalEventActivities: personalEventActivities,
                                personalEventThemeId: int.parse(themesCtr.themeMasterId ?? '0'),
                                backgroundImageData: bgImage,
                                backgroundImageExtention: bgExtension,
                                backgroundMusicData: audio,
                                backgroundMusicExtention: audioExtension,
                                personalEventThemeName: themesCtr.selectedTheme,
                                venueAddress: infoVenue.selectedText?.locationName ??
                                    infoVenue.currentLocationAddress ??
                                    "",
                              );
                              await ref.watch(createEventController).setPersonalEvents(
                                  setPersonalEventPostModel: model,
                                  context: context,
                                  ref: ref,
                                  isAddPhotos: false);
                              /*await ref
                                  .read(
                                  createEventController)
                                  .eventHomePageScreenWithDummyData(
                                context: context,
                                ref: ref,
                                postModel: model,
                              );*/
                            }
                            // else if (ref.watch(createEventController).selectOccassionId == 1) {
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
                            //     weddingStyleMasterId: wedStyleCtr.weddingStyleMasterId != null
                            //         ? int.parse(wedStyleCtr.weddingStyleMasterId!)
                            //         : null,
                            //     title: wedTitleCtr.title,
                            //     aboutTheWedding: aboutEvent ?? "",
                            //     backgroundImageData: bgImage ?? "",
                            //     backgroundImageExtention: bgExtension ?? "",
                            //     backgroundMusicData: audio ?? "",
                            //     backgroundMusicExtention: audioExtension ?? "",
                            //     endDateTime: wedDateCtr.date2 != "End Date"
                            //         ? convertStringToDateTime(wedDateCtr.date2)
                            //         : convertStringToDateTime(wedDateCtr.date1),
                            //     startDateTime: convertStringToDateTime(wedDateCtr.date1),
                            //     invitationData: invitationImage ?? "",
                            //     invitationExtention: invitationExtension ?? "",
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
                            //   await ref.read(createEventController).setWedding(
                            //       context: context,
                            //       ref: ref,
                            //       setWeddingPostModel: model,
                            //       isAddPhotos: false);
                            // }
                            else if (ref.watch(createEventController).hasThemes == false) {
                              final postVisibilityCtr = ref.watch(visibleWhoPostCtr);
                              SetPersonalEventPostModel model = SetPersonalEventPostModel(
                                eventTypeMasterId:
                                    ref.watch(createEventController).selectOccassionId,
                                aboutThePersonalEvent: aboutEvent,
                                countryCode: infoVenue.countryCode ?? "",
                                createdOn: DateTime.now(),
                                endDateTime: wedDateCtr.date2 != "End Date"
                                    ? convertStringToDateTime(wedDateCtr.date2)
                                    : convertStringToDateTime(wedDateCtr.date1),
                                startDateTime: convertStringToDateTime(wedDateCtr.date1),
                                multipleDayEvent: wedDateCtr.isMultipleDay,
                                title: wedTitleCtr.title,
                                venueLat: infoVenue.selectedText?.locationLatitude ??
                                    infoVenue.currentLocation.latitude.toString(),
                                venueLong: infoVenue.selectedText?.locationLongitude ??
                                    infoVenue.currentLocation.longitude.toString(),
                                visibility: wedVisibilityCtr.public
                                    ? 1
                                    : wedVisibilityCtr.private
                                        ? 2
                                        : 3,
                                guestVisibility: wedVisibilityCtr.public
                                    ? false
                                    : wedVisibilityCtr.private
                                        ? false
                                        : true,
                                invitationData: invitationImage,
                                invitationExtention: invitationExtension,
                                personalEventActivities: personalEventActivities,
                                personalEventThemeId: int.parse(themesCtr.themeMasterId ?? '0'),
                                backgroundImageData: bgImage,
                                backgroundImageExtention: bgExtension,
                                backgroundMusicData: audio,
                                backgroundMusicExtention: audioExtension,
                                personalEventThemeName: themesCtr.selectedTheme,
                                venueAddress: infoVenue.selectedText?.locationName ??
                                    infoVenue.currentLocationAddress ??
                                    "",
                                contributor: postVisibilityCtr.public
                                    ? 1
                                    : postVisibilityCtr.onlyHost
                                        ? 2
                                        : 3,
                                selfRegistration: wedVisibilityCtr.selfRegistration,
                              );
                              await ref.watch(createEventController).setPersonalEvents(
                                  setPersonalEventPostModel: model,
                                  context: context,
                                  ref: ref,
                                  isAddPhotos: false);
                            }
                          },
                          title: TButtonLabelStrings.saveEvent,
                          fontSize: MyFonts.size14,
                          buttonBackground: TAppColors.themeColor);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        ref.watch(createEventController).isLoading
            ? Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  resetCtr() {
    ref.read(infoVenueController).resetData();
    ref.read(weddingStylesCtr).clearStyles();
    ref.read(weddingActivityCtr).clearRitualss();
    ref.read(weddingCoupleCtr).clearCoupleNames();
    ref.read(eventTitleCtr).clearTitle();
    ref.read(eventDatesCtr).clearDates();
    ref.read(weddingCreateEventVisibilityCtr).resetSelection();
    ref.watch(createEventExpandedCtr).resetExpand();
  }

  void showAlertMessage(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              bodyText: "Are you sure want to Leave this Screen? \n Data will not be saved!",
              onActionPressed: () {
                ref.read(createEventController).resetAllData();
                ref.read(weddingStylesCtr).clearStyles();
                ref.read(infoVenueController).resetData();
                ref.read(weddingActivityCtr).clearRitualss();
                ref.read(weddingCoupleCtr).clearCoupleNames();
                ref.read(eventTitleCtr).clearTitle();
                ref.read(eventDatesCtr).clearDates();
                ref.read(weddingCreateEventVisibilityCtr).resetSelection();
                ref.watch(createEventExpandedCtr).resetExpand();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ));
  }
}
