import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';

final personalEventVisibilityCtr = ChangeNotifierProvider((ref) => PersonalEventVisibilityController());

class PersonalEventVisibilityController extends ChangeNotifier {

  bool _themesSelected = false;
  bool get themesSelected => _themesSelected;
  setThemesSelected(){
    _themesSelected = true;
    notifyListeners();
  }

  bool _activitySelected = false;
  bool get activitySelected => _activitySelected;
  setActivitySelected(){
    _activitySelected = true;
    notifyListeners();
  }

  resetSelection(){
    _themesSelected = false;
    _activitySelected = false;
    notifyListeners();
  }

}