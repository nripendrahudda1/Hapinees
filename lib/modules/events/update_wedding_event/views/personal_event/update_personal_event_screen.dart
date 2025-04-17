import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_persoanl_event_theme_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_activities_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_activity_widget.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_chose_personal_event_theme.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/update_event_dates_widget.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/update_event_title_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/update_personal_event_post_model.dart';
import '../../controllers/common_update_event_dates_controller.dart';
import '../../controllers/common_update_event_title_controller.dart';
import '../../controllers/common_update_event_visibility_controller.dart';
import '../../controllers/common_update_event_whocanpost_visibility_controller.dart';
import '../../controllers/personal_event/update_personal_event_controller.dart';
import '../../widgets/more_info_screen_widget/update_info_backeground_image_widget.dart';
import '../../widgets/more_info_screen_widget/update_info_venue_widget.dart';
import '../../widgets/update_occassion_widget.dart';
import '../../widgets/update_visible_to_widget.dart';
import '../../widgets/update_visible_who_can_post_widget.dart';

class UpdatePersonalEventScreen extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel? homeModel;
  const UpdatePersonalEventScreen({
    super.key,
    required this.homeModel,
  });

  @override
  ConsumerState<UpdatePersonalEventScreen> createState() => _UpdatePersonalEventScreenState();
}

class _UpdatePersonalEventScreenState extends ConsumerState<UpdatePersonalEventScreen> {
  String? bgExtension;
  String? bgImage;
  String? venueName;
  double? lat;
  double? lng;
  String? countryCode;
  @override
  void initState() {
    super.initState();
    //initiallize();
  }

  initiallize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(updatePersonalEventThemCtr).fetchPersonalEventThemesModel(
            eventTypeMasterId: widget.homeModel?.eventTypeId ?? 0,
          );
    });
  }

  Future<void> delete(BuildContext context, String? eventName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonDeleteEventDialouge(
            onTap: () async {
              await ref.read(updatePersonalEventActivitiesCtr).deletePersonalEvent(
                  personalEventHeaderId: widget.homeModel?.personalEventHeaderId.toString() ?? '',
                  ref: ref);
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                // Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.homeRoute, (route) => false,
                  arguments: {'index': 2}, // Send index 2 (or any tab index)
                );
              });
            },
            title: 'Personal Event',
            eventName: eventName ?? "");
      },
    );
  }

  Widget buildUpdateInfoSection() {
    final dataStatus = compareDate(widget.homeModel?.startDateTime);
    return Column(
      children: [
        if (dataStatus)
          UpdateInfoBackgroundImageWidget(
            imgUrl: widget.homeModel?.backgroundImageUrl ?? "",
            bgExt: (val) {
              bgExtension = val;
            },
            bgImage: (val) {
              bgImage = val;
            },
          ),
        SizedBox(height: 15.h),
        if (dataStatus)
          UpdateInfoVenueWidget(
            venue: widget.homeModel?.venueAddress ?? '',
            location: widget.homeModel?.venueLat.toString() == 'null'
                ? const LatLng(0.0, 0.0)
                : LatLng(
                    double.parse(widget.homeModel?.venueLat.toString() ?? '0.0'),
                    double.parse(widget.homeModel?.venueLong.toString() ?? '0.0'),
                  ),
            venueText: (val) {
              venueName = val;
              print('PlaceName: $venueName');
            },
            venueLatLng: (val) {
              lat = val.latitude;
              lng = val.longitude;
            },
            countryCode: (val) {
              countryCode = val;
              print('CountryCode: $countryCode');
            },
          ),
        if (dataStatus) SizedBox(height: 20.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataStatus = compareDate(widget.homeModel?.startDateTime);
    return Scaffold(
      backgroundColor: TAppColors.white,
      body: CustomSafeArea(
        child: Column(
          children: [
            // topPadding(topPadding: 0.h, offset: 30.h),
            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
                ref.read(updatePersonalEventActivitiesCtr).clearActivities();
              },
              title: TLabelStrings.updateEvent,
              subtitle: ref.watch(updateEventTitleCtr).title,
              hasSubTitle: true,
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
                      UpdateYourOccassionWidget(
                        isPersonalEvent: true,
                        iconPath: widget.homeModel?.eventIcon,
                        selectedName: widget.homeModel?.eventTypeCode,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      if ((widget.homeModel?.personalEventActivityList?.length ?? 0) > 0) ...[
                        UpdatePersonalEventThemeWidget(
                          homeModel: widget.homeModel,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        const UpdateActivitiesWidget(),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                      UpdateEventTitleWidget(
                        isPersonalEvent: true,
                        eventTitle: widget.homeModel?.title ?? '',
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateEventDatesWidget(
                        isPersonalEvent: true,
                        startDate: widget.homeModel?.startDateTime,
                        endDate: widget.homeModel?.endDateTime,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateVisibleToWidget(
                        guestVisibility: widget.homeModel?.guestVisibility ?? false,
                        visibility: widget.homeModel?.visibility ?? 3,
                        selfRegistration: widget.homeModel?.selfRegistration,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateWhoCanPostVisibleToWidget(
                        contributor: widget.homeModel?.contributor ?? 3,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      buildUpdateInfoSection(),
                      if (dataStatus == false)
                        TButton(
                            onPressed: () {
                              print(
                                  ' eventVisibilityCtr.selfRegistration : ${widget.homeModel?.selfRegistration}');
                              print(
                                  ' eventVisibilityPost -public : ${widget.homeModel?.contributor}');
                              print(' visibility -public : ${widget.homeModel?.visibility}');

                              Navigator.pushNamed(context, Routes.updatePersonalEventMoreInfoScreen,
                                  arguments: {'homeModel': widget.homeModel});
                            },
                            title: TButtonLabelStrings.nextButton,
                            fontSize: MyFonts.size14,
                            buttonBackground: TAppColors.themeColor),
                      SizedBox(
                        height: 5.h,
                      ),
                      if (dataStatus)
                        Consumer(
                          builder: (BuildContext context, WidgetRef ref, Widget? child) {
                            final personalEventThemeCtr = ref.watch(updatePersonalEventThemCtr);
                            final personalEventActivityCtr =
                                ref.watch(updatePersonalEventActivitiesCtr);
                            final eventTitleCtr = ref.watch(updateEventTitleCtr);
                            final eventDateCtr = ref.watch(updateEventDatesCtr);
                            final eventVisibilityCtr = ref.watch(updateEventVisibilityCtr);
                            final eventVisibilityWhoPost = ref.watch(updateWhoPostCtr);
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
                                // print('aboutEvent ******************************** $aboutEvent');
                                UpdatePersonalEventPostModel model = UpdatePersonalEventPostModel(
                                  countryCode: countryCode ?? '',
                                  personalEventThemeMasterId: personalEventThemeCtr
                                                  .personaLEventThemeMasterId !=
                                              null &&
                                          personalEventThemeCtr.personaLEventThemeMasterId != ''
                                      ? int.parse(personalEventThemeCtr.personaLEventThemeMasterId!)
                                      : null,
                                  personalEventHeaderId: widget.homeModel?.personalEventHeaderId,
                                  modifiedOn: DateTime.now(),
                                  isActive: true,
                                  visibility: eventVisibilityCtr.public
                                      ? 1
                                      : eventVisibilityCtr.private
                                          ? 2
                                          : 3,
                                  venueLat: lat != null
                                      ? lat.toString()
                                      : widget.homeModel?.venueLat ?? '',
                                  venueLong: lng != null
                                      ? lng.toString()
                                      : widget.homeModel?.venueLong ?? '',
                                  venueAddress: venueName ?? widget.homeModel?.venueAddress,
                                  personalEventThemeName: personalEventThemeCtr.selectedThemes,
                                  endDateTime: eventDateCtr.date2 != "End Date"
                                      ? convertStringToDateTime(eventDateCtr.date2)
                                      : convertStringToDateTime(eventDateCtr.date1),
                                  startDateTime: convertStringToDateTime(eventDateCtr.date1),
                                  invitationData: '',
                                  invitationExtention: '',
                                  multipleDayEvent: eventDateCtr.isMultipleDay,
                                  activities:
                                      personalEventActivityCtr.selectedActivityModels.isEmpty
                                          ? null
                                          : personalEventActivityCtr.selectedActivityModels,
                                  title: eventTitleCtr.title,
                                  aboutThePersonalEvent: '',
                                  backgroundImageData: bgImage ?? '',
                                  backgroundImageExtention: bgExtension ?? '',
                                  backgroundMusicData: '',
                                  backgroundMusicExtention: '',
                                  guestVisibility: eventVisibilityCtr.showGuest,
                                  selfRegistration: eventVisibilityCtr.selfRegistration,
                                  contributor: eventVisibilityWhoPost.public
                                      ? 1
                                      : eventVisibilityWhoPost.onlyHost
                                          ? 2
                                          : 3,
                                );

                                print(
                                    ' eventVisibilityCtr.selfRegistration : ${eventVisibilityCtr.selfRegistration}');
                                print(
                                    ' eventVisibilityPost -public : ${eventVisibilityWhoPost.public}');
                                print(
                                    ' eventVisibilityPost -onlyHost : ${eventVisibilityWhoPost.onlyHost}');
                                print(
                                    ' eventVisibilityPost -guest : ${eventVisibilityWhoPost.guest}');
                                print(' contributor  : ${model.contributor}');
                                print(' guestVisibility  : ${model.guestVisibility}');
                                for (var element
                                    in personalEventActivityCtr.selectedActivityModels) {
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
                                    updatePersonalEventPostModel: model,
                                    ref: ref,
                                    context: context);
                                personalEventActivityCtr.clearActivities();
                              },
                              title: TButtonLabelStrings.updateButton,
                              buttonBackground: TAppColors.themeColor,
                              fontSize: MyFonts.size14,
                            );
                          },
                        ),
                      TextButton(
                          onPressed: () {
                            delete(context, widget.homeModel?.title ?? '');
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
