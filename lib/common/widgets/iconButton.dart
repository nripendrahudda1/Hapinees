import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

Widget iconButton(
    {double? padding,
    double? radius,
    Color? bgColor,
    double? iconheight,
    required String iconPath,
    Function()? onPressed}) {
  return onPressed != null
      ? GestureDetector(
          onTap: onPressed,
          child: Container(
            height: radius ?? 28.h,
            width: radius ?? 28.h,
            decoration: BoxDecoration(color: bgColor ?? TAppColors.white54, shape: BoxShape.circle),
            child: Padding(
              padding: EdgeInsets.all(padding ?? 6.h),
              child: Container(
                  // color: Colors.amber,
                  child: Image.asset(
                iconPath,
                fit: BoxFit.scaleDown,
              )),
            ),
          ),
        )
      : Container(
          height: radius ?? 28.h,
          width: radius ?? 28.h,
          decoration: BoxDecoration(color: bgColor ?? TAppColors.white54, shape: BoxShape.circle),
          child: Padding(
            padding: EdgeInsets.all(padding ?? 6.h),
            child: Image.asset(iconPath),
          ),
        );
}
