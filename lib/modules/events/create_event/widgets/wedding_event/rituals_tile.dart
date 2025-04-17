import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';

class RitualsTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const RitualsTile({super.key, required this.interestName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isSmall = interestName.length < 6;
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final ritualsCtr = ref.watch(weddingActivityCtr);
        bool isSelected = ritualsCtr.selectedRituals.contains(interestName);

        return InkWell(
          onTap: onTap,
          child: Card(
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
                side: BorderSide(
                    color: isSelected ? TAppColors.selectionColor : TAppColors.lightBorderColor,
                    width: 0.5)),
            elevation: 0,
            color: isSelected ? TAppColors.selectionColor : customColors.containerColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  textAlign: TextAlign.center,
                  interestName,
                  overflow: TextOverflow.ellipsis,
                  style: isSelected
                      ? getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white)
                      : getRegularStyle(fontSize: MyFonts.size14, color: customColors.text3Color),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
