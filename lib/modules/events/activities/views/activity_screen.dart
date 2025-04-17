import 'dart:io';

import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/common/widgets/e_top_editbutton.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/models/create_event_models/home/wedding_all_images_model.dart';
import 'package:Happinest/modules/events/activities/widgets/activity_photo_comment_section.dart';
import 'package:Happinest/modules/events/e-card/controllers/personal_event_ecard_controller.dart';
import 'package:Happinest/modules/events/edit_activities/controllers/update_activity_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/views/personal_event_comments_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../common/common_default_apis.dart';
import '../../../../common/common_functions/topPadding.dart';
import '../../../../common/common_imports/apis_commons.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../common/widgets/e_top_backbutton.dart';
import '../../../../core/enums/user_role_enum.dart';
import '../../rituals/widgets/see_more_text_widget.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel homePersonalEventDetailsModel;
  final PersonalEventActivityList activityModels;
  final int activityIndex;
  final Function() favClick;
  bool isFav;
  int likesCount;
  ActivityScreen({
    super.key,
    required this.homePersonalEventDetailsModel,
    required this.activityIndex,
    required this.activityModels,
    required this.favClick,
    required this.isFav,
    required this.likesCount,
  });

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  int selectedImage = 0;
  // int likesCount = 0;
  // bool isFav = false;
  List<String> activityImages = [];
  List<int> activityImageIds = [];

  /*Future favClick() async {
    print(
        'personal event Header ID: ${ref.read(personalEventHomeController).homePersonalEventDetailsModel!.personalEventHeaderId!}');
    setState(() {
      isFav = !isFav;
      likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
      print('Likes:  $likesCount');
    });
    await ref.read(personalEventHomeController).likeActivityPhoto(
        isUnLike: !isFav,
        personalEventActivityPhotoId: activityImageIds[selectedImage],
        likedOn: DateTime.now(),
        ref: ref,
        context: context);
    await ref.read(personalEventHomeController).getAllActivityPhotoLikes(
        personalEventActivityPhotoId: activityImageIds[selectedImage].toString(),
        ref: ref,
        context: context);
  }*/

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(
          'Ritual ID: ${widget.homePersonalEventDetailsModel.personalEventActivityList![selectedImage].personalEventActivityId.toString()}');
      await ref.read(updateActivityController).getActivityImages(
            context: context,
            ref: ref,
            personalEventActivityId: widget.activityModels.personalEventActivityId.toString(),
          );
      activityImages = ref.read(updateActivityController).activityImages ?? [];
      if (activityImages.isEmpty) {
        activityImages = [widget.activityModels.backgroundImageUrl ?? ''];
      }
      activityImageIds = ref.read(updateActivityController).activityImageIds;
      await getLikesAndComments();
    });
  }

  getLikesAndComments() async {
    final eventHomeCtr = ref.read(personalEventHomeController);
    /*await ref.read(personalEventHomeController).getAllActivityPhotoLikes(
        personalEventActivityPhotoId: activityImageIds[selectedImage].toString(),
        ref: ref,
        context: context);*/

    await ref.read(personalEventHomeController).getAllPersonalEventComments(
          personalEventHeaderId: ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventHeaderId
                  .toString() ??
              '',
          shortByPopular: false,
          offset: 0,
          noOfRecords: 1000,
          ref: ref,
          context: context,
        );

    /*  likesCount =
        eventHomeCtr.activityPhotoUserLikesModel?.activityPhotoLikeUsers?.length ??
            0;
    setState(() {});
    eventHomeCtr.activityPhotoUserLikesModel?.activityPhotoLikeUsers
        ?.forEach((element) {
          if(element.email == myProfileData!.email) {
            isFav = true;
          }
      // if (element.email ==
      //     ref
      //         .read(personalEventHomeController)
      //         .homePersonalEventDetailsModel!
      //         .createdBy!
      //         .email) {
      //   isFav = true;
      //   // setState(() {
      //   //   likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
      //   // });
      // } else {
      //   isFav = false;
      //   setState(() {});
      // }

    });*/
  }

  getActivityNames(HomePersonalEventDetailsModel model) {
    List<String> tempNames = [];
    model.personalEventActivityList?.forEach((element) {
      tempNames.add(element.activityName ?? '');
    });
    return tempNames;
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String personalEventHeaderId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.transparent,
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final eventCtr = ref.watch(personalEventHomeController);
          return Stack(
            children: [
              Stack(
                children: [
                  activityImages.isEmpty
                      ? CachedRectangularNetworkImageWidget(
                          image: widget.activityModels.backgroundImageUrl ?? '',
                          width: 1.sw,
                          height: 1.sh)
                      : CachedRectangularNetworkImageWidget(
                          image: activityImages[selectedImage], width: 1.sw, height: 1.sh),
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
                            selectedImage != 0
                                ? Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () async {
                                          setState(() {
                                            selectedImage > 0 ? selectedImage-- : null;
                                          });
                                          // await getLikesAndComments();
                                        },
                                        icon: TImageName.arrowBackPngIcon),
                                  )
                                : widget.activityIndex > 0
                                    ? Padding(
                                        padding: EdgeInsets.all(15.0.w),
                                        child: ERitualAndActivityButton(
                                            onTap: () async {
                                              Navigator.pushReplacementNamed(
                                                  context, Routes.eventActivityBackward,
                                                  arguments: {
                                                    'homePersonalEventDetailsModel':
                                                        widget.homePersonalEventDetailsModel,
                                                    'activityIndex': widget.activityIndex - 1,
                                                    'activityModels': widget
                                                            .homePersonalEventDetailsModel
                                                            .personalEventActivityList![
                                                        widget.activityIndex - 1],
                                                    'favClick': widget.favClick,
                                                    'isFav': widget.isFav,
                                                    'likesCount': widget.likesCount,
                                                  });
                                              // Navigator.push(
                                              //   context,
                                              //   leftToRight(RitualScreen(
                                              //       homeWeddingDetailsModel: widget.homeWeddingDetailsModel,
                                              //       ritualIndex:  widget.ritualIndex-1,
                                              //       ritualModels: widget.homeWeddingDetailsModel.weddingRitualList![widget.ritualIndex-1],
                                              //   ),
                                              //     400
                                              //   )
                                              // );
                                            },
                                            icon: TImageName.arrowBackPngIcon),
                                      )
                                    : const SizedBox(),
                          ],
                        )),
                        // ritualImages.isEmpty
                        //     ? const SizedBox()
                        //     :
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            selectedImage != activityImages.length - 1 && activityImages.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () async {
                                          setState(() {
                                            selectedImage < activityImages.length - 1
                                                ? selectedImage++
                                                : null;
                                          });
                                          // await getLikesAndComments();
                                        },
                                        icon: TImageName.arrowForwardPngIcon),
                                  )
                                : widget.activityIndex + 1 <
                                        widget.homePersonalEventDetailsModel
                                            .personalEventActivityList!.length
                                    ? Padding(
                                        padding: EdgeInsets.all(15.0.w),
                                        child: ERitualAndActivityButton(
                                            onTap: () async {
                                              Navigator.pushReplacementNamed(
                                                  context, Routes.eventActivityForward,
                                                  arguments: {
                                                    'homePersonalEventDetailsModel':
                                                        widget.homePersonalEventDetailsModel,
                                                    'activityIndex': widget.activityIndex + 1,
                                                    'activityModels': widget
                                                            .homePersonalEventDetailsModel
                                                            .personalEventActivityList![
                                                        widget.activityIndex + 1],
                                                    'favClick': widget.favClick,
                                                    'isFav': widget.isFav,
                                                    'likesCount': widget.likesCount,
                                                  });
                                            },
                                            icon: TImageName.arrowForwardPngIcon),
                                      )
                                    : const SizedBox(),
                          ],
                        )),
                      ],
                    ),
                  ),
                  CustomSafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(15.w, Platform.isAndroid ? 0 : 1.sh * 0.04, 15.w, 0),
                      child: Column(
                        children: [
                          // topPaddingIphone(topPadding: 0.h),
                          Row(
                            children: List.generate(
                                activityImages.length,
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
                                  Navigator.canPop(context)
                                      ? Navigator.pop(context)
                                      : Navigator.pushReplacementNamed(context, Routes.homeRoute);
                                  // Navigator.pushNamedAndRemoveUntil(
                                  //     context,
                                  //     Routes.eventHomePageScreen,
                                  //     arguments: {
                                  //       'weddingId': null
                                  //     },
                                  //     (route) => false);
                                },
                              ),
                              SizedBox(
                                width: 21.w,
                              ),
                              Expanded(
                                child: Text(
                                  widget.homePersonalEventDetailsModel.title ?? '',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size18, color: TAppColors.white),
                                ),
                              ),
                              eventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                                  ? const SizedBox()
                                  : ETopEditButton(
                                      onTap: () async {
                                        Navigator.pushNamed(context, Routes.editActivityScreen,
                                            arguments: {
                                              'homePersonalEventDetailsModel':
                                                  widget.homePersonalEventDetailsModel,
                                              'activityIndex': widget.activityIndex,
                                            });
                                        /*Navigator.pushNamed(
                                      context, Routes.editRitualScreen,
                                      arguments: {
                                        'homeWeddingDetailsModel':
                                        widget.homeWeddingDetailsModel,
                                        'ritualIndex': widget.ritualIndex,
                                      });*/
                                      },
                                    )
                            ],
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Image.asset(
                                TImageName.logoSmall,
                                height: 24,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Text(
                                  widget.activityModels.activityName ?? '',
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size18, color: TAppColors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SeeMoreTextWidget(
                                text: widget.activityModels.aboutActivity == ''
                                    ? '.'
                                    : widget.activityModels.aboutActivity ?? '.'),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          activityImageIds.isEmpty
                              ? SizedBox(
                                  height: 50.h,
                                )
                              : Consumer(
                                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                    final eventHomeCtr = ref.watch(personalEventHomeController);
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            padding: const EdgeInsets.all(0),
                                            alignment: Alignment.center,
                                            enableFeedback: true,
                                            icon: Image.asset(
                                              widget.isFav
                                                  ? TImageName.heartRedPngIcon
                                                  : TImageName.heartPngIcon,
                                              width: 22.w,
                                              height: 22.h,
                                            ),
                                            onPressed: () {
                                              widget.favClick.call();
                                              setState(() {
                                                if (widget.isFav) {
                                                  widget.isFav = !widget.isFav;
                                                  widget.likesCount--;
                                                } else if (widget.isFav == false) {
                                                  widget.isFav = !widget.isFav;
                                                  widget.likesCount++;
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            widget.likesCount.toString()
                                            // eventHomeCtr.ritualPhotoUserLikesModel
                                            //         ?.ritualPhotoLikeUsers?.length
                                            //         .toString() ??
                                            //     '0'
                                            ,
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
                                                personalEventHeaderId: eventCtr
                                                        .homePersonalEventDetailsModel
                                                        ?.personalEventHeaderId
                                                        .toString() ??
                                                    '',
                                                context: context,
                                              );
                                              // Navigator.pushNamed(context, Routes.eventRitualCommentsScreen);
                                              // listOfComments(context,
                                              //     count: '348', title: TLabelStrings.comments);
                                            },
                                          ),
                                          Text(
                                            eventCtr.personalEventCommentModel != null &&
                                                    eventCtr.personalEventCommentModel?.comments !=
                                                        null
                                                ? eventCtr
                                                    .personalEventCommentModel!.comments!.length
                                                    .toString()
                                                : "0",
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
                                            onPressed: () async {
                                              await ref
                                                  .watch(personalEventECardCtr)
                                                  .setCurrentImage(
                                                      activityImages[selectedImage] ?? '');
                                              Navigator.pushNamed(
                                                  context, Routes.personalEventECardScreen,
                                                  arguments: {'isSingleImage': true});
                                              // EasyLoading.showError("Coming Soon");
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              ref.watch(updateActivityController).isLoading
                  ? Positioned.fill(
                      child: Container(
                        color: Colors.black45,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
