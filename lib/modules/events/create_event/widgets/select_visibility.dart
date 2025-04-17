import 'package:Happinest/modules/events/create_event/controllers/create_event_expanded_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_who_can_post_controller.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/visible_to_controller.dart';
import '../../../../common/common_imports/common_imports.dart';

class SelectVisibility extends StatelessWidget {
  const SelectVisibility({super.key});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityCtr = ref.watch(visibleToCtr);
        return Container(
          decoration: BoxDecoration(
              color: TAppColors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor)),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    visiblityCtr.setPublic();
                    ref.read(visibleWhoPostCtr).setPublic();
                    // Correct way to update state
                  },
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: visiblityCtr.public ? TAppColors.selectionColor : TAppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                    alignment: Alignment.center,
                    child: Text(
                      'Public',
                      style: visiblityCtr.public
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    visiblityCtr.setPrivate();
                    ref.read(visibleWhoPostCtr).setonlyHost();
                  },
                  child: Container(
                    height: 30.h,
                    color: visiblityCtr.private ? TAppColors.selectionColor : TAppColors.white,
                    alignment: Alignment.center,
                    child: Text(
                      'Private',
                      style: visiblityCtr.private
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    visiblityCtr.setGuest();
                    ref.read(visibleWhoPostCtr).setGuest();
                  },
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: visiblityCtr.guest ? TAppColors.selectionColor : TAppColors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))),
                    alignment: Alignment.center,
                    child: Text(
                      'Guests',
                      style: visiblityCtr.guest
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
