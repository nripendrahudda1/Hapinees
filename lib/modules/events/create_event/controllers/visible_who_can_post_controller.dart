import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visibleWhoPostCtr = ChangeNotifierProvider((ref) => VisibleWhoCanPostController());

class VisibleWhoCanPostController extends ChangeNotifier {

  bool _public = false;
  bool get public => _public;
  setPublic() {
    _guest = false;
    _public = true;
    _onlyHost = false;
    notifyListeners();
  }

  bool _onlyHost = false;
  bool get onlyHost => _onlyHost;
  setonlyHost() {
    _guest = false;
    _public = false;
    _onlyHost = true;
    notifyListeners();
  }

  bool _guest = true;
  bool get guest => _guest;
  setGuest() {
    _guest = true;
    _public = false;
    _onlyHost = false;
    notifyListeners();
  }
}
