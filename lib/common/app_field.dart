import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

Widget TTextField(
    {required TextEditingController controller,
    required String hintText,
    String? icon,
    Color? inputboxBoder,
    final bool? isSecure,
    final Function(String)? onChanged,
    final Function()? onTap,
    List<TextInputFormatter>? inputFormatter,
    final TextInputType? textInputType,
    final double? height,
    final EdgeInsetsGeometry? iconPadding,
    final double? fontSize,
    final int? maxLines,
    final Color? textColor,
    final bool? isKeyboardUnfocus,
    final FocusNode? focusNode,
    final Color? cursorColor,
    final Function(PointerDownEvent)? onTapOutside,
    bool? enabled}) {
  // late FocusNode focusNode0 = FocusNode();
  return Container(
    height: height ?? 40.h,
    decoration: BoxDecoration(
      border: Border.all(color: inputboxBoder ?? TAppColors.white),
      color: TAppColors.white,
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: TextFormField(
      focusNode: focusNode,
      enabled: enabled,
      onTap: () {
        (isKeyboardUnfocus ?? false) ? focusNode?.unfocus() : null;
        onTap != null ? onTap() : null;
      },
      textCapitalization: TextCapitalization.sentences,
      keyboardType: textInputType,
      maxLines: maxLines ?? 1,
      style: GoogleFonts.workSans(
        fontSize: fontSize?.sp ?? MyFonts.size14.sp,
        letterSpacing: 0.5,
        color: Colors.black87,
      ),
      obscureText: isSecure ?? false,
      controller: controller,
      onChanged: onChanged,
      cursorColor: cursorColor,
      inputFormatters: inputFormatter,
      onEditingComplete: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onTapOutside: onTapOutside,
      decoration: InputDecoration(
        contentPadding:
            icon != null ? EdgeInsets.zero : EdgeInsets.only(left: 12.w),
        // filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: TAppColors.white, width: 0.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: TAppColors.white, width: 0.w),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: TAppColors.white, width: 0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: TAppColors.white, width: 0.w),
        ),
        hintText: hintText,
        hintStyle:
            TextStyle(fontSize: MyFonts.size16, color: TAppColors.text4Color),
        // filled: true,
        // fillColor: Colors.transparent,
        prefixIcon: icon != null
            ? Padding(
                padding: iconPadding ?? EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Image.asset(
                  icon,
                  color: TAppColors.text4Color,
                  fit: BoxFit.contain,
                ))
            : null,
      ),
    ),
  );
}
