import 'package:Happinest/theme/theme_manager.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../common_imports/common_imports.dart';

//
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasSubTitle;
  final String? subtitle;
  final Widget? prefixWidget;
  final Widget? rightWidget;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool hasSuffix;
  final String? suffix;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.prefixWidget,
    this.rightWidget,
    this.hasSubTitle = false,
    this.subtitle,
    this.textColor,
    this.color,
    this.hasSuffix = true,
    this.suffix,
  });
  @override
  Size get preferredSize => Size.fromHeight(hasSubTitle
      ? topSfarea > 20
          ? 55
          : 65
      : topSfarea > 20
          ? 40
          : 50);

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        alignment: Alignment.center,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0, left: 15),
              child: SizedBox(height: 24.h, width: 36.h, child: prefixWidget ?? const SizedBox()),
            ),
            Expanded(
              child: hasSubTitle
                  ? Padding(
                      padding: EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: getSemiBoldStyle(
                              color: textColor ?? customColors.text1Color,
                              fontSize: MyFonts.size22,
                            ),
                          ),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: getRegularStyle(
                              color: textColor ?? customColors.text1Color,
                              fontSize: MyFonts.size13,
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0),
                        child: Text(
                          title,
                          style: getSemiBoldStyle(
                            color: customColors.text1Color,
                            fontSize: MyFonts.size22,
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0, right: 15),
              child: rightWidget ??
                  (hasSuffix
                      ? IconButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: onTap ?? () => Navigator.pop(context),
                          icon: Image.asset(
                            suffix ?? TImageName.cancelIcon,
                            width: 28.h,
                            height: 28.h,
                          ),
                        )
                      : SizedBox(width: 28.h, height: 28.h)),
            )
          ],
        ),
      ),
      backgroundColor: color ?? customColors.darkBackGround,
      surfaceTintColor: customColors.darkBackGround,
      elevation: 0,
    );
  }
}
