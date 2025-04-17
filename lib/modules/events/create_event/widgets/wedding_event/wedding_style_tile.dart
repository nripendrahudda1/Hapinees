import 'package:Happinest/theme/app_colors.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';

class WeddingStyleTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const WeddingStyleTile({super.key, required this.interestName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(weddingStylesCtr);
        bool isSelected = manageStylesCtr.selectedStyles.contains(interestName);
        bool isSmall = interestName.length < 6;
        return InkWell(
          onTap: onTap,
          child: Card(
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: BorderSide(
                  color: isSelected ? TAppColors.selectionColor : TAppColors.lightBorderColor,
                )),
            elevation: 0,
            surfaceTintColor: TAppColors.text1Color,
            color: isSelected ? TAppColors.selectionColor : customColors.containerColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.h),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    interestName,
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white)
                        : getRegularStyle(fontSize: MyFonts.size14, color: customColors.text3Color),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
