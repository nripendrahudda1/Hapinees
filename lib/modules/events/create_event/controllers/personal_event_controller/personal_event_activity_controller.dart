import 'package:Happinest/modules/events/create_event/controllers/create_event_controller.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import '../../data/apis/create_event_apis.dart';

final personalEventActivityCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return PersonalEventActivityController(repo: api);
});

class PersonalEventActivityController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  PersonalEventActivityController({required CreateEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  PersonalEventActivityModel? _eventActivitiesModel;
  PersonalEventActivityModel? get eventActivitiesModel => _eventActivitiesModel;
  setEventActivityModel(PersonalEventActivityModel? model) {
    _eventActivitiesModel = model;
    notifyListeners();
  }

  Future<void> fetchPersonalEventActivityModel(
      {required WidgetRef ref,
      required BuildContext context,
      required int personalEventThemeMasterId}) async {
    _selectedActivity = [];
    _writeByHandActivity = [];
    setLoading(true);
    final token = PreferenceUtils.getString(PreferenceKey.accessToken);
    // print('weddingStyleMasterId: $weddingStyleMasterId');
    final result = await _repo.fetchPersonalEventActivityMaster(
        language: "EN", personalEventThemeMasterId: personalEventThemeMasterId, token: token);
    result.fold((l) {
      _eventActivitiesModel = null;
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      if (r.personalEventActivityMasterList != null &&
          r.personalEventActivityMasterList!.isNotEmpty) {
        List<String> tempStyles = [];
        for (var activity in r.personalEventActivityMasterList!) {
          tempStyles.add(activity.activityName ?? '');
        }
        _eventActivitiesModel = r;
        setEventActivity(tempStyles);
      }

      _isLoading = false;
      setEventActivityModel(r);
    });
    setLoading(false);
  }

  List<String> _eventActivity = [];
  List<String> get eventActivity => _eventActivity;
  setEventActivity(List<String> activity) {
    _eventActivity = activity;
    notifyListeners();
  }

  String concatenateList(List<String> inputList) {
    return inputList.join(' , ');
  }

  List<String> _selectedActivity = [];
  List<String> get selectedActivity => _selectedActivity;
  addSelectedActivity(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedActivity.contains(capitalizedValue)) {
      _selectedActivity.add(capitalizedValue);
    } else {
      _selectedActivity.removeWhere((element) => element == capitalizedValue);
    }
    notifyListeners();
  }

  removeActivityFromList(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _selectedActivity.removeWhere((element) => element == capitalizedValue);
    notifyListeners();
  }

  List<String> _writeByHandActivity = [];
  List<String> get writeByHandActivity => _writeByHandActivity;
  addWriteByHandActivity(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');
    if (!_writeByHandActivity.contains(capitalizedValue)) {
      _writeByHandActivity.add(capitalizedValue);
    }
    notifyListeners();
  }

  void removeWriteByHandActivity(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _writeByHandActivity.removeWhere((element) => element == capitalizedValue);
    notifyListeners();
  }

  clearActivity() {
    _selectedActivity.clear();
    _writeByHandActivity.clear();
    notifyListeners();
  }
}
