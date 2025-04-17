import 'package:flutter/material.dart';

import 'app_colors.dart';

class TextStyles {
  static TextStyle label({Color color = TAppColors.login}) {
    return TextStyle(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w300,
      color: color,
    );
  }

  static TextStyle label_tab({Color color = TAppColors.login}) {
    return TextStyle(
      fontSize: 18,
      height: 1.2,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }
}
