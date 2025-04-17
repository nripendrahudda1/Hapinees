import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../../../../../common/common_functions/get_file_extension.dart';
import '../../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../../common/widgets/appbar.dart';
import '../../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../../common/widgets/custom_textfield.dart';
import '../../../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../../../gallery/select_multiple_images_for_moments.dart';
import '../../../../../../../location/location_client.dart';
import '../../../../../../../models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import '../../../../../../../models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_photo_model.dart';
import '../../../../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../../../../../../../utility/constants/strings/parameter.dart';

class UpdatePersonalEventGalleryMomentScreen extends ConsumerStatefulWidget {
  const UpdatePersonalEventGalleryMomentScreen(
      {super.key,
      required this.eventHeaderId,
      required this.eventTitle,
      required this.token,
      required this.imagePaths,
      required this.postModel});
  final List<PersonalEventPhoto> imagePaths;
  final String? token, eventTitle;
  final int? eventHeaderId;
  final PersonalEventPost postModel;

  @override
  ConsumerState<UpdatePersonalEventGalleryMomentScreen> createState() =>
      _UpdatePersonalEventGalleryMomentScreenState();
}

class _UpdatePersonalEventGalleryMomentScreenState
    extends ConsumerState<UpdatePersonalEventGalleryMomentScreen> {
  int selectedImage = 0;
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  bool checkDeleteStatus = false;
  TextEditingController commentController = TextEditingController();
  late final List<String> imagePathsList;
  late List<String> encodedPaths = [];

  @override
  void initState() {
    print(("------sdsdsdsdsd----${widget.imagePaths}"));
    commentController.text = widget.postModel.description ?? '';

    imagePathsList = widget.imagePaths.map((photo) => photo.photo).toList();
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  onScreenTap() {
    setState(() {
      isKeyBoardFocus = false;
    });
    FocusManager.instance.primaryFocus!.unfocus();
  }

  // // DownLoad and Image From UrL and Convert
  // Future<String> downloadImageAndConvertToBase64(String imageUrl) async {
  //   try {
  //     Dio dio = Dio();
  //     Response<Uint8List> response = await dio.get<Uint8List>(
  //       imageUrl,
  //       options: Options(responseType: ResponseType.bytes), // Get response as bytes
  //     );
  //     if (response.statusCode == 200) {
  //       Uint8List imageBytes = response.data!; // Get image bytes
  //       String base64String = base64.encode(imageBytes); // Convert bytes to Base64
  //       return base64String;
  //     } else {
  //       return "";
  //     }
  //   } catch (e) {
  //     return "";
  //   }
  // }
  updateMoment() async {
    imagePathsList.removeWhere((e) => e.startsWith(ApiUrl.urlPathWithoutFolderName));
    List<String> extensions = imagePathsList.map((e) => getFileExtension(path: e)).toList();
    await Future.wait(imagePathsList.map((e) async {
      if (e.startsWith(ApiUrl.urlPathWithoutFolderName)) {
        // ✅ Convert URL string to Base64 directly (downloading)
        //  String base64String = await downloadImageAndConvertToBase64(e);
        // encodedPaths.add(base64String);
      } else {
        // ✅ Compress local image
        Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(e));
        String base64String = base64.encode(stringPPic!);
        encodedPaths.add(base64String);
      }
    }));
    PersonalEventCreateMemoriesTextPostModel model = PersonalEventCreateMemoriesTextPostModel(
      createdOn: DateTime.now(),
      personalEventHeaderId: widget.eventHeaderId ?? 0,
      personalEventPostId: widget.postModel.personalEventPostId ?? 0,
      aboutPost: commentController.text,
    );
    await ref.read(personalEventMemoriesController).updatePersonalEventMemoryPostText(
        personalEventCreateMemoriesTextPostModel: model,
        token: widget.token ?? '',
        mediaDatas: encodedPaths,
        mediaExtensions: extensions,
        isSingleMediaPost: false,
        isMultiMediaPost: encodedPaths.isNotEmpty ? true : false,
        isTextPost: false,
        context: context,
        ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isKeyBoardFocus = false;
      });
      commentController.clear();
      FocusManager.instance.primaryFocus!.unfocus();
      Navigator.pop(context, true);
    });
  }

  deleteImagefromArray(int inedexNo) {
    String imagePath = imagePathsList[inedexNo];
    if (imagePath.startsWith(ApiUrl.urlPathWithoutFolderName)) {
      showAlertMessageforDeleteImage(context, true, false, inedexNo);
    } else {}
    imagePathsList.removeAt(inedexNo);
  }

  ///
  deleteMomentPostPhoto(int personalEventPostPhotoId) async {
    DeletePersonalEventPostMomentPhotoModel model = DeletePersonalEventPostMomentPhotoModel(
      personalEventPostPhotoId: personalEventPostPhotoId,
      personalEventHeaderId: widget.eventHeaderId ?? 0,
    );
    await ref.read(personalEventMemoriesController).deletePersonalEventPostMedia(
        personalEventCreateMemoriesTextPostModel: model,
        token: widget.token ?? '',
        context: context,
        ref: ref);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isKeyBoardFocus = false;
      });
      FocusManager.instance.primaryFocus!.unfocus();
    });
  }

  /// compareContentLengths and Array lenth
  void compareContentLengths(
      BuildContext context, String description, String comment, List<String> imagePathsList) {
    int descriptionLength = description.length;
    int commentLength = comment.length;
    int imageCount = imagePathsList.length;
    if (descriptionLength > commentLength || imageCount > widget.imagePaths.length) {
      showAlertMessage(context, true);
    } else if (descriptionLength < commentLength) {
      showAlertMessage(context, true);
    } else if (imageCount > widget.imagePaths.length) {
      showAlertMessage(context, true);
    } else {
      if (checkDeleteStatus) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context);
      }
    }
  }

  void showAlertMessageforDeleteImage(
      BuildContext context, bool hideYesButton, bool isminimumImage, int index) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              showActionButton: hideYesButton,
              bodyText: hideYesButton
                  ? TMessageStrings.imageDeleteMessageServerImage
                  : TMessageStrings.imageDeleteMessage,
              onActionPressed: () {
                if (!isminimumImage) {
                  int photoPostID = widget.imagePaths[index].personalEventPhotoId;
                  deleteMomentPostPhoto(photoPostID);
                  checkDeleteStatus = true;
                } else {
                  Navigator.pop(context);
                }
              },
            ));
  }

  void showAlertMessage(BuildContext context, bool hideYesButton) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              showActionButton: hideYesButton,
              bodyText:
                  hideYesButton ? TMessageStrings.canlcelAction : TMessageStrings.maxPhotoSelection,
              onActionPressed: () {
                if (checkDeleteStatus) {
                  Navigator.pop(context, true);
                } else {
                  Navigator.pop(context);
                }
              },
            ));
  }

  galleryCallback(List<XFile> imgFileList, bool imageType) {
    if (imgFileList.isEmpty) {
      return;
    }
    List<String> newImages = imgFileList.map((image) => image.path).toList();
    setState(() {
      imagePathsList.addAll(newImages); // ✅ Only update imagePathsList
    });
  }

//
  updateGalleryMoment() async {
    if (imagePathsList.length < 10) {
      int totalCount = imagePathsList.length;
      selectionGalleryImagesForMoments(context, galleryCallback, totalCount);
    } else {
      showAlertMessage(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScreenTap,
      child: Scaffold(
        backgroundColor: TAppColors.eventScaffoldColor,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CustomAppBar(
                color: TAppColors.eventScaffoldColor,
                textColor: Colors.white,
                onTap: () {
                  compareContentLengths(context, widget.postModel.description ?? '',
                      commentController.text, imagePathsList);
                },
                title: TLabelStrings.updateEvent,
                hasSubTitle: true,
                subtitle: widget.eventTitle ?? '',
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CachedRectangularNetworkImageWidget(
                        height: 54.w,
                        width: 1.sh,
                        fit: BoxFit.cover,
                        image: imagePathsList.isNotEmpty
                            ? imagePathsList[selectedImage]
                            : TPParameters.defaultThemeBackground,
                        errorWidget: Container(
                          height: 70.h,
                          width: 70.w,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.file(
                            File(imagePathsList[selectedImage]),
                            width: 70.w,
                            height: 60.h,
                            fit: BoxFit
                                .cover, // ✅ Ensures the image fills properly without distortion
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: SizedBox(
                        width: 1.sw,
                        height: 1.sh,
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (selectedImage != 0)
                                  Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () {
                                          setState(() {
                                            selectedImage > 0 ? selectedImage-- : null;
                                          });
                                        },
                                        icon: TImageName.arrowBackPngIcon),
                                  ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (selectedImage != imagePathsList.length - 1)
                                  Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () {
                                          setState(() {
                                            selectedImage < imagePathsList.length - 1
                                                ? selectedImage++
                                                : null;
                                          });
                                        },
                                        icon: TImageName.arrowForwardPngIcon),
                                  ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.h,
                      left: 0.h,
                      child: Container(
                        color: TAppColors.black.withOpacity(0.6),
                        height: 110.h,
                        width: 1.sw,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                          shrinkWrap: false,
                          physics: const BouncingScrollPhysics(),
                          itemCount: imagePathsList.length + 1, // +1 to include "+" button
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // ✅ "+" Button for Adding More Images
                              return GestureDetector(
                                onTap: () {
                                  updateGalleryMoment(); // Replace with your image add function
                                },
                                child: Container(
                                  width: 90.w,
                                  height: 80.h,
                                  margin: EdgeInsets.only(right: 8.0.w), // Adjust spacing
                                  decoration: BoxDecoration(
                                    color: TAppColors.white
                                        .withOpacity(0.2), // Background color for "+" button
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: Border.all(
                                      color: TAppColors.white.withOpacity(0.5),
                                      width: 2.0.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      TImageName.addIconplusCircle,
                                      width: 24.w, // Decreased width
                                      height: 24.h, // Decreased height
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              // ✅ Show Image Thumbnails for Existing Images
                              int imageIndex = index - 1; // Adjust index since "+" button is at 0
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImage = imageIndex;
                                  });
                                },
                                child: Container(
                                  width: 90.w,
                                  height: 80.h,
                                  margin: EdgeInsets.only(right: 8.0.w),
                                  decoration: BoxDecoration(
                                    color: TAppColors.white
                                        .withOpacity(0.2), // Background color for "+" button
                                    borderRadius: BorderRadius.circular(5.r),
                                    border: selectedImage == imageIndex
                                        ? Border.all(
                                            color: TAppColors.white.withOpacity(0.5),
                                            width: 2.0.w,
                                          )
                                        : null,
                                    image: DecorationImage(
                                      image: FileImage(File(imagePathsList[imageIndex])),
                                      fit: BoxFit.cover, // ✅ Ensures full coverage
                                      alignment: Alignment.center, // ✅ Keeps image centered
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4.r),
                                        child: CachedRectangularNetworkImageWidget(
                                          height: 90.h, // Fixed height
                                          width: 90.w, // Fixed width
                                          fit: BoxFit.cover,
                                          image: imagePathsList[imageIndex],

                                          errorWidget: Container(
                                            height: 90.h,
                                            width: 90.w,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Image.file(
                                              File(imagePathsList[imageIndex]),
                                              width: 90.w,
                                              height: 80.h,
                                              fit: BoxFit
                                                  .cover, // ✅ Ensures the image fills properly without distortion
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (imagePathsList.length > 1) {
                                                deleteImagefromArray(imageIndex);
                                                //imagePathsList.removeAt(imageIndex);
                                              } else {
                                                showAlertMessageforDeleteImage(
                                                    context, false, true, 0);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16, // Adjust size
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isKeyBoardFocus ? 0.w : 10.w),
                child: TCard(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldDesc(
                                controller: commentController,
                                hintText: 'Enter Description',
                                onChanged: (String) {},
                                onFieldSubmitted: (String) {},
                                obscure: false,
                                maxLines: 5,
                                minLines: 1,
                                maxLength: 300,
                                topPadding: 10.h,
                                onTap: () {
                                  setState(() {
                                    isKeyBoardFocus = true;
                                  });
                                }),
                          ),
                          // CTTextField(hint: 'Write comment here ...',controller: commentController,maxLength:300,onEditingComplete: sendComment,focusNode:focusNode,onTap: (){
                          //   setState(() {
                          //     isKeyBoardFocus=true;
                          //   });
                          // })),
                          InkWell(
                            splashColor: TAppColors.transparent,
                            onTap: updateMoment,
                            child: Image.asset(
                              TImageName.send,
                              height: 24.h,
                              width: 24.h,
                            ),
                          )
                        ],
                      ),
                    )),
              ),
              if (!isKeyBoardFocus)
                SizedBox(
                  height: 20.h,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
