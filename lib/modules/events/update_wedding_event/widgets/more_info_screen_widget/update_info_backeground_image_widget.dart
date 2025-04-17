import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_more_info_expanded_controller.dart';
import '../../../../../common/common_functions/get_file_extension.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../gallery/media_pop.dart';
import '../../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../../../../../utility/constants/images/image_url.dart';

class UpdateInfoBackgroundImageWidget extends ConsumerStatefulWidget {
  final String? imgUrl;
  final Function(String imageExtension) bgExt;
  final Function(String image) bgImage;
  const UpdateInfoBackgroundImageWidget({
    super.key,
    this.imgUrl,
    required this.bgExt,
    required this.bgImage,
  });

  @override
  ConsumerState<UpdateInfoBackgroundImageWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<UpdateInfoBackgroundImageWidget> {
  String? imagePath;
  String? imageUrl;
  String cleanedFileName = '';
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
    if (widget.imgUrl != null) {
      imageUrl = widget.imgUrl;
    } else {
      imageUrl = null;
    }
    // Replace backslashes with forward slashes for consistency
    imageUrl = imageUrl!.replaceAll("\\", "/");
    // Extract the last part after the last "/"
    String fileName = imageUrl!.split("/").last;
    cleanedFileName = fileName.replaceFirst("PersonalEventBackgroundImage", "");
    print("---imagePath---${widget.imgUrl}");
    print("---imagePath---${imageUrl}");
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(updateEventMoreInfoExpandedCtr).setBgImageUnExpanded();
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventMoreInfoExpandedCtr).bgImageExpanded) {
      ref.read(updateEventMoreInfoExpandedCtr).setBgImageUnExpanded();
    } else {
      ref.read(updateEventMoreInfoExpandedCtr).setBgImageExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: TAppColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventMoreInfoExpandedCtr).bgImageExpanded
                    ? BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      )
              ]),
          child: ListTileTheme(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(updateEventMoreInfoExpandedCtr).bgImageExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TLabelStrings.addBackground,
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : imagePath != null || imageUrl != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  TLabelStrings.addBackground,
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 330.w),
                                  child: Text(
                                    cleanedFileName,
                                    maxLines: 2,
                                    style: getBoldStyle(
                                      fontSize: MyFonts.size14,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Background Image (Optional)",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventMoreInfoExpandedCtr).bgImageExpanded)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        imageUrl != null && imagePath == null
                            ? Stack(
                                children: [
                                  Center(
                                    child: CachedRectangularNetworkImageWidget(
                                      image: imageUrl != '' && imageUrl != null ? imageUrl! : "",
                                      fit: BoxFit.fitHeight,
                                      // fit: BoxFit.fitWidth,
                                      width: 1.sw,
                                      height: 1.sw,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: GestureDetector(
                                      onTap: () {
                                        selectionModalBottomSheet(
                                            context, callback, true, false, 0);
                                      },
                                      child: Center(
                                        child: Image.asset(
                                          TImageName.cameraPngIcon,
                                          height: 48.h,
                                          width: 48.w,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : imagePath == null
                                ? GestureDetector(
                                    onTap: () {
                                      selectionModalBottomSheet(context, callback, true, false, 0);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: TAppColors.white,
                                          borderRadius: BorderRadius.circular(10.r),
                                          border: Border.all(color: TAppColors.lightBorderColor)),
                                      width: imagePath == null ? double.infinity : null,
                                      height: imagePath == null ? 200.h : null,
                                      alignment: Alignment.center,
                                      child: const Text('Add background image'),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Center(
                                          child: Image.file(
                                        File(imagePath!),
                                        fit: BoxFit.fitHeight,
                                      )),
                                      Positioned.fill(
                                        child: GestureDetector(
                                          onTap: () {
                                            selectionModalBottomSheet(
                                                context, callback, true, false, 0);
                                          },
                                          child: Center(
                                            child: Image.asset(
                                              TImageName.cameraPngIcon,
                                              height: 48.h,
                                              width: 48.w,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void callback(List<XFile> imgFileList, bool imageType) {
    setFilePath(imgFileList, imageType);
  }

  // Set image Path ---
  setFilePath(List<XFile> imgFileList, bool imageType) async {
    var imageFile = imgFileList[0];
    var path = imageFile.path;
    File filePath = File(path);
    String encoded = base64.encode(utf8.encode(filePath.path));
    // ignore: use_build_context_synchronously
    // if (path != null) {
    //   setState(() {
    //     imagePath = path;
    //   });
    // } else {}
    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(path));
    setState(() {
      imagePath = path;
      imageUrl = null;
      print(base64.encode(stringPPic!));
    });
    widget.bgExt(getFileExtension(path: path));
    widget.bgImage(base64.encode(stringPPic!));
  }
}
