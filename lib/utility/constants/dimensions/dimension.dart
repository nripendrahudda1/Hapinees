import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:flutter/material.dart';

class TDimension {
  static double buttonCornerRadius = 20.h;
  static const double fieldCornerRadius = 8;
  static const double buttonHeight = 0.05;
  static const double fieldHeight = 36;
  static const double buttonTitleFont = 18;
  static const double socialTitleFont = 15;
}

class Responsive {
  static width(double p, BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static height(double p, BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
