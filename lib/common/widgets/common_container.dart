import '../common_imports/common_imports.dart';

class CommonContainer extends StatelessWidget {
  final Widget child;
  const CommonContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.only(bottom:10.h,right: 10.w,left: 10.w),
      decoration: BoxDecoration(
          color: TAppColors.containerColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: TAppColors.text1Color.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(2.w, 4.h),
            )
          ]
      ),
      child: child,
    );
  }
}
