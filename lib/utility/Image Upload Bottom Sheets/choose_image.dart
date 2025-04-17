// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:Happinest/theme/app_colors.dart';
import 'package:Happinest/utility/constants/strings/placeholder_strings.dart';
import 'package:Happinest/utility/utility.dart';
import '../../common/widgets/app_text.dart';
import 'listOfImages_of_one_day.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePickerBottomSheet {
  static Future<void> show(BuildContext context,
      {required bool isMultiImage,
      String? dayName,
      bool isOneDaySuggetion = false,
      DateTime? tripDate,
      required Function(List<AssetEntity>?) selectedAsset,
      required Function(List<File?>?) selectedImageList,
      required String tripName,
      List<AssetEntity>? listOfPhotosOfOneDay}) async {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(24.0),
        topLeft: Radius.circular(24.0),
      )),
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Wrap(
            children: [
              isOneDaySuggetion
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: InkWell(
                        onTap: () async {
                          if (listOfPhotosOfOneDay != null) {
                            await listOfImages(context, onUpload: (p0) async {
                              await selectedAsset(p0);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                                    listOfPhotos: listOfPhotosOfOneDay,
                                    tripDate: tripDate!,
                                    noOfDay: dayName ?? '',
                                    tripName: tripName)
                                .then((value) {
                              Navigator.pop(context);
                            });
                          } else {
                            EasyLoading.show();
                            List<AssetEntity>? listOfPhotos = await getImagesForDay1(tripDate!);
                            EasyLoading.dismiss();
                            if (listOfPhotos != null) {
                              await listOfImages(context, onUpload: (p0) async {
                                await selectedAsset(p0);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                                      listOfPhotos: listOfPhotos,
                                      tripDate: tripDate,
                                      noOfDay: dayName ?? '',
                                      tripName: tripName)
                                  .then((value) {
                                Navigator.pop(context);
                              });
                            } else {
                              EasyLoading.showError(
                                  'No Photos Found For The Day \n${formatDate(tripDate.toString(), context)}',
                                  duration: const Duration(seconds: 6));
                            }
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: TAppColors.appColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: TText(
                                'Suggestion for $dayName',
                                color: TAppColors.appColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              isOneDaySuggetion ? Utility.addDivider() : const SizedBox(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    if (!isMultiImage) {
                      File? image = await _getImage(ImageSource.gallery);
                      image != null ? selectedImageList([image]) : null;
                    } else {
                      List<File?>? listOfImages = await _getListOFImages();
                      if (kDebugMode) {
                        print(listOfImages?.length.toString());
                      }
                      selectedImageList(listOfImages);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.photo,
                        color: TAppColors.appColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TText(
                          TPlaceholderStrings.galleryTest,
                          color: TAppColors.appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                  onTap: () async {
                    Navigator.pop(context);
                    File? image = await _getImage(ImageSource.camera);
                    selectedImageList([image]);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.camera,
                        size: 24,
                        color: TAppColors.appColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TText(
                          TPlaceholderStrings.cameraTest,
                          color: TAppColors.appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> back(BuildContext context) async {
    Navigator.pop(context);
  }

  static Future<List<AssetEntity>?> getImagesForDay1(DateTime tripDate) async {
    final PermissionState ps = await PhotoManager
        .requestPermissionExtend(); // the method can use optional param `permission`.
    List<AssetEntity> selectedImages = [];

    if (ps == PermissionState.authorized ||
        ps == PermissionState.limited ||
        ps == PermissionState.restricted) {
      final List<AssetEntity> entities = await PhotoManager.getAssetListRange(
          start: 0,
          end: 80,
          type: RequestType.image,
          filterOption: FilterOptionGroup(
            createTimeCond: DateTimeCond(
              min: DateTime(tripDate.year, tripDate.month, tripDate.day, 0, 0, 0),
              max: DateTime(tripDate.year, tripDate.month, tripDate.day, 23, 59, 59),
            ),
          ));
      selectedImages = entities;
    } else {
      PhotoManager.openSetting();
    }
    return selectedImages;
  }

  // static Future<Map<DateTime, List<AssetEntity>?>> getImagesForTripDays(
  //     DateTime tripStartDate, DateTime tripEndDate) async {
  //   final PermissionState ps = await PhotoManager.requestPermissionExtend();
  //   debugPrint(ps.toString());

  //   Map<DateTime, List<AssetEntity>> data = {};
  //   int noOfDays = tripEndDate.difference(tripStartDate).inDays;

  //   if (ps == PermissionState.authorized ||
  //       ps == PermissionState.limited ||
  //       ps == PermissionState.restricted) {
  //     // Get all albums
  //     List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
  //       onlyAll: false,
  //       type: RequestType.image,
  //     );

  //     AssetPathEntity? screenshotsAlbum;
  //     AssetPathEntity? allPhotosAlbum;

  //     for (var album in albums) {
  //       String albumName = album.name.toLowerCase();
  //       if (albumName.contains("screenshot")) {
  //         screenshotsAlbum = album;
  //       }  else if (albumName.contains("camera") ||
  //           albumName.contains("dcim") ||
  //           albumName.contains("photos")) {
  //         allPhotosAlbum ??= album; // Store the first general album
  //       }
  //     }

  //     // If no general album is found, use "Recent" (default all images)
  //     allPhotosAlbum ??= albums.firstWhere((album) => album.isAll, orElse: () => albums.first);

  //     for (int i = 0; i <= noOfDays; i++) {
  //       DateTime day = tripStartDate.add(Duration(days: i));
  //       List<AssetEntity> selectedImages = [];

  //       Future<List<AssetEntity>> fetchImages(AssetPathEntity album) async {
  //         final List<AssetEntity> entities = await album.getAssetListRange(start: 0, end: 400);
  //         return entities.where((entity) {
  //           DateTime? createdDate = entity.createDateTime;
  //           return createdDate.isAfter(DateTime(day.year, day.month, day.day, 0, 0, 0)) &&
  //               createdDate.isBefore(DateTime(day.year, day.month, day.day, 23, 59, 59));
  //         }).toList();
  //       }

  //       // Fetch images from general album
  //       selectedImages.addAll(await fetchImages(allPhotosAlbum));

  //       // Fetch screenshots separately
  //       if (screenshotsAlbum != null) {
  //         selectedImages.addAll(await fetchImages(screenshotsAlbum));
  //       }

  //       // Remove duplicates (if any)
  //       data[day] = selectedImages.toSet().toList();
  //     }
  //   } else {
  //     PhotoManager.openSetting();
  //   }

  //   return data;
  // }

  static Future<Map<DateTime, List<AssetEntity>?>> getImagesForTripDays(
      DateTime tripStartDate, DateTime tripEndDate) async {
    final PermissionState ps = await PhotoManager
        .requestPermissionExtend(); // the method can use optional param `permission`.
    debugPrint(ps.toString());

    Map<DateTime, List<AssetEntity>> data = {};
    int noOfDays = tripEndDate.difference(tripStartDate).inDays;
    if (ps == PermissionState.authorized ||
        ps == PermissionState.limited ||
        ps == PermissionState.restricted) {
      for (int i = 0; i <= noOfDays; i++) {
        List<AssetEntity> selectedImages = [];
        DateTime day = tripStartDate.add(Duration(days: i));
        final List<AssetEntity> entities = await PhotoManager.getAssetListRange(
            start: 0,
            end: 600,
            type: RequestType.image,
            filterOption: FilterOptionGroup(
              createTimeCond: DateTimeCond(
                min: DateTime(day.year, day.month, day.day, 0, 0, 0).toUtc(),
                max: DateTime(day.year, day.month, day.day, 23, 59, 59).toUtc(),
              ),
              // updateTimeCond: DateTimeCond(
              //   min: DateTime(day.year, day.month, day.day, 0, 0, 0).toUtc(),
              //   max: DateTime(day.year, day.month, day.day, 23, 59, 59).toUtc(),
              // ),
              // containsPathModified: true, // Ensures modified paths are included
            ));
        selectedImages = entities;
        data[day] = selectedImages;
      }
    } else {
      PhotoManager.openSetting();
    }
    log(data.toString());
    return data;
  }

  static Future<File?> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) {
      return null; // User canceled the image selection
    }
    return File(pickedFile.path);
  }

  static Future<List<File>?> _getListOFImages() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMultiImage();
    if (pickedFile.isEmpty) {
      return null;
    }
    return pickedFile.map((e) => File(e.path)).toList();
  }

  static Future<Uint8List?> fileToUint8List(File? file) async {
    if (file == null) {
      return null;
    }
    List<int> bytes = await file.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  // static Future<Uint8List> imageToByte(File imageFile) async {
  //   // Read the file as bytes
  //   List<int> imageBytes = await imageFile.readAsBytes();

  //   // Convert the list of integers to a Uint8List
  //   Uint8List byteData = Uint8List.fromList(imageBytes);

  //   return byteData;
  // }

  static Future<Uint8List?> compressFile(File? file, {int? maxSizeKB}) async {
    if (file == null) {
      return null;
    }

    int quality = 90; // Initial quality value

    Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: quality,
    );
    if (compressedImage == null) {
      return null;
    }
    while (compressedImage!.lengthInBytes > (maxSizeKB ?? 720) * 1024 && quality > 0) {
      quality -= 10; // for testing
      compressedImage = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
      );
    }

    return compressedImage;
  }
}
