import 'package:Happinest/theme/app_colors.dart';
import 'package:Happinest/theme/colors_base.dart';
import 'package:Happinest/theme/colors_dark.dart';
import 'package:Happinest/theme/colors_light.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// final lightTheme = ThemeData(

//   ColorsBase colorsLight = ColorsLight(),
//   textTheme: GoogleFonts.workSansTextTheme(),
//   cardColor: TAppColors.cardBg,
//   // colorScheme: const ColorScheme.light(
//   //   primary: TAppColors.appColor,
//   //   surface: TAppColors.white,
//   //   onPrimary: TAppColors.black,
//   //   onSurface: TAppColors.text1Color,
//   // ),
//   scaffoldBackgroundColor: TAppColors.containerColor,
// );

// final darkTheme = ThemeData(
//    ColorsBase colorsDark = ColorsDark(),
//   cardColor: TAppColors.blackShadow,
//   textTheme: GoogleFonts.workSansTextTheme(),
//   brightness: Brightness.dark,
//   // colorScheme: const ColorScheme.dark(
//   //   primary: TAppColors.themeColor,
//   //   surface: TAppColors.eventScaffoldColor,
//   //   onPrimary: TAppColors.white,
//   //   onSurface: TAppColors.white54,
//   // ),
// );
// final ColorsBase colorsLight = ColorsLight();
// final ColorsBase colorsDark = ColorsDark();

// final lightTheme = ThemeData(
//   textTheme: GoogleFonts.workSansTextTheme(),
//   scaffoldBackgroundColor: colorsLight.secondary, // example

//   // primaryColor: colorsLight.primaryColor,
//   brightness: Brightness.light,
// );

// final darkTheme = ThemeData(
//   textTheme: GoogleFonts.workSansTextTheme(),
//   scaffoldBackgroundColor: colorsDark.placeholder, // example
//   // cardColor: colorsDark.cardColor,
//   // primaryColor: colorsDark.primaryColor,
//   brightness: Brightness.dark,
// );

class CustomColors extends ThemeExtension<CustomColors> {
  final ColorsBase colors;

  CustomColors({required this.colors});

  @override
  CustomColors copyWith({ColorsBase? colors}) {
    return CustomColors(colors: colors ?? this.colors);
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    return this;
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  textTheme: GoogleFonts.workSansTextTheme(),
  scaffoldBackgroundColor: TAppColors.containerColor,
  cardColor: TAppColors.cardBg,
  extensions: <ThemeExtension<dynamic>>[
    CustomColors(colors: ColorsLight()),
  ],
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  textTheme: GoogleFonts.workSansTextTheme(),
  cardColor: TAppColors.blackShadow,
  extensions: <ThemeExtension<dynamic>>[
    CustomColors(colors: ColorsDark()),
  ],
);

class ThemeProvider with ChangeNotifier {
  ThemeMode _theme = ThemeMode.light;
  ThemeMode get themeMode => _theme;
  dynamic toggleTheme(bool isDark) {
    _theme = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
