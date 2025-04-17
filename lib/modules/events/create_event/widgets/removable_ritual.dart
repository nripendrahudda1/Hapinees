


import '../../../../common/common_imports/common_imports.dart';

class RemoveableRitualTile extends StatelessWidget {
  final String interestName;
  final VoidCallback onTap;
  const RemoveableRitualTile(
      {super.key,
        required this.interestName,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    // bool isSmall =  interestName.length <= 6;
    // bool isVerySmall =  interestName.length <= 2;
    // bool isLarge =  interestName.length >= 14;
    // bool isMedium = interestName.length <= 5 || interestName.length >= 14;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      splashColor: TAppColors.transparent,
      highlightColor: TAppColors.transparent,
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(6.r)
        ),
        shadowColor: TAppColors.text1Color,
        elevation: 1,
        surfaceTintColor:  TAppColors.text1Color,
        color: TAppColors.selectionColor ,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    interestName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style:
                    getMediumStyle(
                        fontSize: MyFonts.size14,
                        color: TAppColors.white),
                  ),
                ),
              ),
              Image.asset(TImageName.crossIcon, width: 24.w, height: 24.h,)
            ],
          ),
        ),
      ),
    );
  }
}
