import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateWhoPostCtr = ChangeNotifierProvider((ref) => UpdateWhoCanPostController());

class UpdateWhoCanPostController extends ChangeNotifier {
  bool _public = false;
  bool _loadingfromAPI = false;
  bool get public => _public;
  bool get loadingfromAPI => _loadingfromAPI;
  setPublic() {
    _guest = false;
    _public = true;
    _onlyHost = false;
    _loadingfromAPI = false;
    notifyListeners();
  }

  bool _onlyHost = false;
  bool get onlyHost => _onlyHost;
  setonlyHost() {
    _guest = false;
    _public = false;
    _onlyHost = true;
    _loadingfromAPI = false;
    notifyListeners();
  }

  bool _guest = true;
  bool get guest => _guest;
  setGuest() {
    _guest = true;
    _public = false;
    _onlyHost = false;
    _loadingfromAPI = false;
    notifyListeners();
  }

  setFromAPIGuest(value) {
    _loadingfromAPI = value;
    notifyListeners();
  }
}
