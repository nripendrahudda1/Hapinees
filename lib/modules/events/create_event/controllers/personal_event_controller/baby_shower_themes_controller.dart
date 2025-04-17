
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/personal_event_theme_model.dart';
import '../../data/apis/create_event_apis.dart';

final personalEventThemesCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return PersonalEventThemesController(repo: api);
});

class PersonalEventThemesController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  PersonalEventThemesController({required CreateEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  PersonalEventThemeModel? _eventThemeModel;
  PersonalEventThemeModel? get eventThemeModel => _eventThemeModel;
  setThemesModel(PersonalEventThemeModel? model) {
    _eventThemeModel = model;
    notifyListeners();
  }

  List<String> _eventThemes = [];
  List<String> get eventThemes => _eventThemes;
  setEventThemes(List<String> rituals) {
    _eventThemes = rituals;
    notifyListeners();
  }

  Future<void> fetchPersonalEventThemesModel({required String token,required int eventTypeMasterId}) async {
    setLoading(true);
    final result = await _repo.getPersonalEventThemes(token: token,eventTypeMasterId: eventTypeMasterId);
    result.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) {
      if (r.personalEventThemeMasterList != null &&
          r.personalEventThemeMasterList!.isNotEmpty) {
        List<String> tempStyles = [];
        for (var theme in r.personalEventThemeMasterList!) {
          tempStyles.add(theme.personalEventThemeName ?? '');
        }
        _eventThemeModel = r;
        setEventThemes(tempStyles);
      }

      _isLoading = false;
      setThemesModel(r);
    });
    setLoading(false);
  }

  String? _themeMasterId;
  String? get themeMasterId => _themeMasterId;
  setThemeMasterId(String? id){
    _themeMasterId = id;
    notifyListeners();
  }

  String _selectedTheme = "";
  String get selectedTheme => _selectedTheme;
  addSelectedTheme(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedTheme.contains(capitalizedValue)) {
      _selectedTheme = capitalizedValue;
    } else {
      _selectedTheme = "";
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

  removeWriteByHandTheme(){
    _writeByHandThemes = "";
    notifyListeners();
  }

  removeSelectedTheme(){
    _selectedTheme = "";
    notifyListeners();
  }

  clearThemes(){
    _selectedTheme = '';
    _writeByHandThemes = '';
    notifyListeners();
  }

}