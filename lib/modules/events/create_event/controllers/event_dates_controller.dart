import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utility/constants/strings/parameter.dart';
final eventDatesCtr = ChangeNotifierProvider((ref) => EventDatesController());

class EventDatesController extends ChangeNotifier {

  bool _isMultipleDay = false;
  bool get isMultipleDay => _isMultipleDay;
  setStatusOfDays(bool date){
    _isMultipleDay = date;
    if(!_isMultipleDay) {
      _date2 = TPParameters.endDate;
    }
    notifyListeners();
  }

  String _date1 = "Start Date";
  String get date1 => _date1;

  DateTime? _date1Time;
  DateTime? get date1Time => _date1Time;

  setDate1(String date, DateTime? dateTime){
    _date1 = date;
    _date1Time = dateTime;
    notifyListeners();
  }
  resetDate1(){
    _date1 = "Start Date";
    notifyListeners();
  }


  DateTime? _date2Time;
  DateTime? get date2Time => _date2Time;

  String _date2 = TPParameters.endDate;
  String get date2 => _date2;
  setDate2(String date, DateTime? dateTime){
    if(_time != null){
      _date2 = date;
      _date2Time = dateTime;
      notifyListeners();
    }
  }

  DateTime? _time;
  DateTime? get time => _time;
  setDate1Time(DateTime? date){
    _time = date;
    notifyListeners();
  }

  clearDates(){
    _date1 = "Start Date";
    _date2 = "End Date";
    _time = null;
    _date1Time = null;
    _date2Time = null;
    _isMultipleDay = false;
    notifyListeners();
  }


}
