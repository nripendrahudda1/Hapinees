import 'package:Happinest/modules/events/create_event/controllers/visible_to_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_who_can_post_controller.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';

class WhoCanPsotSelectVisibility extends StatelessWidget {
  const WhoCanPsotSelectVisibility({super.key});
  //

  Widget showHost(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityTOCtr = ref.watch(visibleToCtr);
        Widget container = GestureDetector(
          onTap: () {
            ref.watch(visibleWhoPostCtr).setonlyHost();
          },
          child: Align(
            alignment: Alignment.center, // Always center
            child: Container(
              height: 30.h,
              decoration: BoxDecoration(
                color: ref.watch(visibleWhoPostCtr).onlyHost
                    ? TAppColors.selectionColor
                    : TAppColors.white,
                borderRadius: visiblityTOCtr.private
                    ? BorderRadius.circular(10.r) // Apply full border radius when private
                    : BorderRadius.only(
                        topLeft: (visiblityTOCtr.guest) ? Radius.circular(10.r) : Radius.zero,
                        bottomLeft: (visiblityTOCtr.guest) ? Radius.circular(10.r) : Radius.zero,
                      ),
                border: visiblityTOCtr.private
                    ? Border.all(color: Colors.white, width: 1.5) // Apply border only if private
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                'Host',
                style: ref.watch(visibleWhoPostCtr).onlyHost
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
        //final visiblityCtr = ref.watch(visibleWhoPostCtr);
        final visiblityTOCtr = ref.watch(visibleToCtr);

        return Container(
          decoration: BoxDecoration(
              color: TAppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor)),
          child: Row(
            children: [
              (visiblityTOCtr.guest || (visiblityTOCtr.private))
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(visibleWhoPostCtr).setPublic();
                        },
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                            color: ref.watch(visibleWhoPostCtr).public
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
                            style: ref.watch(visibleWhoPostCtr).public
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
              (visiblityTOCtr.private)
                  ? const SizedBox.shrink()
                  : Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ref.watch(visibleWhoPostCtr).setGuest();
                        },
                        child: Container(
                          height: 30.h,
                          decoration: BoxDecoration(
                              color: ref.watch(visibleWhoPostCtr).guest
                                  ? TAppColors.selectionColor
                                  : TAppColors.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10.r),
                                  bottomRight: Radius.circular(10.r))),
                          alignment: Alignment.center,
                          child: Text(
                            'Guests',
                            style: ref.watch(visibleWhoPostCtr).guest
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
