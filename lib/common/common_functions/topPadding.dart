import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget topPadding({double topPadding = 15.0,double offset=20.0}) {
  return Padding(
    padding: EdgeInsets.only(
        top: (Platform.isAndroid) ? (topPadding + offset).h : topPadding.h),
  );
}

Widget topPaddingIphone({double topPadding = 15.0}) {
  return Padding(
    padding: EdgeInsets.only(
        top: (Platform.isAndroid) ? topPadding.h:(topPadding.h+ 20).h ),
  );
}