import 'package:flutter/gestures.dart';

import '../../../../common/common_imports/common_imports.dart';

class SeeMoreCommentTextWidget extends StatefulWidget {
  final String text;
  final int limit;
  final Function()? onTap;

  const SeeMoreCommentTextWidget(
      {super.key, required this.text, this.limit = 70, this.onTap});

  @override
  _SeeMoreCommentTextWidgetState createState() =>
      _SeeMoreCommentTextWidgetState();
}

class _SeeMoreCommentTextWidgetState extends State<SeeMoreCommentTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichText(
        text: TextSpan(
          text: isExpanded ? '${widget.text} ' : _getTrimmedText(),
          style: getRobotoRegularStyle(
              fontSize: MyFonts.size13, color: TAppColors.white),
          children: [
            if (widget.text.length > widget.limit)
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                    widget.onTap != null ? widget.onTap!() : null;
                  },
                text: isExpanded ? 'See Less' : 'See More',
                style: getRobotoRegularUnderlineStyle(
                    color: TAppColors.white, fontSize: MyFonts.size13),
              ),
          ],
        ),
      ),
    );
  }

  String _getTrimmedText() {
    if (widget.text.length > widget.limit) {
      return '${widget.text.substring(0, widget.limit)} ';
    } else {
      return '${widget.text} ';
    }
  }
}
