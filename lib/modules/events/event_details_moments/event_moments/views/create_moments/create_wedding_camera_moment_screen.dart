import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/custom_textfield.dart';

import '../../../../../../common/common_functions/get_file_extension.dart';
import '../../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_create_post_moment_post_model.dart';
import '../../../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../../../controller/occasion_event_memories_controller.dart';

class CreateWeddingCameraMomentScreen extends ConsumerStatefulWidget {
  const CreateWeddingCameraMomentScreen({super.key,required this.eventTitle, required this.imagePath,required this.token,required this.eventHeaderId});
  final String imagePath;
  final String? token, eventTitle;
  final int? eventHeaderId;

  @override
  ConsumerState<CreateWeddingCameraMomentScreen> createState() =>
      _CreateWeddingCameraMomentScreenState();
}

class _CreateWeddingCameraMomentScreenState extends ConsumerState<CreateWeddingCameraMomentScreen> {
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();

  createMoment()async {

    File filePath = File(widget.imagePath);
    String encoded = base64.encode(utf8.encode(filePath.path));
    // ignore: use_build_context_synchronously

      Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(widget.imagePath));



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
        mediaData: base64.encode(stringPPic!),
        mediaExtension: getFileExtension(path: widget.imagePath),
        isSingleMediaPost:  true,
        isMultiMediaPost: false,
        isTextPost: false,
        context: context,
        ref: ref
    );
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
                            "New Moment",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: getSemiBoldStyle(
                                fontSize: MyFonts.size22,
                                color: TAppColors.white),
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
                          child: Text(widget.eventTitle ?? '',
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                                fontSize: MyFonts.size16,
                                color: TAppColors.white),
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
                child: Image.file(
                  File(widget.imagePath),
                  width: 1.sh,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isKeyBoardFocus ? 0.w : 10.w),
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
                              TImageName.sendNew,
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
