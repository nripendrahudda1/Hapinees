import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_styles_model.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../create_event/widgets/removeable_style_tile.dart';
import '../../../create_event/widgets/styles_shimmer.dart';
import '../../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../../controllers/wedding_event/update_wedding_rituals_controller.dart';
import 'update_wedding_style_tile.dart';
import 'update_write_style_widget.dart';
import '../../controllers/wedding_event/update_wedding_style_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';

class UpdateWeddingStyleWidget extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel? homeModel;
  const UpdateWeddingStyleWidget({
    required this.homeModel,
    super.key,
  });

  @override
  ConsumerState<UpdateWeddingStyleWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<UpdateWeddingStyleWidget> {
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() {
    final manageStylesCtr = ref.read(updateWeddingStylesCtr);
    final manageRitualsCtr = ref.read(updateWeddingRitualsCtr);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(updateEventExpandedCtr).setWeddingStyleUnExpanded();
      manageStylesCtr.addFirstSelectedStyle(manageStylesCtr.selectedStyles != ''
          ? manageStylesCtr.selectedStyles
          : widget.homeModel?.weddigStyleName ?? '');
      await manageRitualsCtr.fetchWeddingRitualsMaster(
        ref: ref,
        context: context,
        weddingStyleMasterId: widget.homeModel?.weddingStyleMasterId.toString(),
      );

      await manageRitualsCtr.fetchWeddingRitualsModel(
        ref: ref,
        context: context,
        weddingHeaderId: widget.homeModel?.weddingHeaderId.toString(),
      );
      initialRituals(model: widget.homeModel);
    });
  }

  initialRituals({required HomeWeddingDetailsModel? model}) {
    final manageRitualsCtr = ref.read(updateWeddingRitualsCtr);
    List<String> rituals = [];
    List<String> ritualIds = [];
    model?.weddingRitualList?.forEach((element) {
      log("wedding rituals id name and ids == weddingRitualId : ${element.weddingRitualId} & weddingRitualMasterId : ${element.weddingRitualMasterId} & weddingRitualname : ${element.ritualName}");
      rituals.add(element.ritualName ?? '');
      ritualIds.add(element.weddingRitualId.toString());
      print('Ritual ID: ${element.weddingRitualId.toString()}');
    });
    manageRitualsCtr.setInitialRitualss(rituals, ritualIds);
    // manageRitualsCtr.setInitialRitualIds(ritualIds);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).weddingStyleExpanded) {
      ref.watch(updateEventExpandedCtr).setWeddingStyleUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setWeddingStyleExpanded();
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
                ref.watch(updateEventExpandedCtr).weddingStyleExpanded
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
                  title: ref.watch(updateEventExpandedCtr).weddingStyleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Wedding Style",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 5.h,
                            )
                          ],
                        )
                      : ref.read(updateWeddingStylesCtr).selectedStyles != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Style",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref
                                      .read(updateWeddingStylesCtr)
                                      .selectedStyles,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : ref
                                      .read(updateWeddingStylesCtr)
                                      .writeByHandStyles !=
                                  ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Style",
                                      style: getRegularStyle(
                                          fontSize: MyFonts.size14,
                                          color: TAppColors.selectionColor),
                                    ),
                                    Text(
                                      ref
                                          .read(updateWeddingStylesCtr)
                                          .writeByHandStyles,
                                      style: getBoldStyle(
                                        fontSize: MyFonts.size14,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Wedding Style",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.text2Color),
                                ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).weddingStyleExpanded)
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: 10.h, right: 10.w, left: 10.w),
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final manageStylesCtr =
                              ref.watch(updateWeddingStylesCtr);
                          return manageStylesCtr.isLoading
                              ? const StylesShimmer()
                              : manageStylesCtr.weddingStylesModel == null ||
                                      manageStylesCtr.weddingStylesModel
                                              ?.weddingStyleMasterList ==
                                          null ||
                                      manageStylesCtr
                                              .weddingStylesModel
                                              ?.weddingStyleMasterList
                                              ?.length ==
                                          0
                                  ? const Text('No styles found!')
                                  : Column(
                                      children: [
                                        GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 4,
                                                  crossAxisSpacing: 0,
                                                  mainAxisSpacing: 0.w),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: manageStylesCtr
                                              .weddingStylesModel
                                              ?.weddingStyleMasterList
                                              ?.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String interest = manageStylesCtr
                                                .weddingStyles[index];
                                            WeddingStyleMasterList
                                                selectedWeddingStyle =
                                                manageStylesCtr
                                                        .weddingStylesModel!
                                                        .weddingStyleMasterList![
                                                    index];

                                            return UpdateWeddingStyleTile(
                                              onTap: () {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback(
                                                        (timeStamp) async {
                                                  manageStylesCtr.addSelectedStyle(
                                                      selectedWeddingStyle
                                                              .weddingStyleName ??
                                                          '');
                                                  manageStylesCtr
                                                      .removeWriteByHandStyle();
                                                  manageStylesCtr
                                                      .setWeddingStyleMasterId(
                                                          selectedWeddingStyle
                                                              .weddingStyleMasterId
                                                              ?.toString());
                                                  _toggleExpansion();
                                                  await ref
                                                      .read(
                                                          updateWeddingRitualsCtr)
                                                      .fetchWeddingRitualsMaster(
                                                          ref: ref,
                                                          context: context,
                                                          weddingStyleMasterId:
                                                              selectedWeddingStyle
                                                                      .weddingStyleMasterId
                                                                      ?.toString() ??
                                                                  ''
                                                          // weddingHeaderId: widget.homeModel.weddingStyleMasterId?.toString() ?? ''
                                                          );
                                                });
                                                // initialRituals(model: widget.homeModel);
                                              },
                                              interestName: selectedWeddingStyle
                                                      .weddingStyleName ??
                                                  '',
                                            );
                                          },
                                        ),
                                        // Align(
                                        //   alignment: Alignment.topLeft,
                                        //   child: Wrap(
                                        //     alignment: WrapAlignment.start,
                                        //     children: List.generate(
                                        //       manageStylesCtr.weddingStyles.length,
                                        //           (index){
                                        //         String interest = manageStylesCtr.weddingStyles[index];
                                        //         return UpdateWeddingStyleTile(
                                        //           onTap: (){
                                        //             manageStylesCtr.addSelectedStyle(interest);
                                        //             manageStylesCtr.removeWriteByHandStyle();
                                        //            _toggleExpansion();
                                        //           },
                                        //           interestName: interest,
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        manageStylesCtr.writeByHandStyles == ""
                                            ? UpdateWriteStyleWidget(
                                                getCall: () {
                                                  _toggleExpansion();
                                                },
                                              )
                                            : GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 4,
                                                        crossAxisSpacing: 0,
                                                        mainAxisSpacing: 0.w),
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: 1,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return RemoveableInterestTile(
                                                    onTap: () {
                                                      manageStylesCtr
                                                          .removeWriteByHandStyle();
                                                    },
                                                    interestName:
                                                        manageStylesCtr
                                                            .writeByHandStyles,
                                                  );
                                                },
                                              )
                                        // Align(
                                        //   alignment: Alignment.topLeft,
                                        //   child: RemoveableInterestTile(
                                        //     onTap: (){
                                        //       manageStylesCtr.removeWriteByHandStyle();
                                        //     },
                                        //     interestName: manageStylesCtr.writeByHandStyles,
                                        //   ),
                                        // ),
                                      ],
                                    );
                        },
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
