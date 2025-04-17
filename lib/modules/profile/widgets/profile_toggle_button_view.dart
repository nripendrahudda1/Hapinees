import 'package:google_fonts/google_fonts.dart';

import '../../../common/common_imports/common_imports.dart';

class ProfileToggleButtonView extends StatelessWidget {
  ProfileToggleButtonView({super.key,required this.selectedSegmentIndex,required this.onPressed});
  final int selectedSegmentIndex;
  Function(int)? onPressed;

  final List<String> segmentButton = ['Stories', 'Fav', 'Fun'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ToggleButtons(
        borderColor: TAppColors.greyText,
        selectedBorderColor: TAppColors.selectionColor,
        borderWidth: 1,

        selectedColor: Colors.white,
        color: TAppColors.black,
        fillColor: TAppColors.selectionColor,
        borderRadius: BorderRadius.circular(20),
        onPressed: onPressed,
        isSelected: List.generate(segmentButton.length, (index) => index == selectedSegmentIndex),
        children: segmentButton.map((String label) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 38.w),
          child: Text(label,style: GoogleFonts.roboto(fontSize: 12.sp,fontWeight: FontWeight.bold),),
        )).toList(),
      ),
    );
  }
}
