import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/update_wedding_event/data/apis/personal_event/update_personal_event_apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';

final updatePersonalEventActivitiesCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(updatePersonalEventApisController);
  return UpdatePersonalEventActivitiesController(repo: api);
});

class UpdatePersonalEventActivitiesController extends ChangeNotifier {
  final UpdatePersonalEventDatasource _repo;

  UpdatePersonalEventActivitiesController({required UpdatePersonalEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  PersonalEventActivityModel? _personalEventActivityModel;
  PersonalEventActivityModel? get personalEventActivityModel => _personalEventActivityModel;
  setPersonalEventActivityModel(PersonalEventActivityModel? model) {
    _personalEventActivityModel = model;
    notifyListeners();
  }

  Future<void> fetchPersonalEventActivityModel({
    required WidgetRef ref,
    required BuildContext context,
    required int personalEventThemeMasterId,
  }) async {
    _selectedActivities = [];
    _writeByHandActivities = [];
    _selectedActivityIds = [];
    setLoading(true);
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    print('personalEventThemeMasterId: $personalEventThemeMasterId');

    try {
      // final result = await _repo.fetchWeddingRituals(
      //   weddingHeaderId: weddingHeaderId,
      //   token: ref.read(weddingCreateEventController).userToken ?? '',
      // );
      final result = await _repo.fetchPersonalEventActivityMaster(
          language: "EN", personalEventThemeMasterId: personalEventThemeMasterId, token: token);
      result.fold((l) {
        setLoading(false);
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        //
        print('Im Left');
      }, (r) {
        print('Im Right');
        if (r.personalEventActivityMasterList != null &&
            r.personalEventActivityMasterList!.isNotEmpty) {
          List<String> tempStyles = [];
          for (var activity in r.personalEventActivityMasterList!) {
            tempStyles.add(activity.activityName ?? '');
            log("temp list == $tempStyles");
          }
          print('personal event activity length: ${tempStyles.length}');

          setPersonalEventActivities(tempStyles);
        }

        _isLoading = false;
        setPersonalEventActivityModel(r);
      });
      setLoading(false);
    } catch (e) {
      log("error in fetch rituals == ${e.toString()}");
    }
  }

  Future<void> deletePersonalEvent({
    required String personalEventHeaderId,
    required WidgetRef ref,
  }) async {
    EasyLoading.show();
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    final result =
        await _repo.deletePersonalEvent(personalEventHeaderId: personalEventHeaderId, token: token);
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

  PersonalEventActivityModel? _personalEventActivityMaster;
  PersonalEventActivityModel? get personalEventActivityMaster => _personalEventActivityMaster;
  setPersonalEventActivityMaster(PersonalEventActivityModel? model) {
    _personalEventActivityMaster = model;
    notifyListeners();
  }

  Future<void> fetchPersonalEventActivityMaster({
    required WidgetRef ref,
    required BuildContext context,
    required int personalEventThemeMasterId,
  }) async {
    try {
      String token = PreferenceUtils.getString(PreferenceKey.accessToken);
      setLoading(true);
      print('personalEventThemeMasterId: $personalEventThemeMasterId');
      final result = await _repo.fetchPersonalEventActivityMaster(
          language: 'EN', personalEventThemeMasterId: personalEventThemeMasterId, token: token);
      print("result __________________________________________________________________ ");
      result.fold((l) {
        setPersonalEventActivityMaster(null);
        print("error view __________________________________________________________________");
        setPersonalEventActivities([]);
        setPersonalEventActivitiesMasterIds([]);
        setLoading(false);
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
      }, (r) {
        print("response view __________________________________________________________________");
        if (r.personalEventActivityMasterList != null &&
            r.personalEventActivityMasterList!.isNotEmpty) {
          List<String> tempStyles = [];
          List<int> tempIDs = [];
          for (var activity in r.personalEventActivityMasterList!) {
            tempStyles.add(activity.activityName ?? '');
            tempIDs.add(activity.personalEventActivityMasterId ?? 0);
          }
          setPersonalEventActivities(tempStyles);
          setPersonalEventActivitiesMasterIds(tempIDs);
        } else {
          setPersonalEventActivities([]);
          setPersonalEventActivitiesMasterIds([]);
        }

        _isLoading = false;
        setPersonalEventActivityMaster(r);
      });
      setLoading(false);
    } catch (e) {
      log("error in fetch rituals in update event screen == ${e.toString()}");
    }
  }

  List<String> _personalEventActivities = [];
  List<String> get personalEventActivities => _personalEventActivities;
  setPersonalEventActivities(List<String> activity) {
    _personalEventActivities = activity;
    notifyListeners();
  }

  List<int> _personalEventActivitiesIds = [];
  List<int> get personalEventActivitiesIDs => _personalEventActivitiesIds;
  setPersonalEventActivitiesMasterIds(List<int> activitiesMasterIDs) {
    _personalEventActivitiesIds = activitiesMasterIDs;
    notifyListeners();
  }

  String concatenateList(List<String> inputList) {
    return inputList.join(' , ');
  }

  List<String> _selectedActivities = [];
  List<String> get selectedActivities => _selectedActivities;

  final List<Activity> _selectedActivityModels = [];
  List<Activity> get selectedActivityModels => _selectedActivityModels;

  addSelectedActivity(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    log("capitalizedWords == $capitalizedWords");
    log("istrue == ${!_selectedActivities.contains(capitalizedValue)}");
    if (!_selectedActivities.contains(capitalizedValue)) {
      _selectedActivities.add(capitalizedValue);
      log("add _selectedRituals.. == $_selectedActivities");
    } else {
      _selectedActivities.removeWhere((element) => element == capitalizedValue);
      log("remove _selectedRituals.. == $_selectedActivities");
      _selectedActivityModels.removeWhere(
        (element) => element.activityName?.toLowerCase() == capitalizedValue.toLowerCase(),
      );
    }
    notifyListeners();
  }

  List<String> _selectedActivityMasterIds = [];
  List<String> get selectedActivityMasterIds => _selectedActivityMasterIds;
  addSelectedActivityMasterIds({
    required String activityMasterId,
    required String activityName,
  }) {
    if (!_selectedActivityMasterIds.contains(activityMasterId) &&
        !selectedActivityModels.contains(activityMasterId)) {
      _selectedActivityMasterIds.add(activityMasterId);
      selectedActivityModels.add(Activity(
        activityName: activityName,
        // weddingRitualId: int.parse(weddingRitualId),
        personalEventActivityMasterId: int.parse(activityMasterId),
      ));
      for (var element in selectedActivityModels) {
        log("after add selectedActivityModels Id and name : ${element.activityName} & ${element.personalEventActivityMasterId}");
      }
      log("add _selectedActivityMasterIds.. == $_selectedActivityMasterIds");
      print('_selectedActivityMasterIds length: ${_selectedActivityMasterIds.length}');
    } else {
      _selectedActivityMasterIds.removeWhere((element) => element == activityMasterId);
      selectedActivityModels.removeWhere(
          (element) => element.personalEventActivityMasterId.toString() == activityMasterId
          // &&element.weddingRitualId == weddingRitualId
          );
      // selectedRitualModels.remove(Ritual(
      //   ritualName: ritualName,
      //   weddingRitualMasterId: id,
      // ));
      for (var element in selectedActivityModels) {
        log("after remove selectedActivityModels Id and name : ${element.activityName} & ${element.personalEventActivityMasterId}");
      }
      log("remove _selectedActivityMasterIds.. == $_selectedActivityMasterIds");
    }
    notifyListeners();
  }

  List<String> _selectedActivityIds = [];
  List<String> get selectedActivityIds => _selectedActivityIds;
  addSelectedActivityIds({required String id, required String activityName}) {
    log('selectedActivityIds : $id');

    if (!_selectedActivityIds.contains(id)) {
      log("!_selectedRitualIds.contains(id) is true == ${!_selectedActivityIds.contains(id)}");
      _selectedActivityIds.add(id);
      selectedActivityModels
          .add(Activity(activityName: activityName, personalEventActivityId: int.parse(id)));
      log('add _selectedActivityIds length: ${_selectedActivityIds.length}');
    } else {
      _selectedActivityIds.removeWhere((element) => element == id);
      selectedActivityModels
          .remove(Activity(activityName: activityName, personalEventActivityId: int.parse(id)));
      log('remove _selectedActivityIds list : $_selectedActivityIds');
    }
    notifyListeners();
  }

  addFirstSelectedActivities(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word; // Preserve empty strings
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();
    String capitalizedValue = capitalizedWords.join(' ');
    if (!_selectedActivities.contains(capitalizedValue)) {
      _selectedActivities.add(capitalizedValue);
    }
    notifyListeners();
  }

  addInitialSelectedActivities(String val) {
    if (!_selectedActivities.contains(val)) {
      _selectedActivities.add(val);
    }
    notifyListeners();
  }

  removeActivitiesFromList(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _selectedActivities.removeWhere((element) => element == capitalizedValue);
    _selectedActivityModels.removeWhere(
      (element) => element.activityName?.toLowerCase() == capitalizedValue.toLowerCase(),
    );
    notifyListeners();
  }

  List<String> _writeByHandActivities = [];
  List<String> get writeByHandActivities => _writeByHandActivities;

  removeAllHandwrittenActivities(List<String> vals) {
    _writeByHandActivities = [];
    notifyListeners();
  }

  addWriteByHandActivities(String val) {
    if (!_writeByHandActivities.contains(val)) {
      _writeByHandActivities.add(val);
    }
    notifyListeners();
  }

  void removeWriteByHandActivities(String val) {
    List<String> words = val.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).toList();

    String capitalizedValue = capitalizedWords.join(' ');

    _writeByHandActivities.removeWhere((element) => element == capitalizedValue);
    notifyListeners();
  }

  void setInitialActivities(List<String> initialActivities, List<String> activityIds) {
    print('set initial activities length: ${initialActivities.length}');

    for (int i = 0; i < initialActivities.length; i++) {
      String activity = initialActivities[i];
      String activityId = activityIds[i];

      bool exists = selectedActivityModels.any((element) =>
          element.activityName == activity &&
          element.personalEventActivityMasterId.toString() == activityId);

      if (!exists) {
        if (initialActivities.contains(activity)) {
          addInitialSelectedActivities(activity);
          _selectedActivityIds = activityIds;
          _selectedActivityMasterIds = activityIds;

          log("element == ${activityId.toString()}");
          selectedActivityModels.add(Activity(
            activityName: activity,
            personalEventActivityMasterId: int.parse(activityId),
            personalEventActivityId: int.parse(activityId),
          ));
        } else {
          addWriteByHandActivities(activity);
        }
      }
    }
    notifyListeners();
  }

  List<String> _combinedActivities = [];
  List<String> get combinedActivities => _combinedActivities;
  setCombinedActivities({
    required List<String> normalActivities,
    required List<String> writeByHandActivities,
  }) {
    _combinedActivities = normalActivities + writeByHandActivities;
    notifyListeners();
  }

  clearActivities() {
    _selectedActivities.clear();
    _writeByHandActivities.clear();
    _combinedActivities.clear();
    _selectedActivityIds.clear();
    _personalEventActivities.clear();
    _personalEventActivitiesIds.clear();
    selectedActivityModels.clear();
    _selectedActivityMasterIds.clear();
    notifyListeners();
  }
}
