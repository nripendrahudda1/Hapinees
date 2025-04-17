import 'package:Happinest/models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_for_ritual_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_post_like_user_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_post_like_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/occasion_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/comment_screen/personal_event_moments_comments_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/views/single_moment_details/image_zoomableImage_widget.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/remove_photo_to_ritual_bottom_sheet.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/save_photo_to_ritual_bottom_sheet.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../../common/common_default_apis.dart';
import '../../../../../../common/common_functions/topPadding.dart';
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../e-card/controllers/personal_event_ecard_controller.dart';
import '../../widgets/moment_feed_see_more_text_widget.dart';

class PersonalEventSingleMomentDetailScreen extends ConsumerStatefulWidget {
  final PersonalEventPost postModel;
  final String? token;
  final int? selectedImageIndex;
  const PersonalEventSingleMomentDetailScreen(
      {super.key, required this.postModel, required this.token, this.selectedImageIndex});

  @override
  ConsumerState<PersonalEventSingleMomentDetailScreen> createState() =>
      _PersonalEventSingleMomentDetailScreenState();
}

class _PersonalEventSingleMomentDetailScreenState
    extends ConsumerState<PersonalEventSingleMomentDetailScreen> {
  int selectedImage = 0;
  bool isFav = false;
  String? bookmarkedRitual;
  String userId = PreferenceUtils.getString(PreferenceKey.userId);
  double _scale = 1.0;
  Future favClick() async {
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
    await memoryCtr.getMemoryPostLikes(
        personalEventPostId: widget.postModel.personalEventPostId.toString(),
        token: token,
        ref: ref,
        context: context);
  }

  getLikesAndComments() async {
    PersonalEventPostLikesUsersModel? likesModel = await ref
        .read(personalEventMemoriesController)
        .getMemoryPostLikes(
            personalEventPostId: widget.postModel.personalEventPostId.toString(),
            token: widget.token ?? '',
            ref: ref,
            context: context);

    if (likesModel != null) {
      if (likesModel.personalEventPostLikeUsers != null) {
        for (int i = 0; i < (likesModel.personalEventPostLikeUsers?.length ?? 0); i++) {
          if (likesModel.personalEventPostLikeUsers![i].email.toString().toLowerCase() ==
              myProfileData!.email.toString().toLowerCase()) {
            isFav = true;
            setState(() {});
            break;
          }
        }
      }
    }

    await ref.read(personalEventMemoriesController).getMemoryPostAllCommentsFirstTime(
          token: widget.token ?? '',
          personalEventPostId: widget.postModel.personalEventPostId.toString(),
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
    print("widget.postModel.personalEventPostId ${widget.postModel.personalEventPostId}");
    selectedImage = widget.selectedImageIndex ?? 0;
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await getLikesAndComments();
      // bookmarkedRitual = widget.postModel.postMedias?[selectedImage].ritualName;
      // print('post media id: ${widget.postModel.postMedias?[selectedImage].occasionPostMediaId}');
    });
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String personalEventPostId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return PersonalEventMomentPostCommentSection(
          personalEventPostId: personalEventPostId,
          commentCall: () {},
          token: widget.token,
        );
      },
    );
  }

  saveBookMarked() async {
    final personalEventCtr = ref.watch(personalEventHomeController);
    final personalEventWed = ref.watch(weddingEventHomeController);
    final momentsCtr = ref.watch(occasionEventMemoriesController);
    List<String> personalEventActivityNames = [];
    List<int> personalEventActivityIDS = [];
    personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList?.forEach((element) {
      personalEventActivityNames.add(element.activityName ?? '');
      personalEventActivityIDS.add(element.personalEventActivityId ?? 0);
    });
    savePhotoToActivityBottomSheet(
      context: context,
      ritualList: personalEventActivityNames,
      onTap: (index) async {
        print("personalEventActivityId ${personalEventActivityIDS[index]}");
        // print(personalEventCtr.homeWeddingDetails?.weddingRitualList?[index].weddingHeaderId);
        setState(() {
          bookmarkedRitual = personalEventActivityNames[index];
        });
        PersonalEventCreateMemoriesTextPostModel model = PersonalEventCreateMemoriesTextPostModel(
          createdOn: DateTime.now(),
          personalEventHeaderId:
              personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId ?? 0,
          personalEventActivityId: personalEventActivityIDS[index],
          aboutPost: "",
        );
        await ref.read(personalEventMemoriesController).setPersonalEventMemoryPostText(
            personalEventCreateMemoriesTextPostModel: model,
            token: widget.token ?? '',
            isSingleMediaPost: false,
            isMultiMediaPost: false,
            isTextPost: true,
            context: context,
            ref: ref);
        Navigator.pop(context);
        //   OccasionSetPostMediaForRitualPostModel model1 = OccasionSetPostMediaForRitualPostModel(
        //     weddingHeaderId:
        //         personalEventWed.homeWeddingDetails?.weddingRitualList?[index].weddingHeaderId,
        //     weddingRitualId:
        //         personalEventWed.homeWeddingDetails?.weddingRitualList?[index].weddingRitualId,
        //     occasionPostId: widget.postModel.personalEventPostId,
        //     occasionPostMediaId:
        //         widget.postModel.personalEventPhotos?[selectedImage].personalEventPhotoId,
        //     createdOn: DateTime.now(),
        //   );

        //   await momentsCtr.setPostRitualMediaPost(
        //       ritualMediaPostModel: model1,
        //       token: PreferenceUtils.getString(PreferenceKey.accessToken),
        //       ref: ref,
        //       context: context);
        //   // Navigator.pop(context);
      },
    );
  }

  removeBookMark() {
    final personalEventCtr = ref.watch(personalEventHomeController);
    final momentsCtr = ref.watch(occasionEventMemoriesController);
    final personalEventWed = ref.watch(weddingEventHomeController);
    removePhotoToRitualBottomSheet(
      context: context,
      ritual: bookmarkedRitual!,
      onTap: () async {
        setState(() {
          bookmarkedRitual = null;
        });
        await momentsCtr.removePostRitualMediaPost(
            weddingHeaderId: personalEventWed.homeWeddingDetails?.weddingHeaderId.toString() ?? '',
            postMediaId: widget.postModel.personalEventPhotos?[selectedImage].personalEventPhotoId
                    .toString() ??
                '',
            token: PreferenceUtils.getString(PreferenceKey.accessToken),
            ref: ref,
            context: context);
      },
    );
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
              print("widget.postModel.personalEventPostId ${widget.postModel.personalEventPostId}");
              DeletePersonalEventPostModel model = DeletePersonalEventPostModel(
                personalEventPostId: widget.postModel.personalEventPostId ?? 0,
                personalEventHeaderId: ref
                    .watch(personalEventHomeController)
                    .homePersonalEventDetailsModel
                    ?.personalEventHeaderId,
              );
              await ref.read(personalEventMemoriesController).deletePost(
                  deletePersonalEventPostModel: model,
                  token: PreferenceUtils.getString(PreferenceKey.accessToken),
                  ref: ref,
                  context: context);
              await ref.read(personalEventMemoriesController).getAllMemories(
                  token: PreferenceUtils.getString(PreferenceKey.accessToken),
                  pageCount: 0,
                  personalEventHeaderId: ref
                          .read(personalEventHomeController)
                          .homePersonalEventDetailsModel
                          ?.personalEventHeaderId
                          ?.toString() ??
                      '',
                  ref: ref,
                  context: context);
            },
            title: 'Personal Event',
            eventName: "");
      },
    );
  }

// update The index on swift
  void _updateImage(int newIndex) {
    setState(() {
      selectedImage = newIndex;
    });
  }

  Widget buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Left Back Button
        ETopBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 10.w), // Reduced spacing

        // Title (Wrapped in Expanded to prevent overlap)
        Expanded(
          child: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final eventCtr = ref.watch(personalEventHomeController);
              return Text(
                eventCtr.homePersonalEventDetailsModel?.title ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Prevents text from expanding too much
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontSize: MyFonts.size18,
                  color: TAppColors.white,
                ),
              );
            },
          ),
        ),

        SizedBox(width: 10.w), // Ensures spacing before the right-side button

        // Right Side Button (Prevents Overlap)
        // Edit and Delete in Coming Soon// Nripendra
        // (int.parse(userId) == widget.postModel.createdBy?.userId)
        //     ? ETopManuButton(
        //         editMemories: () {},
        //         deleteMemories: () async {
        //           delete(context, TMessageStrings.deleteAction);
        //         },
        //       )
        //     : ETopEditButton(
        //         onTap: () async {
        //           EasyLoading.showError("Coming Soon");
        //         },
        //       ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final personalEventCtr = ref.watch(personalEventHomeController);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
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
                  TAppColors.black.withOpacity(0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ZoomableImage(
            selectIndex: selectedImage,
            imageUrls: widget.postModel.personalEventPhotos ?? [],
            onImageChange: _updateImage,
          ),
          SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: Row(
              children: [
                // Rigth  Button
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
                                _scale = 1.0;
                                // bookmarkedRitual = widget.postModel.postMedias?[selectedImage].ritualName;
                              });
                            },
                            icon: TImageName.arrowBackPngIcon),
                      ),
                  ],
                )),
                // Left Side button
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (selectedImage != widget.postModel.personalEventPhotos!.length - 1)
                      Padding(
                        padding: EdgeInsets.all(15.0.w),
                        child: ERitualAndActivityButton(
                            onTap: () {
                              setState(() {
                                _scale = 1.0;
                                selectedImage < widget.postModel.personalEventPhotos!.length - 1
                                    ? selectedImage++
                                    : null;
                                // bookmarkedRitual = widget.postModel.photos?[selectedImage].ritualName;
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
                final memoryCtr = ref.watch(personalEventMemoriesController);
                return Column(
                  children: [
                    topPaddingIphone(topPadding: 0.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(
                                widget.postModel.personalEventPhotos!.length,
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
                          buildTopBar(context),
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
                                  getCommentTimeAgo(widget.postModel.createdOn ?? DateTime.now()),
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
                      child: MomentFeedSeeMoreTextWidget(text: widget.postModel.aboutPost ?? ''),
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
                                isFav
                                    ? TImageName.heartRedPngIcon
                                    : TImageName.heartPngIcon, // Single Image Woth Zoom
                                width: 22.w,
                                height: 22.h,
                              ),
                              onPressed: favClick),
                          Text(
                            memoryCtr.postLikesUserModel?.personalEventPostLikeUsers?.length
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
                                personalEventPostId:
                                    widget.postModel.personalEventPostId.toString(),
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
                              ref.watch(personalEventECardCtr).setCurrentImage(
                                  widget.postModel.personalEventPhotos?[selectedImage].photo ?? '');
                              Navigator.pushNamed(context, Routes.personalEventECardScreen,
                                  arguments: {'isSingleImage': false});
                            },
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          // BookMark  // Nripendra No Book mark in personal
                          if ((personalEventCtr.homePersonalEventDetailsModel
                                      ?.personalEventActivityList?.length ??
                                  0) >
                              0)
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
                                // EasyLoading.showError("Coming Soon");
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
