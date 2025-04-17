import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/edit_ritual_visibility_controller.dart';

class EditRitualSelectVisibility extends StatelessWidget {
  final Function(int visibility) visibilityFunc;
  const EditRitualSelectVisibility({super.key, required this.visibilityFunc});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final visiblityCtr = ref.watch(editRitualVisibilityCtr);
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
                    visibilityFunc(1);
                  },
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: visiblityCtr.public ? TAppColors.selectionColor : TAppColors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r))),
                    alignment: Alignment.center,
                    child: Text(
                      TPlaceholderStrings.visibilitypublic,
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
                    visiblityCtr.setPrivate();
                    visibilityFunc(2);
                  },
                  child: Container(
                    height: 30.h,
                    color: visiblityCtr.private ? TAppColors.selectionColor : TAppColors.white,
                    alignment: Alignment.center,
                    child: Text(
                      TPlaceholderStrings.visibilityyprivate,
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
                    visiblityCtr.setGuest();
                    visibilityFunc(3);
                  },
                  child: Container(
                    height: 30.h,
                    decoration: BoxDecoration(
                        color: visiblityCtr.guest ? TAppColors.selectionColor : TAppColors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))),
                    alignment: Alignment.center,
                    child: Text(
                      TPlaceholderStrings.visibilityguests,
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
