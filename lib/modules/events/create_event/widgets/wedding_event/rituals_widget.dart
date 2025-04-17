import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import 'package:Happinest/modules/events/create_event/widgets/removable_ritual.dart';
import 'package:Happinest/modules/events/create_event/widgets/wedding_event/rituals_tile.dart';
import 'package:Happinest/modules/events/create_event/widgets/styles_shimmer.dart';
import 'package:Happinest/modules/events/create_event/widgets/wedding_event/write_rituals_widget.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../controllers/create_event_expanded_controller.dart';
import '../../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';

class RitualsWidget extends ConsumerStatefulWidget {
  const RitualsWidget({
    super.key,
  });

  @override
  ConsumerState<RitualsWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<RitualsWidget> {
  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).ritualsExpanded) {
      ref.watch(createEventExpandedCtr).setRitualsUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setRitualsExpanded();
    }
  }

  String getFormattedRitualString(String ritualList) {
    List<String> rituals = ritualList.split(',').map((e) => e.trim()).toList();

    if (rituals.isEmpty) {
      return "";
    }

    String result = '';
    int remainingRituals = rituals.length;

    for (int i = 0; i < rituals.length; i++) {
      if ((result + rituals[i]).length <= 35) {
        if (remainingRituals == 1) {
          result += rituals[i];
        } else {
          result += '${rituals[i]}, ';
        }
        remainingRituals--;
      } else {
        break;
      }
    }

    if (remainingRituals > 0) {
      result = result.substring(0, result.length - 2); // Remove the trailing comma and space
      result += ' + $remainingRituals';
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
                ref.watch(createEventExpandedCtr).ritualsExpanded
                    ? BoxShadow(
                        color: customColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : BoxShadow(
                        color: customColors.text1Color.withOpacity(0.25),
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
                  title: ref.watch(createEventExpandedCtr).ritualsExpanded
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
                      : ref.read(weddingActivityCtr).selectedRituals.isNotEmpty ||
                              ref.read(weddingActivityCtr).writeByHandRitualss.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Rituals",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  getFormattedRitualString(
                                      ref.read(weddingActivityCtr).concatenateList(
                                            ref.read(weddingActivityCtr).selectedRituals +
                                                ref.read(weddingActivityCtr).writeByHandRitualss,
                                          )),
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Text(
                              "Rituals",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).ritualsExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final ritualsCtr = ref.watch(weddingActivityCtr);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            ritualsCtr.isLoading
                                ? const StylesShimmer()
                                : ritualsCtr.weddingRitualsModel == null ||
                                        ritualsCtr.weddingRitualsModel?.weddingRitualMasterList ==
                                            null ||
                                        ritualsCtr.weddingRitualsModel?.weddingRitualMasterList
                                                ?.length ==
                                            0
                                    ? const Text('No styles found!')
                                    : GridView.builder(
                                        padding: EdgeInsets.zero,
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 2.5,
                                            crossAxisSpacing: 0,
                                            mainAxisSpacing: 0.w),
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: ritualsCtr
                                            .weddingRitualsModel?.weddingRitualMasterList?.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          String interest = ritualsCtr.weddingRitualss[index];
                                          WeddingRitualMasterList ritual = ritualsCtr
                                              .weddingRitualsModel!.weddingRitualMasterList![index];
                                          return RitualsTile(
                                            onTap: () {
                                              ref
                                                  .read(weddingCreateEventVisibilityCtr.notifier)
                                                  .setRitualsSelected();
                                              ritualsCtr.addSelectedRituals(interest);
                                            },
                                            interestName: ritual.ritualName ?? '',
                                          );
                                        },
                                        // child: Align(
                                        //   alignment: Alignment.topLeft,
                                        //   child: Wrap(
                                        //     alignment: WrapAlignment.start,
                                        //     children: List.generate(
                                        //       ritualsCtr.weddingRitualss.length,
                                        //           (index){
                                        //
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
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
                                  itemCount: ritualsCtr.writeByHandRitualss.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String interest = ritualsCtr.writeByHandRitualss[index];
                                    return RemoveableRitualTile(
                                      onTap: () {
                                        ritualsCtr.removeWriteByHandRituals(interest);
                                      },
                                      interestName: interest,
                                    );
                                  },
                                ),
                                WriteRitualsWidget(getCall: () {})
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
