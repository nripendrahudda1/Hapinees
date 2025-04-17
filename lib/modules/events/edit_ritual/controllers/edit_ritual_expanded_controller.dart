import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final editRitualExpandedCtr = ChangeNotifierProvider((ref) => EditRitualExpandedController());

class EditRitualExpandedController extends ChangeNotifier {

  bool _ritualNameExpanded= false;
  bool get ritualNameExpanded=> _ritualNameExpanded;
  setRitualNameExpanded(){
    _ritualNameExpanded= true;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }


  setRitualNameUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= true;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }

  bool _ritualScheduleExpanded= false;
  bool get ritualScheduleExpanded=> _ritualScheduleExpanded;
  setRitualScheduleExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= true;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }
  setRitualScheduleUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded=false;
    _ritualsAboutExpanded= true;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }

  bool _ritualsAboutExpanded= false;
  bool get ritualsAboutExpanded=> _ritualsAboutExpanded;
  setRitualsAboutExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= true;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }
  setRitualsAboutUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=true;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }

  bool _photosExpanded= false;
  bool get photosExpanded=> _photosExpanded;
  setPhotosExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=true;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }
  setPhotosUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = true;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }

  bool _venueExpanded= false;
  bool get venueExpanded=> _venueExpanded;
  setVenueExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = true;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }
  setVenueUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=true;
    notifyListeners();
  }

  bool _guestVisibilityExpanded= false;
  bool get guestVisibilityExpanded=> _guestVisibilityExpanded;
  setGuestVisibilityExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=true;
    notifyListeners();
  }

  setGuestVisibilityUnExpanded(){
    _ritualNameExpanded= false;
    _ritualScheduleExpanded= false;
    _ritualsAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }

}
