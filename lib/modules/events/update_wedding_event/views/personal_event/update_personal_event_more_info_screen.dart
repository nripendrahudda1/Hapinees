import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_dates_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_persoanl_event_theme_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_activities_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../controllers/common_update_event_title_controller.dart';
import '../../controllers/common_update_event_visibility_controller.dart';
import '../../controllers/common_update_event_whocanpost_visibility_controller.dart';
import '../../widgets/more_info_screen_widget/update_info_backeground_image_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_message_from_the_host_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_upload_audio_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_venue_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_upload_invitation_widget.dart';

class UpdatePersonalEventMoreInfoScreen extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel homeModel;
  const UpdatePersonalEventMoreInfoScreen({super.key, required this.homeModel});

  @override
  ConsumerState<UpdatePersonalEventMoreInfoScreen> createState() =>
      _UpdatePersonalEventMoreInfoScreenState();
}

class _UpdatePersonalEventMoreInfoScreenState
    extends ConsumerState<UpdatePersonalEventMoreInfoScreen> {
  String? bgImage;
  String? bgExtension;
  String? invitationImage;
  String? invitationExtension;
  String? audio;
  String? audioExtension;
  String? aboutEvent;
  String? venueName;
  double? lat;
  double? lng;
  String? countryCode;

  Future<void> delete(BuildContext context, String? eventName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonDeleteEventDialouge(
            onTap: () async {
              await ref.read(updatePersonalEventActivitiesCtr).deletePersonalEvent(
                  personalEventHeaderId: widget.homeModel.personalEventHeaderId.toString(),
                  ref: ref);
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            title: 'Personal Event',
            eventName: eventName ?? "");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Latitude**: ${widget.homeModel.venueAddress ?? '0.0'}');
    print('Latitude**: ${widget.homeModel.venueLat ?? '0.0'}');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: TAppColors.white,
        body: Column(
          children: [
            topPadding(topPadding: 0.h, offset: 30.h),
            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'Update Event',
              hasSubTitle: true,
              subtitle: ref.watch(updateEventTitleCtr).title,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                  child: Column(
                    children: [
                      UpdateInfoBackgroundImageWidget(
                        imgUrl: widget.homeModel.backgroundImageUrl ?? "",
                        bgExt: (val) {
                          // setState(() {
                          bgExtension = val;
                          // });
                        },
                        bgImage: (val) {
                          // setState(() {
                          bgImage = val;
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoMessageFromTheHostWidget(
                        about: widget.homeModel.aboutThePersonalEvent ?? "",
                        aboutText: (val) {
                          // setState(() {
                          aboutEvent = val;
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoVenueWidget(
                        venue: widget.homeModel.venueAddress ?? '',
                        location: widget.homeModel.venueLat.toString() == 'null'
                            ? const LatLng(0.0, 0.0)
                            : LatLng(double.parse(widget.homeModel.venueLat.toString() ?? '0.0'),
                                double.parse(widget.homeModel.venueLong.toString() ?? '0.0')),
                        venueText: (val) {
                          venueName = val;
                          print('PlaceName: $venueName');
                        },
                        venueLatLng: (val) {
                          // setState(() {
                          lat = val.latitude;
                          lng = val.longitude;
                          // });
                        },
                        countryCode: (val) {
                          // setState(() {
                          countryCode = val;
                          print('CountryCode: $countryCode');
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoUploadInvitationWidget(
                        inviteFileLink: widget.homeModel.invitationUrl,
                        invitationExt: (val) {
                          // setState(() {
                          invitationExtension = val;
                          // });
                        },
                        invitationPath: (val) {
                          // setState(() {
                          invitationImage = val;
                          print(invitationImage);
                          // });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateInfoUploadAudioWidget(
                        audioFileLink: widget.homeModel.backgroundMusicUrl,
                        audioExt: (val) {
                          // setState(() {
                          audioExtension = val;
                          print('audioExt : $audioExtension');
                          // });
                        },
                        audioPath: (val) {
                          // setState(() {
                          audio = val;
                          print('audio : $val');

                          // });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final personalEventThemeCtr = ref.watch(updatePersonalEventThemCtr);
                          final personalEventActivityCtr =
                              ref.watch(updatePersonalEventActivitiesCtr);
                          final eventTitleCtr = ref.watch(updateEventTitleCtr);
                          final eventDateCtr = ref.watch(updateEventDatesCtr);
                          final eventVisibilityCtr = ref.watch(updateEventVisibilityCtr);
                          final eventVisibilityPost = ref.watch(updateWhoPostCtr);

                          List<Activity> personalEventActivity = [];
                          int index = 0;
                          for (var activity in personalEventActivityCtr.selectedActivityModels) {
                            Activity model = Activity(
                                activityName: activity.activityName,
                                personalEventActivityMasterId: activity.personalEventActivityId);

                            index = index + 1;
                            personalEventActivity.add(model);
                          }

                          for (var ritual in personalEventActivityCtr.writeByHandActivities) {
                            Activity model = Activity(
                              activityName: ritual,
                            );
                            index = index + 1;
                            personalEventActivity.add(model);
                          }

                          return TButton(
                            onPressed: () async {
                              print('aboutEvent ******************************** $aboutEvent');
                              UpdatePersonalEventPostModel model = UpdatePersonalEventPostModel(
                                countryCode: countryCode ?? '',
                                personalEventThemeMasterId: personalEventThemeCtr
                                                .personaLEventThemeMasterId !=
                                            null &&
                                        personalEventThemeCtr.personaLEventThemeMasterId != ''
                                    ? int.parse(personalEventThemeCtr.personaLEventThemeMasterId!)
                                    : null,
                                personalEventHeaderId: widget.homeModel.personalEventHeaderId,
                                modifiedOn: DateTime.now(),
                                isActive: true,
                                visibility: eventVisibilityCtr.public
                                    ? 1
                                    : eventVisibilityCtr.private
                                        ? 2
                                        : 3,
                                venueLat:
                                    lat != null ? lat.toString() : widget.homeModel.venueLat ?? '',
                                venueLong:
                                    lng != null ? lng.toString() : widget.homeModel.venueLong ?? '',
                                venueAddress: venueName ?? widget.homeModel.venueAddress,
                                personalEventThemeName: personalEventThemeCtr.selectedThemes,
                                endDateTime: eventDateCtr.date2 != "End Date"
                                    ? convertStringToDateTime(eventDateCtr.date2)
                                    : convertStringToDateTime(eventDateCtr.date1),
                                startDateTime: convertStringToDateTime(eventDateCtr.date1),
                                invitationData: invitationImage ?? '',
                                invitationExtention: invitationExtension ?? '',
                                multipleDayEvent: eventDateCtr.isMultipleDay,
                                activities: personalEventActivityCtr.selectedActivityModels.isEmpty
                                    ? null
                                    : personalEventActivityCtr.selectedActivityModels,
                                title: eventTitleCtr.title,
                                aboutThePersonalEvent: aboutEvent ?? '',
                                backgroundImageData: bgImage ?? '',
                                backgroundImageExtention: bgExtension ?? '',
                                backgroundMusicData: audio ?? '',
                                backgroundMusicExtention: audioExtension ?? '',
                                selfRegistration: eventVisibilityCtr.selfRegistration,
                                guestVisibility: eventVisibilityCtr.showGuest,
                                contributor: eventVisibilityPost.public
                                    ? 1
                                    : eventVisibilityPost.onlyHost
                                        ? 2
                                        : 3,
                              );
                              log(updatePersonalEventPostModelToJson(model));
                              for (var element in personalEventActivityCtr.selectedActivityModels) {
                                print(
                                    '{{{{{{{{{{{{{{{{{{********************************}}}}}}}}}}}}}}}}}}');
                                print(
                                    'Rituals Length : ${personalEventActivityCtr.selectedActivityModels.length}');
                                print('Ritual Name : ${element.activityName}');
                                print('Ritual Master : ${element.personalEventActivityMasterId}');
                                print('Ritual ID : ${element.personalEventActivityId}');
                                print('********************************');
                              }

                              await ref.read(updatePersonalEventController).updatePersonalEvent(
                                  updatePersonalEventPostModel: model, ref: ref, context: context);
                              personalEventActivityCtr.clearActivities();
                            },
                            title: 'UPDATE',
                            buttonBackground: TAppColors.themeColor,
                            fontSize: MyFonts.size14,
                          );
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            delete(context, widget.homeModel.title ?? '');
                          },
                          child: Text(
                            "DELETE EVENT",
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14, color: TAppColors.buttonRed),
                          )),
                      SizedBox(
                        height: 55.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
