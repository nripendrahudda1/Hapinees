import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/wedding_view_post_model.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../e-card/controllers/wedding_event_ecard_controller.dart';
import '../controller/wedding_event_home_controller.dart';
import '../views/wedding_event_comments_screen.dart';

class WeddingEventHomePageSideButtons extends ConsumerStatefulWidget {
  const WeddingEventHomePageSideButtons(
      {super.key,
      required this.isPlaying,
      required this.likes,
      required this.playPause,
      required this.isFav,
      required this.favTap,
      required this.weddingHeaderId,
      required this.backgroundMusicUrl});

  final bool isPlaying;
  final Function() playPause;
  final bool isFav;
  final int likes;
  final int? weddingHeaderId;
  final Function() favTap;
  final String? backgroundMusicUrl;

  @override
  ConsumerState<WeddingEventHomePageSideButtons> createState() =>
      _WeddingEventHomePageSideButtonsState();
}

class _WeddingEventHomePageSideButtonsState extends ConsumerState<WeddingEventHomePageSideButtons> {
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final weddingCtr = ref.watch(weddingEventHomeController);
      await weddingCtr.getAllWeddingLikedUsers(
          weddingHeaderId: widget.weddingHeaderId.toString() ?? '', ref: ref, context: context);
      await weddingCtr.getAllWeddingEventComments(
        weddingHeaderId: widget.weddingHeaderId.toString() ?? '',
        sortByPopular: false,
        offset: 0,
        noOfRecords: 1000,
        ref: ref,
      );

      await weddingCtr.getAllWeddingViews(
        weddingHeaderId: widget.weddingHeaderId.toString() ?? '',
        ref: ref,
      );

      WeddingViewPostModel weddingViewPostModel = WeddingViewPostModel(
        weddingHeaderId: widget.weddingHeaderId ?? 0,
        viewDate: DateTime.now(),
      );
      await weddingCtr.setWeddingView(
        weddingViewPostModel: weddingViewPostModel,
        ref: ref,
      );
    });
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String weddingHeaderId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return WeddingEventCommentsSection(
          weddingHeaderId: weddingHeaderId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final weddingCtr = ref.watch(weddingEventHomeController);
          final eventHomeCtr = ref.watch(weddingEventHomeController);
          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Column(
              children: [
                if (widget.backgroundMusicUrl != null && widget.backgroundMusicUrl != '') ...[
                  GestureDetector(
                    onTap: widget.playPause,
                    child: Image.asset(
                      widget.isPlaying ? TImageName.musicGif : TImageName.musicPngIcon,
                      color: widget.isPlaying ? null : TAppColors.white,
                      width: 24.w,
                      height: 24.h,
                    ),
                  ),
                  verticalSpacing(
                    20.h,
                  ),
                ],
                circularIconBackground(
                  child: GestureDetector(
                    onTap: widget.favTap,
                    child: Image.asset(
                      widget.isFav ? TImageName.heartRedPngIcon : TImageName.heartPngIcon,
                      width: 20.w,
                      height: 18.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                verticalSpacing(
                  3.h,
                ),
                Text(
                  widget.likes.toString(),
                  style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                ),
                verticalSpacing(
                  20.h,
                ),
                circularIconBackground(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.eventCommentsScreen);
                      print('wedding Header ID: ${widget.weddingHeaderId}');
                      listOfComments(
                        weddingHeaderId: widget.weddingHeaderId.toString() ?? '',
                        context: context,
                      );
                    },
                    child: Image.asset(
                      TImageName.commentPngIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                verticalSpacing(
                  3.h,
                ),
                Text(
                  eventHomeCtr.eventCommentModel != null &&
                          eventHomeCtr.eventCommentModel?.comments != null
                      ? eventHomeCtr.eventCommentModel!.comments!.length.toString()
                      : weddingCtr.homeWeddingDetails != null &&
                              weddingCtr.homeWeddingDetails?.comments!.toString() != null
                          ? weddingCtr.homeWeddingDetails!.comments!.toString()
                          : "0",
                  style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                ),
                verticalSpacing(
                  20.h,
                ),
                circularIconBackground(
                  child: Image.asset(
                    TImageName.eyePngIcon,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                verticalSpacing(
                  3.h,
                ),
                Text(
                  eventHomeCtr.weddingViewsModel != null &&
                          eventHomeCtr.weddingViewsModel?.weddingViewUsers != null
                      ? eventHomeCtr.weddingViewsModel!.weddingViewUsers!.length.toString()
                      : weddingCtr.homeWeddingDetails?.views?.toString() ?? "0",
                  style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                ),
                verticalSpacing(
                  10.h,
                ),
                if (weddingCtr.homeWeddingDetails?.backgroundImageUrl != null ||
                    weddingCtr.homeWeddingDetails?.backgroundImageUrl != '')
                  verticalSpacing(
                    20.h,
                  ),
                circularIconBackground(
                  child: IconButton(
                    //padding: EdgeInsets.only(left: 5.w),
                    alignment: Alignment.center,
                    enableFeedback: true,
                    icon: Image.asset(
                      ref.read(weddingEventHomeController).userRoleEnum.type ==
                              UserRoleEnum.PublicUser.type
                          ? TImageName.sharePngIcon
                          : TImageName.shareBoxedPngIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                    onPressed: () async {
                      final backgroundImageUrl = weddingCtr.homeWeddingDetails?.backgroundImageUrl;
                      print(
                          "weddingCtr.homeWeddingDetails?.backgroundImageUrl  $backgroundImageUrl");
                      await ref.watch(weddingEventECardCtr).setCurrentImage(backgroundImageUrl);
                      Navigator.pushNamed(context, Routes.weddingECardScreen,
                          arguments: {'isSingleImage': false});
                      // ref.read(weddingEventECardCtr).fetchAllWeddingImages(
                      //     ref: ref,
                      //     context: context,
                      //     weddingHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString() ?? ''
                      // );
                    },
                  ),
                ),
                verticalSpacing(
                  10.h,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ✅ Adds a Circular Background for Better Visibility
Widget circularIconBackground({required Widget child}) {
  return Container(
    width: 40.w, // Ensure fixed width
    height: 40.h, // Ensure fixed height
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.3), // Dark background with transparency
      shape: BoxShape.circle, // Circular shape
    ),
    child: Center(child: child), // ✅ Center-align icon
  );
}

/// ✅ Helper for Vertical Spacing
Widget verticalSpacing(double height) {
  return SizedBox(height: height);
}

/// ✅ Helper for Text Styling
Widget textWidget(String text) {
  return Text(
    text,
    style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
  );
}
