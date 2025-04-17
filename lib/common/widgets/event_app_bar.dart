
import 'package:Happinest/utility/constants/constants.dart';

import '../common_imports/common_imports.dart';
//
class EventAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasSubTitle;
  final String? subtitle;
  final Widget? prefixWidget;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;
  final String? suffix;

  const EventAppBar({
    super.key,
    required this.title,
    this.onTap,
    this.prefixWidget,
    this.hasSubTitle = false,
    this.subtitle,
    this.textColor,
    this.color,
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
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        // color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0,left: 10),
              child: prefixWidget ?? const SizedBox(),
            ),
            Expanded(
              child: hasSubTitle
                  ? Padding(
                padding: EdgeInsets.only(
                    top: topSfarea > 20 ? topSfarea - 10 : 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: getSemiBoldStyle(
                        color: textColor ?? TAppColors.text1Color,
                        fontSize: MyFonts.size22,
                      ),
                    ),
                    FittedBox(
                      child: Container(
                        alignment: Alignment.center,
                        // width: 250.w,
                        child: Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: getRegularStyle(
                            color: textColor ?? TAppColors.text1Color,
                            fontSize: MyFonts.size14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(
                    top: topSfarea > 20 ? topSfarea - 10 : 0),
                child: Text(
                  title,
                  style: getSemiBoldStyle(
                    color: TAppColors.text1Color,
                    fontSize: MyFonts.size22,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(top: topSfarea > 20 ? topSfarea - 10 : 0,right: 10),
              child: IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: onTap ??
                          () {
                        Navigator.pop(context);
                      },
                  icon: Image.asset(
                    suffix ?? TImageName.cancelIcon,
                    width: 24.h,
                    height: 24.h,
                  )),
            )
          ],
        ),
      ),
      backgroundColor: color ?? TAppColors.white,
      surfaceTintColor: TAppColors.white,
      elevation: 0,
    );
  }
}