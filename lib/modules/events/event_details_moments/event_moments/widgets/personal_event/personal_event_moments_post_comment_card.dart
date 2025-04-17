import 'package:Happinest/models/create_event_models/moments/personal_event_moments/perosnal_event_post_all_comment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_like_post.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../../common/widgets/common_comment_card.dart';
import '../../../../../../common/widgets/common_comment_reply_card.dart';

class PersonalEventMomentPostCommentCard extends ConsumerStatefulWidget {
  const PersonalEventMomentPostCommentCard({
    super.key,
    required this.onReplyClick,
    required this.token,
    required this.commentModel,
    required this.isReply,
  });

  final PersonalEventPostComment commentModel;
  final Function(int parantsCmtId) onReplyClick;
  final bool isReply;
  final String? token;

  @override
  ConsumerState<PersonalEventMomentPostCommentCard> createState() => _PersonalEventMomentPostCommentCardState();
}

class _PersonalEventMomentPostCommentCardState extends ConsumerState<PersonalEventMomentPostCommentCard> {
  bool isFav = false;
  bool isShowReply = false;
  PersonalEventPostComment? commentData;

  Future doLike() async {
    String token = widget.token ?? '';

    PersonalEventSetPostCommentLikeModel model = PersonalEventSetPostCommentLikeModel(
        isUnLike: isFav,
        likedOn: DateTime.now(),
        personalEventPostCommentId: commentData?.personalEventCommentId ?? 1
    );
    await ref.read(personalEventMemoriesController).setPostCommentPostLike(
        token: token,
        personalEventSetPostCommentLikeModel:  model,
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
                            commentModel: commentData,
                            onReplyClick: () {
                              widget.onReplyClick(
                                  widget.commentModel.personalEventCommentId ?? 0);
                            },
                            likeOnTab: () {
                              doLike();
                            }, isLike: isFav),
                        if (!isShowReply &&
                            widget.commentModel.personalEventPostCommentReplies != null &&
                            widget.commentModel.personalEventPostCommentReplies!.isNotEmpty)
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
                                  "View ${widget.commentModel.personalEventPostCommentReplies!.length} more replies",
                                  style: getRobotoRegularStyle(
                                      fontSize: MyFonts.size12,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        if (isShowReply &&
                            widget.commentModel.personalEventPostCommentReplies != null &&
                            widget.commentModel.personalEventPostCommentReplies!.isNotEmpty)
                          Column(
                            children: [
                              ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return CommonCommentReplyCard(
                                      replyComment: widget.commentModel.personalEventPostCommentReplies![i],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 0.h);
                                  },
                                  itemCount: widget
                                      .commentModel.personalEventPostCommentReplies!.length),
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