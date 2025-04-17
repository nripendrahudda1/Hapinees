import 'package:Happinest/models/create_event_models/moments/personal_event_moments/perosnal_event_post_all_comment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_post_like_user_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_post_like_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/comment_screen/personal_event_moments_comments_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import '../../../../../../common/common_default_apis.dart';
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../../../../../common/widgets/e_top_manu_button.dart';
import '../../../../e-card/controllers/personal_event_ecard_controller.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../moment_feed_see_more_text_widget.dart';

class PersonalEventMomentPostWidget extends ConsumerStatefulWidget {
  const PersonalEventMomentPostWidget(
      {super.key,
      required this.hasDesc,
      required this.hasBookMark,
      required this.isTextPost,
      required this.personalEventHeaderId,
      required this.token,
      required this.description,
      required this.postModel,
      required this.currentIndex,
      this.onRefresh,
      this.fabKey});
  final PersonalEventPost postModel;
  final bool hasDesc;
  final bool hasBookMark;
  final bool isTextPost;
  final int? personalEventHeaderId;
  final String? token;
  final String description;
  final int currentIndex;
  final VoidCallback? onRefresh;

  final GlobalKey<ExpandableFabState>? fabKey;
  @override
  ConsumerState<PersonalEventMomentPostWidget> createState() =>
      _PersonalEventMomentPostWidgetState();
}

class _PersonalEventMomentPostWidgetState extends ConsumerState<PersonalEventMomentPostWidget> {
  bool isFav = false;
  PersonalEventPostLikesUsersModel? likesModel;
  PersonalEventPostAllCommentsModel? commentsModel;
  SwiperController _swiperController = SwiperController();
  String userId = PreferenceUtils.getString(PreferenceKey.userId);

  int currentIndex = 0;
  Future favClick() async {
    // print('Wedding Header ID: ${ref.read(weddingCreateEventController).homeWeddingDetails!.weddingHeaderId!}');
    String token = widget.token ?? '';
    PersonalEventSetLikePostModel model = PersonalEventSetLikePostModel(
        personalEventPostId: widget.postModel.personalEventPostId,
        likedOn: DateTime.now(),
        isUnLike: isFav);
    await ref.read(personalEventMemoriesController).likeMemoryPost(
        personalEventSetLikePostModel: model, token: token, ref: ref, context: context);
    setState(() {
      isFav = !isFav;
    });

    final memoryCtr = ref.watch(personalEventMemoriesController);
    likesModel = await memoryCtr.getMemoryPostLikes(
        personalEventPostId: widget.postModel.personalEventPostId.toString(),
        token: token,
        ref: ref,
        context: context);
  }

  bool isPostVisible = true;
  bool isUnhideVisible = false;

  void hidePost() {
    setState(() {
      isPostVisible = false;
      isUnhideVisible = true;
    });
    // Wait for 5 seconds and then permanently hide the post
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isUnhideVisible = false;
      });
      permanentlyHidePost();
    });
  }

  void unhidePost() {
    setState(() {
      isPostVisible = true;
      isUnhideVisible = false;
    });
  }

// close The Menu button
  void _closeFab() {
    if (widget.fabKey?.currentState?.isOpen ?? false) {
      widget.fabKey?.currentState?.toggle(); // Close the FAB only if it's open
    }
  }

// API Request of hide Post
  void permanentlyHidePost() {
    // Implement logic to permanently hide the post here
    // For example, you might want to update a database or remove it from a list.
  }

  Future<void> delete(BuildContext context, String? eventName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonDeleteEventDialouge(
            onTap: () async {
              // Close the dialog after the actions are completed
              Navigator.pop(context);
              DeletePersonalEventPostModel model = DeletePersonalEventPostModel(
                personalEventHeaderId: widget.personalEventHeaderId ?? 0,
                personalEventPostId: widget.postModel.personalEventPostId,
              );

              await ref.read(personalEventMemoriesController).deletePost(
                  deletePersonalEventPostModel: model,
                  token: widget.token ?? '',
                  ref: ref,
                  context: context);
              await ref.read(personalEventMemoriesController).getAllMemories(
                  pageCount: 0,
                  token: widget.token ?? '',
                  personalEventHeaderId: widget.personalEventHeaderId.toString() ?? '',
                  ref: ref,
                  context: context);
            },
            title: 'Personal Event',
            eventName: "");
      },
    );
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String occasionPostId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return PersonalEventMomentPostCommentSection(
          personalEventPostId: occasionPostId,
          token: widget.token,
          commentCall: getComment,
        );
      },
    );
  }

  getComment() async {
    final memoryCtr = ref.watch(personalEventMemoriesController);
    String token = widget.token ?? '';
    if (mounted) {
      commentsModel = await memoryCtr.getMemoryPostAllComments(
        token: token,
        personalEventPostId: widget.postModel.personalEventPostId.toString(),
        sortByPopular: false,
        offset: 0,
        noOfRecords: 1000,
        ref: ref,
        context: context,
      );
      setState(() {});
    }
  }

  getLikesAndComments() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (mounted) {
        String token = widget.token ?? '';
        final memoryCtr = ref.watch(personalEventMemoriesController);
        likesModel = await memoryCtr.getMemoryPostLikes(
            personalEventPostId: widget.postModel.personalEventPostId.toString(),
            token: token,
            ref: ref,
            context: context);
        if (mounted) {
          commentsModel = await memoryCtr.getMemoryPostAllComments(
            token: token,
            personalEventPostId: widget.postModel.personalEventPostId.toString(),
            sortByPopular: false,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );
        }
        isFav = false;
        setState(() {});
        print(
            "myProfileData!.email.toString().toLowerCase() ${myProfileData!.email.toString().toLowerCase()}");
        if (likesModel != null) {
          if (likesModel?.personalEventPostLikeUsers != null) {
            for (int i = 0; i < (likesModel?.personalEventPostLikeUsers?.length ?? 0); i++) {
              if (likesModel?.personalEventPostLikeUsers![i].email.toString().toLowerCase() ==
                  myProfileData!.email.toString().toLowerCase()) {
                isFav = true;
                setState(() {});
                break;
              }
            }
          }
        }
        print(likesModel?.validationMessage);
        print(commentsModel?.validationMessage);
      }
    });
  }

  @override
  initState() {
    super.initState();
    print("widget.postModel.personalEventPostId 1 ${widget.postModel.personalEventPostId}");
    initiallize();
  }

  initiallize() {
    getLikesAndComments();
  }

  /// Hide  Post
  Widget buildPopupMenuHide(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white), // White three-dot icon
      offset: const Offset(-20, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 2,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: TButtonLabelStrings.hideButton,
          height: 30.h,
          onTap: () {
            Future.delayed(Duration.zero, () => hidePost()); // Ensures menu closes before action
          },
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              Image.asset(TImageName.eyeClosedOutlinedIcon, width: 18.w, height: 18.h),
              SizedBox(width: 8.w),
              Text(
                TButtonLabelStrings.hideButton,
                style: getRegularStyle(fontSize: MyFonts.size14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double calculateFontSize(double maxWidth) {
    // You can adjust this logic based on your requirements
    double minFontSize = MyFonts.size12;
    double maxFontSize = MyFonts.size22;
    const double scaleFactor = 0.8;
    double fontSize = maxFontSize;
    while (fontSize > minFontSize) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: widget.description,
          style: TextStyle(fontSize: fontSize),
        ),
        maxLines: null,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);

      if (textPainter.height < 180.h * scaleFactor) {
        break;
      }

      fontSize -= 1.0;
    }

    return fontSize;
  }

  /// Update Event
  void navigateToUpdateTextMomentScreen() {
    _closeFab();
    if (widget.isTextPost) {
      // Create the PersonalEventPost model
      PersonalEventPost model = PersonalEventPost(
        personalEventPostId: widget.postModel.personalEventPostId,
        description: widget.description,
      );

      // Fetch event title from the provider
      String? eventTitle =
          ref.read(personalEventHomeController).homePersonalEventDetailsModel?.title;
      // Navigate with arguments
      Navigator.pushNamed(
        context,
        Routes.updatePersonalEventTextMomentScreen,
        arguments: {
          'postModel': model,
          'eventTitle': eventTitle,
          'token': widget.token,
          'eventHeaderId': widget.personalEventHeaderId,
        },
      ).then((result) {
        if (result == true) {
          // Refresh the state after returning
          setState(() {
            //widget.onRefresh!();
          });
        }
      });
    } else {
      PersonalEventPost model = PersonalEventPost(
        personalEventPostId: widget.postModel.personalEventPostId,
        description: widget.description,
      );
      // Fetch event title from the provider
      String? eventTitle =
          ref.read(personalEventHomeController).homePersonalEventDetailsModel?.title;

      // Navigate with arguments
      Navigator.pushNamed(
        context,
        Routes.updatePersonalEventGalleryMomentScreen,
        arguments: {
          'postModel': model,
          'eventTitle': eventTitle,
          'token': widget.token,
          'eventHeaderId': widget.personalEventHeaderId,
          'imagePaths': widget.postModel.personalEventPhotos
        },
      ).then((result) {
        if (result == true) {
          // Refresh the state after returning
          setState(() {
            //\widget.onRefresh!();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isPostVisible)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return Container(
                width: double.infinity,
                color: TAppColors.venueCardTextColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                    // imageBoxType: BoxFit.fitHeight,
                                    image: widget.postModel.createdBy?.profileImageUrl ?? '',
                                    size: 36,
                                  ))),
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
                                  getCommentTimeAgo(widget.postModel.createdOn ?? DateTime.now()),
                                  // getTimeAgo(widget.postModel.createdOn ?? DateTime.now()) == "0" ? "a few moments ago" : "${getTimeAgo(widget.postModel.createdOn ?? DateTime.now())} mins ago",
                                  style: getRobotoMediumStyle(
                                      fontSize: MyFonts.size10, color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                          (int.parse(userId) == widget.postModel.createdBy?.userId)
                              ? ETopManuButton(
                                  editMemories: () {
                                    navigateToUpdateTextMomentScreen();
                                  },
                                  deleteMemories: () async {
                                    delete(context, TMessageStrings.deleteAction);
                                  },
                                )
                              : buildPopupMenuHide(
                                  context,
                                ) // If not the owner, return an empty widget
                        ],
                      ),
                    ),
                    if (!widget.isTextPost)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.hasBookMark)
                            Padding(
                              padding: EdgeInsets.fromLTRB(15.w, 0.w, 15.w, 5.w),
                              child: Text(
                                "Sangeet",
                                style: getBoldStyle(
                                    fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                              ),
                            ),
                          if (widget.hasDesc)
                            MomentFeedSeeMoreTextWidget(text: widget.postModel.aboutPost ?? ''),
                          GestureDetector(
                            onTap: () {
                              _closeFab();
                              print(
                                  "widget.postModel.personalEventPostId 2 ${widget.postModel.personalEventPostId}");
                              Navigator.pushNamed(
                                  context, Routes.personalEventSingleMomentDetailScreen,
                                  arguments: {
                                    'postModel': widget.postModel,
                                    'token': widget.token,
                                    'selectedIndex': currentIndex,
                                  }).then(
                                (value) {
                                  getLikesAndComments();
                                },
                              );
                            },
                            child: Container(
                              color: TAppColors.black,
                              height: 0.6.sh,
                              width: 1.sw,
                              child: Swiper(
                                physics: const BouncingScrollPhysics(),
                                loop: false,
                                controller: _swiperController,
                                onIndexChanged: (value) {
                                  currentIndex = value;
                                },
                                indicatorLayout: PageIndicatorLayout.SCALE,
                                itemCount: widget.postModel.personalEventPhotos?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return CachedRectangularNetworkImageWidget(
                                    height: 0.5.sh,
                                    width: 1.sw,
                                    fit: BoxFit.fitHeight,
                                    image: widget.postModel.personalEventPhotos?[index].photo ?? '',
                                    radius: 0.r,
                                  );
                                },
                                pagination: widget.postModel.personalEventPhotos?.length == 1
                                    ? null
                                    : SwiperPagination(
                                        builder: DotSwiperPaginationBuilder(
                                          color: TAppColors.white.withOpacity(0.5),
                                          activeColor: TAppColors.white,
                                          size: 15.0.h,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (widget.isTextPost)
                      Container(
                        height: 280.h,
                        width: 1.sw,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                TImageName.textMomentBgImage), // Update with your image asset path
                            fit: BoxFit.cover, // You can adjust the fit based on your needs
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15.h),
                          child: Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Text(
                                  widget.description,
                                  textAlign: TextAlign.center,
                                  style: getSemiBoldStyle(
                                    fontSize: calculateFontSize(0.8.sw),
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    // Event Details bottom bar
                    SizedBox(
                      height: 50.h,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 0.h, top: 0.h), // Event Details bottom bar
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                padding: const EdgeInsets.all(0),
                                alignment: Alignment.center,
                                enableFeedback: true,
                                icon: Image.asset(
                                  isFav ? TImageName.heartRedPngIcon : TImageName.heartPngIcon,
                                  width: 22.w,
                                  height: 22.h,
                                ),
                                onPressed: favClick),
                            Text(
                              likesModel?.personalEventPostLikeUsers?.length.toString() ?? "0",
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
                                  occasionPostId: widget.postModel.personalEventPostId.toString(),
                                  context: context,
                                );
                              },
                            ),
                            Text(
                              commentsModel?.comments?.length.toString() ?? "0",
                              style: getRobotoBoldStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.white),
                            ),
                            if (!widget.isTextPost)
                              SizedBox(
                                width: 30.w,
                              ),
                            if (!widget.isTextPost)
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
                                  //ref.watch(personalEventECardCtr).setCurrentImage(widget.postModel.personalEventPhotos?[0] ?? '');
                                  Navigator.pushNamed(context, Routes.personalEventECardScreen,
                                      arguments: {'isSingleImage': false});
                                  // Share.share(widget.isTextPost
                                  //     ? widget.description
                                  //     : widget.postModel.photos![0]);
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 10.h,
                      color: TAppColors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              );
            },
          ),
        if (isUnhideVisible)
          Container(
            height: 58.h,
            color: TAppColors.black.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  TImageName.eyeClosedOutlinedIcon,
                  width: 20.w,
                  height: 20.h,
                  color: TAppColors.white,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Post has been hidden. ',
                  style: getRegularStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                ),
                InkWell(
                    onTap: unhidePost,
                    child: Text(
                      "Unhide",
                      style: getRegularUnderlineStyle(
                          fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                    ))
              ],
            ),
          ),
      ],
    );
  }
}
