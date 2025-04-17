import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editRitualScheduleCtr =
    ChangeNotifierProvider((ref) => EditRitualScheduleController());

class EditRitualScheduleController extends ChangeNotifier {
  String _date = "MM/DD/YYYY";
  String get date => _date;
  setDate1(String date) {
    _date = date;
    notifyListeners();
  }

  String _eventTime = "00:00 AM/PM";
  String get eventTime => _eventTime;
  setEventTime(String date) {
    _eventTime = date;
    notifyListeners();
  }
}
