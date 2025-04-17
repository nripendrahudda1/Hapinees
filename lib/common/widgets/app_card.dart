import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

Widget TCard(
    {Widget? child,
    double? height,
    double? width,
    Color? color,
    Color? borderColor,
    bool? border,
    bool? shadowPadding,
    bool? shadow,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    DecorationImage? image,
    Gradient? gradient,
    BoxShape? shape,
    Color? shadowColor,
    double? blurRadius,
    double? radius}) {
  return SizedBox(
    child: Padding(
      padding: shadowPadding == true
          ? const EdgeInsets.all(4)
          : const EdgeInsets.all(0),
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              gradient: gradient,
              image: image,
              shape: shape ?? BoxShape.rectangle,
              border: border == true
                  ? Border.all(
                      color: borderColor ?? TAppColors.lightBorderColor,
                      width: borderWidth ?? 1)
                  : null,
              borderRadius: borderRadius ??
                  (shape != null ? null : BorderRadius.circular(radius ?? 10)),
              color: color ?? Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: (shadow ?? false)
                      ? shadowColor ?? Colors.grey.withOpacity(0.3)
                      : Colors.transparent,
                  spreadRadius: 0.5,
                  blurRadius: blurRadius ?? 1,
                )
              ]),
          child: child),
    ),
  );
}
