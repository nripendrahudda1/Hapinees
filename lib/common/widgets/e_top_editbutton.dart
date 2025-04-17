import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Happinest/utility/constants/images/image_name.dart';
import '../../theme/app_colors.dart';

class ETopEditButton extends StatelessWidget {
  const ETopEditButton({
    super.key, this.bgColor, required this.onTap,
  });
  final Color? bgColor;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: 12.r,
      backgroundColor: bgColor??TAppColors.white.withOpacity(0.5),
      child: IconButton(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        enableFeedback: true,
        icon: Image.asset(TImageName.editPngIcon,width: 15.w,height: 15.h,),
        onPressed: onTap,
      ),
    );
  }
}

class ERitualAndActivityButton extends StatelessWidget {
  const ERitualAndActivityButton({
    super.key, this.bgColor, required this.onTap, required this.icon,
  });
  final String icon;
  final Color? bgColor;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: 18.r,
      backgroundColor: bgColor??TAppColors.davyGrey.withOpacity(0.7),
      child: IconButton(
        padding: const EdgeInsets.all(0),
        alignment: Alignment.center,
        enableFeedback: true,
        icon: Image.asset(icon,width: 16.w,height: 16.h,),
        onPressed: onTap,
      ),
    );
  }
}
