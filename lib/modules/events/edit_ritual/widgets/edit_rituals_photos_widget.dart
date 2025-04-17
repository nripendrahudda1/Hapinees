import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:Happinest/theme/app_colors.dart';
import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../gallery/media_pop.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_ritual_photo_post_model.dart';
import '../../../../models/create_event_models/create_wedding_models/ritual_image_response_model.dart';
import '../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../controllers/edit_ritual_expanded_controller.dart';
import '../controllers/update_ritual_controller.dart';

class EditRitualsPhotosWidget extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel homeWeddingDetailsModel;
  final WeddingRitualList weddingRitualModel;
  final Function(String imageExtension) bgExt;
  final Function(String image) bgImage;
  const EditRitualsPhotosWidget( {
    super.key,
    required this.homeWeddingDetailsModel,
    required this.weddingRitualModel,
    required this.bgExt,
    required this.bgImage,
  });

  @override
  ConsumerState<EditRitualsPhotosWidget> createState() =>
      _EditRitualsPhotosWidgetState();
}

class _EditRitualsPhotosWidgetState
    extends ConsumerState<EditRitualsPhotosWidget> {
  List<String> ritualPhotosUrl = [];
  List<String> ritualPhotosPath = [];
  List<String> tempPhotosPath = [];

  @override
  void initState() {
    super.initState();
    ritualPhotosUrl = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      ref.watch(editRitualExpandedCtr).setPhotosUnExpanded();
      await ref.read(updateRitualController).getRitualImages(weddingRitualId: widget.weddingRitualModel.weddingRitualId.toString() ?? '20', context: context, ref: ref);
    ritualPhotosUrl = ref.read(updateRitualController).ritualImages;
    });
  }



  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpansion() {
    if(ref.watch(editRitualExpandedCtr).photosExpanded){
      ref.watch(editRitualExpandedCtr).setPhotosUnExpanded();
    }else{
      ref.watch(editRitualExpandedCtr).setPhotosExpanded();
    }
  }

  void _deleteImage(int index)async {
      if (index < ritualPhotosUrl.length) {
        final updateRitualCtr = ref.read(updateRitualController);
        if(updateRitualCtr.ritualImagesModel!= null && updateRitualCtr.ritualImagesModel?.weddingRitualPhotos != null && updateRitualCtr.ritualImagesModel?.weddingRitualPhotos?.length!= 0){
          WeddingRitualPhoto model =  updateRitualCtr.ritualImagesModel!.weddingRitualPhotos![index];
          await ref.read(updateRitualController).deleteWeddingRitualPhoto(
            weddingRitualPhotoId: model.weddingRitualPhotoId.toString(),
            context: context,
            ref: ref,
          );
          ritualPhotosUrl.removeAt(index);

          setState(() {
          });
        }

      } else {
        ritualPhotosPath.removeAt(index - ritualPhotosUrl.length);
        setState(() {
        });
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
                ref.watch(editRitualExpandedCtr).photosExpanded
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
                  title: ref.watch(editRitualExpandedCtr).photosExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Photos",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ritualPhotosUrl.isNotEmpty ||
                              ritualPhotosPath.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "Photos",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                GridView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1,
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10.w),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ritualPhotosUrl.length +
                                              ritualPhotosPath.length <
                                          3
                                      ? ritualPhotosUrl.length +
                                          ritualPhotosPath.length
                                      : 3,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: [
                                        if (index < ritualPhotosUrl.length)
                                          CachedRectangularNetworkImageWidget(
                                            image: ritualPhotosUrl[index],
                                            width: 200.w,
                                            height: 200.h,
                                            radius: 8.r,
                                          ),
                                        if (!(index < ritualPhotosUrl.length))
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              child: Image.file(
                                                File(ritualPhotosPath[index -
                                                    ritualPhotosUrl.length]),
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        if (index == 2)
                                          Positioned(
                                              bottom: 5.h,
                                              right: 5.w,
                                              child: Text(
                                                ritualPhotosUrl.length +
                                                            ritualPhotosPath
                                                                .length >
                                                        3
                                                    ? "${ritualPhotosUrl.length + ritualPhotosPath.length - 3}+"
                                                    : "",
                                                style: getBoldStyle(
                                                    fontSize: MyFonts.size18,
                                                    color:
                                                        TAppColors.white),
                                              ))
                                      ],
                                    );
                                  },
                                ),
                              ],
                            )
                          : Text(
                              "Photos",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(editRitualExpandedCtr).photosExpanded)
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10.w),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 1 +
                                  ritualPhotosUrl.length +
                                  ritualPhotosPath.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return InkWell(
                                    onTap: () {
                                      selectionModalBottomSheet(
                                          context, callback, true, false, 0);
                                    },
                                    splashColor: TAppColors.transparent,
                                    child: Image.asset(
                                        TImageName.uploadRitualImage,
                                        width: 200.w,
                                        height: 200.h),
                                  );
                                }
                                return Stack(
                                  children: [
                                    if (index - 1 < ritualPhotosUrl.length)
                                      CachedRectangularNetworkImageWidget(
                                        image: ritualPhotosUrl[index - 1],
                                        width: 200.w,
                                        height: 200.h,
                                        radius: 8.r,
                                      ),
                                    if (!(index - 1 < ritualPhotosUrl.length))
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: Image.file(
                                            File(ritualPhotosPath[index -
                                                1 -
                                                ritualPhotosUrl.length]),
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    Positioned(
                                        top: 5.h,
                                        right: 5.w,
                                        child: InkWell(
                                          onTap: () {
                                            _deleteImage(index -
                                                1); //First index is button
                                          },
                                          splashColor: TAppColors.transparent,
                                          child: Image.asset(
                                            TImageName.cancelDarkIcon,
                                            width: 24.w,
                                            height: 24.h,
                                          ),
                                        ))
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> callback(List<XFile> imgFileList, bool imageType) async {
    for (var imgFile in imgFileList) {
      await setFilePath(imgFile, imageType);
    }
  }

  // Set image Path ---
  setFilePath(XFile imgFile, bool imageType) async {
    var path = imgFile.path;
    File filePath = File(path);
    String encoded = base64.encode(utf8.encode(filePath.path));
    // ignore: use_build_context_synchronously

    Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(path));



    SetWeddingRitualPhotoPostModel model = SetWeddingRitualPhotoPostModel(
      weddingHeaderId: widget.homeWeddingDetailsModel.weddingHeaderId,
      createdOn: DateTime.now(),
      imageData: base64.encode(stringPPic!),
      imageExtention: getFileExtension(path: path),
      weddingRitualId: widget.weddingRitualModel.weddingRitualId
    );

    // print(widget.weddingRitualModel.weddingRitualId);
    await ref.read(updateRitualController).setWeddingRitualPhoto(
        setWeddingRitualPhotoPostModel: model,
        context: context,
        ref: ref,
        onSuccess:() {
          setState(() {
            ritualPhotosPath.add(path);
          });
          widget.bgExt(getFileExtension(path: path));

          widget.bgImage(base64.encode(stringPPic));
        }
    );

    }
}
