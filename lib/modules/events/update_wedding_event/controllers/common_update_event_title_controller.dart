import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final updateEventTitleCtr = ChangeNotifierProvider((ref) => UpdateEventTitleController());

class UpdateEventTitleController extends ChangeNotifier {


  String _title = "";
  String get title => _title;
  setTitleName(String name){
    _title = name;
    notifyListeners();
  }

}
