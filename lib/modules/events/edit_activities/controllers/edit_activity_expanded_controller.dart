import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../common/common_imports/apis_commons.dart';

final editActivityExpandedCtr = ChangeNotifierProvider((ref) => EditActivityExpandedController());

class EditActivityExpandedController extends ChangeNotifier {
  bool _activityNameExpanded= false;
  bool get activityNameExpanded=> _activityNameExpanded;
  setActivityNameExpanded(){
    _activityNameExpanded= true;
    _activityScheduleExpanded = false;
    _activityAboutExpanded = false;
    _photosExpanded = false;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }


  setActivityNameUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded = true;
    _activityAboutExpanded = false;
    _photosExpanded = false;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }


  bool _activityScheduleExpanded= false;
  bool get activityScheduleExpanded=> _activityScheduleExpanded;
  setActivityScheduleExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= true;
    _activityAboutExpanded = false;
    _photosExpanded = false;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }
  setActivityScheduleUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded=false;
    _activityAboutExpanded = true;
    _photosExpanded = false;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }


  bool _activityAboutExpanded= false;
  bool get activityAboutExpanded=> _activityAboutExpanded;
  setActivityAboutExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= true;
    _photosExpanded = false;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }
  setActivityAboutUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded = true;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }

  bool _photosExpanded= false;
  bool get photosExpanded=> _photosExpanded;
  setPhotosExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=true;
    _venueExpanded = false;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }
  setPhotosUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = true;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }

  bool _venueExpanded= false;
  bool get venueExpanded=> _venueExpanded;
  setVenueExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = true;
    _guestVisibilityExpanded = false;
    notifyListeners();
  }
  setVenueUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded = true;
    notifyListeners();
  }

  bool _guestVisibilityExpanded= false;
  bool get guestVisibilityExpanded=> _guestVisibilityExpanded;
  setGuestVisibilityExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=true;
    notifyListeners();
  }

  setGuestVisibilityUnExpanded(){
    _activityNameExpanded= false;
    _activityScheduleExpanded= false;
    _activityAboutExpanded= false;
    _photosExpanded=false;
    _venueExpanded = false;
    _guestVisibilityExpanded=false;
    notifyListeners();
  }
}