import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';

class UpdateRitualsTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const UpdateRitualsTile(
      {super.key, required this.interestName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isSmall = interestName.length < 6;

    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final ritualsCtr = ref.watch(updateWeddingRitualsCtr);
        bool isSelected = ritualsCtr.selectedRituals.contains(interestName);

        return InkWell(
          onTap: onTap,
          child: Card(
            // margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w
            // ),
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius:  BorderRadius.circular(6.r)
            ),
            shadowColor: TAppColors.text1Color,
            elevation: 1,
            surfaceTintColor:  TAppColors.text1Color,
            color: isSelected ? TAppColors.selectionColor : TAppColors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 0.h),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    textAlign: TextAlign.center,
                    interestName,
                    overflow: TextOverflow.ellipsis,
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
