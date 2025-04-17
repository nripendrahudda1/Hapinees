import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Happinest/gallery/gallery_manager.dart';

//ignore: long-method
void selectionModalBottomSheet(
    BuildContext context,
    void Function(
      List<XFile> networkImgFileList,
      bool imageType,
    ) onCallBack,
    bool isFileSection,
    bool isSelectMultiImages,
    int? totalImgCount) {
  // ignore: long-method

  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(32.0),
    ),
    context: context,
    builder: (BuildContext bc) {
      Size size = MediaQuery.of(context).size;
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: isFileSection ? size.height * 0.21 : size.height * 0.18,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24.0),
                topLeft: Radius.circular(24.0),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        GlobalMedia(onCallBack)
                            .pickMultiImageFromGallery(chooseMedia: 4, totalImgCount, context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.photo,
                            color: TAppColors.appColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Gallery',
                              style: TextStyle(
                                color: TAppColors.appColor,
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Utility.addDivider(),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        GlobalMedia(onCallBack)
                            .pickMultiImageFromGallery(chooseMedia: 1, totalImgCount, context);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.camera,
                            size: 24,
                            color: TAppColors.appColor,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Camera',
                              style: TextStyle(
                                color: TAppColors.appColor,
                                fontSize: 16,
                                height: 1.2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
