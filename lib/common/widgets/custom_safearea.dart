import 'dart:io';

import 'package:flutter/cupertino.dart';

class CustomSafeArea extends StatelessWidget {
  final Widget child;
  const CustomSafeArea({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: Platform.isAndroid ? true : false,
        bottom: false,
        child: child
    );
  }
}
