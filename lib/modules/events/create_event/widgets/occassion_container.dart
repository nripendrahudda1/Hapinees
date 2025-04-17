import 'package:Happinest/theme/theme_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/common_imports/common_imports.dart';

class OccassionContainer extends StatelessWidget {
  final bool isSelected;
  final String iconPath;
  final String name;
  final VoidCallback onTap;
  const OccassionContainer(
      {super.key,
      required this.isSelected,
      required this.onTap,
      required this.iconPath,
      required this.name});

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: (MediaQuery.sizeOf(context).width - (52.w)) / 3,
        width: (MediaQuery.sizeOf(context).width - (52.w)) / 3,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: isSelected ? TAppColors.selectionColor : customColors.containerColorchip,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 0),
                      color: TAppColors.text1Color.withOpacity(0.15),
                      blurRadius: 4)
                ]),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  iconPath,
                  width: 30.w,
                  height: 30.h,
                  color: isSelected ? TAppColors.white : TAppColors.themeColor,
                ),
                // CachedNetworkImage(
                //   imageUrl: iconPath,
                //   width: 30.w,
                //   height: 30.w,
                //   //color: isSelected ? TAppColors.white : TAppColors.themeColor,
                // ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? getBoldStyle(
                          color: TAppColors.white,
                          fontSize: MyFonts.size14,
                        )
                      : GoogleFonts.workSans(
                          color: customColors.text3Color,
                          fontSize: MyFonts.size14.sp,
                          height: 1.1,
                          letterSpacing: 0,
                          fontWeight: FontWeightManager.regular,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
