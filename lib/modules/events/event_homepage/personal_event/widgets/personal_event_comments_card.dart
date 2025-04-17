import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../common/widgets/common_comment_card.dart';
import '../../../../../common/widgets/common_comment_reply_card.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_comment_model.dart';

class PersonalEventCommentCard extends ConsumerStatefulWidget {
  const PersonalEventCommentCard({
    super.key,
    required this.onReplyClick,
    required this.commentModel,
    required this.isReply,
  });

  final Comment commentModel;
  final Function(int parantsCmtId) onReplyClick;
  final bool isReply;

  @override
  ConsumerState<PersonalEventCommentCard> createState() => _PersonalEventCommentCardState();
}

class _PersonalEventCommentCardState extends ConsumerState<PersonalEventCommentCard> {
  bool isFav = false;
  bool isShowReply = false;
  Comment? commentData;

  Future doLike() async {
    var userId = PreferenceUtils.getString(PreferenceKey.userId);
    if (userId == 10106.toString()) {
      Utility.showAlertMessageForGuestUser(context);
    } else {
      await ref.read(personalEventHomeController).likePersonalEventComment(
          isUnLike: isFav,
          personalEventCommentId: commentData!.personalEventCommentId!,
          likedOn: DateTime.now(),
          ref: ref,
          context: context);
      setState(() {
        isFav
            ? commentData!.totalLikes = (commentData!.totalLikes ?? 1) - 1
            : commentData!.totalLikes = (commentData!.totalLikes ?? 0) + 1;
        isFav = !isFav;
      });
    }
  }

  switchIsShowReply() {
    setState(() {
      isShowReply = !isShowReply;
    });
  }

  @override
  void initState() {
    setState(() {
      isFav = widget.commentModel.isLikedBySelf ?? false;
      commentData = widget.commentModel;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TCard(
          color: TAppColors.transparent,
          border: true,
          borderColor: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedCircularNetworkImageWidget(
                      isWhiteBorder: true,
                      image: widget.commentModel.commentedBy?.profileImageUrl ??
                          '',
                      size: 36),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        CommonCommentCard(
                          isReply: widget.isReply,
                            commentModel: widget.commentModel,
                            onReplyClick: () {
                            print("commentModel onReplyClick ****** ");
                              var userId =
                              PreferenceUtils.getString(
                                  PreferenceKey.userId);
                            print("commentModel onReplyClick ****** $userId");
                              if (userId == 10106.toString()) {
                                Utility
                                    .showAlertMessageForGuestUser(
                                    context);
                              } else {
                                print("commentModel onReplyClick ****** ${widget.commentModel.personalEventCommentId }");
                                widget.onReplyClick(
                                    widget.commentModel.personalEventCommentId ??
                                        0);}
                            }, likeOnTab: () {
                          doLike();
                        }, isLike: isFav),
                        if (!isShowReply &&
                            widget.commentModel.personalEventCommentReplies != null &&
                            widget
                                .commentModel.personalEventCommentReplies!.isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: switchIsShowReply,
                            child: Row(
                              children: [
                                Container(
                                  color: TAppColors.white,
                                  height: 1.h,
                                  width: 16.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "View ${widget.commentModel.personalEventCommentReplies!.length} more replies",
                                  style: getRobotoRegularStyle(
                                      fontSize: MyFonts.size12,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        if (isShowReply &&
                            widget.commentModel.personalEventCommentReplies != null &&
                            widget
                                .commentModel.personalEventCommentReplies!.isNotEmpty)
                          Column(
                            children: [
                              ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return CommonCommentReplyCard(
                                      replyComment: widget.commentModel
                                          .personalEventCommentReplies![i],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 0.h);
                                  },
                                  itemCount: widget.commentModel
                                      .personalEventCommentReplies!.length),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: switchIsShowReply,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        color: TAppColors.white,
                                        height: 1.h,
                                        width: 16.w,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text(
                                        "Hide replies",
                                        style: getRobotoRegularStyle(
                                            fontSize: MyFonts.size12,
                                            color: TAppColors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  )
                ]),
          )),
    );
  }
}
