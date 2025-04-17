import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/utility/constants/constants.dart';

Future<List<AssetEntity>?> listOfImages(BuildContext context,
    {required List<AssetEntity> listOfPhotos,
    required DateTime tripDate,
    required String tripName,
    required String noOfDay,
    required Function(List<AssetEntity>?) onUpload}) async {
  List<AssetEntity> selectedImages = [];
  Completer<List<AssetEntity>> completer = Completer();
  int maxImage = 50;
  List<File> imgs = [];
  for (var element in listOfPhotos) {
    File? pic = await element.file;
    if (pic != null) {
      imgs.add(pic);
    }
  }
  EasyLoading.dismiss();
  showModalBottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0),
        topLeft: Radius.circular(0),
      ),
    ),
    backgroundColor: Colors
        .transparent, // Make background transparent for full-screen effect
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: topSfarea > 0 ? topSfarea : 0.03.sh,
                      left: 15.w,
                      right: 15.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 55,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            iconButton(
                                radius: 28.h,
                                onPressed: () => Navigator.pop(context),
                                iconPath: TImageName.crossIcon,
                                bgColor: TAppColors.black50),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TText(TLabelStrings.addMemories,
                                fontWeight: FontWeight.w600,
                                color: TAppColors.text1Color,
                                fontSize: MyFonts.size18),
                            const SizedBox(
                              height: 6,
                            ),
                            TText(tripName, color: TAppColors.text1Color),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        child: GestureDetector(
                          onTap: () {
                            selectedImages.isNotEmpty
                                ? onUpload(selectedImages)
                                : null;
                          },
                          child: TText(TLabelStrings.upload,
                              maxLines: 1,
                              fontWeight: FontWeight.w700,
                              color: selectedImages.isNotEmpty
                                  ? TAppColors.themeColor
                                  : TAppColors.text3Color,
                              fontSize: MyFonts.size18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TText(
                        '$noOfDay - ${formatDateddMMMyyyy(tripDate.toIso8601String(), context)}',
                        fontSize: 18,
                        color: TAppColors.text1Color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    listOfPhotos.length <= maxImage && listOfPhotos.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedImages.length <
                                    listOfPhotos.length) {
                                  selectedImages = List.from(listOfPhotos);
                                } else {
                                  selectedImages.clear();
                                }
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16.0),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 2,
                                    color: selectedImages.length ==
                                            listOfPhotos.length
                                        ? TAppColors.selectionColor
                                        : Colors.grey),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 16,
                                color:
                                    selectedImages.length == listOfPhotos.length
                                        ? TAppColors.selectionColor
                                        : Colors.transparent,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: listOfPhotos.isNotEmpty
                          ? GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // 3 images in a row
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                              ),
                              itemCount: listOfPhotos.length,
                              itemBuilder: (BuildContext context, int index) {
                                AssetEntity image = listOfPhotos[index];
                                bool isSelected =
                                    selectedImages.contains(image);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedImages.remove(image);
                                      } else {
                                        selectedImages.length < maxImage
                                            ? selectedImages.add(image)
                                            : null;
                                      }
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          image: DecorationImage(
                                            image: FileImage(imgs[index]),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: isSelected
                                                ? TAppColors.white
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: isSelected
                                                    ? TAppColors.selectionColor
                                                    : TAppColors.white,
                                                width: 2),
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: TAppColors.selectionColor,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: TText(
                                  'No Photos Found For The Day ${formatDateddMMMyyyy(tripDate.toIso8601String(), context)}',
                                  color: TAppColors.text1Color),
                            )),
                ),
                TCard(
                    color: Colors.grey.withOpacity(0.2),
                    width: dwidth,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h).copyWith(
                          bottom: bottomSfarea > 0 ? bottomSfarea : 12.h),
                      child: TText(
                        'Selected ${selectedImages.length}/$maxImage',
                        color: TAppColors.themeColor,
                        fontSize: 18,
                      ),
                    )))
              ],
            ),
          );
        },
      );
    },
  );

  return completer.future;
}
