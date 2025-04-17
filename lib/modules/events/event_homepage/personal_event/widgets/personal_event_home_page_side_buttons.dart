import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/personal_event_view_post_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/views/personal_event_comments_screen.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../e-card/controllers/personal_event_ecard_controller.dart';

class PersonalEventHomePageSideButtons extends ConsumerStatefulWidget {
  const PersonalEventHomePageSideButtons(
      {super.key,
      required this.isPlaying,
      required this.likes,
      required this.playPause,
      required this.isFav,
      required this.favTap,
      required this.personalEventHeaderId,
      required this.backgroundMusicUrl});

  final bool isPlaying;
  final Function() playPause;
  final bool isFav;
  final int likes;
  final int? personalEventHeaderId;
  final Function() favTap;
  final String? backgroundMusicUrl;

  @override
  ConsumerState<PersonalEventHomePageSideButtons> createState() =>
      _PersonalEventHomePageSideButtonsState();
}

class _PersonalEventHomePageSideButtonsState
    extends ConsumerState<PersonalEventHomePageSideButtons> {
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final personalEventCtr = ref.watch(personalEventHomeController);
      print(
          "personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId.toString() **** ${widget.personalEventHeaderId}");
      await ref.read(personalEventHomeController).getAllPersonalEventLikedUsers(
          eventHeaderId: widget.personalEventHeaderId.toString() ?? '', ref: ref, context: context);
      await ref.watch(personalEventHomeController).getAllPersonalEventComments(
            personalEventHeaderId: widget.personalEventHeaderId.toString() ?? '',
            shortByPopular: false,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );

      await ref.watch(personalEventHomeController).getAllPersonalEventViews(
          personalEventHeaderId: widget.personalEventHeaderId.toString() ?? '',
          ref: ref,
          context: context);

      PersonalEventViewPostModel personalEventViewPostModel = PersonalEventViewPostModel(
        personalEventHeaderId: widget.personalEventHeaderId ?? 0,
        viewDate: DateTime.now(),
      );
      await ref.watch(personalEventHomeController).setPersonalEventView(
          personalEventViewPostModel: personalEventViewPostModel, ref: ref, context: context);
    });
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String personalEventHeaderId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return PersonalEventCommentsSection(
          personalEventHeaderId: personalEventHeaderId,
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
          final personalEventCtr = ref.watch(personalEventHomeController);

          return Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Column(
              children: [
                if (widget.backgroundMusicUrl?.isNotEmpty ?? false) ...[
                  GestureDetector(
                    onTap: widget.playPause,
                    child: circularIconBackground(
                      child: Image.asset(
                        widget.isPlaying ? TImageName.musicGif : TImageName.musicPngIcon,
                        color: widget.isPlaying ? null : TAppColors.white,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                  ),
                  verticalSpacing(10.h),
                ],
                GestureDetector(
                  onTap: widget.favTap,
                  child: circularIconBackground(
                    child: Image.asset(
                      widget.isFav ? TImageName.heartRedPngIcon : TImageName.heartPngIcon,
                      width: 20.w,
                      height: 18.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                verticalSpacing(3.h),
                textWidget(widget.likes.toString()),
                verticalSpacing(10.h),
                GestureDetector(
                  onTap: () {
                    print('Wedding Header ID: ${widget.personalEventHeaderId}');
                    listOfComments(
                      personalEventHeaderId: widget.personalEventHeaderId.toString(),
                      context: context,
                    );
                  },
                  child: circularIconBackground(
                    child: Image.asset(
                      TImageName.commentPngIcon,
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                verticalSpacing(3.h),
                textWidget(
                  personalEventCtr.personalEventCommentModel?.comments?.length.toString() ?? "0",
                ),
                verticalSpacing(10.h),
                circularIconBackground(
                  child: Image.asset(
                    TImageName.eyePngIcon,
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                verticalSpacing(3.h),
                textWidget(
                  personalEventCtr.personalEventViewsModel?.personalEventViewUsers?.length
                          .toString() ??
                      personalEventCtr.homePersonalEventDetailsModel?.views?.toString() ??
                      "0",
                ),
                verticalSpacing(10.h),
                if (personalEventCtr.homePersonalEventDetailsModel?.backgroundImageUrl != null ||
                    personalEventCtr.homePersonalEventDetailsModel?.backgroundImageUrl != '')
                  //verticalSpacing(10.h),
                  circularIconBackground(
                    child: IconButton(
                      alignment: Alignment.center,
                      enableFeedback: true,
                      icon: Image.asset(
                        ref.read(personalEventHomeController).userRoleEnum.type ==
                                UserRoleEnum.PublicUser.type
                            ? TImageName.sharePngIcon
                            : TImageName.shareBoxedPngIcon,
                        width: 18.w,
                        height: 18.h,
                      ),
                      onPressed: () async {
                        final backgroundImageUrl =
                            personalEventCtr.homePersonalEventDetailsModel?.backgroundImageUrl;
                        print(
                            "personalEventCtr.homePersonalEventDetailsModel?.backgroundImageUrl  $backgroundImageUrl");
                        await ref.watch(personalEventECardCtr).setCurrentImage(backgroundImageUrl);
                        Navigator.pushNamed(context, Routes.personalEventECardScreen,
                            arguments: {'isSingleImage': false});
                        // List<int> activityId = [];
                        // for(int i = 0;i < (ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventActivityList?.length ?? 0); i++) {
                        //   activityId.add(ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventActivityList?[i].personalEventActivityId ?? 0);
                        // }
                        // ref.read(personalEventECardCtr).fetchAndSetPersonalEventPhotos(
                        //     ref: ref,
                        //     context: context,
                        //     activityId: activityId
                        // );
                      },
                    ),
                  ),
                SizedBox(
                  height: 10.h,
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



//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Consumer(
//         builder: (BuildContext context, WidgetRef ref, Widget? child) {
//           final personalEventCtr = ref.watch(personalEventHomeController);
//           return Padding(
//             padding: EdgeInsets.only(right: 16.w),
//             child: Column(
//               children: [
//                 if (widget.backgroundMusicUrl != null && widget.backgroundMusicUrl != '') ...[
//                   GestureDetector(
//                     onTap: widget.playPause,
//                     child: Image.asset(
//                       widget.isPlaying ? TImageName.musicGif : TImageName.musicPngIcon,
//                       color: widget.isPlaying ? null : TAppColors.white,
//                       width: 24.w,
//                       height: 24.h,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.h,
//                   ),
//                 ],
//                 GestureDetector(
//                   onTap: widget.favTap,
//                   child: Image.asset(
//                     widget.isFav ? TImageName.heartRedPngIcon : TImageName.heartPngIcon,
//                     width: 20.w,
//                     height: 18.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Text(
//                   widget.likes.toString(),
//                   style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     // Navigator.pushNamed(context, Routes.eventCommentsScreen);
//                     print('wedding Header ID: ${widget.personalEventHeaderId}');
//                     listOfComments(
//                       personalEventHeaderId: widget.personalEventHeaderId.toString() ?? '',
//                       context: context,
//                     );
//                   },
//                   child: Image.asset(
//                     TImageName.commentPngIcon,
//                     width: 20.w,
//                     height: 20.h,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Text(
//                   personalEventCtr.personalEventCommentModel != null &&
//                           personalEventCtr.personalEventCommentModel?.comments != null
//                       ? personalEventCtr.personalEventCommentModel!.comments!.length.toString()
//                       : "0",
//                   style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//                 Image.asset(
//                   TImageName.eyePngIcon,
//                   width: 20.w,
//                   height: 20.h,
//                 ),
//                 SizedBox(
//                   height: 3.h,
//                 ),
//                 Text(
//                   personalEventCtr.personalEventViewsModel != null &&
//                           personalEventCtr.personalEventViewsModel?.personalEventViewUsers != null
//                       ? personalEventCtr.personalEventViewsModel!.personalEventViewUsers!.length
//                           .toString()
//                       : personalEventCtr.homePersonalEventDetailsModel?.views?.toString() ?? "0",
//                   style: getRobotoMediumStyle(fontSize: MyFonts.size14, color: TAppColors.white),
//                 ),
//                 SizedBox(
//                   height: 20.h,
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }