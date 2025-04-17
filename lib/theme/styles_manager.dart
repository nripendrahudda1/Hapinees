import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color,
    {double height = 1.45}) {
  return GoogleFonts.workSans(
    color: color,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
    height: height,
  );
}

// regular style
TextStyle getRegularStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.regular, color);
}

TextStyle getEventFieldTitleStyle({
  double fontSize = 16,
  Color color = TAppColors.text2Color,
  FontWeight fontWidth = FontWeight.w500,
}) {
  return GoogleFonts.workSans(
    color: color,
    fontSize: fontSize.sp,
    letterSpacing: 0,
    fontWeight: fontWidth,
  );
}

TextStyle getRegularUnderlineStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
  FontWeight fontWeight = FontWeightManager.regular,
}) {
  return GoogleFonts.workSans(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      decoration: TextDecoration.underline,
      decorationColor: color);
}

TextStyle getRobotoRegularUnderlineStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
  FontWeight fontWeight = FontWeightManager.regular, // Default Regular
}) {
  return GoogleFonts.workSans(
    color: color,
    fontSize: fontSize.sp,
    fontWeight: fontWeight, // Now you can pass FontWeight
    decoration: TextDecoration.underline,
    decorationColor: color,
  );
}

// medium style
TextStyle getMediumStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.medium, color);
}

// medium style
TextStyle getLightStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.light, color);
}

// bold style
TextStyle getBoldStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
  double height = 1.45,
}) {
  return _getTextStyle(
    fontSize.sp,
    FontWeightManager.bold,
    color,
    height: height,
  );
}

// semibold style
TextStyle getSemiBoldStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
}) {
  return _getTextStyle(fontSize.sp, FontWeightManager.semiBold, color);
}

TextStyle _getRobotoTextStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color,
) {
  return GoogleFonts.roboto(
    color: color,
    fontSize: fontSize.sp,
    fontWeight: fontWeight,
  );
}

// regular style
TextStyle getRobotoRegularStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
}) {
  return _getRobotoTextStyle(fontSize.sp, FontWeightManager.regular, color);
}

// medium style
TextStyle getRobotoMediumStyle({
  double fontSize = 16,
  Color color = TAppColors.text1Color,
}) {
  return _getRobotoTextStyle(fontSize.sp, FontWeightManager.medium, color);
}

// medium style
TextStyle getRobotoLightStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
}) {
  return _getRobotoTextStyle(fontSize.sp, FontWeightManager.light, color);
}

// bold style
TextStyle getRobotoBoldStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
}) {
  return _getRobotoTextStyle(fontSize.sp, FontWeightManager.bold, color);
}

// semibold style
TextStyle getRobotoSemiBoldStyle({
  double fontSize = 14,
  Color color = TAppColors.text1Color,
}) {
  return _getRobotoTextStyle(fontSize.sp, FontWeightManager.semiBold, color);
}
