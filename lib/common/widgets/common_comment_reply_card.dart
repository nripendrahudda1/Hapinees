import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/modules/events/rituals/widgets/see_more_comment_text_widget.dart';


class CommonCommentReplyCard extends StatefulWidget {
  const CommonCommentReplyCard({
    required this.replyComment,
    super.key,
  });
  final dynamic replyComment;
  @override
  State<CommonCommentReplyCard> createState() => _CommonCommentReplyCardState();
}

class _CommonCommentReplyCardState extends State<CommonCommentReplyCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 8.h, 8.w, 8.h),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedCircularNetworkImageWidget(
                isWhiteBorder: true,
                image: widget.replyComment.commentedBy?.profileImageUrl ?? '',
                size: 36),
            const SizedBox(
              width: 16,
            ),
            Flexible(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.replyComment.commentedBy?.displayName ?? '',
                          style: getSemiBoldStyle(
                              fontSize: MyFonts.size12,
                              color: TAppColors.white),
                        ),
                      ),
                      Text(
                        getCommentTimeAgo(DateTime.parse(widget.replyComment.commentedOn.toString())),
                        // getTimeAgo(DateTime.parse(widget.replyComment.commentedOn.toString())) == "0" ? "a few moments ago" : "${getTimeAgo(DateTime.parse(widget.replyComment.commentedOn.toString()))}  mins ago",
                        style: getRegularStyle(
                            fontSize: MyFonts.size10,
                            color: TAppColors.white),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: SeeMoreCommentTextWidget(
                            limit: 40, text: widget.replyComment.comment ?? ''),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
