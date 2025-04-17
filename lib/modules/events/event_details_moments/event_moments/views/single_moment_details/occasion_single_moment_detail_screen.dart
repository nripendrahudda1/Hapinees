import 'package:Happinest/common/widgets/e_top_manu_button.dart';
import 'package:Happinest/modules/events/e-card/controllers/wedding_event_ecard_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../../core/enums/user_role_enum.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_event_all_moment_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_like_post_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_for_ritual_post_model.dart';
import '../../../controller/occasion_event_memories_controller.dart';
import '../../widgets/moment_feed_see_more_text_widget.dart';
import '../../widgets/remove_photo_to_ritual_bottom_sheet.dart';
import '../../widgets/save_photo_to_ritual_bottom_sheet.dart';
import '../comment_screen/wedding_event_moments_comments_screen.dart';

class OccasionSingleMomentDetailScreen extends ConsumerStatefulWidget {
  final Post postModel;
  final String? token;
  const OccasionSingleMomentDetailScreen({super.key, required this.postModel, required this.token});

  @override
  ConsumerState<OccasionSingleMomentDetailScreen> createState() =>
      _OccasionSingleMomentDetailScreenState();
}

class _OccasionSingleMomentDetailScreenState
    extends ConsumerState<OccasionSingleMomentDetailScreen> {
  int selectedImage = 0;
  bool isFav = false;
  String? bookmarkedRitual;

  Future favClick() async {
    String token = widget.token ?? '';

    OccasionSetLikePostModel model = OccasionSetLikePostModel(
        occasionPostId: widget.postModel.occasionPostId, likedOn: DateTime.now(), isUnLike: isFav);
    await ref
        .read(occasionEventMemoriesController)
        .likeMemoryPost(likeWeddingPostModel: model, token: token, ref: ref, context: context);
    setState(() {
      isFav = !isFav;
    });

    final memoryCtr = ref.watch(occasionEventMemoriesController);
    await memoryCtr.getMemoryPostLikes(
        postId: widget.postModel.occasionPostId.toString(),
        token: token,
        ref: ref,
        context: context);
  }

  getLikesAndComments() async {
    await ref.read(occasionEventMemoriesController).getMemoryPostLikes(
        postId: widget.postModel.occasionPostId.toString(),
        token: widget.token ?? '',
        ref: ref,
        context: context);

    await ref.read(occasionEventMemoriesController).getMemoryPostAllCommentsFirstTime(
          token: widget.token ?? '',
          postId: widget.postModel.occasionPostId.toString(),
          sortByPopular: false,
          offset: 0,
          noOfRecords: 1000,
          ref: ref,
          context: context,
        );
  }

  @override
  initState() {
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getLikesAndComments();
      bookmarkedRitual = widget.postModel.postMedias?[selectedImage].ritualName;
      print('post media id: ${widget.postModel.postMedias?[selectedImage].occasionPostMediaId}');
    });
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String occasionPostId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return WeddingEventMomentPostCommentSection(
          occasionPostId: occasionPostId,
          token: widget.token,
        );
      },
    );
  }

  saveBookMarked() {
    final weddingCtr = ref.watch(weddingEventHomeController);
    final momentsCtr = ref.watch(occasionEventMemoriesController);
    List<String> ritualNames = [];
    weddingCtr.homeWeddingDetails?.weddingRitualList?.forEach((element) {
      ritualNames.add(element.ritualName ?? '');
    });
    savePhotoToActivityBottomSheet(
      context: context,
      ritualList: ritualNames,
      onTap: (index) async {
        print(ritualNames[index]);
        // print(weddingCtr.homeWeddingDetails?.weddingRitualList?[index].weddingHeaderId);
        setState(() {
          bookmarkedRitual = ritualNames[index];
        });

        OccasionSetPostMediaForRitualPostModel model = OccasionSetPostMediaForRitualPostModel(
          weddingHeaderId: weddingCtr.homeWeddingDetails?.weddingRitualList?[index].weddingHeaderId,
          weddingRitualId: weddingCtr.homeWeddingDetails?.weddingRitualList?[index].weddingRitualId,
          occasionPostId: widget.postModel.occasionPostId,
          occasionPostMediaId: widget.postModel.postMedias?[selectedImage].occasionPostMediaId,
          createdOn: DateTime.now(),
        );

        await momentsCtr.setPostRitualMediaPost(
            ritualMediaPostModel: model,
            token: PreferenceUtils.getString(PreferenceKey.accessToken),
            ref: ref,
            context: context);
        Navigator.pop(context);
      },
    );
  }

  removeBookMark() {
    final weddingCtr = ref.watch(weddingEventHomeController);
    final momentsCtr = ref.watch(occasionEventMemoriesController);
    removePhotoToRitualBottomSheet(
      context: context,
      ritual: bookmarkedRitual!,
      onTap: () async {
        setState(() {
          bookmarkedRitual = null;
        });
        await momentsCtr.removePostRitualMediaPost(
            weddingHeaderId: weddingCtr.homeWeddingDetails?.weddingHeaderId.toString() ?? '',
            postMediaId:
                widget.postModel.postMedias?[selectedImage].occasionPostMediaId.toString() ?? '',
            token: PreferenceUtils.getString(PreferenceKey.accessToken),
            ref: ref,
            context: context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CachedRectangularNetworkImageWidget(
              image: widget.postModel.postMedias![selectedImage].imageUrl ?? '',
              // TImageUrl.ritualImages[selectedImage],
              width: 1.sw,
              height: 1.sh),
          Container(
            width: 1.sw,
            height: 1.sh,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TAppColors.black.withOpacity(0.7),
                  TAppColors.transparent,
                  TAppColors.transparent,
                  TAppColors.black.withOpacity(0.6),
                  TAppColors.black.withOpacity(0.9)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedImage != 0)
                      Padding(
                        padding: EdgeInsets.all(15.0.w),
                        child: ERitualAndActivityButton(
                            onTap: () {
                              setState(() {
                                selectedImage > 0 ? selectedImage-- : null;
                                bookmarkedRitual =
                                    widget.postModel.postMedias?[selectedImage].ritualName;
                              });
                            },
                            icon: TImageName.arrowBackPngIcon),
                      ),
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (selectedImage != widget.postModel.postMedias!.length - 1)
                      Padding(
                        padding: EdgeInsets.all(15.0.w),
                        child: ERitualAndActivityButton(
                            onTap: () {
                              setState(() {
                                selectedImage < widget.postModel.postMedias!.length - 1
                                    ? selectedImage++
                                    : null;
                                bookmarkedRitual =
                                    widget.postModel.postMedias?[selectedImage].ritualName;
                              });
                            },
                            icon: TImageName.arrowForwardPngIcon),
                      ),
                  ],
                )),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 1.sh * 0.04, 0, 0),
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final memoryCtr = ref.watch(occasionEventMemoriesController);
                return Column(
                  children: [
                    topPaddingIphone(topPadding: 0.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(
                                widget.postModel.postMedias!.length,
                                (index) => Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 4.h,
                                            bottom: 4.h,
                                            left: index == 0 ? 0 : 4.w,
                                            right: 0),
                                        child: TCard(
                                            height: 6,
                                            radius: 12,
                                            color: selectedImage == index
                                                ? Colors.white70
                                                : Colors.white30),
                                      ),
                                    )),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              ETopBackButton(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              SizedBox(
                                width: 21.w,
                              ),
                              Consumer(
                                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                  final eventCtr = ref.watch(weddingEventHomeController);
                                  return Container(
                                    constraints: BoxConstraints(maxWidth: 0.8.sw),
                                    child: Text(
                                      eventCtr.homeWeddingDetails?.title ?? '',
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size18, color: TAppColors.white),
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                              ref.watch(weddingEventHomeController).userRoleEnum.type ==
                                      UserRoleEnum.PublicUser.type
                                  ? ETopManuButton(
                                      editMemories: () {},
                                      deleteMemories: () async {
                                        await ref.read(occasionEventMemoriesController).deletePost(
                                            postId: widget.postModel.occasionPostId.toString(),
                                            token: PreferenceUtils.getString(
                                                PreferenceKey.accessToken),
                                            ref: ref,
                                            context: context);
                                        await ref
                                            .read(occasionEventMemoriesController)
                                            .getAllMemories(
                                                token: PreferenceUtils.getString(
                                                    PreferenceKey.accessToken),
                                                weddingHeaderId: ref
                                                        .read(weddingEventHomeController)
                                                        .homeWeddingDetails
                                                        ?.weddingHeaderId
                                                        ?.toString() ??
                                                    '',
                                                eventTypeMasterId: '1',
                                                ref: ref,
                                                context: context);
                                      },
                                    )
                                  : ETopEditButton(
                                      onTap: () async {
                                        Navigator.pushNamed(context, Routes.editRitualScreen);
                                      },
                                    )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15.w, 15.h, 10.w, 10.h),
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 18.r,
                              backgroundColor: TAppColors.white,
                              child: CircleAvatar(
                                  radius: 17.r,
                                  backgroundColor: TAppColors.white,
                                  child: CachedCircularNetworkImageWidget(
                                      image: widget.postModel.createdBy?.profileImageUrl ?? '',
                                      size: 36))),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.postModel.createdBy?.displayName ?? '',
                                  style: getRobotoSemiBoldStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.white),
                                ),
                                Text(
                                  getTimeAgo(widget.postModel.createdOn ?? DateTime.now()),
                                  style: getRobotoMediumStyle(
                                      fontSize: MyFonts.size10, color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MomentFeedSeeMoreTextWidget(text: widget.postModel.postNote ?? ''),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              alignment: Alignment.center,
                              enableFeedback: true,
                              icon: Image.asset(
                                isFav ? TImageName.heartWhitePngIcon : TImageName.heartPngIcon,
                                width: 22.w,
                                height: 22.h,
                              ),
                              onPressed: favClick),
                          Text(
                            memoryCtr.postLikesUserModel?.occasionPostLikeUsers?.length
                                    .toString() ??
                                "0",
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14, color: TAppColors.white),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            alignment: Alignment.center,
                            enableFeedback: true,
                            icon: Image.asset(
                              TImageName.commentPngIcon,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () {
                              listOfComments(
                                occasionPostId: widget.postModel.occasionPostId.toString(),
                                context: context,
                              );
                            },
                          ),
                          Text(
                            memoryCtr.postAllCommentsModel?.comments?.length.toString() ?? '0',
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14, color: TAppColors.white),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          IconButton(
                            padding: EdgeInsets.only(bottom: 4.h),
                            alignment: Alignment.center,
                            enableFeedback: true,
                            icon: Image.asset(
                              TImageName.shareBoxedPngIcon,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () {
                              ref.watch(weddingEventECardCtr).setCurrentImage(
                                  widget.postModel.postMedias![selectedImage].imageUrl ?? '');
                              Navigator.pushNamed(context, Routes.weddingECardScreen,
                                  arguments: {'isSingleImage': false});
                              // Share.share(widget.postModel.postMedias![selectedImage].imageUrl ?? '');
                            },
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          IconButton(
                            padding: EdgeInsets.only(bottom: 4.h),
                            alignment: Alignment.center,
                            enableFeedback: true,
                            icon: Image.asset(
                              bookmarkedRitual == null
                                  ? TImageName.bookMarkOutlinedIcon
                                  : TImageName.bookMarkFillIcon,
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () {
                              if (bookmarkedRitual == null) {
                                saveBookMarked();
                              } else {
                                removeBookMark();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
