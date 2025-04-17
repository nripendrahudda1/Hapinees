import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/rituals/widgets/ritual_photo_comment_card.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../../../../common/widgets/common_comments_header_view.dart';
import '../../../../models/create_event_models/create_wedding_models/ritual_photo_all_comments_model.dart';
import '../../event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import '../../../../common/widgets/event_t_card.dart';

class RitualPhotoCommentSection extends ConsumerStatefulWidget {
  final String weddingRitualPhotoId;

  const RitualPhotoCommentSection({
    super.key,
    required this.weddingRitualPhotoId,
  });

  @override
  ConsumerState<RitualPhotoCommentSection> createState() =>
      _RitualPhotoCommentSectionState();
}

class _RitualPhotoCommentSectionState
    extends ConsumerState<RitualPhotoCommentSection> {
  int selectedRitual = 0;
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();
  String selectedFilter = '';
  ScrollController scrollController = ScrollController();
  int? replyIndex;
  int? replyParantsID;

  bool isFav = false;

  // favClick() {
  //   setState(() {
  //     isFav = !isFav;
  //   });
  // }

  @override
  void initState() {
    selectedFilter = commonCommentFilterList[0];
    super.initState();
    // getComments(true);
    initiallize();
    focusNode.addListener(_onFocusChange);
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(weddingEventHomeController).getRitualPhotoAllComments(
            weddingRitualPhotoId: widget.weddingRitualPhotoId,
            sortByPopular: isPopular,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );
    });
  }

  void _onFocusChange() {
    setState(() {
      isKeyBoardFocus = focusNode.hasFocus;
      !isKeyBoardFocus ? replyIndex = null : null;
    });
  }

  doCommentAgain({
    int? parantCommentID,
    required String comment,
  }) async {
    focusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      commentController.clear();
      await ref.read(weddingEventHomeController).writeRitualPhotoComment(
          weddingRitualPhotoId: int.parse(widget.weddingRitualPhotoId),
          parentComentId: replyParantsID,
          comment: comment,
          commentedOn: DateTime.now(),
          ref: ref,
          context: context);
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(weddingEventHomeController).getRitualPhotoAllComments(
            weddingRitualPhotoId: widget.weddingRitualPhotoId,
            sortByPopular: isPopular,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );
      setState(() {
        replyParantsID = null;
      });
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TAppColors.black, // 80% opacity black at the top
              TAppColors.black.withOpacity(0.8),
              TAppColors.black.withOpacity(0.5),
              TAppColors.black.withOpacity(0.5),
              TAppColors.black
                  .withOpacity(0.8), // 80% opacity black at the bottom
              TAppColors.black
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 6.sh * 0.04, 14.w, 0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.0.w, right: 2.w),
                  child: Column(
                    children: [
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final evetnCtr =
                          ref.watch(weddingEventHomeController);
                          return CommonCommentsHeaderView(selectedFilter: selectedFilter, onChanged: (String? newValue) async {
                            setState(() {
                              selectedFilter = newValue ?? commonCommentFilterList[0];
                            });
                            await initiallize();
                          }, commentCount: evetnCtr.ritualPhotoAllCommentsModel == null ||
                              evetnCtr.ritualPhotoAllCommentsModel
                                  ?.comments ==
                                  null ||
                              (evetnCtr.ritualPhotoAllCommentsModel
                                  ?.comments ??
                                  '') ==
                                  ''
                              ? '0'
                              : evetnCtr
                              .ritualPhotoAllCommentsModel!
                              .comments!
                              .length
                              .toString());
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final evetnCtr = ref.watch(weddingEventHomeController);

                          return evetnCtr.ritualPhotoAllCommentsModel == null ||
                                  evetnCtr.ritualPhotoAllCommentsModel
                                          ?.comments ==
                                      null ||
                                  (evetnCtr.ritualPhotoAllCommentsModel
                                              ?.comments ??
                                          '') ==
                                      ''
                              ? const Spacer()
                              : Expanded(
                                  child: ListView.separated(
                                    controller: scrollController,
                                    padding: EdgeInsets.zero,
                                    itemCount: evetnCtr
                                        .ritualPhotoAllCommentsModel!
                                        .comments!
                                        .length,
                                    physics: const ClampingScrollPhysics(),
                                    //shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      RitualComment model = evetnCtr
                                          .ritualPhotoAllCommentsModel!
                                          .comments![index];

                                      return replyIndex == null
                                          ? RitualPhotoCommentCard(
                                        isReply: false,
                                        commentModel: model,
                                        onReplyClick: (parantsCmtId) {
                                          replyIndex = index;
                                          replyParantsID = parantsCmtId;
                                          focusNode.requestFocus();
                                          },
                                      ) : replyIndex == index
                                          ? RitualPhotoCommentCard(
                                        isReply: true,
                                        commentModel: model,
                                        onReplyClick: (parantsCmtId) {
                                          replyIndex = index;
                                          replyParantsID =
                                              parantsCmtId;
                                          focusNode.requestFocus();
                                          },
                                      ) : const SizedBox.shrink();
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                          height: replyIndex == null
                                              ? 6
                                              : replyIndex == index
                                                  ? 6
                                                  : 0);
                                    },
                                  ),
                                );
                        },
                      ),
                      SizedBox(height: 10.h),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final evetnCtr = ref.watch(weddingEventHomeController);
                          return EventTCard(
                              height: 40.h,
                              color: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: CTTextField(
                                            hint: 'Write comment here ...',
                                            controller: commentController,
                                            focusNode: focusNode,
                                            onTap: () {
                                              SchedulerBinding.instance
                                                  .addPostFrameCallback((_) {
                                                scrollController.animateTo(
                                                  scrollController
                                                      .position.minScrollExtent,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.easeInOut,
                                                );
                                              });
                                            },
                                          onTapOutside: (p0) {
                                            FocusScope.of(context).unfocus();
                                          },
                                        )),
                                    InkWell(
                                      onTap: () async {
                                        if (replyIndex != null) {
                                          commentController.text.isNotEmpty
                                              ? await doCommentAgain(
                                                  parantCommentID:
                                                      replyParantsID,
                                                  comment:
                                                      commentController.text,
                                                )
                                              : null;
                                        } else {
                                          commentController.text.isNotEmpty
                                              ? await doCommentAgain(
                                                  parantCommentID:
                                                      replyParantsID,
                                                  comment:
                                                      commentController.text,
                                                )
                                              : null;
                                        }
                                      },
                                      splashColor: TAppColors.transparent,
                                      child: Image.asset(
                                        TImageName.send,
                                        height: 24.h,
                                        width: 24.h,
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      // if (!isKeyBoardFocus)
                      !isKeyBoardFocus
                          ? SizedBox(
                              height: dheight! * 0.1,
                              child: Padding(
                                padding: EdgeInsets.only(top: 0.03.sh),
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: TCard(
                                        radius: 14,
                                        color: Colors.white.withOpacity(0.1),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 4.h),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset(
                                                TImageName.arrowUpPngIcon,
                                                height: 16.h,
                                                width: 16.h,
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              Text(
                                                "Hide",
                                                style: getBoldStyle(
                                                    fontSize: MyFonts.size12,
                                                    color: TAppColors.white),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
