import '../../../../common/common_imports/common_imports.dart';

class CustomEcardRow extends StatelessWidget {
  final String title;
  final String imagePath;
  const CustomEcardRow({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: 20.w,
          height: 20.h,
          color: TAppColors.white,
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: TText(title,
              color: TAppColors.white, fontSize: MyFonts.size12, fontWeight: FontWeight.bold),
          // Text(
          //   title,
          //   maxLines: 2,
          //   style: getBoldStyle(
          //     fontSize: MyFonts.size10,
          //     color: TAppColors.white,
          //   ),
          // ),
        )
      ],
    );
  }
}
