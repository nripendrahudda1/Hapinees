import 'package:flutter/cupertino.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:Happinest/utility/constants/constants.dart';

// ignore: non_constant_identifier_names
Bounce TBounceAction(
    {required Widget child,
    Duration duration = const Duration(milliseconds: AppConst.bounceDuration),
    void Function()? onPressed}) {
  return Bounce(duration: duration, onPressed: onPressed ?? () {}, child: child);
}
