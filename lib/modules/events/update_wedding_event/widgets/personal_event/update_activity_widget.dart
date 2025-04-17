import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_activities_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_activity_tile.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_write_activity_widget.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../create_event/widgets/removable_ritual.dart';
import '../../../create_event/widgets/styles_shimmer.dart';
import '../../controllers/wedding_event/update_wedding_event_expanded_controller.dart';

class UpdateActivitiesWidget extends ConsumerStatefulWidget {
  const UpdateActivitiesWidget({
    super.key,
  });

  @override
  ConsumerState<UpdateActivitiesWidget> createState() => _UpdateActivitiesWidgetState();
}

class _UpdateActivitiesWidgetState extends ConsumerState<UpdateActivitiesWidget> {
  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).activityExpanded) {
      ref.watch(updateEventExpandedCtr).setActivityUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setActivityExpanded();
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(updateEventExpandedCtr).setActivityUnExpanded();
    });
  }

  bool isSelectedActivity = false;

  String getFormattedActivityString(String activityList) {
    List<String> activity = activityList.split(',').map((e) => e.trim()).toList();

    if (activity.isEmpty) {
      return "";
    }

    String result = '';
    int remainingActivity = activity.length;

    for (int i = 0; i < activity.length; i++) {
      if ((result + activity[i]).length <= 35) {
        if (remainingActivity == 1) {
          result += activity[i];
        } else {
          result += '${activity[i]}, ';
        }
        remainingActivity--;
      } else {
        break;
      }
    }

    if (remainingActivity > 0) {
      result = result.substring(0, result.length - 2); // Remove the trailing comma and space
      result += ' + $remainingActivity';
    }
    isSelectedActivity = true;
    return result;
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
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventExpandedCtr).activityExpanded
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
                  title: ref.watch(updateEventExpandedCtr).activityExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Activities",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.watch(updatePersonalEventActivitiesCtr).selectedActivities.isNotEmpty ||
                              ref
                                  .watch(updatePersonalEventActivitiesCtr)
                                  .writeByHandActivities
                                  .isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Activity",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  getFormattedActivityString(
                                      ref.read(updatePersonalEventActivitiesCtr).concatenateList(
                                            ref
                                                    .read(updatePersonalEventActivitiesCtr)
                                                    .selectedActivities +
                                                ref
                                                    .read(updatePersonalEventActivitiesCtr)
                                                    .writeByHandActivities,
                                          )),
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Activities",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).activityExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final personalEventCtr = ref.watch(personalEventHomeController);
                      final activitiesCtr = ref.watch(updatePersonalEventActivitiesCtr);
                      final activitiesIDCtr = personalEventCtr;
                      // for (var element in (activitiesCtr
                      //         .personalEventActivityMaster?.personalEventActivityMasterList ??
                      //     [])) {
                      //   log("wedding master id list == ${element.personalEventThemeMasterId}");
                      // }
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                        child: activitiesCtr.isLoading
                            ? const StylesShimmer()
                            : activitiesCtr.selectedActivities.isEmpty == null ||
                                    activitiesCtr.personalEventActivityMaster
                                            ?.personalEventActivityMasterList ==
                                        null
                                ? const Text('No Activities found!')
                                : Column(
                                    children: [
                                      GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2.5,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0.w),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: activitiesCtr.personalEventActivityMaster
                                            ?.personalEventActivityMasterList?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          // log("list == ${ritualsCtr.weddingRitualsModel!.weddingRitualList ?? []}");
                                          String interest = activitiesCtr
                                                  .personalEventActivityMaster!
                                                  .personalEventActivityMasterList![index]
                                                  .activityName ??
                                              '';
                                          List<PersonalEventActivityList>? templist =
                                              activitiesIDCtr.homePersonalEventDetailsModel!
                                                  .personalEventActivityList;
                                          // String interest = ritualsCtr.weddingRitualss[index];
                                          // WeddingRitualList ritual = WeddingRitualList.fromJson(ritualsCtr.weddingRitualsModel!.weddingRitualList![index].toJson());
                                          PersonalEventActivityMasterList activity = activitiesCtr
                                              .personalEventActivityMaster!
                                              .personalEventActivityMasterList![index];
                                          // WeddingRitualList ritualID = (ritualsCtr.homeWeddingDetailsModel!).weddingRitualList![index];
                                          // return UpdateRitualsTile(
                                          //   onTap: () {
                                          //     ref.read(weddingCreateEventVisibilityCtr.notifier).setRitualsSelected();
                                          //     ritualsCtr.addSelectedRituals(interest);
                                          //   },
                                          //   interestName: ritual.ritualName?? '',
                                          // );
                                          return UpdateActivitiesTile(
                                            onTap: () {
                                              // bool found = false;
                                              // for (int i = 0; i < (ritualsCtr.weddingRitualsModel?.weddingRitualList??[]).length; i++) {
                                              //   if ((ritualsCtr.weddingRitualsModel!.weddingRitualList![i].ritualName ?? "") == (ritual.ritualName ?? "")) {
                                              //     found = true;
                                              //     ritualsCtr.addSelectedRituals(interest);
                                              //     ritualsCtr.addSelectedRitualIds(id: ritualsCtr.weddingRitualsModel!.weddingRitualList![i].weddingRitualId.toString() ?? '', ritualName: interest);
                                              //     print('Ritual ID: ${ritualsCtr.weddingRitualsModel!.weddingRitualList![i].weddingRitualId.toString()}');
                                              //     print('Ritual Name: $interest');
                                              //     break;
                                              //   }
                                              // }
                                              // if (!found) {
                                              //   ritualsCtr.addSelectedRituals(interest);
                                              //   ritualsCtr.addSelectedRitualMasterIds(
                                              //       id: ritual.weddingRitualMasterId.toString() ?? '', ritualName: interest);
                                              //   print('Ritual Not Found: $interest');
                                              //   print('Selected Rituals Length: ${ritualsCtr.selectedRituals.length}');
                                              // }
                                              // print('Selected Rituals Length: ${ ritualsCtr.selectedRituals.length}');
                                              // print('Selected Ritual Master Ids Length: ${ ritualsCtr.selectedRitualMasterIds.length}');
                                              // print('Selected Ritual Ids Length: ${ ritualsCtr.selectedRitualIds.length}');
                                              // print('Selected Ritual models Length: ${ ritualsCtr.selectedRitualModels.length}');
                                              bool found = false;
                                              // log((ritualsCtr.weddingRitualsModel?.weddingRitualMasterList).toString());
                                              for (int i = 0;
                                                  i <
                                                      (activitiesCtr.personalEventActivityModel
                                                                  ?.personalEventActivityMasterList ??
                                                              [])
                                                          .length;
                                                  i++) {
                                                if ((activitiesCtr
                                                            .personalEventActivityModel!
                                                            .personalEventActivityMasterList![i]
                                                            .activityName ??
                                                        "") ==
                                                    (activity.activityName ?? "")) {
                                                  log("found condition == $found");
                                                  found = true;
                                                  activitiesCtr.addSelectedActivity(interest);
                                                  activitiesCtr.addSelectedActivityIds(
                                                      id: activitiesCtr
                                                              .personalEventActivityModel!
                                                              .personalEventActivityMasterList![i]
                                                              .personalEventActivityMasterId
                                                              .toString() ??
                                                          '',
                                                      activityName: interest);
                                                  print(
                                                      'Ritual ID: ${activitiesCtr.personalEventActivityModel!.personalEventActivityMasterList![i].personalEventActivityMasterId.toString()}');
                                                  print('Ritual Name: $interest');
                                                  break;
                                                }
                                              }
                                              if (!found) {
                                                log("!found condition == $found");
                                                templist?.forEach((element) {
                                                  log("selected ritual id : ${element.personalEventActivityId} ");
                                                });
                                                activitiesCtr.addSelectedActivity(interest);
                                                activitiesCtr.addSelectedActivityMasterIds(
                                                  activityMasterId: activity
                                                      .personalEventActivityMasterId
                                                      .toString(),
                                                  activityName: interest,
                                                  // weddingRitualId: ritual.we
                                                );
                                                // ritualsCtr.addSelectedRitualIds(
                                                //     id: ritual.weddingRitualMasterId.toString() , ritualName: interest);

                                                templist?.forEach((element) {
                                                  log("selected ritual id : ${element.personalEventActivityId} ");
                                                });
                                                print('Ritual Not Found: $interest');
                                                print(
                                                    'Selected Rituals Length: ${activitiesCtr.selectedActivities.length}');
                                              }
                                              print(
                                                  'Selected Rituals Length: ${activitiesCtr.selectedActivities.length}');
                                              print(
                                                  'Selected Ritual Master Ids Length: ${activitiesCtr.selectedActivityMasterIds.length}');
                                              print(
                                                  'Selected Ritual Ids Length: ${activitiesCtr.selectedActivityIds.length}');
                                              print(
                                                  'Selected Ritual models Length: ${activitiesCtr.selectedActivityModels.length}');
                                            },
                                            interestName: interest,
                                          );
                                        },
                                      ),
                                      Column(
                                        children: [
                                          GridView.builder(
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 2.5,
                                                crossAxisSpacing: 0,
                                                mainAxisSpacing: 0.w),
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: activitiesCtr.writeByHandActivities.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              String interest =
                                                  activitiesCtr.writeByHandActivities[index];
                                              return RemoveableRitualTile(
                                                onTap: () {
                                                  activitiesCtr
                                                      .removeWriteByHandActivities(interest);
                                                },
                                                interestName: interest,
                                              );
                                            },
                                          ),
                                          UpdateWriteActivityWidget(getCall: () {})
                                        ],
                                      ),
                                    ],
                                  ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
