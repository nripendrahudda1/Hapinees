import '../../../common/common_imports/common_imports.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final TextInputType? inputType;
  final bool obscure;
  final int maxLines;
  final int minLines;
  final double? height;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  final double? topPadding;
  final double? bottomPadding;
  final bool showLabel;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    this.topPadding,
    this.bottomPadding,
    required this.obscure,
    this.validatorFn,
    this.icon,
    this.tailingIcon,
    this.leadingIconPath,
    this.texfieldHeight,
    this.showLabel = true,
    this.maxLines = 12,
    this.minLines = 1,
    this.height,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      validator: validatorFn,
      obscureText: obscure,
      controller: controller,
      keyboardType: inputType,
      style: getRegularStyle(
        fontSize: MyFonts.size14,
        color: TAppColors.text2Color,
      ),
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        constraints: BoxConstraints(
          maxHeight: height ?? 32.h,
        ),
        counterText: "",
        contentPadding: topPadding != null
            ? EdgeInsets.only(left: 10.w, right: 10.w, top: topPadding!)
            : EdgeInsets.only(
                left: 10.w,
                right: 10.w,
              ),
        hintText: hintText,
        hintStyle: getRegularStyle(
            fontSize: MyFonts.size14, color: TAppColors.text4Color),
        suffixIcon: tailingIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.5.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTapOutside: (p0) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class CustomInviteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final TextInputType? inputType;
  final bool obscure;
  final int maxLines;
  final int minLines;
  final double? height;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  final double? topPadding;
  final double? bottomPadding;
  final bool showLabel;

  const CustomInviteTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    this.topPadding,
    this.bottomPadding,
    required this.obscure,
    this.validatorFn,
    this.icon,
    this.tailingIcon,
    this.leadingIconPath,
    this.texfieldHeight,
    this.showLabel = true,
    this.maxLines = 12,
    this.minLines = 1,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validatorFn,
      obscureText: obscure,
      controller: controller,
      keyboardType: inputType,
      style: getRegularStyle(
        fontSize: MyFonts.size14,
        color: TAppColors.text2Color,
      ),
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        contentPadding: topPadding != null
            ? EdgeInsets.only(left: 10.w, right: 10.w, top: topPadding!)
            : EdgeInsets.only(
                left: 10.w,
                right: 10.w,
              ),
        constraints: const BoxConstraints(),
        hintText: hintText,
        hintStyle: getRegularStyle(
            fontSize: MyFonts.size14, color: TAppColors.text4Color),
        suffixIcon: tailingIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.5.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.lightBorderColor, width: 1.0.w),
        ),
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTapOutside: (p0) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}

class CustomTextFieldDesc extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final TextInputType? inputType;
  final bool obscure;
  final int maxLines;
  final int minLines;
  final double? height;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  final double? topPadding;
  final double? bottomPadding;
  final bool showLabel;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function()? onTap;

  const CustomTextFieldDesc({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    this.topPadding,
    this.bottomPadding,
    required this.obscure,
    this.validatorFn,
    this.icon,
    this.tailingIcon,
    this.leadingIconPath,
    this.texfieldHeight,
    this.showLabel = true,
    this.maxLines = 12,
    this.minLines = 1,
    this.height,
    this.maxLength,
    this.focusNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      validator: validatorFn,
      obscureText: obscure,
      controller: controller,
      keyboardType: inputType,
      style: getRegularStyle(
        fontSize: MyFonts.size14,
        color: TAppColors.text2Color,
      ),
      onTap: onTap,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: topPadding != null
            ? EdgeInsets.only(left: 10.w, right: 10.w, top: topPadding!)
            : EdgeInsets.only(
                left: 10.w,
                right: 10.w,
              ),
        hintText: hintText,
        hintStyle: getRegularStyle(
            fontSize: MyFonts.size14, color: TAppColors.text4Color),
        suffixIcon: tailingIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.transparent, width: 0.0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.transparent, width: 0.0.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.transparent, width: 0.0.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.transparent, width: 0.0.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide:
              BorderSide(color: TAppColors.transparent, width: 0.0.w),
        ),
      ),
      onTapOutside: (p0) {
        FocusScope.of(context).unfocus();
      },
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
    );
  }
}
