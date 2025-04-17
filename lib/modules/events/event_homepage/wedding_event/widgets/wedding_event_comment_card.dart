import 'package:Happinest/common/widgets/common_comment_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';

import '../../../../../common/widgets/common_comment_reply_card.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_event_comment_model.dart';
import '../controller/wedding_event_home_controller.dart';

class WeddingEventCommentCard extends ConsumerStatefulWidget {
  const WeddingEventCommentCard({
    super.key,
    required this.onReplyClick,
    required this.commentModel,
    required this.isReply,
  });

  final Comment commentModel;
  final Function(int parantsCmtId) onReplyClick;
  final bool isReply;

  @override
  ConsumerState<WeddingEventCommentCard> createState() => _WeddingEventCommentCardState();
}

class _WeddingEventCommentCardState extends ConsumerState<WeddingEventCommentCard> {
  bool isFav = false;
  bool isShowReply = false;
  Comment? commentData;

  Future doLike() async {
    var userId = PreferenceUtils.getString(PreferenceKey.userId);
    if (userId == 10106.toString()) {
      Utility.showAlertMessageForGuestUser(context);
    } else {
      await ref.read(weddingEventHomeController).likeWeddingComment(
          isUnLike: isFav,
          weddingCommentId: commentData!.weddingCommentId!,
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
                              var userId =
                              PreferenceUtils.getString(
                                  PreferenceKey.userId);
                              if (userId == 10106.toString()) {
                                Utility
                                    .showAlertMessageForGuestUser(
                                    context);
                              } else {
                                widget.onReplyClick(
                                    widget.commentModel.weddingCommentId ??
                                        0);}
                            }, likeOnTab: () {
                          doLike();
                        }, isLike: isFav),
                        if (!isShowReply &&
                            widget.commentModel.weddingCommentReplies != null &&
                            widget
                                .commentModel.weddingCommentReplies!.isNotEmpty)
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
                                  "View ${widget.commentModel.weddingCommentReplies!.length} more replies",
                                  style: getRobotoRegularStyle(
                                      fontSize: MyFonts.size12,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        if (isShowReply &&
                            widget.commentModel.weddingCommentReplies != null &&
                            widget
                                .commentModel.weddingCommentReplies!.isNotEmpty)
                          Column(
                            children: [
                              ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return CommonCommentReplyCard(
                                      replyComment: widget.commentModel
                                          .weddingCommentReplies![i],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 0.h);
                                  },
                                  itemCount: widget.commentModel
                                      .weddingCommentReplies!.length),
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
