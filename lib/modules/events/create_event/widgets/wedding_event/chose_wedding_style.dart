import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/widgets/styles_shimmer.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_styles_model.dart';
import '../../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import '../removeable_style_tile.dart';
import 'wedding_style_tile.dart';
import 'write_style_widget.dart';
import '../../controllers/create_event_expanded_controller.dart';
import '../../controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../controllers/wedding_controllers/wedding_style_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';

class ChoseWeddingStyleWidget extends ConsumerStatefulWidget {
  const ChoseWeddingStyleWidget({
    super.key,
  });

  @override
  ConsumerState<ChoseWeddingStyleWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<ChoseWeddingStyleWidget> {
  String iconPath = TImageName.weddingIcon;

  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).weddingStyleExpanded) {
      ref.watch(createEventExpandedCtr).setWeddingStyleUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setWeddingStyleExpanded();
    }
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
                ref.watch(createEventExpandedCtr).weddingStyleExpanded
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
                  title: ref.watch(createEventExpandedCtr).weddingStyleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select Wedding Style",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5.h,
                            )
                          ],
                        )
                      : ref.read(weddingStylesCtr).selectedStyles != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Style",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(weddingStylesCtr).selectedStyles,
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : ref.read(weddingStylesCtr).writeByHandStyles != ""
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
                                      ref.read(weddingStylesCtr).writeByHandStyles,
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size14, color: customColors.label),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Select Wedding Style",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: customColors.text2Color),
                                ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).weddingStyleExpanded)
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final manageStylesCtr = ref.watch(weddingStylesCtr);
                          return Column(
                            children: [
                              manageStylesCtr.isLoading
                                  ? const StylesShimmer()
                                  : manageStylesCtr.weddingStylesModel == null ||
                                          manageStylesCtr
                                                  .weddingStylesModel?.weddingStyleMasterList ==
                                              null ||
                                          manageStylesCtr.weddingStylesModel?.weddingStyleMasterList
                                                  ?.length ==
                                              0
                                      ? const Text('No styles found!')
                                      : GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 4,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0.w),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: manageStylesCtr
                                              .weddingStylesModel?.weddingStyleMasterList?.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            String interest = manageStylesCtr.weddingStyles[index];
                                            WeddingStyleMasterList selectedWeddingStyle =
                                                manageStylesCtr.weddingStylesModel!
                                                    .weddingStyleMasterList![index];

                                            return WeddingStyleTile(
                                              onTap: () async {
                                                manageStylesCtr.addSelectedStyle(interest);
                                                manageStylesCtr.removeWriteByHandStyle();
                                                manageStylesCtr.setWeddingStyleMasterId(
                                                    selectedWeddingStyle.weddingStyleMasterId
                                                        ?.toString());
                                                await ref
                                                    .read(weddingActivityCtr)
                                                    .fetchWeddingRitualsModel(
                                                        ref: ref,
                                                        context: context,
                                                        weddingStyleMasterId: selectedWeddingStyle
                                                                .weddingStyleMasterId
                                                                ?.toString() ??
                                                            '');
                                                _toggleExpansion();
                                                ref
                                                    .read(weddingCreateEventVisibilityCtr.notifier)
                                                    .setWeddingStyleSelected();
                                              },
                                              interestName: interest,
                                            );
                                          },
                                        ),
                              manageStylesCtr.writeByHandStyles == ""
                                  ? WriteStyleWidget(
                                      getCall: () {
                                        _toggleExpansion();
                                      },
                                    )
                                  : GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 4,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0.w),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: 1,
                                      itemBuilder: (BuildContext context, int index) {
                                        return RemoveableInterestTile(
                                          onTap: () {
                                            manageStylesCtr.removeWriteByHandStyle();
                                          },
                                          interestName: manageStylesCtr.writeByHandStyles,
                                        );
                                      },
                                    )
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
