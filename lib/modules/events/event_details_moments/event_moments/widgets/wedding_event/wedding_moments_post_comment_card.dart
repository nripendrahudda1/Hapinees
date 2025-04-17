import 'package:Happinest/common/widgets/common_comment_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/occasion_event_memories_controller.dart';

import '../../../../../../common/widgets/common_comment_reply_card.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_all_comments_model.dart';
import '../../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_comment_like_post_model.dart';


class WeddingEventMomentPostCommentCard extends ConsumerStatefulWidget {
  const WeddingEventMomentPostCommentCard({
    super.key,
    required this.onReplyClick,
    required this.token,
    required this.commentModel,
    required this.isReply,
  });

  final OccasionPostComment commentModel;
  final Function(int parantsCmtId) onReplyClick;
  final bool isReply;
  final String? token;

  @override
  ConsumerState<WeddingEventMomentPostCommentCard> createState() => _RitualPhotoCommentCardState();
}

class _RitualPhotoCommentCardState extends ConsumerState<WeddingEventMomentPostCommentCard> {
  bool isFav = false;
  bool isShowReply = false;
  OccasionPostComment? commentData;

  Future doLike() async {
    String token = widget.token ?? '';

    OccasionSetPostCommentLikePostModel model = OccasionSetPostCommentLikePostModel(
      isUnLike: isFav,
      likedOn: DateTime.now(),
      occasionPostCommentId: commentData?.occasionPostCommentId?? 1
    );
    await ref.read(occasionEventMemoriesController).setPostCommentPostLike(
      token: token,
        setPostCommentLikePostModel:  model,
        ref: ref,
        context: context
    );
    setState(() {
      isFav
          ? commentData!.totalLikes = (commentData!.totalLikes ?? 1) - 1
          : commentData!.totalLikes = (commentData!.totalLikes ?? 0) + 1;
      isFav = !isFav;
    });
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
                      image: widget.commentModel.commentedBy?.profileImageUrl ?? '',
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
                              widget.onReplyClick(
                              widget.commentModel.occasionPostCommentId ?? 0);
                            },
                            likeOnTab: () {
                              doLike();
                            }, isLike: isFav),
                        if (!isShowReply &&
                            widget.commentModel.occasionPostCommentReplies != null &&
                            widget.commentModel.occasionPostCommentReplies!.isNotEmpty)
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
                                  "View ${widget.commentModel.occasionPostCommentReplies!.length} more replies",
                                  style: getRobotoRegularStyle(
                                      fontSize: MyFonts.size12,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        if (isShowReply &&
                            widget.commentModel.occasionPostCommentReplies != null &&
                            widget.commentModel.occasionPostCommentReplies!.isNotEmpty)
                          Column(
                            children: [
                              ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return CommonCommentReplyCard(
                                      replyComment: widget.commentModel.occasionPostCommentReplies![i],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 0.h);
                                  },
                                  itemCount: widget
                                      .commentModel.occasionPostCommentReplies!.length),
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
