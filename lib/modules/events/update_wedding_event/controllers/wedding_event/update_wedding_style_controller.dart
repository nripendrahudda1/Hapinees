import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_styles_model.dart';
import '../../../create_event/data/apis/create_event_apis.dart';

final updateWeddingStylesCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return UpdateWeddingStyleController(repo: api);
});

class UpdateWeddingStyleController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  UpdateWeddingStyleController({required CreateEventDatasource repo})
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
    EasyLoading.show();
    ref.read(updateWeddingRitualsCtr).setWeddingRituals([]);
    ref.read(updateWeddingRitualsCtr).removeAllHandwrittenRituals([]);
    final result = await _repo.fetchWeddingStyle(
      language: 'EN',
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      if (r.weddingStyleMasterList != null &&
          r.weddingStyleMasterList?.length != 0) {
        List<String> tempStyles = [];
        for (var ritual in r.weddingStyleMasterList!) {
          tempStyles.add(ritual.weddingStyleName ?? '');
        }

        setWeddingStyles(tempStyles);
      }

      EasyLoading.dismiss();
      setWeddingStylesModel(r);
    });
    EasyLoading.dismiss();
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

  addFirstSelectedStyle(String val) {
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

  // setInitialStyles(List<String> initialStyles){
  //   initialStyles.forEach((Style) {
  //     if(weddingStyles.contains(Style)){
  //       addInitialSelectedStyles(Style);
  //     }else{
  //       addWriteByHandStyle(Style);
  //     }
  //   });
  // }

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
