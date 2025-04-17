import 'package:Happinest/common/common_imports/common_imports.dart';

class TButton extends StatelessWidget {
  const TButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.buttonBackground,
      this.fontSize});

  final VoidCallback onPressed;
  final String title;
  final Color buttonBackground;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40.h, // Adjust the height as needed
        decoration: BoxDecoration(
          color: buttonBackground, // Set the background color
          borderRadius: BorderRadius.circular(TDimension
              .buttonCornerRadius), // Set border radius for rounded corners
        ),
        child: Center(
          child: Text(title,
              style: getRobotoBoldStyle(
                color: TAppColors.white, // Text color
                fontSize: fontSize ?? TDimension.buttonTitleFont,
              )),
        ),
      ),
    );
  }
}
