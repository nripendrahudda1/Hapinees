import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final editRitualVisibilityCtr = ChangeNotifierProvider((ref) => EditRitualVisibilityController());

class EditRitualVisibilityController extends ChangeNotifier {

  bool _public = false;
  bool get public => _public;
  setPublic(){
    _guest = false;
    _public = true;
    _private = false;
    notifyListeners();
  }

  bool _private = false;
  bool get private => _private;
  setPrivate(){
    _guest = false;
    _public = false;
    _private = true;
    notifyListeners();
  }

  bool _guest = true;
  bool get guest => _guest;
  setGuest(){
    _guest = true;
    _public = false;
    _private = false;
    notifyListeners();
  }

  bool _showGuest = false;
  bool get showGuest => _showGuest;
  setShowGuest(bool stat){
    _showGuest = stat;
    notifyListeners();
  }
}
