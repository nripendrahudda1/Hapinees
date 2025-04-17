import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Happinest/utility/constants/images/image_name.dart';
import '../../theme/app_colors.dart';




class ETopBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color? backColor;
  const ETopBackButton({
    super.key, required this.onTap, this.backColor,
  });
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 12.r,
      backgroundColor: backColor ??
      TAppColors.white.withOpacity(0.5),
      child: IconButton(
        //padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        enableFeedback: true,
        icon: Image.asset(TImageName.back),
        onPressed: onTap,
      ),
    );
  }
}