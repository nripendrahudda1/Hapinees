import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';

class UploadProgressDialog extends StatelessWidget {
  final int totalImages;
  final int imagesUploaded;

  const UploadProgressDialog({
    super.key,
    required this.totalImages,
    required this.imagesUploaded,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: TCard(
            color: TAppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 28.w,
                        height: 28.h,
                      ),
                      Expanded(
                        child: Center(
                          child: TText('Photos',
                              fontSize: 20,
                              fontWeight: FontWeightManager.semiBold,
                              color: TAppColors.black),
                        ),
                      ),
                      // iconButton(
                      //     padding: 0,
                      //     radius: 28.w,
                      //     onPressed: () {
                      //        Navigator.pop(context);
                      //     },
                      //     iconPath: TImageName.cancelIcon),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12, top: 30),
                    child: SizedBox(
                      height: 10,
                      width: 0.6.sw,
                      child: Stack(
                        children: [
                          TCard(width: 0.6.sw, color: TAppColors.lightGrayColor),
                          TCard(
                              width: (0.6.sw * imagesUploaded) / totalImages, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                  TText('$imagesUploaded/$totalImages Uploading',
                      fontSize: MyFonts.size18,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.normal,
                      color: TAppColors.black)
                ],
              ),
            )),
      ),
    );
  }
}

class UploadSucessDialog extends StatelessWidget {
  const UploadSucessDialog({super.key, required this.totalImages, this.ocCompleted});
  final int totalImages;
  final Function()? ocCompleted;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: TCard(
          color: TAppColors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 28.w,
                      height: 28.h,
                    ),
                    Expanded(
                      child: Center(
                        child: TText('Photos',
                            fontSize: 20,
                            fontWeight: FontWeightManager.semiBold,
                            color: TAppColors.black),
                      ),
                    ),
                    iconButton(
                        padding: 0,
                        radius: 28.w,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        iconPath: TImageName.cancelIcon),
                  ],
                ),
                const SizedBox(height: 20),
                Image.asset(
                  TImageName.sucessArrow,
                  height: 50.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: TText('$totalImages images uploaded successfully',
                      fontSize: MyFonts.size18,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      color: TAppColors.black),
                ),
                TBounceAction(
                  onPressed: () {
                    ocCompleted != null ? ocCompleted!() : Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TCard(
                            radius: 100,
                            color: TAppColors.themeColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Center(
                                child: TText('OKAY',
                                    fontSize: 16, fontWeight: FontWeightManager.semiBold),
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

Future<void> showUploadDialog(int totalImages, int uploadedImages, context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return UploadProgressDialog(
        totalImages: totalImages,
        imagesUploaded: uploadedImages,
      );
    },
  );
}
