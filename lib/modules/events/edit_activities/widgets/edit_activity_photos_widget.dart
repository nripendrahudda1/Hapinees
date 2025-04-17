import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Happinest/models/create_event_models/activity_photo_response_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_activity_photo_phost_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:Happinest/modules/events/edit_activities/controllers/update_activity_controller.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_imports/apis_commons.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../gallery/media_pop.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';

class EditActivityPhotosWidget extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel homePersonalEventDetailsModel;
  final PersonalEventActivityList personalEventActivityModel;
  final Function(String imageExtension) bgExt;
  final Function(String image) bgImage;
  const EditActivityPhotosWidget( {
    super.key,
    required this.homePersonalEventDetailsModel,
    required this.personalEventActivityModel,
    required this.bgExt,
    required this.bgImage,
  });

  @override
  ConsumerState<EditActivityPhotosWidget> createState() =>
      _EditActivityPhotosWidgetState();
}

class _EditActivityPhotosWidgetState
    extends ConsumerState<EditActivityPhotosWidget> {
  List<String> activityPhotosUrl = [];
  List<String> activityPhotosPath = [];
  List<String> tempPhotosPath = [];

  @override
  void initState() {
    super.initState();
    activityPhotosUrl = [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      ref.watch(editActivityExpandedCtr).setPhotosUnExpanded();
      await ref.read(updateActivityController).getActivityImages(
          personalEventActivityId: widget.personalEventActivityModel.personalEventActivityId.toString() ?? '20',
          context: context, ref: ref);
      activityPhotosUrl = ref.read(updateActivityController).activityImages;
    });
  }



  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpansion() {
    if(ref.watch(editActivityExpandedCtr).photosExpanded){
      ref.watch(editActivityExpandedCtr).setPhotosUnExpanded();
    }else{
      ref.watch(editActivityExpandedCtr).setPhotosExpanded();
    }
  }

  void _deleteImage(int index)async {
    if (index < activityPhotosUrl.length) {
      final updateActivityCtr = ref.read(updateActivityController);
      if(updateActivityCtr.activityImagesModel!= null && updateActivityCtr.activityImagesModel?.personalEventActivityPhotos != null && updateActivityCtr.activityImagesModel?.personalEventActivityPhotos?.length!= 0){
        PersonalEventActivityPhoto model =  updateActivityCtr.activityImagesModel!.personalEventActivityPhotos![index];
        await ref.read(updateActivityController).deletePersonalEventActivityPhoto(
          personalEventActivityPhotoId: model.personalEventActivityPhotoId.toString(),
          context: context,
          ref: ref,
        );
        activityPhotosUrl.removeAt(index);

        setState(() {
        });
      }

    } else {
      activityPhotosPath.removeAt(index - activityPhotosUrl.length);
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
                ref.watch(editActivityExpandedCtr).photosExpanded
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
                  title: ref.watch(editActivityExpandedCtr).photosExpanded
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
                      : activityPhotosUrl.isNotEmpty ||
                      activityPhotosPath.isNotEmpty
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
                        itemCount: activityPhotosUrl.length +
                            activityPhotosPath.length <
                            3
                            ? activityPhotosUrl.length +
                            activityPhotosPath.length
                            : 3,
                        itemBuilder:
                            (BuildContext context, int index) {
                          return Stack(
                            children: [
                              if (index < activityPhotosUrl.length)
                                CachedRectangularNetworkImageWidget(
                                  image: activityPhotosUrl[index],
                                  width: 200.w,
                                  height: 200.h,
                                  radius: 8.r,
                                ),
                              if (!(index < activityPhotosUrl.length))
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(8.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8.r),
                                    child: Image.file(
                                      File(activityPhotosPath[index -
                                          activityPhotosUrl.length]),
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
                                      activityPhotosUrl.length +
                                          activityPhotosPath
                                              .length >
                                          3
                                          ? "${activityPhotosUrl.length + activityPhotosPath.length - 3}+"
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
                if (ref.watch(editActivityExpandedCtr).photosExpanded)
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
                                  activityPhotosUrl.length +
                                  activityPhotosPath.length,
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
                                    if (index - 1 < activityPhotosUrl.length)
                                      CachedRectangularNetworkImageWidget(
                                        image: activityPhotosUrl[index - 1],
                                        width: 200.w,
                                        height: 200.h,
                                        radius: 8.r,
                                      ),
                                    if (!(index - 1 < activityPhotosUrl.length))
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8.r),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(8.r),
                                          child: Image.file(
                                            File(activityPhotosPath[index -
                                                1 -
                                                activityPhotosUrl.length]),
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



    SetPersonalEventActivityPhotoPostModel model = SetPersonalEventActivityPhotoPostModel(
        personalEventHeaderId: widget.homePersonalEventDetailsModel.personalEventHeaderId,
        createdOn: DateTime.now(),
        imageData: base64.encode(stringPPic!),
        imageExtention: getFileExtension(path: path),
        personalEventActivityId: widget.personalEventActivityModel.personalEventActivityId
    );

    // print(widget.weddingRitualModel.weddingRitualId);
    await ref.read(updateActivityController).setPersonalEventActivityPhoto(
        setPersonalEventActivityPhotoPostModel: model,
        context: context,
        ref: ref,
      onSuccess: () {
        setState(() {
          activityPhotosPath.add(path);
        });
        widget.bgExt(getFileExtension(path: path));

        widget.bgImage(base64.encode(stringPPic));
      },
    );

  }
}