import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/common_update_event_visibility_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/common_update_event_whocanpost_visibility_controller.dart';

class UpdateSelectVisibility extends StatelessWidget {
  const UpdateSelectVisibility({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityCtr = ref.watch(updateEventVisibilityCtr);
        final visiblityWhoPost = ref.watch(updateWhoPostCtr);
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
                    visiblityWhoPost.setPublic();
                    visiblityWhoPost.setFromAPIGuest(false);
                    visiblityCtr.setPublic();
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    visiblityWhoPost.setonlyHost();
                    visiblityWhoPost.setFromAPIGuest(false);
                    visiblityCtr.setPrivate();
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
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    visiblityWhoPost.setGuest();
                    visiblityWhoPost.setFromAPIGuest(false);
                    visiblityCtr.setGuest();
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
