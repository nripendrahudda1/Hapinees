import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/create_event_models/create_wedding_models/wedding_styles_model.dart';
import '../../data/apis/create_event_apis.dart';

final weddingStylesCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return WeddingStyleController(repo: api);
});

class WeddingStyleController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  WeddingStyleController({required CreateEventDatasource repo})
      : _repo = repo,
        super();
  List<String> _weddingStyles = [];
  List<String> get weddingStyles => _weddingStyles;
  setWeddingStyles(List<String> styles) {
    _weddingStyles = styles;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  WeddingStylesModel? _weddingStylesModel;
  WeddingStylesModel? get weddingStylesModel => _weddingStylesModel;
  setWeddingStylesModel(WeddingStylesModel? model) {
    _weddingStylesModel = model;
    notifyListeners();
  }

  Future<void> fetchWeddingStylesModel({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    setLoading(true);
    final result = await _repo.fetchWeddingStyle(
      language: 'EN',
    );
    result.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      if (r.weddingStyleMasterList != null && r.weddingStyleMasterList?.length != 0) {
        List<String> tempStyles = [];
        for (var ritual in r.weddingStyleMasterList!) {
          tempStyles.add(ritual.weddingStyleName ?? '');
        }

        setWeddingStyles(tempStyles);
      }

      _isLoading = false;
      setWeddingStylesModel(r);
    });
    setLoading(false);
  }

  String? _weddingStyleMasterId;
  String? get weddingStyleMasterId => _weddingStyleMasterId;
  setWeddingStyleMasterId(String? id) {
    _weddingStyleMasterId = id;
    notifyListeners();
  }

  String _selectedStyles = "";
  String get selectedStyles => _selectedStyles;
  addSelectedStyle(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedStyles.contains(capitalizedValue)) {
      _selectedStyles = capitalizedValue;
    } else {
      _selectedStyles = "";
    }
    notifyListeners();
  }

  addInitialSelectedStyles(String val) {
    String lowerCaseValue = val.toLowerCase();
    if (!_selectedStyles.contains(lowerCaseValue)) {
      _selectedStyles = lowerCaseValue;
    }
    notifyListeners();
  }

  String _writeByHandStyles = "";
  String get writeByHandStyles => _writeByHandStyles;
  addWriteByHandStyle(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');
    if (!_writeByHandStyles.contains(capitalizedValue)) {
      _writeByHandStyles = capitalizedValue;
    }
    notifyListeners();
  }

  removeWriteByHandStyle() {
    _writeByHandStyles = "";
    notifyListeners();
  }

  removeSelectedStyle() {
    _selectedStyles = "";
    notifyListeners();
  }

  List<String> _combinedStyles = [];
  List<String> get combinedStyles => _combinedStyles;
  setCombinedStyles({
    required List<String> normalStyles,
    required List<String> writeByHandStyles,
  }) {
    _combinedStyles = normalStyles + writeByHandStyles;
    notifyListeners();
  }

  clearStyles() {
    _selectedStyles = '';
    _writeByHandStyles = '';
    notifyListeners();
  }
}
