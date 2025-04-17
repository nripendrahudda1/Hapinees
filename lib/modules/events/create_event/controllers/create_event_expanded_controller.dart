import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createEventExpandedCtr = ChangeNotifierProvider((ref) => CreateEventExpandedController());

class CreateEventExpandedController extends ChangeNotifier {
  bool _occasionExpanded = true;
  bool get occasionExpanded => _occasionExpanded;

  setOccasionExpanded() {
    _occasionExpanded = true;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setOccasionUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _weddingStyleExpanded = false;
  bool get weddingStyleExpanded => _weddingStyleExpanded;
  setWeddingStyleExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = true;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setWeddingStyleUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = true;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _ritualsExpanded = false;
  bool get ritualsExpanded => _ritualsExpanded;
  setRitualsExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = true;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setRitualsUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = true;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _coupleExpanded = false;
  bool get coupleExpanded => _coupleExpanded;
  setCoupleExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = true;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setCoupleUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = true;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _themeExpanded = false;
  bool get themeExpanded => _themeExpanded;
  setThemeExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = true;
    _activityExpanded = false;
    notifyListeners();
  }

  setThemeUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = true;
    notifyListeners();
  }

  bool _activityExpanded = false;
  bool get activityExpanded => _activityExpanded;
  setActivityExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = true;
    notifyListeners();
  }

  setActivityUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = true;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _titleExpanded = false;
  bool get titleExpanded => _titleExpanded;
  setTitleExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = true;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setTitleUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = true;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _datesExpanded = false;
  bool get datesExpanded => _datesExpanded;
  setDatesExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = true;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setDatesUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = true;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  bool _guestVisibilityExpanded = false;
  bool get guestVisibilityExpanded => _guestVisibilityExpanded;
  setGuestVisibilityExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = true;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setGuestVisibilityUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  /// WHO Can post Visibility
  bool _postVisibilityExpanded = false;
  bool get postVisibilityExpanded => _postVisibilityExpanded;
  setPostVisibilityExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = true;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  setPostVisibilityUnExpanded() {
    _occasionExpanded = false;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _themeExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }

  resetExpand() {
    _occasionExpanded = true;
    _weddingStyleExpanded = false;
    _ritualsExpanded = false;
    _coupleExpanded = false;
    _titleExpanded = false;
    _datesExpanded = false;
    _guestVisibilityExpanded = false;
    _postVisibilityExpanded = false;
    _activityExpanded = false;
    notifyListeners();
  }
}
