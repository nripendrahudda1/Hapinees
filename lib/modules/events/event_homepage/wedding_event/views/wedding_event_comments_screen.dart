import 'package:Happinest/common/widgets/common_comments_header_view.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../../../../../models/create_event_models/create_wedding_models/wedding_event_comment_model.dart';
import '../controller/wedding_event_home_controller.dart';
import '../widgets/wedding_event_comment_card.dart';
import '../../../../../common/widgets/event_t_card.dart';

class WeddingEventCommentsSection extends ConsumerStatefulWidget {
  final String weddingHeaderId;
  const WeddingEventCommentsSection({
    super.key,
    required this.weddingHeaderId,
  });

  @override
  ConsumerState<WeddingEventCommentsSection> createState() =>
      _WeddingEventCommentsSectionState();
}

class _WeddingEventCommentsSectionState extends ConsumerState<WeddingEventCommentsSection> {
  int selectedRitual = 0;
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
    initiallize();
    focusNode.addListener(_onFocusChange);
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(weddingEventHomeController).getAllWeddingEventComments(
            weddingHeaderId: widget.weddingHeaderId,
            sortByPopular: isPopular,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
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
    required int weddingHeaderId,
    required String comment,
  }) async {
    focusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      commentController.clear();
      await ref.read(weddingEventHomeController).writeWeddingComment(
          weddingHeaderId: weddingHeaderId,
          parentComentId: replyParantsID,
          comment: comment,
          commentedOn: DateTime.now(),
          ref: ref,
          context: context);
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(weddingEventHomeController).getWeddingAllCommentsSecondTime(
            weddingHeaderId: widget.weddingHeaderId,
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
                          ref.watch(weddingEventHomeController);
                          return CommonCommentsHeaderView(selectedFilter: selectedFilter,
                              commentCount: evetnCtr.eventCommentModel ==
                                  null ||
                                  evetnCtr.eventCommentModel
                                      ?.comments ==
                                      null ||
                                  evetnCtr
                                      .eventCommentModel
                                      ?.comments
                                      ?.length ==
                                      0
                                  ? '0'
                                  : evetnCtr.eventCommentModel!
                                  .comments!.length
                                  .toString(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  selectedFilter = newValue ?? commonCommentFilterList[0];
                                });
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
                          final evetnCtr = ref.watch(weddingEventHomeController);

                          return evetnCtr.eventCommentModel == null ||
                                  evetnCtr.eventCommentModel?.comments ==
                                      null ||
                                  evetnCtr.eventCommentModel?.comments
                                          ?.length ==
                                      0
                              ? const Spacer()
                              : Expanded(
                                  child: ListView.separated(
                                    controller: scrollController,
                                    padding: EdgeInsets.zero,
                                    itemCount: evetnCtr
                                        .eventCommentModel!.comments!.length,
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      Comment model = evetnCtr
                                          .eventCommentModel!.comments![index];
                                      return replyIndex == null
                                          ? WeddingEventCommentCard(
                                        isReply: false,
                                        commentModel: model,
                                        onReplyClick: (parantsCmtId) {
                                          replyIndex = index;
                                          replyParantsID = parantsCmtId;
                                          focusNode.requestFocus();
                                          },
                                      ) : replyIndex == index
                                          ? WeddingEventCommentCard(
                                        isReply: true,
                                        commentModel: model,
                                        onReplyClick: (parantsCmtId) {
                                          replyIndex = index;
                                          replyParantsID =
                                              parantsCmtId;
                                          focusNode.requestFocus();
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
                                                  parantCommentID:
                                                      replyParantsID,
                                                  weddingHeaderId: int.parse(
                                                      widget.weddingHeaderId),
                                                  comment:
                                                      commentController.text,
                                                )
                                              : null;
                                        } else {
                                          commentController.text.isNotEmpty
                                              ? await doCommentAgain(
                                                  parantCommentID:
                                                      replyParantsID,
                                                  weddingHeaderId: int.parse(
                                                      widget.weddingHeaderId),
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
