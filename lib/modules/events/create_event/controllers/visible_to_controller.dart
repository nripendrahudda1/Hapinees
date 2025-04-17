import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final visibleToCtr = ChangeNotifierProvider((ref) => VisibleToController());

class VisibleToController extends ChangeNotifier {
  bool _public = false;
  bool _selfRegistration = false; // Default to true
  bool _private = false;
  bool _guest = true;
  bool _showGuest = true;

  bool get public => _public;
  bool get private => _private;
  bool get guest => _guest;
  bool get showGuest => _showGuest;
  bool get selfRegistration => _selfRegistration;

  setPublic() {
    _guest = false;
    _public = true;
    _private = false;
    _showGuest = true;
    _selfRegistration = true; // Enable self-registration
    notifyListeners();
  }

  setPrivate() {
    _guest = false;
    _public = false;
    _private = true;
    _showGuest = false;
    _selfRegistration = false; // Enable self-registration
    notifyListeners();
  }

  setGuest() {
    _guest = true;
    _public = false;
    _private = false;
    _showGuest = true;
    _selfRegistration = false; // Disable self-registration for guests
    notifyListeners();
  }

  setShowGuest(bool stat) {
    _showGuest = stat;
    notifyListeners();
  }

  setSelfRegistrationGuest(bool stat) {
    _selfRegistration = stat;
    notifyListeners();
  }
}
// OLD CODE
//   bool _public = false;
//   bool _selfRegistration = false;
//   bool get public => _public;
//   setPublic() {
//     _guest = false;
//     _public = true;
//     _private = false;
//     notifyListeners();
//   }

//   bool _private = false;
//   bool get private => _private;
//   setPrivate() {
//     _guest = false;
//     _public = false;
//     _private = true;
//     notifyListeners();
//   }

//   bool _guest = true;
//   bool get guest => _guest;
//   setGuest() {
//     _guest = true;
//     _public = false;
//     _private = false;
//     notifyListeners();
//   }

//   bool _showGuest = false;
//   bool get showGuest => _showGuest;
//   setShowGuest(bool stat) {
//     _showGuest = stat;
//     notifyListeners();
//   }
// }
