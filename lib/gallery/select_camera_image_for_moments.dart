
import 'package:image_picker/image_picker.dart';

import '../common/common_imports/common_imports.dart';
import 'gallery_manager.dart';

void selectionCameraImageForMoments(
    BuildContext context,
    void Function(
        List<XFile>networkImgFileList,
        bool imageType,
        ) onCallBack,
    int? totalImgCount) {
  // ignore: long-method

  GlobalMedia(onCallBack).pickMultiImageFromGallery(
      chooseMedia: 1,
      totalImgCount,
      context);
}