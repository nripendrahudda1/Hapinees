import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void bottomSheetComponent({
  required BuildContext context, required Widget child,
  double horizontalPadding = 20,
    bool isDismissible = true,
    bool adjustSizeOnOpenKeyboard = true}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    useRootNavigator: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.fromLTRB(
                horizontalPadding.w, 14.h, horizontalPadding.w, 30.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.w),
                topRight: Radius.circular(12.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    height: 5.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: adjustSizeOnOpenKeyboard
                      ? MediaQuery.of(context).viewInsets.bottom != 0
                          ? 400.h
                          : null
                      : null,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
