import 'package:google_fonts/google_fonts.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

class TDropDwonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? icon;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Color inputboxBoder;

  const TDropDwonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.onChanged,
    this.onTap,
    required this.inputboxBoder,
  });

  @override
  _TTextFieldState createState() => _TTextFieldState();
}

class _TTextFieldState extends State<TDropDwonTextField> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      style: TextStyle(fontSize: MyFonts.size16, color: TAppColors.black),
      controller: widget.controller,
      onChanged: widget.onChanged,
      onTap: () {
        focusNode.unfocus();
        widget.onTap != null ? widget.onTap!() : null;
      },
      onTapOutside: (event) {
          FocusScope.of(context).unfocus();
      },
      decoration: InputDecoration(
        // filled: true,
        fillColor: Colors.transparent,
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down,
          color: TAppColors.ash,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 0,
        ),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.workSans(
          fontWeight: FontWeightManager.medium,
          fontSize: MyFonts.size16,
          color: Colors.grey,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            color: TAppColors.red,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            color: TAppColors.fossilGrey,
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 0,
            color: TAppColors.fossilGrey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: TAppColors.red,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
      ),
    );
  }
}
