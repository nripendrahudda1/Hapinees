import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';
import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../gallery/media_pop.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';

class InfoBackgroundImageWidget extends ConsumerStatefulWidget {
  final Function(String imageExtension) bgExt;
  final Function(String image) bgImage;
  const InfoBackgroundImageWidget({
    super.key,
    required this.bgExt,
    required this.bgImage,
  });

  @override
  ConsumerState<InfoBackgroundImageWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<InfoBackgroundImageWidget> {
  String? imagePath;

  final title = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(createEventMoreInfoExpandedCtr).bgImageExpanded) {
      ref.watch(createEventMoreInfoExpandedCtr).setBgImageUnExpanded();
    } else {
      ref.watch(createEventMoreInfoExpandedCtr).setBgImageExpanded();
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
                ref.watch(createEventMoreInfoExpandedCtr).bgImageExpanded
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
                  title: ref.watch(createEventMoreInfoExpandedCtr).bgImageExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Background Image",
                                style: getEventFieldTitleStyle(
                                    color: TAppColors.text2Color,
                                    fontSize: 16,
                                    fontWidth: FontWeightManager.regular)),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : imagePath != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Background Image",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 330.w),
                                  child: Text(
                                    imagePath!
                                        .split(
                                          "/",
                                        )
                                        .last,
                                    overflow: TextOverflow.ellipsis,
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
                if (ref.watch(createEventMoreInfoExpandedCtr).bgImageExpanded)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        imagePath == null
                            ? GestureDetector(
                                onTap: () {
                                  selectionModalBottomSheet(context, callback, true, true, 0);
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
    widget.bgExt(getFileExtension(path: path));
    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(path));
    setState(() {
      imagePath = path;
      print(base64.encode(stringPPic!));
    });
    widget.bgExt(getFileExtension(path: path));
    widget.bgImage(base64.encode(stringPPic!));
  }
}
