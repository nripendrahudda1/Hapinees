import 'package:flutter/gestures.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

import 'package:Happinest/theme/text_styles.dart';

import 'package:url_launcher/url_launcher.dart';

class CustomCheckbox extends StatefulWidget {
  bool value;
  String? text;
  final ValueChanged<bool?> onChanged;
  final bool enableAsterisk;

  CustomCheckbox({
    super.key,
    required this.value,
    required this.text,
    required this.onChanged,
    this.enableAsterisk = false,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool? _checked;

  @override
  void initState() {
    super.initState();
    _checked = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      ///CHECKBOX
      onTap: () {
        setState(() {
          widget.value = !widget.value;
          widget.onChanged(widget.value);
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: widget.value
                ? SvgPicture.asset(
                    TImageName.icCheckSVG,
                    alignment: Alignment.centerLeft,
                    allowDrawingOutsideViewBox: false,
                  )
                : SvgPicture.asset(
                    TImageName.icUncheckSVG,
                    alignment: Alignment.centerLeft,
                    allowDrawingOutsideViewBox: false,
                  ),
          ),
          const SizedBox(
            width: 5,
          ),
          RichText(
            text: TextSpan(
              text: widget.text!,
              style: TextStyles.label(color: TAppColors.orange),
              children: <TextSpan>[
                TextSpan(
                  text: 'Terms and Conditions',
                  style: const TextStyle(
                    color: TAppColors.white,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _launchURL(); // Call the function to open the URL
                    },
                ) //theme.colors.errors
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    String url = dotenv.get('TERMS_URL');
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
