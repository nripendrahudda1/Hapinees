import 'package:Happinest/common/common_imports/common_imports.dart';

class TTextBoxField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? onTap;
  int? maxLength;

  TTextBoxField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
    this.maxLength,
  });

  @override
  _TTextBoxFieldState createState() => _TTextBoxFieldState();
}

class _TTextBoxFieldState extends State<TTextBoxField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 140.h,
        decoration: BoxDecoration(
          color: TAppColors.white,
          border: Border.all(color: TAppColors.inputBoxBorderColor),
          borderRadius: BorderRadius.circular(TDimension.fieldCornerRadius),
        ),
        child: TextField(
          style: TextStyle(fontSize: MyFonts.size16, color: TAppColors.black),
          controller: widget.controller,
          keyboardType: TextInputType.multiline,
          // minLines: 1, // Normal textInputField will be displayed
          maxLines: 4,
          maxLength: widget.maxLength,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(TDimension.fieldCornerRadius),
              borderSide: const BorderSide(color: Colors.white), //<-- SEE HERE
            ),
            fillColor: TAppColors.white,
            border: InputBorder.none,
            filled: true,
            hintStyle: TextStyle(
                fontSize: MyFonts.size16,
                color: TAppColors.inputPlaceHolderColor),
            hintText: TPlaceholderStrings.writeAboutYourself,
          ),
          onChanged: widget.onChanged,
          onTapOutside: (p0) {
            FocusScope.of(context).unfocus();
          },
        ));
  }
}
