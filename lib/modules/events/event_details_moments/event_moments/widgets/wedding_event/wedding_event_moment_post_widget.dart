import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_event_all_moment_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_all_comments_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_likes_users_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_like_post_model.dart';
import '../../../../e-card/controllers/wedding_event_ecard_controller.dart';
import '../../../controller/occasion_event_memories_controller.dart';
import '../../views/comment_screen/wedding_event_moments_comments_screen.dart';
import '../moment_feed_see_more_text_widget.dart';

class WeddingEventMomentPostWidget extends ConsumerStatefulWidget {
  const WeddingEventMomentPostWidget({
    super.key,
    required this.hasDesc,
    required this.hasBookMark,
    required this.isTextPost,
    required this.eventHeaderId,
    required this.token,
    required this.description, required this.postModel,
  });
  final Post postModel;
  final bool hasDesc;
  final bool hasBookMark;
  final bool isTextPost;
  final int? eventHeaderId;
  final String? token;
  final String description;

  @override
  ConsumerState<WeddingEventMomentPostWidget> createState() => _MomentFeedWidgetState();
}

class _MomentFeedWidgetState extends ConsumerState<WeddingEventMomentPostWidget> {
  bool isFav = false;
  OccasionPostLikesUsersModel? likesModel;
  OccasionPostAllCommentsModel? commentsModel;


  Future favClick() async {
    // print('Wedding Header ID: ${ref.read(weddingCreateEventController).homeWeddingDetails!.weddingHeaderId!}');
    String token = widget.token ?? '';

    OccasionSetLikePostModel model = OccasionSetLikePostModel(
      occasionPostId: widget.postModel.occasionPostId,
      likedOn: DateTime.now(),
      isUnLike: isFav
    );
    await ref.read(occasionEventMemoriesController).likeMemoryPost(
      likeWeddingPostModel: model,
      token: token,
        ref: ref,
        context: context);
    setState(() {
      isFav = !isFav;
    });

    final memoryCtr = ref.watch(occasionEventMemoriesController);
    likesModel = await memoryCtr.getMemoryPostLikes(
        postId: widget.postModel.occasionPostId.toString(),
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

  void permanentlyHidePost() {
    // Implement logic to permanently hide the post here
    // For example, you might want to update a database or remove it from a list.
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
          occasionPostId:  occasionPostId,
          token: widget.token,
        );
      },
    );
  }
  getLikesAndComments() async {



 WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
   if(mounted){
     String token = widget.token ?? '';
     final memoryCtr = ref.watch(occasionEventMemoriesController);
     likesModel = await memoryCtr.getMemoryPostLikes(
         postId: widget.postModel.occasionPostId.toString(),
         token: token,
         ref: ref,
         context: context);
     if(mounted){
       commentsModel = await memoryCtr.getMemoryPostAllComments(
         token: token,
         postId: widget.postModel.occasionPostId.toString(),
         sortByPopular: false,
         offset: 0,
         noOfRecords: 1000,
         ref: ref,
         context: context,
       );
     }
     print(likesModel?.validationMessage);
     print(commentsModel?.validationMessage);
   }
 });
  }


  @override
  initState(){
    super.initState();
    initiallize();
  }

  initiallize(){
      getLikesAndComments();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isPostVisible)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final memoryCtr = ref.watch(occasionEventMemoriesController);
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
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.white),
                                ),
                                Text(
                                  getCommentTimeAgo(widget.postModel.createdOn ?? DateTime.now()),
                                  // getTimeAgo(widget.postModel.createdOn ?? DateTime.now()) == "0" ? "a few moments ago" : "${getTimeAgo(widget.postModel.createdOn ?? DateTime.now())} mins ago",
                                  style: getRobotoMediumStyle(
                                      fontSize: MyFonts.size10,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              print(value);
                              if (value == "Hide") {
                                hidePost();
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 2,
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'Hide',
                                height: 30.h,
                                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                child: Row(
                                  children: [
                                    Image.asset(TImageName.eyeClosedOutlinedIcon,
                                        width: 18.w, height: 18.h),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Hide',
                                      style:
                                      getRegularStyle(fontSize: MyFonts.size14),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Edit',
                                height: 30.h,
                                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      TImageName.editOutlinedIcon,
                                      width: 18.w,
                                      height: 18.h,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Edit',
                                      style: getRegularStyle(
                                          color: TAppColors.black,
                                          fontSize: MyFonts.size14),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Delete',
                                onTap: ()async{

                                  await ref.read(occasionEventMemoriesController).deletePost(
                                      postId: widget.postModel.occasionPostId.toString(),
                                      token: widget.token ?? '',
                                      ref: ref,
                                      context: context
                                  );
                                  await ref.read(occasionEventMemoriesController).getAllMemories(
                                      token: widget.token ?? '',
                                      weddingHeaderId: widget.eventHeaderId.toString() ?? '',
                                      eventTypeMasterId: '1',
                                      ref: ref,
                                      context: context
                                  );
                                },
                                height: 30.h,
                                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                child: Row(
                                  children: [
                                    Image.asset(TImageName.deleteOutlineIcon,
                                        width: 18.w, height: 18.h),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Delete',
                                      style: getRegularStyle(
                                          color: TAppColors.black,
                                          fontSize: MyFonts.size14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            child: Container(
                                child: Image.asset(
                                  TImageName.moreVertIcon,
                                  width: 22.w,
                                  height: 22.h,
                                  color: TAppColors.white,
                                )),
                          ),
                        ],
                      ),
                    ),
                    if(!widget.isTextPost)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(widget.hasBookMark)
                            Padding(
                              padding: EdgeInsets.fromLTRB(15.w, 0.w, 15.w, 5.w),
                              child: Text(
                                "Sangeet",
                                style: getBoldStyle(
                                    fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                              ),
                            ),
                          if(widget.hasDesc)
                            MomentFeedSeeMoreTextWidget(
                                text:
                                widget.postModel.postNote ?? ''),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.occasionSingleMomentDetailScreen,
                                  arguments: {
                                    'postModel': widget.postModel,
                                    'token':widget.token,
                                  }
                              );
                            },
                            child: Container(
                              color: TAppColors.black,
                              height: 0.5.sh,
                              width: 1.sw,
                              child: Swiper(
                                physics: const BouncingScrollPhysics(),
                                loop: false,
                                indicatorLayout: PageIndicatorLayout.SCALE,
                                itemCount: widget.postModel.postMedias?.length ?? 0,
                                itemBuilder: (context, index) {
                                  print('Image url: ${widget.postModel.postMedias![index].imageUrl}');
                                  return CachedRectangularNetworkImageWidget(
                                    height: 0.5.sh,
                                    width: 1.sw,
                                    fit: BoxFit.fitHeight,
                                    image: widget.postModel.postMedias![index].imageUrl?? '',
                                    radius: 0.r,
                                  );
                                },
                                pagination: widget.postModel.postMedias?.length == 1
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
                    if(widget.isTextPost)
                      Container(
                        height: 280.h,
                        width: 1.sw,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(TImageName
                                .textMomentBgImage), // Update with your image asset path
                            fit: BoxFit
                                .cover, // You can adjust the fit based on your needs
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
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.h, top: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                              padding: const EdgeInsets.all(0),
                              alignment: Alignment.center,
                              enableFeedback: true,
                              icon: Image.asset(
                                isFav
                                    ? TImageName.heartWhitePngIcon
                                    : TImageName.heartPngIcon,
                                width: 22.w,
                                height: 22.h,
                              ),
                              onPressed: favClick),
                          Text(
                            likesModel?.occasionPostLikeUsers?.length.toString()??
                                "0",
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14,
                                color: TAppColors.white),
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
                                occasionPostId: widget.postModel.occasionPostId
                                    .toString(),
                                context: context,
                              );
                            },
                          ),
                          Text(
                            commentsModel?.comments?.length.toString()??"0",
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14,
                                color: TAppColors.white),
                          ),
                          if(!widget.isTextPost)
                          SizedBox(
                            width: 30.w,
                          ),
                          if(!widget.isTextPost)
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
                              ref.watch(weddingEventECardCtr).setCurrentImage(widget.postModel.postMedias![0].imageUrl ?? '');
                              Navigator.pushNamed(context, Routes.weddingECardScreen,arguments: {'isSingleImage':false});
                              // Share.share(widget.isTextPost ? widget.description : widget.postModel.postMedias![0].imageUrl ?? '');
                            },
                          ),
                        ],
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
                  style: getRegularStyle(
                      fontSize: MyFonts.size14, color: TAppColors.white),
                ),
                InkWell(
                    onTap: unhidePost,
                    child: Text(
                      "Unhide",
                      style: getRegularUnderlineStyle(
                          fontSize: MyFonts.size14,
                          color: TAppColors.selectionColor),
                    ))
              ],
            ),
          ),
      ],
    );
  }
}
