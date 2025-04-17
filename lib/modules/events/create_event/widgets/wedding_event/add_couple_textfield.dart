import '../../../../../common/common_imports/common_imports.dart';

class AddCoupleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final TextInputType? inputType;
  final bool obscure;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  final bool showLabel;
  final int? maxLength;

  const AddCoupleTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    required this.obscure,
    this.validatorFn,
    this.icon, this.tailingIcon, this.leadingIconPath, this.texfieldHeight,
    this.showLabel=true, this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      validator: validatorFn,
      obscureText: obscure,
      controller: controller,
      keyboardType: inputType,
      style: getMediumStyle(
        fontSize: MyFonts.size14,
        color: TAppColors.text2Color,
      ),
      maxLength: maxLength,
      decoration: InputDecoration(
        constraints: BoxConstraints(
            maxHeight:  32.h,
        ),
        contentPadding: EdgeInsets.only(left: 10.w, right: 10.w,),
        prefixIcon: Padding(
          padding: EdgeInsets.all(7.sp),
          child: Image.asset(
            TImageName.userIconPng,
            height: 10,
            width: 10,
          ),
        ),

        hintText: hintText,
        hintStyle: getMediumStyle(
            fontSize: MyFonts.size14,
            color:TAppColors.text4Color),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
              color: TAppColors.lightBorderColor,
              width: 1.0.w),
        ),
        counterText: "",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
              color: TAppColors.lightBorderColor,
              width: 1.5.w),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
              color:  TAppColors.lightBorderColor,
              width: 1.0.w),
        ),
        focusedErrorBorder:  InputBorder.none,
        errorBorder:  InputBorder.none,
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
    );
  }
}
