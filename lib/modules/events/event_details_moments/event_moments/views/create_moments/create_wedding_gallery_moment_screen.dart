import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/custom_textfield.dart';
import '../../../../../../common/common_functions/get_file_extension.dart';
import '../../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_create_post_moment_post_model.dart';
import '../../../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../../../controller/occasion_event_memories_controller.dart';

class CreateWeddingGalleryMomentScreen extends ConsumerStatefulWidget {
  const CreateWeddingGalleryMomentScreen(
      {super.key,
      required this.eventHeaderId,
      required this.eventTitle,
      required this.token,
      required this.imagePaths});
  final List<String> imagePaths;
  final String? token, eventTitle;
  final int? eventHeaderId;

  @override
  ConsumerState<CreateWeddingGalleryMomentScreen> createState() =>
      _CreateWeddingGalleryMomentScreenState();
}

class _CreateWeddingGalleryMomentScreenState
    extends ConsumerState<CreateWeddingGalleryMomentScreen> {
  int selectedImage = 0;
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();

  createMoment() async {
    // List<File> filePaths = widget.imagePaths.map((e) => File(e)).toList();
    // List<String> encodedPaths = filePaths.map((e) => base64.encode(utf8.encode(e.path))).toList();
    List<String> extensions = widget.imagePaths.map((e) => getFileExtension(path: e)).toList();
    List<Uint8List?> stringPPic = await Future.wait(widget.imagePaths.map((e) async {
      return await ImagePickerBottomSheet.compressFile(File(e));
    }));

    List<String> encodedPaths = stringPPic.map((e) => base64.encode(e!)).toList();

    OccasionCreatePostMemoryPostModel model = OccasionCreatePostMemoryPostModel(
      createdOn: DateTime.now(),
      background: null,
      eventTypeMasterId: 1,
      occasionId: widget.eventHeaderId ?? 0,
      postNote: commentController.text,
    );

    await ref.read(occasionEventMemoriesController).writeEventMemoryPost(
        createEventMemoryPostModel: model,
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
      Navigator.pop(context);
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
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 1.sh * 0.04, 14.w, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    topPaddingIphone(topPadding: 0.h),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ETopBackButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          constraints: BoxConstraints(maxWidth: 0.8.sw),
                          child: Text(
                            TLabelStrings.newMoment,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style:
                                getSemiBoldStyle(fontSize: MyFonts.size22, color: TAppColors.white),
                          ),
                        ),
                        SizedBox(
                          width: 21.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        return Container(
                          constraints: BoxConstraints(maxWidth: 0.8.sw),
                          child: Text(
                            widget.eventTitle ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style:
                                getRegularStyle(fontSize: MyFonts.size16, color: TAppColors.white),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
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
                        height: 72.h,
                        width: 1.sw,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.h),
                          shrinkWrap: false,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.imagePaths.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage = index;
                                });
                              },
                              child: Container(
                                margin:
                                    EdgeInsets.only(right: 8.0.w), // Adjust spacing between images
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.r),
                                  border: selectedImage == index
                                      ? Border.all(
                                          color: TAppColors.white
                                              .withOpacity(0.5), // Specify the border color
                                          width: 2.0.w, // Specify the border width
                                        )
                                      : null,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.r),
                                  child: Image.file(
                                    File(widget.imagePaths[index]),
                                    width: 54.w,
                                    height: 58.h,
                                    fit: BoxFit.cover, // Adjust the fit based on your needs
                                  ),
                                ),
                              ),
                            );
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
