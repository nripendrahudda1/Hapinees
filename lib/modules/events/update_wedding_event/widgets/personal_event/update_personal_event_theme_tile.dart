import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_persoanl_event_theme_controller.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';

class UpdatePersonalEventThemeTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const UpdatePersonalEventThemeTile(
      {super.key, required this.interestName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final manageStylesCtr = ref.watch(updatePersonalEventThemCtr);
        bool isSelected = manageStylesCtr.selectedThemes.contains(interestName);
        bool isSmall = interestName.length < 6;
        return InkWell(
          onTap: onTap,
          child: Card(
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(6.r)
            ),
            shadowColor: isSelected ? TAppColors.selectionColor : TAppColors.text1Color,
            elevation: 1,
            surfaceTintColor:  TAppColors.text1Color,
            color: isSelected ? TAppColors.selectionColor : TAppColors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.h),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    interestName,
                    textAlign: TextAlign.center,
                    style: isSelected ?
                    getBoldStyle(
                        fontSize: MyFonts.size14,
                        color: TAppColors.white) :
                    getRegularStyle(
                        fontSize: MyFonts.size14,
                        color: TAppColors.text3Color),
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
