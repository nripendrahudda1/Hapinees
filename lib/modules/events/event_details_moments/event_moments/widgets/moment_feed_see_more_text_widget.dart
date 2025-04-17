import '../../../../../common/common_imports/common_imports.dart';

class MomentFeedSeeMoreTextWidget extends StatefulWidget {
  final String text;

  const MomentFeedSeeMoreTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  _MomentFeedSeeMoreTextWidgetState createState() => _MomentFeedSeeMoreTextWidgetState();
}

class _MomentFeedSeeMoreTextWidgetState extends State<MomentFeedSeeMoreTextWidget> {
  bool isExpanded = false;
  bool isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkOverflow();
    });
  }

  void _checkOverflow() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.text.trim(),
        style: getRegularStyle(fontSize: MyFonts.size14, color: TAppColors.white),
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width - 40);

    setState(() {
      isOverflowing = textPainter.didExceedMaxLines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.w, 0.w, 15.w, 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isExpanded ? widget.text.trim() : _getTrimmedText(),
                  style: getRegularStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                  maxLines: isExpanded ? null : 2,
                  overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (isOverflowing)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        isExpanded ? 'See Less' : 'See More',
                        style: getRobotoRegularUnderlineStyle(
                            fontWeight: FontWeightManager.semiBold,
                            fontSize: MyFonts.size14,
                            color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getTrimmedText() {
    if (isOverflowing) {
      return widget.text.trim().split('\n').take(2).join('\n');
    } else {
      return widget.text.trim();
    }
  }
}
