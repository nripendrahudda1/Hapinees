import 'dart:io';

import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/modules/events/edit_ritual/controllers/update_ritual_controller.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../common/widgets/e_top_backbutton.dart';
import '../../../../common/widgets/e_top_editbutton.dart';
import '../../../../core/enums/user_role_enum.dart';
import '../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import '../widgets/ritual_photo_comment_section.dart';
import '../widgets/see_more_text_widget.dart';

class RitualScreen extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel homeWeddingDetailsModel;
  final WeddingRitualList ritualModels;
  final int ritualIndex;
  const RitualScreen({
    super.key,
    required this.homeWeddingDetailsModel,
    required this.ritualIndex,
    required this.ritualModels,
  });

  @override
  ConsumerState<RitualScreen> createState() => _RitualScreenState();
}

class _RitualScreenState extends ConsumerState<RitualScreen> {
  int selectedImage = 0;
  int likesCount = 0;
  bool isFav = false;
  List<String> ritualImages = [];
  List<int> ritualImageIds = [];

  Future favClick() async {
    print(
        'Wedding Header ID: ${ref.read(weddingEventHomeController).homeWeddingDetails!.weddingHeaderId!}');
    setState(() {
      isFav = !isFav;
      likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
      print('Likes:  $likesCount');
    });
    await ref.read(weddingEventHomeController).likeRitualPhoto(
        isUnLike: !isFav,
        weddingRitualPhotoId: ritualImageIds[selectedImage],
        likedOn: DateTime.now(),
        ref: ref,
        context: context);
    await ref.read(weddingEventHomeController).getAllRitualPhotoLikes(
        weddingRitualPhotoId: ritualImageIds[selectedImage].toString(), ref: ref, context: context);
  }

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      print(
          'Ritual ID: ${widget.homeWeddingDetailsModel.weddingRitualList![selectedImage].weddingRitualId.toString()}');
      await ref.read(updateRitualController).getRitualImages(
            context: context,
            ref: ref,
            weddingRitualId: widget.ritualModels.weddingRitualId.toString(),
          );
      ritualImages = ref.read(updateRitualController).ritualImages ?? [];
      if (ritualImages.isEmpty) {
        ritualImages = [widget.ritualModels.backgroundImageUrl!];
      }
      ritualImageIds = ref.read(updateRitualController).ritualImageIds;
      await getLikesAndComments();
    });
  }

  getLikesAndComments() async {
    isFav = false;
    likesCount = 0;
    final eventHomeCtr = ref.read(weddingEventHomeController);
    await ref.read(weddingEventHomeController).getAllRitualPhotoLikes(
        weddingRitualPhotoId: ritualImageIds[selectedImage].toString(), ref: ref, context: context);

    await ref.read(weddingEventHomeController).getRitualPhotoAllCommentsFirstTime(
          weddingRitualPhotoId: ritualImageIds[selectedImage].toString(),
          sortByPopular: false,
          offset: 0,
          noOfRecords: 1000,
          ref: ref,
          context: context,
        );

    likesCount = eventHomeCtr.ritualPhotoUserLikesModel?.ritualPhotoLikeUsers?.length ?? 0;
    setState(() {});
    eventHomeCtr.ritualPhotoUserLikesModel?.ritualPhotoLikeUsers?.forEach((element) {
      if (element.email ==
          ref.read(weddingEventHomeController).homeWeddingDetails!.createdBy!.email) {
        isFav = true;
        setState(() {
          likesCount = isFav == true ? likesCount + 1 : likesCount - 1;
        });
      } else {
        isFav = false;
        setState(() {});
      }
    });
  }

  getRitualNames(HomeWeddingDetailsModel model) {
    List<String> tempNames = [];
    model.weddingRitualList?.forEach((element) {
      tempNames.add(element.ritualName ?? '');
    });
    return tempNames;
  }

  Future<dynamic> listOfComments({
    required BuildContext context,
    required String weddingRitualPhotoId,
  }) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return RitualPhotoCommentSection(
          weddingRitualPhotoId: weddingRitualPhotoId,
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
          final weddingCtr = ref.watch(weddingEventHomeController);
          return Stack(
            children: [
              Stack(
                children: [
                  ritualImages.isEmpty
                      ? CachedRectangularNetworkImageWidget(
                          image: widget.ritualModels.backgroundImageUrl ?? '',
                          width: 1.sw,
                          height: 1.sh)
                      : CachedRectangularNetworkImageWidget(
                          image: ritualImages[selectedImage], width: 1.sw, height: 1.sh),
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
                                          await getLikesAndComments();
                                        },
                                        icon: TImageName.arrowBackPngIcon),
                                  )
                                : widget.ritualIndex > 0
                                    ? Padding(
                                        padding: EdgeInsets.all(15.0.w),
                                        child: ERitualAndActivityButton(
                                            onTap: () async {
                                              Navigator.pushNamed(
                                                  context, Routes.eventRitualBackward,
                                                  arguments: {
                                                    'homeWeddingDetailsModel':
                                                        widget.homeWeddingDetailsModel,
                                                    'ritualIndex': widget.ritualIndex - 1,
                                                    'ritualModels': widget.homeWeddingDetailsModel
                                                        .weddingRitualList![widget.ritualIndex - 1],
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
                            selectedImage != ritualImages.length - 1 && ritualImages.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(15.0.w),
                                    child: ERitualAndActivityButton(
                                        onTap: () async {
                                          setState(() {
                                            selectedImage < ritualImages.length - 1
                                                ? selectedImage++
                                                : null;
                                          });
                                          await getLikesAndComments();
                                        },
                                        icon: TImageName.arrowForwardPngIcon),
                                  )
                                : widget.ritualIndex + 1 <
                                        widget.homeWeddingDetailsModel.weddingRitualList!.length
                                    ? Padding(
                                        padding: EdgeInsets.all(15.0.w),
                                        child: ERitualAndActivityButton(
                                            onTap: () async {
                                              Navigator.pushNamed(
                                                  context, Routes.eventRitualForward,
                                                  arguments: {
                                                    'homeWeddingDetailsModel':
                                                        widget.homeWeddingDetailsModel,
                                                    'ritualIndex': widget.ritualIndex + 1,
                                                    'ritualModels': widget.homeWeddingDetailsModel
                                                        .weddingRitualList![widget.ritualIndex + 1],
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
                          topPaddingIphone(topPadding: 0.h),
                          Row(
                            children: List.generate(
                                ritualImages.length,
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
                              Container(
                                width: MediaQuery.of(context).size.width / 1.4,
                                constraints: BoxConstraints(maxWidth: 0.8.sw),
                                child: Text(
                                  widget.homeWeddingDetailsModel.title ?? '',
                                  // maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size18, color: TAppColors.white),
                                ),
                              ),
                              const Spacer(),
                              weddingCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                                  ? const SizedBox()
                                  : ETopEditButton(
                                      onTap: () async {
                                        Navigator.pushNamed(context, Routes.editRitualScreen,
                                            arguments: {
                                              'homeWeddingDetailsModel':
                                                  widget.homeWeddingDetailsModel,
                                              'ritualIndex': widget.ritualIndex,
                                            });
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
                                  widget.ritualModels.ritualName ?? '',
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
                                text: widget.ritualModels.aboutRitual == ''
                                    ? '.'
                                    : widget.ritualModels.aboutRitual ?? '.'),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          ritualImageIds.isEmpty
                              ? SizedBox(
                                  height: 50.h,
                                )
                              : Consumer(
                                  builder: (BuildContext context, WidgetRef ref, Widget? child) {
                                    final eventHomeCtr = ref.watch(weddingEventHomeController);
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
                                                isFav
                                                    ? TImageName.heartRedPngIcon
                                                    : TImageName.heartPngIcon,
                                                width: 22.w,
                                                height: 22.h,
                                              ),
                                              onPressed: favClick),
                                          Text(
                                            likesCount.toString()
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
                                                weddingRitualPhotoId:
                                                    ritualImageIds[selectedImage].toString(),
                                                context: context,
                                              );
                                              // Navigator.pushNamed(context, Routes.eventRitualCommentsScreen);
                                              // listOfComments(context,
                                              //     count: '348', title: TLabelStrings.comments);
                                            },
                                          ),
                                          Text(
                                            eventHomeCtr
                                                    .ritualPhotoAllCommentsModel?.comments?.length
                                                    .toString() ??
                                                "0",
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
                                            onPressed: () {},
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
              ref.watch(updateRitualController).isLoading
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
