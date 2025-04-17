import '../../modules/events/rituals/widgets/see_more_comment_text_widget.dart';
import '../common_imports/common_imports.dart';

class CommonCommentCard extends StatefulWidget {
  const CommonCommentCard(
      {super.key,
      required this.commentModel,
      required this.onReplyClick,
      required this.likeOnTab,
      required this.isLike,
      required this.isReply});

  final dynamic commentModel;
  final void Function()? onReplyClick;
  final void Function()? likeOnTab;
  final bool isLike;
  final bool isReply;
  @override
  State<CommonCommentCard> createState() => _CommonCommentCardState();
}

class _CommonCommentCardState extends State<CommonCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                widget.commentModel.commentedBy?.displayName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getSemiBoldStyle(fontSize: MyFonts.size12, color: TAppColors.white),
              ),
            ),
            Text(
              getCommentTimeAgo(DateTime.parse(widget.commentModel.commentedOn.toString())),
              style: getRegularStyle(fontSize: MyFonts.size12, color: TAppColors.white),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          children: [
            Flexible(
              child: SeeMoreCommentTextWidget(text: widget.commentModel.comment ?? ''),
            ),
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !widget.isReply
                ? GestureDetector(
                    onTap: widget.onReplyClick,
                    child: Row(
                      children: [
                        Image.asset(
                          TImageName.reply,
                          height: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Text(
                          "Reply",
                          style: getRobotoRegularStyle(
                              fontSize: MyFonts.size12, color: TAppColors.appColor),
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
            Row(
              children: [
                InkWell(
                  onTap: widget.likeOnTab,
                  splashColor: Colors.transparent,
                  child: Image.asset(
                    widget.isLike ? TImageName.heartWhitePngIcon : TImageName.like,
                    color: TAppColors.selectionColor,
                    width: 16.w,
                    height: 16.h,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  (widget.commentModel?.totalLikes ?? 0).toString(),
                  style: getRegularStyle(fontSize: MyFonts.size12, color: TAppColors.white),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 6.h,
        ),
      ],
    );
  }
}
