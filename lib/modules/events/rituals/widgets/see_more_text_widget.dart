
import '../../../../common/common_imports/common_imports.dart';

class SeeMoreTextWidget extends StatefulWidget {
  final String text;

  const SeeMoreTextWidget({super.key, required this.text});

  @override
  _SeeMoreTextWidgetState createState() => _SeeMoreTextWidgetState();
}

class _SeeMoreTextWidgetState extends State<SeeMoreTextWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: RichText(
            text: TextSpan(
              text: isExpanded ? '${widget.text} ': _getTrimmedText(),
              style: getRegularStyle(
                  fontSize: MyFonts.size14, color: TAppColors.white),
              children: [
                if (widget.text.length > 70)
                  TextSpan(
                    text: isExpanded ? 'See Less' : 'See More',
                    style: getRegularUnderlineStyle(
                        color: TAppColors.white, fontSize: MyFonts.size14),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getTrimmedText() {
    if (widget.text.length > 70) {
      return '${widget.text.substring(0, 70)} ';
    } else {
      return '${widget.text} ';
    }
  }
}
