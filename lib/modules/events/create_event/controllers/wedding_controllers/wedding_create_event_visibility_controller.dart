import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final weddingCreateEventVisibilityCtr = ChangeNotifierProvider((ref) => WeddingCreateEventVisibilityController());

class WeddingCreateEventVisibilityController extends ChangeNotifier {

  bool _occasionSelected = false;
  bool get occasionSelected => _occasionSelected;

  late String _selectedTitle;
  String get selectedTitle => _selectedTitle;
  setOccasionSelected(String title){
    //_ritualsSelected = false;
    _occasionSelected = true;
    _selectedTitle = title;
    //_weddingStyleSelected = false;
    notifyListeners();
  }

  bool _weddingStyleSelected = false;
  bool get weddingStyleSelected => _weddingStyleSelected;
  setWeddingStyleSelected (){
   // _ritualsSelected = false;
    //_occasionSelected = false;
    _weddingStyleSelected = true;
    notifyListeners();
  }

  bool _ritualsSelected = false;

  var selectOccassionId;
  bool get ritualsSelected => _ritualsSelected;
  setRitualsSelected(){
    _ritualsSelected = true;
    //_occasionSelected = false;
    //_weddingStyleSelected = false;
    notifyListeners();
  }

  resetSelection(){
    _ritualsSelected = false;
    _occasionSelected = false;
    _weddingStyleSelected = false;
    notifyListeners();
  }

}
