

import '../../../../../common/common_imports/common_imports.dart';

class AddStyleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(String) onFieldSubmitted;
  final VoidCallback onArrowTapped;
  final TextInputType? inputType;
  final bool obscure;
  final IconData? icon;
  final String? Function(String?)? validatorFn;
  final Widget? leadingIcon;
  final Widget? tailingIcon;
  final String? leadingIconPath;
  final double? texfieldHeight;
  final String label;
  final bool showLabel;

  const AddStyleTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFieldSubmitted,
    this.inputType,
    this.leadingIcon,
    required this.obscure,
    this.validatorFn,
    this.icon, this.tailingIcon, this.leadingIconPath, this.texfieldHeight, required this.label,  this.showLabel=true,
    required this.onArrowTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 36.h
      ),
      decoration: BoxDecoration(
        color: TAppColors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: TAppColors.lightBorderColor
        )
      ),
      // padding: EdgeInsets.only(left: 10.w),
      alignment: Alignment.center,
      child: TextFormField(
        validator: validatorFn,
        obscureText: obscure,
        controller: controller,
        keyboardType: inputType,
        style: getMediumStyle(
            fontSize: MyFonts.size14,
            color: TAppColors.text4Color,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 10.w, right: 10.w,bottom: 6.h, top: 26.h,),
          suffixIcon: GestureDetector(
            onTap: onArrowTapped,
            child: Padding(
              padding: EdgeInsets.all(4.sp),
              child: Image.asset(
                TImageName.tickIcon,
                width: 24.w,
                height: 24.h,
              ),
            ),
          ),

          hintText: hintText,
          hintStyle: getMediumStyle(
              fontSize: MyFonts.size14,
              color:TAppColors.text4Color),
          enabledBorder:  InputBorder.none,
          focusedBorder:  InputBorder.none,
          border: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorBorder:  InputBorder.none,
        ),
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
      ),
    );
  }
}
