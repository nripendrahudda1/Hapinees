import 'package:Happinest/modules/events/create_event/widgets/removable_ritual.dart';
import 'package:Happinest/modules/events/create_event/widgets/styles_shimmer.dart';
import 'package:Happinest/modules/events/create_event/widgets/personal_event/write_activity_widget.dart';
import 'package:Happinest/theme/theme_manager.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import '../../controllers/create_event_expanded_controller.dart';
import '../../controllers/personal_event_controller/baby_shower_visibility_controller.dart';
import '../../controllers/personal_event_controller/personal_event_activity_controller.dart';
import 'activity_tile.dart';

class PersonnalActivityWidget extends ConsumerStatefulWidget {
  const PersonnalActivityWidget({super.key});

  @override
  ConsumerState<PersonnalActivityWidget> createState() => _PersonalActivityWidgetState();
}

class _PersonalActivityWidgetState extends ConsumerState<PersonnalActivityWidget> {
  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).activityExpanded) {
      ref.watch(createEventExpandedCtr).setActivityUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setActivityExpanded();
    }
  }

  String getFormattedActivityString(String activityList) {
    List<String> activities = activityList.split(',').map((e) => e.trim()).toList();

    if (activities.isEmpty) {
      return "";
    }

    String result = '';
    int remainingActivities = activities.length;

    for (int i = 0; i < activities.length; i++) {
      if ((result + activities[i]).length <= 35) {
        if (remainingActivities == 1) {
          result += activities[i];
        } else {
          result += '${activities[i]}, ';
        }
        remainingActivities--;
      } else {
        break;
      }
    }

    if (remainingActivities > 0) {
      result = result.substring(0, result.length - 2); // Remove the trailing comma and space
      result += ' + $remainingActivities';
    }

    return result;
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
                ref.watch(createEventExpandedCtr).activityExpanded
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
                  title: ref.watch(createEventExpandedCtr).activityExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Activities",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(personalEventActivityCtr).selectedActivity.isNotEmpty ||
                              ref.read(personalEventActivityCtr).writeByHandActivity.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Activities",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  getFormattedActivityString(
                                      ref.read(personalEventActivityCtr).concatenateList(
                                            ref.read(personalEventActivityCtr).selectedActivity +
                                                ref
                                                    .read(personalEventActivityCtr)
                                                    .writeByHandActivity,
                                          )),
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Text(
                              "Activities",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).activityExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final activityCrt = ref.watch(personalEventActivityCtr);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            activityCrt.isLoading
                                ? const StylesShimmer()
                                : activityCrt.eventActivitiesModel == null ||
                                        activityCrt.eventActivitiesModel
                                                ?.personalEventActivityMasterList ==
                                            null ||
                                        activityCrt.eventActivitiesModel
                                                ?.personalEventActivityMasterList?.length ==
                                            0
                                    ? const Text('No Activities found!')
                                    : GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2.5,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0.w),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: activityCrt.eventActivitiesModel
                                            ?.personalEventActivityMasterList?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          String interest = activityCrt.eventActivity[index];
                                          PersonalEventActivityMasterList ritual = activityCrt
                                              .eventActivitiesModel!
                                              .personalEventActivityMasterList![index];
                                          return ActivityTile(
                                            onTap: () {
                                              ref
                                                  .read(personalEventVisibilityCtr.notifier)
                                                  .setActivitySelected();
                                              activityCrt.addSelectedActivity(
                                                interest,
                                              );
                                            },
                                            interestName: ritual.activityName ?? '',
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
                                  itemCount: activityCrt.writeByHandActivity.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String interest = activityCrt.writeByHandActivity[index];
                                    return RemoveableRitualTile(
                                      onTap: () {
                                        activityCrt.removeWriteByHandActivity(interest);
                                      },
                                      interestName: interest,
                                    );
                                  },
                                ),
                                WriteActivityWidget(getCall: () {})
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
