import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateEventVisibilityCtr = ChangeNotifierProvider((ref) => UpdateEventVisibilityController());

class UpdateEventVisibilityController extends ChangeNotifier {
  bool _public = false;
  bool get public => _public;

  setPublic() {
    _guest = false;
    _public = true;
    _private = false;
    _selfRegistration = true;
    notifyListeners();
  }

  bool _private = false;
  bool get private => _private;
  setPrivate() {
    _guest = false;
    _public = false;
    _private = true;
    _selfRegistration = false;
    _showGuest = false;
    notifyListeners();
  }

  bool _guest = true;
  bool get guest => _guest;
  setGuest() {
    _guest = true;
    _public = false;
    _private = false;
    _selfRegistration = false;
    notifyListeners();
  }

  bool _showGuest = false;
  bool get showGuest => _showGuest;
  setShowGuest(bool stat) {
    _showGuest = stat;
    notifyListeners();
  }

  bool _selfRegistration = false; // Default to true
  bool get selfRegistration => _selfRegistration;

  setSelfRegistrationGuest(bool stat) {
    _selfRegistration = stat;
    notifyListeners();
  }
}
