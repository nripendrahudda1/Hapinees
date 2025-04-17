import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../controllers/common_update_event_visibility_controller.dart';
import '../widgets/update_select_visibility.dart';
import '../../../../common/common_imports/common_imports.dart';

class UpdateVisibleToWidget extends ConsumerStatefulWidget {
  final int visibility;
  final bool? selfRegistration;
  final bool? guestVisibility;
  const UpdateVisibleToWidget({
    super.key,
    required this.visibility,
    this.selfRegistration,
    this.guestVisibility,
  });

  @override
  ConsumerState<UpdateVisibleToWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<UpdateVisibleToWidget> {
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
      final visiblityCtr = ref.watch(updateEventVisibilityCtr);
      if (widget.visibility == 1) {
        visiblityCtr.setPublic();
      }
      if (widget.visibility == 2) {
        visiblityCtr.setPrivate();
      }
      if (widget.visibility == 3) {
        visiblityCtr.setGuest();
      }
      if (widget.selfRegistration == true) {
        visiblityCtr.setSelfRegistrationGuest(true);
      } else {
        visiblityCtr.setSelfRegistrationGuest(false);
      }
      if (widget.guestVisibility == true) {
        visiblityCtr.setShowGuest(true);
      } else {
        visiblityCtr.setShowGuest(false);
      }
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).guestVisibilityExpanded) {
      ref.watch(updateEventExpandedCtr).setGuestVisibilityUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setGuestVisibilityExpanded();
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
                ref.watch(updateEventExpandedCtr).guestVisibilityExpanded
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
                  title: ref.watch(updateEventExpandedCtr).guestVisibilityExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Visible to",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
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
                                  "Visibility",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(updateEventVisibilityCtr).private
                                      ? 'Private'
                                      : ref.read(updateEventVisibilityCtr).public
                                          ? 'Public'
                                          : 'Guest',
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Visibility",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).guestVisibilityExpanded)
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                        child: const UpdateSelectVisibility(),
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final visibilityCtr = ref.watch(updateEventVisibilityCtr);
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
                                          fontSize: MyFonts.size12, color: TAppColors.text2Color),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                      if (!ref.watch(updateEventVisibilityCtr).private &&
                          !ref.watch(updateEventVisibilityCtr).guest)
                        SizedBox(
                          height: 25.w,
                          child: Consumer(
                            builder: (BuildContext context, WidgetRef ref, Widget? child) {
                              final visibilityCtr = ref.watch(updateEventVisibilityCtr);
                              return !visibilityCtr.private
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
                                              color: TAppColors.text2Color),
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
