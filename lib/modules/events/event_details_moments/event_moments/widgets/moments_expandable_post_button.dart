import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Happinest/gallery/select_camera_image_for_moments.dart';

import '../../../../../common/common_imports/common_imports.dart';

import '../../../../../gallery/select_multiple_images_for_moments.dart';

class MomentsExpandablePostButton extends StatefulWidget {
  final String? token, eventTitle;
  final int? eventHeaderId;
  final bool isPersonalEvent;
  final VoidCallback? onRefresh;
  const MomentsExpandablePostButton(
      {super.key,
      required GlobalKey<ExpandableFabState> fabKey,
      required this.token,
      this.onRefresh,
      required this.eventHeaderId,
      required this.eventTitle,
      required this.isPersonalEvent})
      : _key = fabKey;

  final GlobalKey<ExpandableFabState> _key;

  @override
  State<MomentsExpandablePostButton> createState() => _MomentsExpandablePostButtonState();
}

class _MomentsExpandablePostButtonState extends State<MomentsExpandablePostButton> {
  createImageMoment() async {
    selectionCameraImageForMoments(context, cameraCallback, 0);
    _closeFab();
  }

  createGalleryMoment() async {
    selectionGalleryImagesForMoments(context, galleryCallback, 0);
    _closeFab();
  }

  void _closeFab() {
    widget._key.currentState?.toggle(); // Closes the FAB if it's open
  }

  cameraCallback(List<XFile> imgFileList, bool imageType) {
    var imageFile = imgFileList[0];
    var path = imageFile.path;
    if (widget.isPersonalEvent) {
      Navigator.pushNamed(context, Routes.createPersonalEventCameraMomentScreen, arguments: {
        'imagePath': path,
        'token': widget.token,
        'eventHeaderId': widget.eventHeaderId,
        'eventTitle': widget.eventTitle
      }).then((result) {
        if (result == true) {
          // Refresh the state after returning
          setState(() {
            widget.onRefresh!();
          });
        }
      });
    } else {
      Navigator.pushNamed(context, Routes.createWeddingCameraMomentScreen, arguments: {
        'imagePath': path,
        'token': widget.token,
        'eventHeaderId': widget.eventHeaderId,
        'eventTitle': widget.eventTitle
      });
    }
  }

  galleryCallback(List<XFile> imgFileList, bool imageType) {
    if (imgFileList.isEmpty) {
      return;
    }
    List<String> imagePaths = [];
    for (var image in imgFileList) {
      imagePaths.add(image.path);
    }

    if (imagePaths.isNotEmpty) {
      if (widget.isPersonalEvent) {
        Navigator.pushNamed(context, Routes.createPersonalEventGalleryMomentScreen, arguments: {
          'imagePaths': imagePaths,
          'token': widget.token,
          'eventHeaderId': widget.eventHeaderId,
          'eventTitle': widget.eventTitle
        }).then((result) {
          if (result == true) {
            // Refresh the state after returning
            setState(() {
              widget.onRefresh!();
            });
          }
        });
      } else {
        Navigator.pushNamed(context, Routes.createWeddingGalleryMomentScreen, arguments: {
          'imagePaths': imagePaths,
          'token': widget.token,
          'eventHeaderId': widget.eventHeaderId,
          'eventTitle': widget.eventTitle
        });
      }
    } else {}
  }

  createTextMoment() {
    if (widget.isPersonalEvent) {
      Navigator.pushNamed(context, Routes.createPersonalEventTextMomentScreen, arguments: {
        'token': widget.token,
        'eventHeaderId': widget.eventHeaderId,
        'eventTitle': widget.eventTitle
      }).then((result) {
        if (result == true) {
          // Refresh the state after returning
          setState(() {
            widget.onRefresh!();
          });
        }
      });
    } else {
      Navigator.pushNamed(context, Routes.createWeddingTextMomentScreen, arguments: {
        'token': widget.token,
        'eventHeaderId': widget.eventHeaderId,
        'eventTitle': widget.eventTitle
      });
    }
    _closeFab();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      key: widget._key,
      type: ExpandableFabType.up,
      distance: 50.h,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: Image.asset(
          TImageName.plusOrangeIcon,
          width: 18.w,
          height: 18.h,
        ),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: TAppColors.black.withOpacity(0.8),
        shape: const CircleBorder(),
        angle: 3.14,
      ),
      closeButtonBuilder: RotateFloatingActionButtonBuilder(
        child: Image.asset(
          TImageName.crossOrangeIcon,
          width: 18.w,
          height: 18.h,
        ),
        fabSize: ExpandableFabSize.regular,
        backgroundColor: TAppColors.black.withOpacity(0.8),
        shape: const CircleBorder(),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(right: 5.w, bottom: 10.h),
          child: FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            backgroundColor: TAppColors.black.withOpacity(0.5),
            onPressed: createTextMoment,
            child: Image.asset(
              TImageName.chatOrangeIcon,
              width: 22.w,
              height: 22.h,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5.w, bottom: 10.h),
          child: FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            backgroundColor: TAppColors.black.withOpacity(0.5),
            onPressed: createImageMoment,
            child: Image.asset(
              TImageName.cameraOrangeIcon,
              width: 18.w,
              height: 18.h,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 5.w, bottom: 10.h),
          child: FloatingActionButton.small(
            shape: const CircleBorder(),
            heroTag: null,
            backgroundColor: TAppColors.black.withOpacity(0.5),
            onPressed: createGalleryMoment,
            child: Image.asset(
              TImageName.galleryOrangeIcon,
              width: 18.w,
              height: 18.h,
            ),
          ),
        ),
      ],
    );
  }
}
