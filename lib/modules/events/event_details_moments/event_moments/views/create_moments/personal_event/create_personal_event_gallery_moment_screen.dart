import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/location/location_client.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/remove_photo_to_ritual_bottom_sheet.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/save_photo_to_ritual_bottom_sheet.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../common/common_functions/get_file_extension.dart';
import '../../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../../common/widgets/appbar.dart';
import '../../../../../../../common/widgets/custom_textfield.dart';
import '../../../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../../../gallery/select_multiple_images_for_moments.dart';
import '../../../../../../../utility/Image Upload Bottom Sheets/choose_image.dart';

class CreatePersonalEventGalleryMomentScreen extends ConsumerStatefulWidget {
  const CreatePersonalEventGalleryMomentScreen(
      {super.key,
      required this.eventHeaderId,
      required this.eventTitle,
      required this.token,
      required this.imagePaths});
  final List<String> imagePaths;
  final String? token, eventTitle;
  final int? eventHeaderId;

  @override
  ConsumerState<CreatePersonalEventGalleryMomentScreen> createState() =>
      _CreatePersonalEventGalleryMomentScreenState();
}

class _CreatePersonalEventGalleryMomentScreenState
    extends ConsumerState<CreatePersonalEventGalleryMomentScreen> {
  int selectedImage = 0;
  int personalEventActivityId = 0;
  String personalEventBookMarkName = '';
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  saveBookMarked() async {
    final personalEventCtr = ref.watch(personalEventHomeController);
    List<String> personalEventActivityNames = [];
    List<int> personalEventActivityIDS = [];
    personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList?.forEach((element) {
      personalEventActivityNames.add(element.activityName ?? '');
      personalEventActivityIDS.add(element.personalEventActivityId ?? 0);
      personalEventActivityNames = personalEventActivityNames;
    });
    savePhotoToActivityBottomSheet(
      context: context,
      ritualList: personalEventActivityNames,
      onTap: (index) async {
        print("personalEventActivityId ${personalEventActivityIDS[index]}");
        personalEventActivityId = personalEventActivityIDS[index];
        personalEventBookMarkName = personalEventActivityNames[index];
        setState(() {});
        Navigator.pop(context);
        // print(personalEventCtr.homeWeddingDetails?.weddingRitualList?[index].weddingHeaderId);
      },
    );
  }

  removeBookMark() {
    removePhotoToRitualBottomSheet(
      context: context,
      ritual: personalEventBookMarkName,
      onTap: () async {
        setState(() {
          personalEventBookMarkName = '';
          personalEventActivityId = 0;
        });
        //   await momentsCtr.removePostRitualMediaPost(
        //       weddingHeaderId: weddingCtr.homeWeddingDetails?.weddingHeaderId.toString() ?? '',
        //       postMediaId:
        //           widget.postModel.postMedias?[selectedImage].occasionPostMediaId.toString() ?? '',
        //       token: PreferenceUtils.getString(PreferenceKey.accessToken),
        //       ref: ref,
        //       context: context);
      },
    );
  }

  createMoment() async {
    List<File> filePaths = widget.imagePaths.map((e) => File(e)).toList();
    // List<String> encodedPaths = filePaths.map((e) => base64.encode(utf8.encode(e.path))).toList();
    List<String> extensions = widget.imagePaths.map((e) => getFileExtension(path: e)).toList();

    List<Uint8List?> stringPPic = await Future.wait(widget.imagePaths.map((e) async {
      return await ImagePickerBottomSheet.compressFile(File(e));
    }));

    List<String> encodedPaths = stringPPic.map((e) => base64.encode(e!)).toList();

    PersonalEventCreateMemoriesTextPostModel model = PersonalEventCreateMemoriesTextPostModel(
      createdOn: DateTime.now(),
      personalEventHeaderId: widget.eventHeaderId ?? 0,
      aboutPost: commentController.text,
      personalEventActivityId: personalEventActivityId,
    );

    await ref.read(personalEventMemoriesController).setPersonalEventMemoryPostText(
        personalEventCreateMemoriesTextPostModel: model,
        token: widget.token ?? '',
        mediaDatas: encodedPaths,
        mediaExtensions: extensions,
        // mediaData: base64.encode(stringPPic!),
        // mediaExtension: getFileExtension(path: widget.imagePath),
        isSingleMediaPost: false,
        isMultiMediaPost: true,
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
                Navigator.pop(context);
              },
            ));
  }

  galleryCallback(List<XFile> imgFileList, bool imageType) {
    if (imgFileList.isEmpty) {
      return;
    }
    List<String> imagePaths = [];
    for (var image in imgFileList) {
      widget.imagePaths.add(image.path);
    }
    if (imagePaths.isNotEmpty) {
    } else {}
    setState(() {});
  }

  createGalleryMoment() async {
    if (widget.imagePaths.length < 10) {
      int totalCount = widget.imagePaths.length;
      selectionGalleryImagesForMoments(context, galleryCallback, totalCount);
    } else {
      showAlertMessage(context, false);
    }
  }

  Widget buildBookmarkToggleButton({
    required VoidCallback onSave,
    required VoidCallback onRemove,
  }) {
    final isBookmarked = personalEventActivityId > 0;
    return IconButton(
      padding: EdgeInsets.only(bottom: 4.h),
      alignment: Alignment.center,
      enableFeedback: true,
      icon: Image.asset(
        isBookmarked ? TImageName.bookMarkFillIcon : TImageName.bookMarkOutlinedIcon,
        width: 20.w,
        height: 20.h,
      ),
      onPressed: () {
        if (isBookmarked) {
          onRemove();
        } else {
          onSave();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalEventCtr = ref.watch(personalEventHomeController);
    return GestureDetector(
      onTap: onScreenTap,
      child: Scaffold(
        backgroundColor: TAppColors.eventScaffoldColor,
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              CustomAppBar(
                rightWidget: (personalEventCtr
                                .homePersonalEventDetailsModel?.personalEventActivityList?.length ??
                            0) >
                        0
                    ? buildBookmarkToggleButton(onSave: () {
                        saveBookMarked();
                      }, onRemove: () {
                        removeBookMark();
                      })
                    : const SizedBox(),
                color: TAppColors.eventScaffoldColor,
                textColor: Colors.white,
                onTap: () {},
                title: TLabelStrings.newMoment,
                hasSubTitle: true,
                subtitle: widget.eventTitle ?? '',
                prefixWidget: iconButton(
                  bgColor: TAppColors.text4Color,
                  iconPath: TImageName.back,
                  radius: 24.h,
                  onPressed: () {
                    showAlertMessage(context, true);
                    //showAlertMessage(context);
                  },
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.file(
                        File(widget.imagePaths[selectedImage]),
                        width: 1.sh,
                        fit: BoxFit.cover,
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
                                if (selectedImage != widget.imagePaths.length - 1)
                                  Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () {
                                          setState(() {
                                            selectedImage < widget.imagePaths.length - 1
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
                          itemCount: widget.imagePaths.length + 1, // +1 to accommodate "+" button
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              // ✅ Add "+" Button at the First Index
                              return GestureDetector(
                                onTap: () {
                                  createGalleryMoment();
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
                                    // Center the icon
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
                                      image: FileImage(File(widget.imagePaths[imageIndex])),
                                      fit: BoxFit.cover, // ✅ Ensures full coverage
                                      alignment: Alignment.center, // ✅ Keeps image centered
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4.r),
                                        child: Image.file(
                                          File(widget.imagePaths[imageIndex]),
                                          width: 90.w,
                                          height: 80.h,
                                          fit: BoxFit
                                              .cover, // ✅ Ensures the image fills properly without distortion
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (widget.imagePaths.length > 1) {
                                                widget.imagePaths.removeAt(imageIndex);
                                              } else {
                                                Navigator.pop(context);
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
                                              size: 16,
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
                    ),

                    // Positioned(
                    //   bottom: 0.h,
                    //   left: 0.h,
                    //   child: Container(
                    //     color: TAppColors.black.withOpacity(0.6),
                    //     height: 80.h,
                    //     width: 1.sw,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.horizontal,
                    //       padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                    //       shrinkWrap: false,
                    //       physics: const BouncingScrollPhysics(),
                    //       itemCount: widget.imagePaths.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return GestureDetector(
                    //           onTap: () {
                    //             setState(() {
                    //               selectedImage = index;
                    //             });
                    //           },
                    //           child: Container(
                    //             margin:
                    //                 EdgeInsets.only(right: 8.0.w), // Adjust spacing between images
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(5.r),
                    //               border: selectedImage == index
                    //                   ? Border.all(
                    //                       color: TAppColors.white.withOpacity(0.5), // Border color
                    //                       width: 2.0.w, // Border width
                    //                     )
                    //                   : null,
                    //             ),
                    //             child: Stack(
                    //               children: [
                    //                 ClipRRect(
                    //                   borderRadius: BorderRadius.circular(4.r),
                    //                   child: Image.file(
                    //                     File(widget.imagePaths[index]),
                    //                     width: 60.w,
                    //                     height: 58.h,
                    //                     fit: BoxFit.cover, // Adjust the fit based on your needs
                    //                   ),
                    //                 ),
                    //                 Positioned(
                    //                   top: 4, // Adjust position as needed
                    //                   right: 4,
                    //                   child: GestureDetector(
                    //                     onTap: () {
                    //                       // Handle image removal logic here
                    //                       setState(() {
                    //                         if (widget.imagePaths.length > 1) {
                    //                           widget.imagePaths.removeAt(index);
                    //                         } else {
                    //                           Navigator.pop(context);
                    //                         }
                    //                       });
                    //                     },
                    //                     child: Container(
                    //                       padding: EdgeInsets.all(4),
                    //                       decoration: BoxDecoration(
                    //                         color: Colors.black
                    //                             .withOpacity(0.6), // Semi-transparent background
                    //                         shape: BoxShape.circle,
                    //                       ),
                    //                       child: const Icon(
                    //                         Icons.close,
                    //                         color: Colors.white,
                    //                         size: 16, // Adjust size
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // )
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
                            onTap: createMoment,
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
