import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_activity_post_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/edit_activities/controllers/update_activity_controller.dart';
import 'package:Happinest/modules/events/edit_activities/widgets/edit_activity_name_widget.dart';
import 'package:Happinest/modules/events/edit_activities/widgets/edit_activity_photos_widget.dart';
import 'package:Happinest/modules/events/edit_ritual/widgets/edit_ritual_visible_to_widget.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../common/common_functions/topPadding.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/event_app_bar.dart';
import '../../edit_ritual/widgets/custom_dialouge_event.dart';
import '../../edit_ritual/widgets/edit_ritual_info_about_widget.dart';
import '../../edit_ritual/widgets/edit_ritual_info_venue_widget.dart';
import '../../edit_ritual/widgets/edit_ritual_schedule_widget.dart';

class EditActivityScreen extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel homePersonalEventDetailsModel;
  final int activityIndex;
  const EditActivityScreen({
    super.key,
    required this.homePersonalEventDetailsModel,
    required this.activityIndex,
  });

  @override
  ConsumerState<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends ConsumerState<EditActivityScreen>{
  PersonalEventActivityList? personalEventActivityModel;
  int index = 0;

  String? activityName;
  DateTime? schedule;
  String? aboutVal;
  String? venueVal;
  int? visibility;

  @override
  void initState() {
    super.initState();
    index = widget.activityIndex;
    personalEventActivityModel = widget.homePersonalEventDetailsModel.personalEventActivityList![index];
    print('Personal event activity Id: ${personalEventActivityModel?.personalEventActivityId}');
    activityName = personalEventActivityModel?.activityName;
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(updateActivityController).getActivityImages(
          personalEventActivityId: personalEventActivityModel?.personalEventActivityId.toString() ?? '20',
          context: context,
          ref: ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: TAppColors.white,
        body: Column(
          children: [
            topPadding(topPadding: 0.h, offset: 30.h),
            EventAppBar(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              title: TNavigationTitleStrings.editActivity,
              hasSubTitle: true,
              subtitle: widget.homePersonalEventDetailsModel.title,
              prefixWidget: IconButton(
                  onPressed: () {
                    showAlertMessage(context);
                  },
                  icon: Image.asset(
                    TImageName.delete,
                    width: 20.w,
                    height: 20.h,
                  )),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                  child: Column(
                    children: [
                      EditActivityNameWidget(
                        eventName: personalEventActivityModel!.activityName ?? '',
                        eventNameFunc: (String eventName) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              activityName = eventName;
                            });
                          });
                        },
                        eventId: personalEventActivityModel!.personalEventActivityId.toString(),
                        styleId: widget
                            .homePersonalEventDetailsModel.personalEventThemeMasterId
                            ?.toString() ??
                            2.toString(),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      ScheduleWidget(
                        isPersonalEvent: true,
                        initialDateAndTime:
                        personalEventActivityModel!.scheduleDate ?? DateTime.now(),
                        selectedDateAndTime: (DateTime time) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              schedule = time;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualInfoAboutWidget(
                        isPersonalEvent: true,
                        eventName: personalEventActivityModel!.activityName ?? 'Sangeet',
                        aboutEvent: personalEventActivityModel!.aboutActivity ?? '',
                        updateAbout: (String about) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              aboutVal = about;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      // Photos Widget
                      EditActivityPhotosWidget(
                        homePersonalEventDetailsModel: widget.homePersonalEventDetailsModel,
                        personalEventActivityModel: personalEventActivityModel!,
                        bgImage: (String imgData) {},
                        bgExt: (String imgExtension) {},
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualInfoVenueWidget(
                        isPersonalEvent: true,
                        venue: personalEventActivityModel!.venueAddress ?? '',
                        venueFunc: (String venue) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              venueVal = venue;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualsVisibleToWidget(
                        isPersonalEvent: true,
                        visibilityIndex: personalEventActivityModel!.visibility ?? 3,
                        visibilityFunc: (int val) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            setState(() {
                              visibility = val;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ritualSkipWidget(),
                      SizedBox(
                        height: 5.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final editActivityCtr =
                          ref.watch(updateActivityController);
                          return TButton(
                              onPressed: () async {
                                UpdateActivityPostModel model =
                                UpdateActivityPostModel(
                                  personalEventActivityId: personalEventActivityModel!.personalEventActivityId,
                                  personalEventHeaderId: widget
                                      .homePersonalEventDetailsModel.personalEventHeaderId,
                                  scheduleDate: schedule,
                                  aboutActivity: aboutVal,
                                  venueAddress: venueVal,
                                  venueLat: '0.0',
                                  venueLong: '0.0',
                                  visibility: visibility ?? widget.homePersonalEventDetailsModel.visibility,
                                  activityName: personalEventActivityModel?.activityName ?? '',
                                  isActive: true,
                                  modifiedOn: DateTime.now(),
                                  personalEventActivityMasterId: null,
                                );

                                print(personalEventActivityModel!.personalEventActivityId);
                                print(
                                  widget
                                      .homePersonalEventDetailsModel.personalEventHeaderId,
                                );
                                print(personalEventActivityModel!.activityName);
                                print(visibility);
                                await editActivityCtr.updateActivity(
                                  personalEventHeaderId: widget.homePersonalEventDetailsModel.personalEventHeaderId.toString(),
                                  updateActivityPostModel: model,
                                  context: context,
                                  ref: ref,
                                );
                              },
                              title: TButtonLabelStrings.saveButton,
                              fontSize: MyFonts.size14,
                              buttonBackground: TAppColors.themeColor);
                        },
                      ),
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

  void showAlertMessage(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (context) => CustomDialogEvent(
          title: "Delete Games",
          actionButtonText: "Delete $activityName"/*TButtonLabelStrings.yesButton*/,
          bodyText: "$activityName Data will be lost once you delete.",
          onActionPressed: () async {
            await ref.read(updateActivityController).deletePersonalEventActivity(
                personalEventActivityId: personalEventActivityModel?.personalEventActivityId ?? 0, ref: ref);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              await ref.read(personalEventHomeController).getEventActivity(
                  eventId: widget.homePersonalEventDetailsModel.personalEventHeaderId.toString(),
                  context: context,
                  ref: ref).then((value) {
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    if(Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },);
            });
          },
        ));
  }

  Row ritualSkipWidget() {
    return Row(
      children: [
        if (index > 0)
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.chevron_left_rounded,
                    color: TAppColors.buttonBlue, size: 20),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.editActivityScreen,
                      arguments: {
                        'homePersonalEventDetailsModel':
                        widget.homePersonalEventDetailsModel,
                        'activityIndex': index - 1,
                      });
                },
                child: Text(
                  widget.homePersonalEventDetailsModel.personalEventActivityList![index - 1]
                      .activityName ??
                      'MEHNDI',
                  style: getRobotoBoldStyle(
                      fontSize: MyFonts.size14, color: TAppColors.buttonBlue),
                ),
              ),
            ],
          ),
        const Spacer(),
        if (index <
            widget.homePersonalEventDetailsModel.personalEventActivityList!.length - 1)
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushReplacementNamed(context, Routes.editActivityScreen,
                      arguments: {
                        'homePersonalEventDetailsModel':
                        widget.homePersonalEventDetailsModel,
                        'activityIndex': index + 1,
                      });
                },
                child: Text(
                  widget.homePersonalEventDetailsModel.personalEventActivityList![index + 1]
                      .activityName ??
                      '',
                  style: getRobotoBoldStyle(
                      fontSize: MyFonts.size14, color: TAppColors.buttonBlue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.chevron_right_rounded,
                    color: TAppColors.buttonBlue, size: 20),
              ),
            ],
          )
      ],
    );
  }
}