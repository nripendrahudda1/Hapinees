import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final eventTitleCtr = ChangeNotifierProvider((ref) => EventTitleController());

class EventTitleController extends ChangeNotifier {

  String _title = "";
  String get title => _title;
  setTitleName(String name){
    _title = name;
    notifyListeners();
  }

  clearTitle(){
    _title = "";
    notifyListeners();
  }
}
