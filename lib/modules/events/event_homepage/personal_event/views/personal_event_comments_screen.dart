import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_comments_card.dart';
import 'package:flutter/scheduler.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/common_comments_header_view.dart';
import '../../../../../common/widgets/event_t_card.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_comment_model.dart';
import '../../../../../utility/constants/constants.dart';

class PersonalEventCommentsSection extends ConsumerStatefulWidget {
  final String personalEventHeaderId;
  const PersonalEventCommentsSection({
    super.key,
    required this.personalEventHeaderId,
  });

  @override
  ConsumerState<PersonalEventCommentsSection> createState() =>
      _PersonalEventCommentsSectionState();
}

class _PersonalEventCommentsSectionState extends ConsumerState<PersonalEventCommentsSection> {
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();
  String selectedFilter = '';
  ScrollController scrollController = ScrollController();
  int? replyIndex;
  int? replyParantsID;

  bool isFav = false;

  favClick() {
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  void initState() {
    selectedFilter = commonCommentFilterList[0];
    super.initState();
    // getComments(true);
    print('widget.personalEventHeaderId.toString() ***** ${widget.personalEventHeaderId.toString()}');
    initiallize();
    focusNode.addListener(_onFocusChange);
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      print("isPopular ************* $isPopular");
      await ref.read(personalEventHomeController).getAllPersonalEventComments(
        personalEventHeaderId: widget.personalEventHeaderId,
        shortByPopular: isPopular,
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
    int? parentCommentID,
    required int personalEventHeaderId,
    required String comment,
  }) async {
    focusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      commentController.clear();
      await ref.read(personalEventHomeController).writePersonalEventComment(
          personalEventHeaderId: personalEventHeaderId,
          parentCommentId: replyParantsID,
          comment: comment,
          commentedOn: DateTime.now(),
          ref: ref,
          context: context);
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(personalEventHomeController).getPersonalEventAllCommentsSecondTime(
        personalEventHeaderId: widget.personalEventHeaderId,
        shortByPopular: isPopular,
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
    commentController.clear();
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
                          final evetnCtr =
                          ref.watch(personalEventHomeController);
                          return CommonCommentsHeaderView(selectedFilter: selectedFilter,
                              commentCount: evetnCtr.personalEventCommentModel ==
                                  null ||
                                  evetnCtr.personalEventCommentModel
                                      ?.comments ==
                                      null ||
                                  evetnCtr
                                      .personalEventCommentModel
                                      ?.comments
                                      ?.length ==
                                      0
                                  ? '0'
                                  : evetnCtr.personalEventCommentModel!
                                  .comments!.length
                                  .toString(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedFilter = newValue ?? commonCommentFilterList[0];
                                });
                                // print('selectedFilter ********** $selectedFilter');
                                await initiallize();
                              }
                          );
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                          final evetnCtr = ref.watch(personalEventHomeController);

                          return evetnCtr.personalEventCommentModel == null ||
                              evetnCtr.personalEventCommentModel?.comments ==
                                  null ||
                              evetnCtr.personalEventCommentModel?.comments
                                  ?.length ==
                                  0
                              ? const Spacer()
                              : Expanded(
                            child: ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: evetnCtr
                                  .personalEventCommentModel!.comments!.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                Comment model = evetnCtr
                                    .personalEventCommentModel!.comments![index];
                                return replyIndex == null
                                    ? PersonalEventCommentCard(
                                  isReply: false,
                                  commentModel: model,
                                  onReplyClick: (parantsCmtId) {
                                    print("onReplyClick *********** $replyIndex");
                                    print("onReplyClick *********** $parantsCmtId");
                                    setState(() {
                                      replyIndex = index;
                                      replyParantsID = parantsCmtId;
                                      focusNode.requestFocus();
                                    });

                                    print("onReplyClick *********** $replyIndex");
                                    print("onReplyClick *********** $replyParantsID");
                                    print("onReplyClick *********** ${focusNode.hasFocus}");
                                  },
                                )
                                    : replyIndex == index
                                    ? PersonalEventCommentCard(
                                  isReply: true,
                                  commentModel: model,
                                  onReplyClick: (parantsCmtId) {
                                    setState(() {
                                      replyIndex = index;
                                      replyParantsID =
                                          parantsCmtId;
                                      focusNode.requestFocus();
                                    });
                                  },
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
                          final evetnCtr = ref.watch(personalEventHomeController);
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
                                                  scrollController.position
                                                      .minScrollExtent,
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
                                        var userId =
                                        PreferenceUtils.getString(
                                            PreferenceKey.userId);
                                        if (userId == 10106.toString()) {
                                          Utility
                                              .showAlertMessageForGuestUser(
                                              context);
                                        } else {
                                          if (replyIndex != null) {
                                            commentController.text.isNotEmpty
                                                ? await doCommentAgain(
                                              parentCommentID: replyParantsID,
                                              personalEventHeaderId: int.parse(
                                                  widget.personalEventHeaderId),
                                              comment:
                                              commentController.text,
                                            )
                                                : null;
                                          } else {
                                            commentController.text.isNotEmpty
                                                ? await doCommentAgain(
                                              parentCommentID:
                                              replyParantsID,
                                              personalEventHeaderId: int.parse(
                                                  widget.personalEventHeaderId.toString()),
                                              comment:
                                              commentController.text,
                                            )
                                                : null;
                                          }}
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