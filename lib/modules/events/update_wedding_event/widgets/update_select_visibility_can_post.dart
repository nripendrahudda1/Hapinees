import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_visibility_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/common_update_event_whocanpost_visibility_controller.dart';

class WhoCanUpdateSelectVisibilityVisibility extends StatelessWidget {
  const WhoCanUpdateSelectVisibilityVisibility({super.key});
  //

  Widget showHost(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityToCtr = ref.watch(updateEventVisibilityCtr);

        Widget container = GestureDetector(
          onTap: () {
            ref.watch(updateWhoPostCtr).setonlyHost();
            ref.watch(updateWhoPostCtr).setFromAPIGuest(false);
          },
          child: Align(
            alignment: Alignment.center, // Always center
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: ref.watch(updateWhoPostCtr).onlyHost
                    ? TAppColors.selectionColor
                    : TAppColors.white,
                borderRadius: visiblityToCtr.private
                    ? BorderRadius.circular(10.r) // Apply full border radius when private
                    : BorderRadius.only(
                        topLeft: (visiblityToCtr.guest) ? Radius.circular(10.r) : Radius.zero,
                        bottomLeft: (visiblityToCtr.guest) ? Radius.circular(10.r) : Radius.zero,
                      ),
                border: visiblityToCtr.private
                    ? Border.all(color: Colors.white, width: 1.5) // Apply border only if private
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'Host',
                style: ref.watch(updateWhoPostCtr).onlyHost
                    ? getBoldStyle(
                        fontSize: MyFonts.size12,
                        color: TAppColors.text1Color,
                      )
                    : getRegularStyle(
                        fontSize: MyFonts.size12,
                        color: TAppColors.text1Color,
                      ),
              ),
            ),
          ),
        );

        // If guest is selected, wrap in Expanded
        return Expanded(child: container);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityToCtr = ref.watch(updateEventVisibilityCtr);

        return Container(
          decoration: BoxDecoration(
              color: TAppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor)),
          child: Row(
            children: [
              (visiblityToCtr.guest || (visiblityToCtr.private))
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(updateWhoPostCtr).setPublic();
                          ref.watch(updateWhoPostCtr).setFromAPIGuest(false);
                        },
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: ref.watch(updateWhoPostCtr).public
                                ? TAppColors.selectionColor
                                : TAppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              bottomLeft: Radius.circular(10.r),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Public',
                            style: ref.watch(updateWhoPostCtr).public
                                ? getBoldStyle(
                                    fontSize: MyFonts.size12,
                                    color: TAppColors.text1Color,
                                  )
                                : getRegularStyle(
                                    fontSize: MyFonts.size12,
                                    color: TAppColors.text1Color,
                                  ),
                          ),
                        ),
                      ),
                    ),
              const Divider(
                color: Colors.grey, // Set color
                thickness: 1, // Set thickness
              ),
              showHost(context),
              const Divider(
                color: Colors.grey, // Set color
                thickness: 1, // Set thickness
              ),
              (visiblityToCtr.private)
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(updateWhoPostCtr).setGuest();
                          ref.watch(updateWhoPostCtr).setFromAPIGuest(false);
                        },
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                              color: ref.watch(updateWhoPostCtr).guest
                                  ? TAppColors.selectionColor
                                  : TAppColors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r))),
                          alignment: Alignment.center,
                          child: Text(
                            'Guests',
                            style: ref.watch(updateWhoPostCtr).guest
                                ? getBoldStyle(
                                    fontSize: MyFonts.size12,
                                    color: TAppColors.text1Color,
                                  )
                                : getRegularStyle(
                                    fontSize: MyFonts.size12,
                                    color: TAppColors.text1Color,
                                  ),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        );
      },
    );
  }
}
