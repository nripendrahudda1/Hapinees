import '../common_imports/common_imports.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Divider(
        height: 1.h,
        indent: 5.w,
        endIndent: 5.w,
        thickness: 0.5.h,
        color: Colors.black12,
      ),
    );
  }
}
