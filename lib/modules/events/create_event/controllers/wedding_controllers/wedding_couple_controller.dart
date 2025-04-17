import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final weddingCoupleCtr = ChangeNotifierProvider((ref) => WeddingCoupleController());

class WeddingCoupleController extends ChangeNotifier {

  String _couple1Name = "";
  String get couple1Name => _couple1Name;
  setCouple1Name(String name){
    _couple1Name = name;
    notifyListeners();
  }
  String _couple2Name = "";
  String get couple2Name => _couple2Name;
  setCouple2Name(String name){
    _couple2Name = name;
    notifyListeners();
  }


  clearCoupleNames(){
    _couple1Name = "";
    _couple2Name = "";
    notifyListeners();
  }

}
