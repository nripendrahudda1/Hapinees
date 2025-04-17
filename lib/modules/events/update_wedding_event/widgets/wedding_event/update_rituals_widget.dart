import 'dart:developer';

import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../../create_event/widgets/removable_ritual.dart';
import '../../../create_event/widgets/styles_shimmer.dart';
import '../../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../../controllers/wedding_event/update_wedding_rituals_controller.dart';
import 'update_rituals_tile.dart';
import '../update_write_rituals_widget.dart';
import '../../../../../common/common_imports/common_imports.dart';

class UpdateRitualsWidget extends ConsumerStatefulWidget {
  const UpdateRitualsWidget({
    super.key,
  });

  @override
  ConsumerState<UpdateRitualsWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<UpdateRitualsWidget> {
  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).ritualsExpanded) {
      ref.watch(updateEventExpandedCtr).setRitualsUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setRitualsExpanded();
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(updateEventExpandedCtr).setRitualsUnExpanded();
    });
  }
  bool isselectedrituals = false;

  String getFormattedRitualString(String ritualList) {
    List<String> rituals = ritualList.split(',').map((e) => e.trim()).toList();

    if (rituals.isEmpty) {
      return "";
    }

    String result = '';
    int remainingRituals = rituals.length;

    for (int i = 0; i < rituals.length; i++) {
      if ((result + rituals[i]).length <= 35) {
        if(remainingRituals == 1) {
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
    isselectedrituals = true;
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
              border:
                  Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventExpandedCtr).ritualsExpanded
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
                  title: ref.watch(updateEventExpandedCtr).ritualsExpanded
                      ? 
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Rituals",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.watch(updateWeddingRitualsCtr)
                                      .selectedRituals.isNotEmpty ||
                              ref
                                      .watch(updateWeddingRitualsCtr)
                                      .writeByHandRitualss.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Ritual",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  getFormattedRitualString(ref
                                      .read(updateWeddingRitualsCtr)
                                      .concatenateList(
                                        ref
                                                .read(updateWeddingRitualsCtr)
                                                .selectedRituals +
                                            ref
                                                .read(updateWeddingRitualsCtr)
                                                .writeByHandRitualss,
                                      )),
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Rituals",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).ritualsExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final weddingCtr =
                          ref.watch(weddingEventHomeController);
                      final ritualsCtr = ref.watch(updateWeddingRitualsCtr);
                      final ritualIDctr = weddingCtr;
                      for (var element in (ritualsCtr.weddingRitualsModel?.weddingRitualMasterList ?? [])) {
                       log("wedding master id list == ${element.weddingStyleMasterId}");
                       }
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 10.h, right: 10.w, left: 10.w),
                        child:  ritualsCtr.isLoading ?
                        const StylesShimmer():
                        ritualsCtr.weddingRitualsMaster == null ||
                            ritualsCtr.weddingRitualsMaster?.weddingRitualMasterList == null ||
                            ritualsCtr.weddingRitualsMaster?.weddingRitualMasterList?.length == 0 ?
                        const Text('No Rituals found!'):
                        Column(
                          children: [
                            GridView.builder(
                              padding:EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0.w),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: ritualsCtr.weddingRitualsMaster?.weddingRitualMasterList?.length,
                              itemBuilder: (BuildContext context, int index) {
                                // log("list == ${ritualsCtr.weddingRitualsModel!.weddingRitualList ?? []}");
                                String interest = ritualsCtr.weddingRitualsMaster!.weddingRitualMasterList![index].ritualName ?? '';
                                List<WeddingRitualList>? templist = ritualIDctr.homeWeddingDetails!.weddingRitualList;
                                // String interest = ritualsCtr.weddingRitualss[index];
                                // WeddingRitualList ritual = WeddingRitualList.fromJson(ritualsCtr.weddingRitualsModel!.weddingRitualList![index].toJson());
                                WeddingRitualMasterList ritual = ritualsCtr.weddingRitualsMaster!.weddingRitualMasterList![index];
                                // WeddingRitualList ritualID = (ritualsCtr.homeWeddingDetailsModel!).weddingRitualList![index];
                                // return UpdateRitualsTile(
                                //   onTap: () {
                                //     ref.read(weddingCreateEventVisibilityCtr.notifier).setRitualsSelected();
                                //     ritualsCtr.addSelectedRituals(interest);
                                //   },
                                //   interestName: ritual.ritualName?? '',
                                // );
                                return UpdateRitualsTile(
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
                                    for (int i = 0; i < (ritualsCtr.weddingRitualsModel?.weddingRitualMasterList??[]).length; i++) {
                                      if ((ritualsCtr.weddingRitualsModel!.weddingRitualMasterList![i].ritualName ?? "") == (ritual.ritualName ?? "")) {
                                        log("found condition == $found");
                                        found = true;
                                        ritualsCtr.addSelectedRituals(interest);
                                        ritualsCtr.addSelectedRitualIds(id: ritualsCtr.weddingRitualsModel!.weddingRitualMasterList![i].weddingRitualMasterId.toString() ?? '', ritualName: interest);
                                        print('Ritual ID: ${ritualsCtr.weddingRitualsModel!.weddingRitualMasterList![i].weddingRitualMasterId.toString()}');
                                        print('Ritual Name: $interest');
                                        break;
                                      }
                                    }
                                    if (!found) {
                                      log("!found condition == $found");
                                      templist?.forEach((element) {
                                      log("selected ritual id : ${element.weddingRitualId} ");
                                      });
                                      ritualsCtr.addSelectedRituals(interest);
                                      ritualsCtr.addSelectedRitualMasterIds(ritualMasterid: ritual.weddingRitualMasterId.toString(), ritualName: interest , 
                                      // weddingRitualId: ritual.we
                                      );
                                      // ritualsCtr.addSelectedRitualIds(
                                      //     id: ritual.weddingRitualMasterId.toString() , ritualName: interest);
                                      
                                      templist?.forEach((element) {
                                      log("selected ritual id : ${element.weddingRitualId} ");
                                      });
                                      print('Ritual Not Found: $interest');
                                      print('Selected Rituals Length: ${ritualsCtr.selectedRituals.length}');
                                    }
                                    print('Selected Rituals Length: ${ ritualsCtr.selectedRituals.length}');
                                    print('Selected Ritual Master Ids Length: ${ ritualsCtr.selectedRitualMasterIds.length}');
                                    print('Selected Ritual Ids Length: ${ ritualsCtr.selectedRitualIds.length}');
                                    print('Selected Ritual models Length: ${ ritualsCtr.selectedRitualModels.length}');
                                  },
                                  interestName: interest,
                                  
                                );
                              },
                            ),
                            Column(
                              children: [
                                GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 2.5,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0.w),
                                  shrinkWrap: true,
                                  padding:EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      ritualsCtr.writeByHandRitualss.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    String interest =
                                        ritualsCtr.writeByHandRitualss[index];
                                    return RemoveableRitualTile(
                                      onTap: () {
                                        ritualsCtr
                                            .removeWriteByHandRituals(interest);
                                      },
                                      interestName: interest,
                                    );
                                  },
                                ),
                                UpdateWriteRitualsWidget(getCall: () {})
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