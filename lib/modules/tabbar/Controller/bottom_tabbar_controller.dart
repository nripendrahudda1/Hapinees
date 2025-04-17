import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final btmTabCtr = ChangeNotifierProvider((ref) => BtmTabController());

class BtmTabController extends ChangeNotifier {
  bool isCenterMenuExpanded = false;
}
