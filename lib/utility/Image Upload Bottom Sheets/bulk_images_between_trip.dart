import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/utility/constants/constants.dart';

Future<Map<DateTime, List<AssetEntity>>> listOfBulkImages(BuildContext context,
    {required String tripName,
    required Map<DateTime, List<AssetEntity>?> listOfBulkPhotos,
    required Function(List<File?>?) selectedImageList,
    required Function(Map<int, List<AssetEntity>>?, List<File?>? file) onUpload}) async {
  Map<int, List<AssetEntity>> selectedImages = {};
  Map<int, List<File>> images = {};
  int totalImages = 0;
  int totalSelectedImages = 0;
  int i = 0;
  int expandedIndex = 0;
  int tmpI = 0;
  List<bool> isSelected = [true, false];

  if (listOfBulkPhotos.entries.isNotEmpty) {
    try {
      int found = 0;
      for (var entry in listOfBulkPhotos.entries) {
        (entry.value != null && entry.value!.isNotEmpty && expandedIndex == 0) ? found++ : null;
        if (found == 1) {
          expandedIndex = tmpI;
        }
        tmpI++;
      }

      for (var entry in listOfBulkPhotos.entries) {
        var value = entry.value;
        selectedImages[i] = [];
        List<File> tmpList = [];
        for (AssetEntity element in value ?? []) {
          File? file = await element.file;
          if (file != null) {
            tmpList.add(file);
          }
        }
        images[i] = tmpList;
        totalImages += value != null ? value.length : 0;
        i++;
      }
    } catch (e) {
      log('multi image upload : $e');
    }
  }

  Completer<Map<DateTime, List<AssetEntity>>> completer = Completer();
  int maxImage = 10;
  // ignore: use_build_context_synchronously

  showModalBottomSheet(
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(0),
        topLeft: Radius.circular(0),
      ),
    ),
    backgroundColor: Colors.transparent, // Make background transparent for full-screen effect
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: dheight,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: topSfarea > 0 ? topSfarea : 0.03.sh, left: 15.w, right: 15.w),
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
                            TText(tripName,
                                fontWeight: FontWeight.w600,
                                color: TAppColors.text1Color,
                                fontSize: 18),
                            const SizedBox(
                              height: 6,
                            ),
                            ToggleButtons(
                              isSelected: isSelected,
                              onPressed: (int index) {
                                setState(() async {
                                  // Update selection
                                  // for (int i = 0; i < isSelected.length; i++) {
                                  //   isSelected[i] = i == index;
                                  // }

                                  final picker = ImagePicker();
                                  final pickedFile = await picker.pickMultiImage();
                                  if (pickedFile.isEmpty) {
                                    return;
                                  }
                                  List<File?>? listOfImages =
                                      pickedFile.map((e) => File(e.path)).toList();
                                  if (kDebugMode) {
                                    print(listOfImages.length.toString());
                                  }
                                  //onUpload(listOfImages);
                                  selectedImageList(listOfImages);
                                  setState(() {
                                    selectedImages.clear();
                                    totalSelectedImages = 0;
                                    totalSelectedImages += listOfImages.length;
                                    print("totalSelectedImages **** $totalSelectedImages");
                                  });
                                  onUpload(null, listOfImages);
                                });
                              },
                              borderRadius: BorderRadius.circular(17),
                              selectedColor: Colors.white,
                              fillColor: Colors.orange,
                              color: Colors.black,
                              constraints: const BoxConstraints(minHeight: 34.0, minWidth: 80.0),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Album",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    "Suggestion",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 55.w,
                        child: GestureDetector(
                          onTap: () {
                            totalSelectedImages > 0 ? onUpload(selectedImages, null) : null;
                          },
                          child: TText(TLabelStrings.addPhoto,
                              maxLines: 1,
                              fontWeight: FontWeight.w700,
                              color: totalSelectedImages > 0
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
                // _pickImages(setState),
                totalImages == 0 && isSelected[1] == true
                    ? Expanded(
                        child: Center(
                          child: TText('No Photos Found Between Trip Days',
                              color: TAppColors.text1Color),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfBulkPhotos.length,
                          itemBuilder: (context, day) {
                            DateTime tripDate = listOfBulkPhotos.keys.elementAt(day);
                            List<AssetEntity> listOfPhotos = listOfBulkPhotos[tripDate] ?? [];
                            return listOfPhotos.isNotEmpty
                                ? Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(
                                              () {
                                                expandedIndex == day
                                                    ? expandedIndex = 50
                                                    : expandedIndex = day;
                                              },
                                            );
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: TText(
                                                  'Day ${day + 1} - ${formatDateddMMMyyyy(tripDate.toString(), context)}',
                                                  fontSize: 18,
                                                  color: TAppColors.text1Color,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              /*Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: expandedIndex == day
                                                    ? const Icon(Icons
                                                        .keyboard_arrow_down_rounded)
                                                    : const Icon(Icons
                                                        .keyboard_arrow_right_rounded),
                                              )*/
                                            ],
                                          ),
                                        ),
                                        Container(
                                            // padding:
                                            // const EdgeInsets.all(2.0),
                                            // decoration: BoxDecoration(
                                            //     borderRadius:
                                            //     const BorderRadius.all(
                                            //         Radius.circular(
                                            //             20)),
                                            //     color: Colors.grey[100]),
                                            child: listOfPhotos.isNotEmpty && images[day] != null
                                                ? GridView.builder(
                                                    physics: const ClampingScrollPhysics(),
                                                    shrinkWrap: true,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      crossAxisSpacing: 1.5,
                                                      mainAxisSpacing: 1.5,
                                                    ),
                                                    itemCount: listOfPhotos.length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      AssetEntity image = listOfPhotos[index];

                                                      bool isSelected =
                                                          selectedImages[day]!.contains(image);
                                                      return GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedImages[day]!.remove(image);
                                                            } else {
                                                              totalSelectedImages < maxImage
                                                                  ? selectedImages[day]!.add(image)
                                                                  : null;
                                                            }
                                                            totalSelectedImages = 0;
                                                            selectedImages.forEach((key, value) {
                                                              totalSelectedImages += value.length;
                                                            });
                                                          });
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(0.5),
                                                                image: DecorationImage(
                                                                  image: FileImage(images[day]!
                                                                      .elementAt(index)),
                                                                  fit: BoxFit.cover,
                                                                ),
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 6,
                                                              right: 6,
                                                              child: Container(
                                                                width: 20,
                                                                height: 20,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  color: isSelected
                                                                      ? Colors.white
                                                                      : Colors.transparent,
                                                                  border: Border.all(
                                                                      color: TAppColors.orange,
                                                                      width: 2),
                                                                ),
                                                                child: isSelected
                                                                    ? const Icon(
                                                                        Icons.check,
                                                                        color: TAppColors.orange,
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
                                                        'No Photos Found For The Day ${formatDate(tripDate.toIso8601String(), context)}',
                                                        color: TAppColors.text1Color),
                                                  ))
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                TCard(
                    color: Colors.grey.withOpacity(0.2),
                    width: dwidth!,
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h)
                          .copyWith(bottom: bottomSfarea > 0 ? bottomSfarea : 12.h),
                      child: TText(
                        'Selected $totalSelectedImages/$maxImage',
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

  EasyLoading.dismiss();
  return completer.future;
}
