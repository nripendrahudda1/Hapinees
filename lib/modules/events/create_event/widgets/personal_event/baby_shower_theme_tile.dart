import 'package:Happinest/theme/theme_manager.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../controllers/personal_event_controller/baby_shower_themes_controller.dart';

class BabyShowerThemeTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const BabyShowerThemeTile({super.key, required this.interestName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(personalEventThemesCtr);
        bool isSelected = manageStylesCtr.selectedTheme.contains(interestName);
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
            color: isSelected ? TAppColors.selectionColor : customColors.containerColorchip,
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
