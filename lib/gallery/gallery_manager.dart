// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../utility/utility.dart';

// class GlobalMedia {
//   List networkImgFileList_ = [];
//   XFile? selectedImage;
//   List<XFile> selectedImageList = [];
//   List selectedFiles = [];
//   late final Function? onCalledBack;
//   int exitingFileCount = 0;
//   GlobalMedia(this.onCalledBack);

// // ignore: long-method
//   pickMultiImageFromGallery(
//     int? totalCount,
//     BuildContext context, {
//     required int chooseMedia,
//   }) async {
//     ImagePicker picker = ImagePicker();
//     exitingFileCount = totalCount ?? 0;
//     switch (chooseMedia) {
//       case 1:
//         try {
//           selectedImage = await picker.pickImage(
//             source: ImageSource.camera,
//             maxHeight: 500,
//             maxWidth: 500,
//           );
//           if (selectedImage != null) {
//             selectedImageList.add(selectedImage!);
//           }
//         } on PlatformException {
//           loadPermissions(await Permission.camera.status);
//         }
//         await uploadFileOnServer(selectedImageList, selectedImage, totalCount);
//         break;

//       case 2:
//         try {
//           selectedImageList = await picker.pickMultiImage(
//             limit: 5,
//             maxHeight: 500,
//             maxWidth: 500,
//           );
//         } catch (PlatformException) {
//           loadPermissions(await Permission.accessMediaLocation.status);
//         }

//         await uploadFileOnServer(selectedImageList, selectedImage, totalCount);
//         break;

//       case 4:
//         try {
//           selectedImage = await picker.pickImage(
//             source: ImageSource.gallery,
//             maxHeight: 500,
//             maxWidth: 500,
//           );
//           selectedImageList.add(selectedImage!);
//         } catch (PlatformException) {
//           loadPermissions(await Permission.accessMediaLocation.status);
//         }

//         await uploadFileOnServer(selectedImageList, selectedImage, totalCount);
//         break;
//     }
//   }

//   //upload via camera and gallery

//   uploadFileOnServer(
//     List<XFile> selectedImageList,
//     XFile? selectedImage,
//     int? totalCount,
//   ) {
//     var selectedImageCount = selectedImageList.length;
//     if (((selectedImageCount) + (totalCount ?? 0)) <= 5) {
//       if (selectedImageList.isNotEmpty) {
//         Utility.verifyInternet().then((internet) async {
//           if (internet) {
//             onCalledBack!(selectedImageList, false);
//           } else {
//             Utility.toast("Please check your internet connection");
//           }
//         });
//       }
//     } else {
//       Utility.toast(
//         "Issue with Image",
//       );
//     }
//   }

//   String permissions(PermissionStatus permissionStatus) {
//     return permissionStatus.name;
//   }

//   void _openAppSettings() async {
//     await openAppSettings();
//     BasicMessageChannel<String?> lifecycleChannel = SystemChannels.lifecycle;
//     lifecycleChannel.setMessageHandler((msg) async {
//       if (msg!.endsWith("resumed")) {
//         lifecycleChannel.setMessageHandler(null);
//       }
//       return null;
//     });
//   }

//   Future<Future<bool?>?> loadPermissions(PermissionStatus permissionStatus) async {
//     if (permissionStatus.isGranted) {
//       return Utility.toast("permission granted!");
//     } else if (permissionStatus.isDenied) {
//       return Utility.toast("Please enable Permission from  permission settings");
//     }

//     return null;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utility/utility.dart';

class GlobalMedia {
  List networkImgFileList_ = [];
  XFile? selectedImage;
  List<XFile> selectedImageList = [];
  late final Function? onCalledBack;
  int exitingFileCount = 0;
  static int maxImageLimit = 10; // ✅ Define max limit
  bool isSelectionDisabled = false;
  GlobalMedia(this.onCalledBack);

  // Pick images from camera or gallery
  Future<void> pickMultiImageFromGallery(
    int? totalCount,
    BuildContext context, {
    required int chooseMedia,
  }) async {
    ImagePicker picker = ImagePicker();
    exitingFileCount = totalCount ?? 0;
    // maxImageLimit = maxImageLimit - exitingFileCount;

    switch (chooseMedia) {
      case 1: // 📷 Capture image from Camera
        try {
          if ((exitingFileCount + selectedImageList.length) >= maxImageLimit) {
            Utility.toast("You can select a maximum of $maxImageLimit images.");
            return;
          }

          selectedImage = await picker.pickImage(
            source: ImageSource.camera,
            maxHeight: 500,
            maxWidth: 500,
          );

          if (selectedImage != null) {
            selectedImageList.add(selectedImage!);
          }
        } on PlatformException {
          loadPermissions(await Permission.camera.status);
        }
        break;

      case 2: // 📂 Pick multiple images from Gallery
        try {
          List<XFile> images =
              await picker.pickMultiImage(maxHeight: 500, maxWidth: 500, limit: maxImageLimit);

          if ((exitingFileCount + images.length) > maxImageLimit) {
            Utility.toast("You can select a maximum of $maxImageLimit images.");
            return;
          }

          selectedImageList.addAll(images);
        } catch (PlatformException) {
          loadPermissions(await Permission.accessMediaLocation.status);
        }
        break;

      case 4: // 📂 Pick a single image from Gallery
        try {
          selectedImage = await picker.pickImage(
            source: ImageSource.gallery,
            maxHeight: 500,
            maxWidth: 500,
          );

          if (selectedImage != null) {
            if ((exitingFileCount + selectedImageList.length) >= maxImageLimit) {
              Utility.toast("You can select a maximum of $maxImageLimit images.");
              return;
            }
            selectedImageList.add(selectedImage!);
          }
        } catch (PlatformException) {
          loadPermissions(await Permission.accessMediaLocation.status);
        }
        break;
    }

    // Upload only if images are selected
    if (selectedImageList.isNotEmpty) {
      await uploadFileOnServer(selectedImageList, totalCount);
    }
  }

  // Upload selected images
  Future<void> uploadFileOnServer(List<XFile> images, int? totalCount) async {
    int selectedImageCount = images.length + (totalCount ?? 0);

    if (selectedImageCount <= maxImageLimit) {
      bool internet = await Utility.verifyInternet();
      if (internet) {
        onCalledBack!(images, false);
      } else {
        Utility.toast("Please check your internet connection.");
      }
    } else {
      Utility.toast("You can select a maximum of $maxImageLimit images.");
    }
  }

  Future<void> loadPermissions(PermissionStatus permissionStatus) async {
    if (permissionStatus.isGranted) {
      Utility.toast("Permission granted!");
    } else if (permissionStatus.isDenied) {
      Utility.toast("Please enable Permission from settings.");
    }
  }
}
