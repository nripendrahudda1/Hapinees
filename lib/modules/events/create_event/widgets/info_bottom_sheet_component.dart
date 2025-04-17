
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/divider.dart';

class InfoBottomSheetComponent extends StatelessWidget {
  final VoidCallback onCameraTapped;
  final VoidCallback onGalleryTapped;
  final VoidCallback onPdfTapped;
  const InfoBottomSheetComponent({super.key, required this.onCameraTapped, required this.onGalleryTapped, required this.onPdfTapped});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: onCameraTapped,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.camera,
                  size: 24.sp,
                  color: TAppColors.themeColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Camera',
                    style: getBoldStyle(
                      color: TAppColors.themeColor,
                      fontSize: MyFonts.size16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const DividerWidget(),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: onGalleryTapped,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.photo,
                  color: TAppColors.themeColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Gallery',
                    style: getBoldStyle(
                      color: TAppColors.themeColor,
                      fontSize: MyFonts.size16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const DividerWidget(),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: onPdfTapped,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  TImageName.pdfIcon,
                  width: 22.w,
                  height: 25.h,
                  color: TAppColors.themeColor,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'PDF',
                    style: getBoldStyle(
                      color: TAppColors.themeColor,
                      fontSize: MyFonts.size16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
