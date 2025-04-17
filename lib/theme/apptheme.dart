import 'package:Happinest/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: TAppColors.white,
      primaryColor: TAppColors.primary500,

      // inputDecorationTheme: const InputDecorationTheme(
      //   filled: true,
      //   fillColor: TAppColors.textFieldColor,
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(color: TAppColors.inputBoxBorderColor),
      //   ),
      // ),
      // textTheme: const TextTheme(
      //   bodyLarge: TextStyle(color: TAppColors.text1Color),
      //   bodyMedium: TextStyle(color: TAppColors.text2Color),
      //   bodySmall: TextStyle(color: TAppColors.text3Color),
      // ),
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: TAppColors.white,
      //   foregroundColor: TAppColors.black,
      //   elevation: 1,
      // ),
      // colorScheme: const ColorScheme.light(
      //   primary: TAppColors.primary500,
      //   secondary: TAppColors.orangeColor,
      //   error: TAppColors.red,
      // ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TAppColors.red,
      primaryColor: TAppColors.buttonBlue,
      // inputDecorationTheme: const InputDecorationTheme(
      //   filled: true,
      //   fillColor: TAppColors.davyGrey,
      //   border: OutlineInputBorder(
      //     borderSide: BorderSide(color: TAppColors.lightBorderColor),
      //   ),
      // ),
      // textTheme: const TextTheme(
      //   bodyLarge: TextStyle(color: TAppColors.white),
      //   bodyMedium: TextStyle(color: TAppColors.greyText),
      //   bodySmall: TextStyle(color: TAppColors.lightGrayColor),
      // ),
      // appBarTheme: const AppBarTheme(
      //   backgroundColor: TAppColors.davyGrey,
      //   foregroundColor: TAppColors.white,
      //   elevation: 1,
      // ),
      // colorScheme: const ColorScheme.dark(
      //   primary: TAppColors.buttonBlue,
      //   secondary: TAppColors.selectionColor,
      //   error: TAppColors.errorMessage,
      // ),
    );
  }
}
