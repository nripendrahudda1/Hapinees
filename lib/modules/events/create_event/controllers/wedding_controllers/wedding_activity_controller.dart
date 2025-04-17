import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../data/apis/create_event_apis.dart';

final weddingActivityCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return WeddingActivityController(repo: api);
});

class WeddingActivityController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  WeddingActivityController({required CreateEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  WeddingRitualsModel? _weddingRitualsModel;
  WeddingRitualsModel? get weddingRitualsModel => _weddingRitualsModel;
  setWeddingStylesModel(WeddingRitualsModel? model) {
    _weddingRitualsModel = model;
    notifyListeners();
  }

  Future<void> fetchWeddingRitualsModel({
    required WidgetRef ref,
    required BuildContext context,
    required String weddingStyleMasterId,
  }) async {
    _selectedRituals = [];
    _writeByHandRitualss = [];
    setLoading(true);
    print('weddingStyleMasterId: $weddingStyleMasterId');
    final result = await _repo.fetchWeddingRitualsMaster(
        language: 'EN', weddingStyleMasterId: weddingStyleMasterId);
    result.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      if (r.weddingRitualMasterList != null &&
          r.weddingRitualMasterList!.isNotEmpty) {
        List<String> tempStyles = [];
        for (var ritual in r.weddingRitualMasterList!) {
          tempStyles.add(ritual.ritualName ?? '');
        }
        _weddingRitualsModel = r;
        setWeddingRituals(tempStyles);
      }

      _isLoading = false;
      setWeddingStylesModel(r);
    });
    setLoading(false);
  }

  List<String> _weddingRitualss = [];
  List<String> get weddingRitualss => _weddingRitualss;
  setWeddingRituals(List<String> rituals) {
    _weddingRitualss = rituals;
    notifyListeners();
  }

  String concatenateList(List<String> inputList) {
    return inputList.join(' , ');
  }

  List<String> _selectedRituals = [];
  List<String> get selectedRituals => _selectedRituals;
  addSelectedRituals(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedRituals.contains(capitalizedValue)) {
      _selectedRituals.add(capitalizedValue);
    } else {
      _selectedRituals.removeWhere((element) => element == capitalizedValue);
    }
    notifyListeners();
  }

  removeRitualsFromList(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _selectedRituals.removeWhere((element) => element == capitalizedValue);
    notifyListeners();
  }

  List<String> _writeByHandRitualss = [];
  List<String> get writeByHandRitualss => _writeByHandRitualss;
  addWriteByHandRituals(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');
    if (!_writeByHandRitualss.contains(capitalizedValue)) {
      _writeByHandRitualss.add(capitalizedValue);
    }
    notifyListeners();
  }

  void removeWriteByHandRituals(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _writeByHandRitualss.removeWhere((element) => element == capitalizedValue);
    notifyListeners();
  }

  clearRitualss() {
    _selectedRituals.clear();
    _writeByHandRitualss.clear();
    notifyListeners();
  }
}
