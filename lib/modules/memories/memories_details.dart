
import '../../common/common_imports/common_imports.dart';

Widget memoryDetailsWidget({
  bool? isDayVisible,
  required String tripName,
  String? date,
  String? dayText,
}) {
  return TCard(
      color: TAppColors.cardBg,
      child: Padding(
        padding:
        EdgeInsets.only(left: 10.w, top: 6.h, right: 10.w, bottom: 6.h),
        child: Column(
          mainAxisAlignment: isDayVisible ?? true ? MainAxisAlignment.spaceAround:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TText(tripName,
                color: TAppColors.text1Color,
                fontSize: MyFonts.size16,
                fontWeight: FontWeight.w700),
            isDayVisible ?? true
                ? Row(
              children: [
                TText(
                  dayText ?? '',
                  fontSize: MyFonts.size14,
                  fontWeight: FontWeight.w500,
                  color: TAppColors.text1Color,
                ),
                const SizedBox(
                  width: 12,
                ),
                Image.asset(
                  TImageName.calanderGrey,
                  height: 16,
                ),
                const SizedBox(
                  width: 8,
                ),
                TText(
                  date ?? '',
                  color: TAppColors.text1Color,
                  fontSize: MyFonts.size14,
                  fontWeight: FontWeight.w500,
                )
              ],
            )
                : const SizedBox.shrink()
          ],
        ),
      ));
}
