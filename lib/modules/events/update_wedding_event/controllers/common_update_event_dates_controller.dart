import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final updateEventDatesCtr = ChangeNotifierProvider((ref) => UpdateEventDatesController());

class UpdateEventDatesController extends ChangeNotifier {

  bool _isMultipleDay = false;
  bool get isMultipleDay => _isMultipleDay;
  setStatusOfDays(bool date){
    _isMultipleDay = date;
    notifyListeners();
  }

  String _date1 = "Start Date";
  String get date1 => _date1;
  setDate1(String date){
    _date1 = date;
    notifyListeners();
  }

  String _date2 = "End Date";
  String get date2 => _date2;
  setDate2(String date){
    if(_time != null){
      _date2 = date;
      notifyListeners();
    }
  }

  DateTime? _time;
  DateTime? get time => _time;
  setDate1Time(DateTime? date){
    _time = date;
    notifyListeners();
  }

}
