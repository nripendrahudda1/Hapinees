import 'package:Happinest/theme/app_colors.dart';

import '../common_imports/common_imports.dart';

class CommonDropDown extends StatelessWidget {
  final String hintText;
  final String label;
  final String? value;
  final double? width;
  final double? height;
  final List<String> valueItems;
  final Function(String?) onChanged;

  const CommonDropDown({
    super.key,
    required this.hintText,
    required this.label,
    this.value,
    this.width,
    this.height,
    required this.valueItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 30.h,
        width: width ?? 110.w,
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
        ),
        decoration: BoxDecoration(
          color: TAppColors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: DropdownButton(
            hint: Text(
              hintText,
              style: getBoldStyle(
                  color: TAppColors.white, fontSize: MyFonts.size12),
            ),
            //menuMaxHeight: 250.h,
            isExpanded: true,
            menuMaxHeight: 300.h,
            dropdownColor: TAppColors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10.r),
            underline: const SizedBox(),
            icon: ImageIcon(const AssetImage(TImageName.dropDownArrowPngIcon),
                size: 10.h, color: TAppColors.white),
            value: value,
            focusColor: Colors.blue,
            style: getBoldStyle(
                color: TAppColors.white, fontSize: MyFonts.size12),
            onChanged: onChanged,
            items: valueItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                ),
              );
            }).toList()));
  }
}
