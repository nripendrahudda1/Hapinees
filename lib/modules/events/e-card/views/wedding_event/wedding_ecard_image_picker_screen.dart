import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:Happinest/common/widgets/image_upload_dialogue.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/e-card/controllers/wedding_event_ecard_controller.dart';
import 'package:Happinest/modules/events/e-card/views/wedding_event/wedding_ecard_image_cropper.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../../../../memories/memories_details.dart';


class WeddingEcardImagePickerScreen extends ConsumerStatefulWidget {
  const WeddingEcardImagePickerScreen({
    super.key,
    this.onImageUpload,
  });
  final Function()? onImageUpload;
  @override
  ConsumerState<WeddingEcardImagePickerScreen> createState() => _WeddingEcardImagePickerScreenState();
}

class _WeddingEcardImagePickerScreenState extends ConsumerState<WeddingEcardImagePickerScreen> {
  String selectedImages = '';
  List<String> totalImages = [];

  @override
  void initState() {
    if(ref.read(weddingEventECardCtr).weddingAllImagesModel != null) {
      totalImages = ref
          .read(weddingEventECardCtr)
          .weddingAllImagesModel!
          .weddingPhotoList!
          .map((e) {
        return e.imageUrl ?? '';
      }).toList();
    }
    super.initState();
  }

  storeImage(String image) async {
    ref.read(weddingEventECardCtr).setCurrentImage(image);
  }


  Future<void> showImagesucessDialog(int totalImages) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return UploadSucessDialog(
          totalImages: totalImages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15).copyWith(top: 0),
      ),
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        onTap: () => Navigator.pop(context),
        title: TNavigationTitleStrings.editECard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 12),
              child: memoryDetailsWidget(
                  isDayVisible: false,
                  tripName: ref.read(weddingEventHomeController).homeWeddingDetails!.title.toString()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TText('Select only 1 image', color: TAppColors.text2Color),
                ],
              ),
            ),
            SizedBox(
              height: 0.5.sh,
              child: TCard(
                  width: dwidth,
                  border: true,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: totalImages.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8),
                      itemBuilder: (context, index) {
                        return
                        //   index == 0
                        //     ? TBounceAction(
                        //   onPressed: () async {
                        //     // if (widget.data.index != -1) {
                        //     //   await ImagePickerBottomSheet.show(context,
                        //     //       dayName: widget.data
                        //     //           .dayData[widget.data.index].dayName
                        //     //           .toString(),
                        //     //       tripName:
                        //     //       widget.data.tripData.tripName ?? '',
                        //     //       isOneDaySuggetion: true,
                        //     //       tripDate: DateTime.parse(widget
                        //     //           .data
                        //     //           .dayData[widget.data.index]
                        //     //           .tripDayDate
                        //     //           .toString()),
                        //     //       selectedAsset: (photos) async {
                        //     //         if (photos != null && photos.isNotEmpty) {
                        //     //           for (int i = 1;
                        //     //           i <= photos.length;
                        //     //           i++) {
                        //     //             _showUploadDialog(photos.length, i);
                        //     //             await uploadImages(photos[i - 1])
                        //     //                 .then((value) {
                        //     //               Navigator.pop(context);
                        //     //             });
                        //     //           }
                        //     //           await showImagesucessDialog(
                        //     //               photos.length);
                        //     //         }
                        //     //       }, selectedImageList: (photos) async {
                        //     //         if (photos != null && photos.isNotEmpty) {
                        //     //           for (int i = 1;
                        //     //           i <= photos.length;
                        //     //           i++) {
                        //     //             _showUploadDialog(photos.length, i);
                        //     //             await uploadFileImages(photos[i - 1]!)
                        //     //                 .then((value) {
                        //     //               Navigator.pop(context);
                        //     //             });
                        //     //           }
                        //     //           await showImagesucessDialog(
                        //     //               photos.length);
                        //     //         }
                        //     //       }, isMultiImage: true);
                        //     // } else {
                        //     //   Map<DateTime, List<AssetEntity>?>
                        //     //   photosBetweeenDays;
                        //     //   EasyLoading.show();
                        //     //
                        //     //   await _.getImagesBetweeenDays(
                        //     //       startDate:
                        //     //       widget.data.tripData.startTime,
                        //     //       endDate: widget.data.tripData.endTime);
                        //     //   photosBetweeenDays =
                        //     //       _.photosBetweeenDays ?? {};
                        //     //   EasyLoading.dismiss();
                        //     //   await listOfBulkImages(context,
                        //     //       listOfBulkPhotos: photosBetweeenDays,
                        //     //       tripData: widget.data.tripData,
                        //     //       onUpload: (images) async {
                        //     //         Navigator.pop(context);
                        //     //         int tPhotos = 0;
                        //     //         int totPhotos = images.values.fold(0,
                        //     //                 (sum, photos) => sum + photos.length);
                        //     //         for (int key in images.keys) {
                        //     //           List<AssetEntity>? photos = images[key];
                        //     //           for (int i = 0;
                        //     //           i <
                        //     //               (photos != null
                        //     //                   ? photos.length
                        //     //                   : 0);
                        //     //           i++) {
                        //     //             tPhotos++;
                        //     //             _showUploadDialog(totPhotos, tPhotos);
                        //     //             await uploadImages(photos![0],
                        //     //                 currPageIndex: key)
                        //     //                 .then((value) {
                        //     //               Navigator.pop(context);
                        //     //             });
                        //     //           }
                        //     //         }
                        //     //
                        //     //         await showImagesucessDialog(totPhotos);
                        //     //       },
                        //     //       tripName:
                        //     //       widget.data.tripData.tripName ??
                        //     //           '');
                        //     // }
                        //   },
                        //   child: TCard(
                        //     image: const DecorationImage(
                        //         image:
                        //         AssetImage(TImageName.uploadPhotos)),
                        //   ),
                        // )
                        //     :
                          Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                   selectedImages==
                                      totalImages[index]
                                      ? selectedImages = ''
                                      : selectedImages = totalImages[index];
                                  storeImage(selectedImages);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            WeddingEcardImagePCropper(
                                              selectedImage: selectedImages,
                                            ),
                                      ));
                                });
                              },
                              child: TCard(
                                border: selectedImages.contains(
                                    totalImages[index]),
                                borderWidth: 4,
                                radius: 12,
                                borderColor: TAppColors.selectionColor,
                                child:
                                CachedRectangularNetworkImageWidget(
                                    image: totalImages[index],
                                    width: double.maxFinite,
                                    radius: 8,
                                    height: double.maxFinite),
                              ),
                            ),
                            // Positioned(
                            //   top: 6,
                            //   right: 6,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       setState(() {
                            //         selectedImages ==
                            //                 totalImages[widget.isCoAuthor ? index - 1:index]
                            //             ? selectedImages = ''
                            //             : selectedImages =
                            //                 totalImages[widget.isCoAuthor ? index - 1:index];
                            //         storeImage(selectedImages);
                            //         // if (selectedImages.contains(
                            //         //     totalImages[widget.isCoAuthor ? index - 1:index])) {
                            //         //   selectedImages
                            //         //       .remove(totalImages[widget.isCoAuthor ? index - 1:index]);
                            //         // } else if (selectedImages.length <
                            //         //     3) {
                            //         //   selectedImages
                            //         //       .add(totalImages[widget.isCoAuthor ? index - 1:index]);
                            //         // }
                            //       });
                            //     },
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         shape: BoxShape.circle,
                            //         border: Border.all(
                            //             width: 2,
                            //             color: TAppColors.orange),
                            //       ),
                            //       child: Icon(
                            //         Icons.check,
                            //         size: 16,
                            //         color: selectedImages.contains(
                            //                 totalImages[widget.isCoAuthor ? index - 1:index])
                            //             ? TAppColors.orange
                            //             : Colors.transparent,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                      },
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
