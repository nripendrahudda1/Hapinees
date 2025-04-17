import '../../../../common/common_imports/common_imports.dart';

class UplaoadFile extends StatelessWidget {
  final VoidCallback onTap;
  final String hintText;
  final String iconpath;
  final String? fileName;
  const UplaoadFile({super.key, required this.onTap, this.fileName,required this.hintText, required this.iconpath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 32.h,
        decoration: BoxDecoration(
            color: TAppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: TAppColors.lightBorderColor
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 240.w
              ),
              child: Text(fileName ?? hintText,
                overflow: TextOverflow.ellipsis,
                style: getRegularStyle(
                fontSize: MyFonts.size14,
                color: TAppColors.text2Color
              ),),
            ),
            Transform.scale(
                scale: 0.7,
                child: Image.asset(iconpath)),
          ],
        )
      ),
    );
  }
}
