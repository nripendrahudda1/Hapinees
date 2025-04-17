import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/image_picker.dart';
import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_functions/pdf_picker.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/bottom_sheet_component.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../../create_event/widgets/info_bottom_sheet_component.dart';
import '../../create_event/widgets/upload_pdf_widget.dart';
import '../controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';

class InfoUploadInvitationWidget extends ConsumerStatefulWidget {
  final Function(String imageExtension) invitationExt;
  final Function(String image) invitationPath;
  const InfoUploadInvitationWidget({
    super.key,
     required this.invitationExt,
    required this.invitationPath,
  });

  @override
  ConsumerState<InfoUploadInvitationWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<InfoUploadInvitationWidget> {
  String? filePath;

  void _toggleExpansion() {
    if (ref.watch(createEventMoreInfoExpandedCtr).invitationExpanded) {
      ref
          .watch(createEventMoreInfoExpandedCtr)
          .setInvitationUnExpanded();
    } else {
      ref.watch(createEventMoreInfoExpandedCtr).setInvitationExpanded();
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
              border:
                  Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref
                        .watch(createEventMoreInfoExpandedCtr)
                        .invitationExpanded
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref
                          .watch(createEventMoreInfoExpandedCtr)
                          .invitationExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Upload The Invitation",
                              style: getEventFieldTitleStyle(color: TAppColors.text2Color,fontSize: 16,fontWidth: FontWeightManager.regular),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : filePath != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Invitation",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 330.w
                                  ),
                                  child: Text(
                                    filePath!
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
                          : Container(
                              constraints: BoxConstraints(maxWidth: 311.w),
                              child: Text(
                                "Invitation (Optional)",
                                style: getRegularStyle(
                                    fontSize: MyFonts.size14,
                                    color: TAppColors.text2Color),
                              ),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref
                    .watch(createEventMoreInfoExpandedCtr)
                    .invitationExpanded)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        UplaoadFile(
                          hintText: 'Upload pdf or jpg file',
                          onTap: () {
                            bottomSheetComponent(
                              context: context,
                              child: InfoBottomSheetComponent(
                                onCameraTapped: () async {
                                  String? image = await getCameraImage();
                                  Navigator.pop(context);
                                  _toggleExpansion();
                                  if(image!= null){
                                    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(image));
                                    widget.invitationExt(getFileExtension(path: image));
                                    widget.invitationPath(base64.encode(stringPPic!));
                                    setState(() {
                                      filePath = image;
                                    });
                                  }
                                },
                                onGalleryTapped: () async {
                                  String? image = await getGalleryImage();
                                  Navigator.pop(context);
                                  _toggleExpansion();
                                  if(image!= null){
                                    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(image));
                                    widget.invitationExt(getFileExtension(path: image));
                                    widget.invitationPath(base64.encode(stringPPic!));
                                    setState(() {
                                      filePath = image;
                                    });
                                  }
                                },
                                onPdfTapped: () async {
                                  String? pdf = await getPdf();
                                  Navigator.pop(context);
                                  setState(() {
                                    filePath = pdf;
                                  });
                                  _toggleExpansion();
                                  if(pdf!= null){
                                    // Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(pdf));
                                    List<int> imageBytes = File(pdf).readAsBytesSync();
                                    widget.invitationExt(getFileExtension(path: pdf));
                                    // widget.invitationPath(pdf);
                                    widget.invitationPath(base64.encode(imageBytes));
                                    setState(() {
                                      filePath = pdf;
                                    });
                                  }
                                },
                              ),
                            );
                          },
                          iconpath: TImageName.uploadIcon,
                          fileName: filePath?.split(
                                    "/",
                                  )
                                  .last,
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
}
