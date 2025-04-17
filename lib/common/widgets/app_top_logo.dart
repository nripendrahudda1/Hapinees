import 'package:Happinest/common/common_imports/common_imports.dart';

class TAppTopImage extends StatelessWidget {
  const TAppTopImage({super.key, this.titleName});
  final String? titleName;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            width: screenSize.width * 0.5,
            child: Image.asset(TImageName.appLogo)),
        SizedBox(
          height: 20.h,
        ),
        titleName != null
            ? TText(titleName!,
                fontSize: MyFonts.size20,
                color: TAppColors.white,
                fontWeight: FontWeightManager.bold)
            : const SizedBox.shrink(),
      ],
    );
  }
}
