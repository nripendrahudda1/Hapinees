import 'package:Happinest/common/widgets/common_comment_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/ritual_photo_all_comments_model.dart';
import 'package:Happinest/common/widgets/common_comment_reply_card.dart';

import '../../event_homepage/wedding_event/controller/wedding_event_home_controller.dart';


class RitualPhotoCommentCard extends ConsumerStatefulWidget {
  const RitualPhotoCommentCard({
    super.key,
    required this.onReplyClick,
    required this.commentModel,
    required this.isReply,
  });

  final RitualComment commentModel;
  final Function(int parantsCmtId) onReplyClick;
  final bool isReply;
  @override
  ConsumerState<RitualPhotoCommentCard> createState() => _RitualPhotoCommentCardState();
}

class _RitualPhotoCommentCardState extends ConsumerState<RitualPhotoCommentCard> {
  bool isFav = false;
  bool isShowReply = false;
  RitualComment? commentData;

  Future doLike() async {

    await ref.read(weddingEventHomeController).likeRitualPhoto(
        isUnLike: isFav,
        weddingRitualPhotoId: commentData!.weddingRitualPhotoCommentId!,
        likedOn: DateTime.now(),
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
                            onReplyClick: (){widget.onReplyClick(widget.commentModel.weddingRitualPhotoCommentId ?? 0);},
                            likeOnTab: () {doLike();},
                            isLike: isFav),
                        if (!isShowReply &&
                            widget.commentModel.ritualPhotoCommentReplies != null &&
                            widget.commentModel.ritualPhotoCommentReplies!.isNotEmpty)
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
                                  "View ${widget.commentModel.ritualPhotoCommentReplies!.length} more replies",
                                  style: getRobotoRegularStyle(
                                      fontSize: MyFonts.size12,
                                      color: TAppColors.white),
                                )
                              ],
                            ),
                          ),
                        if (isShowReply &&
                            widget.commentModel.ritualPhotoCommentReplies != null &&
                            widget.commentModel.ritualPhotoCommentReplies!.isNotEmpty)
                          Column(
                            children: [
                              ListView.separated(
                                  padding: EdgeInsets.zero,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, i) {
                                    return CommonCommentReplyCard(
                                      replyComment: widget.commentModel.ritualPhotoCommentReplies![i],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(height: 0.h);
                                  },
                                  itemCount: widget
                                      .commentModel.ritualPhotoCommentReplies!.length),
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
