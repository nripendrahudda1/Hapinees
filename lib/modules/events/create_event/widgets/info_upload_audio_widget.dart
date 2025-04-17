import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/common_audio_pciker.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';
import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../create_event/widgets/upload_pdf_widget.dart';

class InfoUploadAudioWidget extends ConsumerStatefulWidget {
    final Function(String audioExten) audioExt;
    final Function(String audioPath) audioPath;
  const InfoUploadAudioWidget({
    super.key,
    required this.audioExt,
    required this.audioPath,
  });

  @override
  ConsumerState<InfoUploadAudioWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<InfoUploadAudioWidget> {
  String? audioPath;

  final title = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(createEventMoreInfoExpandedCtr).bgMusicExpanded) {
      ref.watch(createEventMoreInfoExpandedCtr).setBgMusicUnExpanded();
    } else {
      ref.watch(createEventMoreInfoExpandedCtr).setBgMusicExpanded();
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
                ref.watch(createEventMoreInfoExpandedCtr).bgMusicExpanded
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
                          .bgMusicExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Background Music",
                              style:getEventFieldTitleStyle(color: TAppColors.text2Color,fontSize: 16,fontWidth: FontWeightManager.regular),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : audioPath != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Background Music",
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
                                    audioPath!
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
                              "Background Music (Optional)",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref
                    .watch(createEventMoreInfoExpandedCtr)
                    .bgMusicExpanded)
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        UplaoadFile(
                          hintText: 'Upload music',
                          onTap: () async {
                            String? file = await pickAudio();
                            if (file != null) {
                              setState(() {
                                audioPath = file;
                              });
                              File filePath = File(file);
                              List<int> fileBytes = await filePath.readAsBytes();
                              String encoded = base64Encode(fileBytes);
                              // String encoded1 = 'data:audio/${getFileExtension(path: file)};base64,$encoded';

                              widget.audioExt(getFileExtension(path: file));
                              widget.audioPath(encoded);
                            }
                          },
                          iconpath: TImageName.tickIcon,
                          fileName: audioPath?.split(
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
