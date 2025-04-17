import 'dart:ffi';

import 'package:Happinest/models/create_event_models/moments/personal_event_moments/perosnal_event_post_all_comment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/personal_event/personal_event_moments_post_comment_card.dart';
import 'package:flutter/scheduler.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/common_comments_header_view.dart';
import '../../../../../../common/widgets/event_t_card.dart';
import '../../../../../../utility/constants/constants.dart';

class PersonalEventMomentPostCommentSection extends ConsumerStatefulWidget {
  final String personalEventPostId;
  final Function() commentCall;
  final String? token;

  const PersonalEventMomentPostCommentSection({
    super.key,
    required this.personalEventPostId,
    required this.commentCall,
    required this.token
  });

  @override
  ConsumerState<PersonalEventMomentPostCommentSection> createState() =>
      _PersonalEventMomentPostCommentSectionState();
}

class _PersonalEventMomentPostCommentSectionState
    extends ConsumerState<PersonalEventMomentPostCommentSection> {
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
      String token = widget.token ?? '';
      await ref.read(personalEventMemoriesController).getMemoryPostAllCommentsFirstTime(
        personalEventPostId: widget.personalEventPostId,
        token: token,
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
      String token = widget.token ?? '';
      commentController.clear();
      PersonalEventPostCommentPostModel model = PersonalEventPostCommentPostModel(
        parentCommentId: replyParantsID,
        personalEventPostId: int.parse(widget.personalEventPostId),
        comment: comment,
        commentedOn: DateTime.now(),
      );
      await ref.read(personalEventMemoriesController).setPostComment(
          personalEventPostCommentPostModel: model,
          token: token,
          ref: ref,
          context: context);
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(personalEventMemoriesController).getMemoryPostAllComments(
        personalEventPostId: widget.personalEventPostId,
        token: token,
        sortByPopular: isPopular,
        offset: 0,
        noOfRecords: 1000,
        ref: ref,
        context: context,
      );
      widget.commentCall.call();
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
        color: TAppColors.black.withOpacity(0.30),
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
                          final memoriesCtr =
                          ref.watch(personalEventMemoriesController);
                          return CommonCommentsHeaderView(selectedFilter: selectedFilter,
                              commentCount: memoriesCtr.postAllCommentsModel ==
                                  null ||
                                  memoriesCtr
                                      .postAllCommentsModel
                                      ?.comments ==
                                      null ||
                                  (memoriesCtr
                                      .postAllCommentsModel
                                      ?.comments!
                                      .isEmpty ??
                                      true)
                                  ? '0'
                                  : memoriesCtr
                                  .postAllCommentsModel!
                                  .comments!
                                  .length
                                  .toString(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedFilter = newValue ?? commonCommentFilterList[0];
                                });
                                await initiallize();
                              });
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final memoriesCtr =
                          ref.watch(personalEventMemoriesController);
                          print("memoriesCtr.postAllCommentsModel ${memoriesCtr.postAllCommentsModel}");
                          print("memoriesCtr.postAllCommentsModel?.comments ${memoriesCtr.postAllCommentsModel?.comments}");
                          print("memoriesCtr.postAllCommentsModel?.comments?.isEmpty ${memoriesCtr.postAllCommentsModel?.comments?.isEmpty}");
                          return memoriesCtr.postAllCommentsModel == null ||
                              memoriesCtr.postAllCommentsModel?.comments ==
                                  null ||
                              (memoriesCtr.postAllCommentsModel?.comments
                                  ?.isEmpty ??
                                  true)
                              ? const Spacer()
                              : Expanded(
                            child: ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: memoriesCtr
                                  .postAllCommentsModel!.comments!.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                PersonalEventPostComment model = memoriesCtr
                                    .postAllCommentsModel!
                                    .comments![index];

                                return replyIndex == null ? PersonalEventMomentPostCommentCard(
                                  isReply: false,
                                  commentModel: model,
                                  onReplyClick: (parantsCmtId) {
                                    replyIndex = index;
                                    replyParantsID = parantsCmtId;
                                    focusNode.requestFocus();
                                  },
                                  token: PreferenceUtils.getString(PreferenceKey.accessToken),
                                ) : replyIndex == index
                                    ? PersonalEventMomentPostCommentCard(
                                  isReply: true,
                                  commentModel: model,
                                  onReplyClick: (parantsCmtId) {
                                    replyIndex = index;
                                    replyParantsID =
                                        parantsCmtId;
                                    focusNode.requestFocus();
                                  },
                                  token: PreferenceUtils.getString(PreferenceKey.accessToken),
                                )
                                    : const SizedBox.shrink();
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