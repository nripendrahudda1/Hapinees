import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

Widget TText(String text,
    {Color? color,
    double? fontSize,
    FontWeight? fontWeight = FontWeightManager.medium,
    TextAlign? textAlign,
    double minFontSize = 8,
    int? maxLines,
    double maxFontSize = double.infinity,
    TextOverflow? overflow,
    double? latterSpacing,
    double? wordSpacing,
    Color? decorationColor,
    TextDecoration? decoration}) {
  return AutoSizeText(
    text,
    maxFontSize: maxFontSize,
    minFontSize: minFontSize,
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign,
    style: GoogleFonts.roboto(
        // old Font workSans
        decoration: decoration,
        decorationColor: decorationColor,
        fontSize: fontSize?.sp ?? MyFonts.size14.sp,
        letterSpacing: latterSpacing ?? 0.5,
        fontWeight: fontWeight,
        color: color ?? Colors.white,
        wordSpacing: wordSpacing),
  );
}
