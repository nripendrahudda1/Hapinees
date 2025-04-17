import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/personal_event_theme_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../create_event/data/apis/create_event_apis.dart';

final updatePersonalEventThemCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return UpdatePersonalEventThemController(repo: api);
});

class UpdatePersonalEventThemController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  UpdatePersonalEventThemController({required CreateEventDatasource repo})
      : _repo = repo,
        super();

  List<String> _personalEventTheme = [];
  List<String> get personalEventTheme => _personalEventTheme;
  setPersonalEventThem(List<String> styles) {
    _personalEventTheme = styles;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  PersonalEventThemeModel? _personalEventThemeModel;
  PersonalEventThemeModel? get personalEventThemeModel => _personalEventThemeModel;
  setPersonalEventThemeModel(PersonalEventThemeModel? model) {
    _personalEventThemeModel = model;
    notifyListeners();
  }

  Future<void> fetchPersonalEventThemesModel({
    required int eventTypeMasterId,
    VoidCallback? onSuccess,
  }) async {
    EasyLoading.show();
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    final result =
        await _repo.getPersonalEventThemes(token: token, eventTypeMasterId: eventTypeMasterId);
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      if (r.personalEventThemeMasterList != null && r.personalEventThemeMasterList!.isNotEmpty) {
        List<String> tempStyles = [];
        for (var theme in r.personalEventThemeMasterList!) {
          tempStyles.add(theme.personalEventThemeName ?? '');
        }
        setPersonalEventThem(tempStyles);
      }

      EasyLoading.dismiss();
      setPersonalEventThemeModel(r);
      if (onSuccess != null) onSuccess();
    });
    EasyLoading.dismiss();
  }

  String? _personalEventThemeMasterId;
  String? get personaLEventThemeMasterId => _personalEventThemeMasterId;
  setPersonalEventThemeMasterId(String? id) {
    _personalEventThemeMasterId = id;
    notifyListeners();
  }

  String _selectedThemes = "";
  String get selectedThemes => _selectedThemes;
  addSelectedTheme(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedThemes.contains(capitalizedValue)) {
      _selectedThemes = capitalizedValue;
    } else {
      _selectedThemes = "";
    }
    notifyListeners();
  }

  addFirstSelectedTheme(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedThemes.contains(capitalizedValue)) {
      _selectedThemes = capitalizedValue;
    }
    notifyListeners();
  }

  addInitialSelectedThemes(String val) {
    String lowerCaseValue = val.toLowerCase();
    if (!_selectedThemes.contains(lowerCaseValue)) {
      _selectedThemes = lowerCaseValue;
    }
    notifyListeners();
  }

  String _writeByHandThemes = "";
  String get writeByHandThemes => _writeByHandThemes;
  addWriteByHandThemes(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');
    if (!_writeByHandThemes.contains(capitalizedValue)) {
      _writeByHandThemes = capitalizedValue;
    }
    notifyListeners();
  }

  removeWriteByHandTheme() {
    _writeByHandThemes = "";

    notifyListeners();
  }

  removeSelectedTheme() {
    _selectedThemes = "";
    notifyListeners();
  }

  List<String> _combinedThemes = [];
  List<String> get combinedThemes => _combinedThemes;
  setCombinedThemes({
    required List<String> normalThemes,
    required List<String> writeByHandThemes,
  }) {
    _combinedThemes = normalThemes + writeByHandThemes;
    notifyListeners();
  }

  clearThemes() {
    _selectedThemes = '';
    _writeByHandThemes = '';
    notifyListeners();
  }
}
