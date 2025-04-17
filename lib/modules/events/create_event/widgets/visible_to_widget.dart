import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_to_controller.dart';
import 'package:Happinest/modules/events/create_event/widgets/select_visibility.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/create_event_expanded_controller.dart';

class VisibleToWidget extends ConsumerStatefulWidget {
  const VisibleToWidget({
    super.key,
  });

  @override
  ConsumerState<VisibleToWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<VisibleToWidget> {
  bool firstTime = true;

  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    firstTime = true;
    if (ref.watch(createEventExpandedCtr).guestVisibilityExpanded) {
      ref.watch(createEventExpandedCtr).setGuestVisibilityUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setGuestVisibilityExpanded();
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
                ref.watch(createEventExpandedCtr).guestVisibilityExpanded
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
                  title: ref.watch(createEventExpandedCtr).guestVisibilityExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Visible to",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: customColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : firstTime == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Visible to",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(visibleToCtr).private
                                      ? 'Private'
                                      : ref.read(visibleToCtr).public
                                          ? 'Public'
                                          : 'Guests',
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Text(
                              "Visibility",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).guestVisibilityExpanded)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        child: const SelectVisibility(),
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final visibilityCtr = ref.watch(visibleToCtr);

                          return !visibilityCtr.private
                              ? Row(
                                  children: [
                                    Checkbox(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(4.r))),
                                      value: visibilityCtr.showGuest,
                                      onChanged: (val) {
                                        if (val != null) {
                                          visibilityCtr.setShowGuest(val);
                                        }
                                      },
                                    ),
                                    Text(
                                      'Show Guest List',
                                      style: getRegularStyle(
                                          fontSize: MyFonts.size12, color: customColors.text2Color),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      if (!ref.watch(visibleToCtr).private && !ref.watch(visibleToCtr).guest)
                        SizedBox(
                          height: 25.w,
                          child: Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              final visibilityCtr = ref.watch(visibleToCtr);
                              return !visibilityCtr.private && !visibilityCtr.guest
                                  ? Row(
                                      children: [
                                        Checkbox(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(4.r))),
                                          value: visibilityCtr.selfRegistration,
                                          onChanged: (val) {
                                            if (val != null) {
                                              visibilityCtr.setSelfRegistrationGuest(val);
                                            }
                                          },
                                        ),
                                        Text(
                                          'Self Registration',
                                          style: getRegularStyle(
                                              fontSize: MyFonts.size12,
                                              color: customColors.text2Color),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
