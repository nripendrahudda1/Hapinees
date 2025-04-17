import 'package:Happinest/modules/events/update_wedding_event/widgets/update_select_visibility_can_post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/common_update_event_whocanpost_visibility_controller.dart';
import '../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../controllers/common_update_event_visibility_controller.dart';
import '../../../../common/common_imports/common_imports.dart';

class UpdateWhoCanPostVisibleToWidget extends ConsumerStatefulWidget {
  final int contributor;
  const UpdateWhoCanPostVisibleToWidget({
    super.key,
    required this.contributor,
  });

  @override
  ConsumerState<UpdateWhoCanPostVisibleToWidget> createState() =>
      _ChoseWhoCanPostStyleWidgetState();
}

class _ChoseWhoCanPostStyleWidgetState extends ConsumerState<UpdateWhoCanPostVisibleToWidget> {
  bool firstTime = true;
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(updateEventExpandedCtr).setGuestVisibilityUnExpanded();
      final visiblityCtr = ref.watch(updateWhoPostCtr);

      if (widget.contributor == 1) {
        visiblityCtr.setPublic();
        visiblityCtr.setFromAPIGuest(true);
      }
      if (widget.contributor == 2) {
        visiblityCtr.setonlyHost();
        visiblityCtr.setFromAPIGuest(true);
      }
      if (widget.contributor == 3) {
        visiblityCtr.setGuest();
        visiblityCtr.setFromAPIGuest(true);
      }
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).postVisibilityExpanded) {
      ref.watch(updateEventExpandedCtr).setPostVisibilityUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setPostVisibilityExpanded();
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
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventExpandedCtr).postVisibilityExpanded
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
                  title: ref.watch(updateEventExpandedCtr).postVisibilityExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Who can post",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : firstTime == true
                          ? Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              final visibilityCtr = ref.watch(updateEventVisibilityCtr);
                              // print("---visibilityCtr private---${visibilityCtr.private}");
                              // print("---visibilityCtr public---${visibilityCtr.public}");
                              // print("---visibilityCtr guest---${visibilityCtr.guest}");
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Who can post",
                                    style: getRegularStyle(
                                        fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                  ),
                                  SizedBox(
                                    height: 4.h,
                                  ),
                                  ref.watch(updateWhoPostCtr).loadingfromAPI
                                      ? Text(
                                          ref.watch(updateWhoPostCtr).onlyHost
                                              ? 'Host'
                                              : ref.watch(updateWhoPostCtr).public
                                                  ? 'Public'
                                                  : 'Guest',
                                          style: getBoldStyle(
                                            fontSize: MyFonts.size14,
                                          ),
                                        )
                                      : Text(
                                          visibilityCtr.private
                                              ? 'Host'
                                              : ref.read(updateEventVisibilityCtr).public
                                                  ? 'Public'
                                                  : 'Guest',
                                          style: getBoldStyle(
                                            fontSize: MyFonts.size14,
                                          ),
                                        )
                                ],
                              );
                            })
                          : Text(
                              "Who can post",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).postVisibilityExpanded)
                  SizedBox(
                    width: ref.watch(updateEventVisibilityCtr).private ? 1.sw - 100 : null,
                    child: Column(children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        child: const WhoCanUpdateSelectVisibilityVisibility(),
                      ),
                    ]),
                  ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
