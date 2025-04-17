
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

// ignore: non_constant_identifier_names
Widget CTTextField(
    {final TextEditingController? controller,
    final String? label,
    hint,
    String? errorText,
    TextInputType? textInputType = TextInputType.text,
    bool? obscureText,
    Function()? validate,
    bool? btnValidate = false,
    Color? fontColor,
    int? maxLines,
    int? minLines,
    int? maxLength,
    Function()? onTap,
    Widget? prefix,
    List<TextInputFormatter>? textInputFormatter,
    Color? hintTextColor,
    Color? cursorColor,
    double? fontSize,
    bool? isAutoFocus,
    Function()? onEditingComplete,
    TextCapitalization? textCapitalization,
    bool? isKeyboardUnfocus,
    bool? isEnabled,
    final FocusNode? focusNode,
    Function(String)? onChanged,
    Function(PointerDownEvent)? onTapOutside,
    bool dismissOnTapOutside = true}) {
  return TextField(
    focusNode: focusNode,
    onTap: () {
      (isKeyboardUnfocus ?? false) ? focusNode?.unfocus() : null;
      onTap != null ? onTap() : null;
    },
    autofocus: isAutoFocus ?? false,
    onEditingComplete: () {
      debugPrint("onEditingComplete");
      onEditingComplete != null ? onEditingComplete() : null;
      focusNode?.unfocus();
    },
    onChanged: onChanged,
    cursorColor: cursorColor ?? Colors.black, maxLength: maxLength,
    maxLines: maxLines ?? 1,
    minLines: minLines ?? 1,
    maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
    controller: controller,
    keyboardType: textInputType,
    enabled: isEnabled,
    obscureText: obscureText ?? false,
    inputFormatters: textInputFormatter,
    textCapitalization: textCapitalization ?? TextCapitalization.none,
    onTapOutside: onTapOutside ??
        (event) {
          dismissOnTapOutside
              ? FocusManager.instance.primaryFocus?.unfocus()
              : null;
        },
    style: GoogleFonts.workSans(
      fontSize: fontSize?.sp ?? MyFonts.size14.sp,
      letterSpacing: 0.5,
      color: fontColor ?? Colors.black87,
    ),

    // onFieldSubmitted: (value) {
    //   focusNode.unfocus();
    // },
    // onSaved: (newValue) {
    //   focusNode.unfocus();
    // },
    decoration: InputDecoration(
      prefix: prefix,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(width: 0, color: Colors.transparent)),
      isCollapsed: true,
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeightManager.regular,
        fontSize: fontSize?.sp ?? MyFonts.size16,
        color: Colors.black,
      ),
      contentPadding: EdgeInsets.only(bottom: 4.h),
      hintText: hint,
      hintStyle: GoogleFonts.workSans(
        fontWeight: FontWeightManager.regular,
        fontSize: fontSize?.sp ?? MyFonts.size16,
        color: hintTextColor ?? Colors.grey,
        letterSpacing: 0
      ),
    ),
  );
}
