import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_wedding_event_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../data/apis/wedding_event/update_event_apis.dart';

final updateWeddingRitualsCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(updateWeddingEventApisController);
  return UpdateWeddingRitualsController(repo: api);
});

class UpdateWeddingRitualsController extends ChangeNotifier {
  final UpdateWeddingEventDatasource _repo;
  UpdateWeddingRitualsController({required UpdateWeddingEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  // WeddingRitualsUpdateModel? _weddingRitualsModel;
  WeddingRitualsModel? _weddingRitualsModel;
  WeddingRitualsModel? get weddingRitualsModel => _weddingRitualsModel;
  setWeddingStylesModel(WeddingRitualsModel? model) {
    _weddingRitualsModel = model;
    notifyListeners();
  }

  Future<void> fetchWeddingRitualsModel({
    required WidgetRef ref,
    required BuildContext context,
    required dynamic weddingHeaderId,
  }) async {
    _selectedRituals = [];
    _writeByHandRitualss = [];
    _selectedRitualIds = [];
    setLoading(true);

    print('weddingHeaderId: $weddingHeaderId');

    try {
      // final result = await _repo.fetchWeddingRituals(
      //   weddingHeaderId: weddingHeaderId,
      //   token: ref.read(weddingCreateEventController).userToken ?? '',
      // );
      final result = await _repo.fetchWeddingRitualsMaster(
          language: "EN", weddingStyleMasterId: weddingHeaderId);
      result.fold((l) {
        setLoading(false);
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        //
        print('Im Left');
      }, (r) {
        print('Im Right');
        if (r.weddingRitualMasterList != null &&
            r.weddingRitualMasterList!.isNotEmpty) {
          List<String> tempStyles = [];
          for (var ritual in r.weddingRitualMasterList!) {
            tempStyles.add(ritual.ritualName ?? '');
            log("temp list == $tempStyles");
          }
          _weddingRitualsModel = r;
          print('Weding rituals lenght: ${tempStyles.length}');

          setWeddingRituals(tempStyles);
        }

        _isLoading = false;
        setWeddingStylesModel(r);
      });
      setLoading(false);
    } catch (e) {
      log("error in fetch rituals == ${e.toString()}");
    }
  }

  Future<void> deleteWedding({
    required String weddingHeaderId,
    required WidgetRef ref,
  }) async {
    EasyLoading.show();
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    final result = await _repo.deleteWedding(
        weddingHeaderId: weddingHeaderId, token: token);
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      debugPrint('Error in deleteWedding');
    }, (r) {
      EasyLoading.dismiss();
    });
    EasyLoading.dismiss();
    setLoading(false);
  }

  WeddingRitualsModel? _weddingRitualsMaster;
  WeddingRitualsModel? get weddingRitualsMaster => _weddingRitualsMaster;
  setWeddingRitualsMaster(WeddingRitualsModel? model) {
    _weddingRitualsMaster = model;
    notifyListeners();
  }

  Future<void> fetchWeddingRitualsMaster({
    required WidgetRef ref,
    required BuildContext context,
    required dynamic weddingStyleMasterId,
  }) async {
    try {
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
          List<int> tempIDs = [];
          for (var ritual in r.weddingRitualMasterList!) {
            tempStyles.add(ritual.ritualName ?? '');
            tempIDs.add(ritual.weddingRitualMasterId ?? 0);
          }
          _weddingRitualsMaster = r;
          setWeddingRituals(tempStyles);
          setWeddingRitualsMasterIds(tempIDs);
        }

        _isLoading = false;
        setWeddingRitualsMaster(r);
      });
      setLoading(false);
    } catch (e) {
      log("error in fetch rituals in update event screen == ${e.toString()}");
    }
  }

  List<String> _weddingRitualss = [];
  List<String> get weddingRitualss => _weddingRitualss;
  setWeddingRituals(List<String> rituals) {
    _weddingRitualss = rituals;
    notifyListeners();
  }

  List<int> _weddingRitualssIds = [];
  List<int> get weddingRitualssIDs => _weddingRitualssIds;
  setWeddingRitualsMasterIds(List<int> ritualsMasterIDs) {
    _weddingRitualssIds = ritualsMasterIDs;
    notifyListeners();
  }

  String concatenateList(List<String> inputList) {
    return inputList.join(' , ');
  }

  List<String> _selectedRituals = [];
  List<String> get selectedRituals => _selectedRituals;

  final List<Ritual> _selectedRitualModels = [];
  List<Ritual> get selectedRitualModels => _selectedRitualModels;

  addSelectedRituals(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    log("capitalizedWords == $capitalizedWords");
    log("istrue == ${!_selectedRituals.contains(capitalizedValue)}");
    if (!_selectedRituals.contains(capitalizedValue)) {
      _selectedRituals.add(capitalizedValue);
      log("add _selectedRituals.. == $_selectedRituals");
    } else {
      _selectedRituals.removeWhere((element) => element == capitalizedValue);
      log("remove _selectedRituals.. == $_selectedRituals");
    }
    notifyListeners();
  }

  List<String> _selectedRitualMasterIds = [];
  List<String> get selectedRitualMasterIds => _selectedRitualMasterIds;
  addSelectedRitualMasterIds(
      {required String ritualMasterid,
      required String ritualName,
      // required String weddingRitualId
      }) {
    if (!_selectedRitualMasterIds.contains(ritualMasterid) &&
        !selectedRitualModels.contains(ritualMasterid)) {
      _selectedRitualMasterIds.add(ritualMasterid);
      selectedRitualModels.add(Ritual(
        ritualName: ritualName,
        // weddingRitualId: int.parse(weddingRitualId),
        weddingRitualMasterId: int.parse(ritualMasterid),
      ));
      for (var element in selectedRitualModels) {
        log("after add selectedritualsmodel Id and name : ${element.ritualName} & ${element.weddingRitualMasterId}");
      }
      log("add _selectedRitualMasterIds.. == $_selectedRitualMasterIds");
      print(
          '_selectedRitualMasterIds length: ${_selectedRitualMasterIds.length}');
    } else {
      _selectedRitualMasterIds
          .removeWhere((element) => element == ritualMasterid);
      selectedRitualModels.removeWhere((element) =>
          element.weddingRitualMasterId.toString() == ritualMasterid
          // &&element.weddingRitualId == weddingRitualId
          );
      // selectedRitualModels.remove(Ritual(
      //   ritualName: ritualName,
      //   weddingRitualMasterId: id,
      // ));
      for (var element in selectedRitualModels) {
        log("after remove selectedritualsmodel Id and name : ${element.ritualName} & ${element.weddingRitualMasterId}");
      }
      log("remove _selectedRitualMasterIds.. == $_selectedRitualMasterIds");
    }
    notifyListeners();
  }

  List<String> _selectedRitualIds = [];
  List<String> get selectedRitualIds => _selectedRitualIds;
  addSelectedRitualIds({required String id, required String ritualName}) {
    log('SelectedRitualIds : $id');

    if (!_selectedRitualIds.contains(id)) {
      log("!_selectedRitualIds.contains(id) is true == ${!_selectedRitualIds.contains(id)}");
      _selectedRitualIds.add(id);
      selectedRitualModels
          .add(Ritual(ritualName: ritualName, weddingRitualId: int.parse(id)));
      log('add _selectedRitualIds length: ${_selectedRitualIds.length}');
    } else {
      _selectedRitualIds.removeWhere((element) => element == id);
      selectedRitualModels
          .remove(Ritual(ritualName: ritualName, weddingRitualId: int.parse(id)));
      log('remove _selectedRitualIds list : $_selectedRitualIds');
    }
    notifyListeners();
  }

  addFirstSelectedRituals(String val) {
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
    }
    notifyListeners();
  }

  addInitialSelectedRitualss(String val) {
    if (!_selectedRituals.contains(val)) {
      _selectedRituals.add(val);
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

  removeAllHandwrittenRituals(List<String> vals) {
    _writeByHandRitualss = [];
    notifyListeners();
  }

  addWriteByHandRituals(String val) {
    if (!_writeByHandRitualss.contains(val)) {
      _writeByHandRitualss.add(val);
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

  // setInitialRitualss(List<String> initialRitualss, List<String> ritualId) {
  //   print('setinitial rituals length: ${initialRitualss.length}');
  //   _selectedRituals = [];
  //   _writeByHandRitualss = [];
  //   for (var rituals in initialRitualss) {
  //     if (initialRitualss.contains(rituals)) {
  //       addInitialSelectedRitualss(rituals);
  //       _selectedRitualIds = ritualId;
  //       _selectedRitualMasterIds = ritualId;
  //       for (var element in ritualId) {
  //         log("element == ${element.toString()}");
  //         _selectedRitualModels.add(Ritual(
  //             ritualName: initialRitualss[ritualId.indexOf(element)],
  //             weddingRitualMasterId: element,
  //             weddingRitualId: element));
  //       }
  //     } else {
  //       addWriteByHandRituals(rituals);
  //     }
  //   }
  //   notifyListeners();
  // }

  void setInitialRitualss(
      List<String> initialRitualss, List<String> ritualIds) {
    print('setinitial rituals length: ${initialRitualss.length}');

    for (int i = 0; i < initialRitualss.length; i++) {
      String ritual = initialRitualss[i];
      String ritualId = ritualIds[i];

      bool exists = selectedRitualModels.any((element) =>
          element.ritualName == ritual &&
          element.weddingRitualMasterId == ritualId);

      if (!exists) {
        if (initialRitualss.contains(ritual)) {
          addInitialSelectedRitualss(ritual);
          _selectedRitualIds = ritualIds;
          _selectedRitualMasterIds = ritualIds;

          log("element == ${ritualId.toString()}");
          selectedRitualModels.add(Ritual(
            ritualName: ritual,
            weddingRitualMasterId: int.parse(ritualId),
            weddingRitualId: int.parse(ritualId),
          ));
        } else {
          addWriteByHandRituals(ritual);
        }
      }
    }
    notifyListeners();
  }

  List<String> _combinedRitualss = [];
  List<String> get combinedRitualss => _combinedRitualss;
  setCombinedRitualss({
    required List<String> normalRitualss,
    required List<String> writeByHandRitualss,
  }) {
    _combinedRitualss = normalRitualss + writeByHandRitualss;
    notifyListeners();
  }

  clearRitualss() {
    _selectedRituals.clear();
    _writeByHandRitualss.clear();
    _combinedRitualss.clear();
    _selectedRitualIds.clear();
    _weddingRitualss.clear();
    _weddingRitualssIds.clear();
    selectedRitualModels.clear();
    _selectedRitualMasterIds.clear();
    notifyListeners();
  }
}
