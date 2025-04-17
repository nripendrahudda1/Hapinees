
import '../../../../common/common_imports/common_imports.dart';

class DateWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isSingle;
  final bool isTime;
  const DateWidget({super.key, required this.text, required this.onTap, required this.isSingle, this.isTime=false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isSingle? double.infinity: 150.w,
        height: 32.h,
        decoration: BoxDecoration(
            color: TAppColors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                color: TAppColors.lightBorderColor
            )
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.all(6.sp),
              child: Image.asset(
                isTime?TImageName.clockGrey:TImageName.calenderIconPng,
                width: 16.w,
                height: 16.h,
              ),
            ),
            SizedBox(width: 10.w,),
            Text(text, style: getRegularStyle(
                color: TAppColors.text1Color,
                fontSize: MyFonts.size14
            ),)
          ],
        ),
      ),
    );
  }
}
