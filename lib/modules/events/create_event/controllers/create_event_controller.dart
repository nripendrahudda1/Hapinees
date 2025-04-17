import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_more_info_controller/info_venue_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/baby_shower_themes_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/baby_shower_visibility_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/personal_event_activity_controller.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:Happinest/utility/database_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/custom_dialog.dart';

import 'package:Happinest/models/create_event_models/create_wedding_models/set_wedding_success_model.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_couple_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_expanded_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_dates_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/title_controller.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../common/common_functions/get_file_extension.dart';
import '../../../../common/common_imports/apis_commons.dart';
import '../../../../common/widgets/image_upload_dialogue.dart';
import '../../../../models/create_event_models/create_wedding_models/event_types_model.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_post_model.dart';
import '../../../../models/create_event_models/create_personal_event_models/set_personal_event_success_model.dart';
import '../../../../utility/Image Upload Bottom Sheets/choose_image.dart';
import '../data/apis/create_event_apis.dart';

final createEventController = ChangeNotifierProvider((ref) {
  final api = ref.watch(createEventApisController);
  return CreateEventController(repo: api);
});

class CreateEventController extends ChangeNotifier {
  final CreateEventDatasource _repo;
  final dbManager = DatabaseManager();

  CreateEventController({required CreateEventDatasource repo})
      : _repo = repo,
        super();

  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

  @override
  void dispose() {
    textFieldController.text = "";
    super.dispose();
  }

  int _selectOccassionId = 0;
  int get selectOccassionId => _selectOccassionId;
  String _eventTypeName = "Wedding";
  String get eventTypeName => _eventTypeName;

  bool _hasThemes = false;
  bool get hasThemes => _hasThemes;
  setOccassionID(int id, bool hasTheme, String eventTypeName) {
    _selectOccassionId = id;
    _hasThemes = hasTheme;
    _eventTypeName = eventTypeName;
    notifyListeners();
  }

  bool _isBefore = false;
  bool get isBefore => _isBefore;

  void dateBeforeCheck(DateTime selectedDate) {
    DateTime todayDate = DateTime.now();
    // Check if the selected date is exactly today // Nripendra Update Logic
    if (todayDate.year == selectedDate.year &&
        todayDate.month == selectedDate.month &&
        todayDate.day == selectedDate.day) {
      _isBefore = false;
    } else {
      _isBefore = selectedDate.isBefore(todayDate);
    }
    notifyListeners();
  }

  resetAllData() {
    _isBefore = false;
    _selectOccassionId = 0;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool _isHomeLoading = false;
  bool get isHomeLoading => _isHomeLoading;
  setHomeLoading(bool status) {
    _isHomeLoading = status;
    notifyListeners();
  }

  EventTypesModel? _evenTypesModel;
  EventTypesModel? get evenTypesModel => _evenTypesModel;
  setEventTypesModel(EventTypesModel? model) {
    _evenTypesModel = model;
    notifyListeners();
  }

  // Get offline data
  Future<bool> _getStoredEventData() async {
    var eventData = dbManager.getObject(DBKeys.eventData);
    // log('>>>> weath ${eventData}');
    if (eventData != null) {
      return true;
    }
    return false;
  }

  Future<void> fetchEventTypesModel({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    // 1.Wedding  2.BabyShower 3.Birthday 4.Anniversary 5.Sports 6.Concert 7.Startup 8.Tech 9.Premier 10.Personal 11.House Warming
    setLoading(true);
    Duration syncTime = dbManager.getTimeUntilNextSync();

    if (syncTime <= Duration.zero) {
      print("Sync due now!");
      // Perform sync operation
      setHomeLoading(true);
      dbManager.updateLastSyncTime(); // Update last sync time after syncing
    } else {
      print("Next sync in: ${dbManager.getFormattedTimeUntilNextSync()}");
      bool isEmpty = await _getStoredEventData();

      if (isEmpty) {
        setHomeLoading(false);
      }
    }

    final result = await _repo.fetchAllEventTypes(
      eventCategoryMasterId: TPParameters.eventCategoryMasterId,
      language: TPParameters.eventLanguage,
    );
    result.fold((l) {
      setHomeLoading(false);
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      //
    }, (r) {
      _isLoading = false;
      setHomeLoading(false);
      setEventTypesModel(r);
      notifyListeners();
    });
    setLoading(false);
  }

  SetWeddingSuccessModel? _setWeddingSuccessModel;
  SetWeddingSuccessModel? get setWeddingSuccessModel => _setWeddingSuccessModel;
  setWeddingSuccess(SetWeddingSuccessModel? model) {
    _setWeddingSuccessModel = model;
    notifyListeners();
  }

  SetPersonalEventSuccessModel? _setPersonalEventSuccessModel;
  SetPersonalEventSuccessModel? get setPersonalEventSuccessModel => _setPersonalEventSuccessModel;
  setPersonalEventSuccess(SetPersonalEventSuccessModel? model) {
    _setPersonalEventSuccessModel = model;
    notifyListeners();
  }

  Future<void> setWedding({
    required SetWeddingPostModel setWeddingPostModel,
    required BuildContext context,
    required WidgetRef ref,
    required bool isAddPhotos,
    Map<int, List<AssetEntity>>? images,
    List<File?>? files,
  }) async {
    setLoading(true);
    try {
      final result = await _repo.setWedding(setWeddingPostModel: setWeddingPostModel, token: token);

      result.fold((l) {
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        setLoading(false);
        EasyLoading.showError(l.message ?? "", duration: const Duration(seconds: 6));
      }, (r) async {
        setWeddingSuccess(r);
        if (r.responseStatus == true) {
          // final reseult2 = await _repo.fetchHomeWeddingDetailsModel(
          //     weddingHeaderId: r.weddingHeaderId.toString(), token: token);
          // reseult2.fold((l) {
          //   setLoading(false);
          //   debugPrintStack(stackTrace: l.stackTrace);
          //   debugPrint(l.message);
          //   //
          // }, (r1) {
          //   _isLoading = false;
          //   setHomeWeddingDetailsModel(r1);
          resetCtrAfterDone(ref);
          if (r.responseStatus == true) {
            // print("setPersonalEventSuccess ************ ${isAddPhotos}");
            if (isAddPhotos) {
              PersonalEventCreateMemoriesTextPostModel model =
                  PersonalEventCreateMemoriesTextPostModel(
                aboutPost: "",
                personalEventHeaderId: r.weddingHeaderId,
                createdOn: DateTime.now(),
              );
              // print(
              //     "setPersonalEventSuccess ************ ${personalEventCreateMemoriesTextPostModelToJson(model)}");
              await createEvenPosts(
                  model: model, ref: ref, images: images, context: context, file: files);
              await setLoading(false);
            } else {
              setLoading(false);
              await resetCtrAfterDone(ref);
              await Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.weddingEventHomePageScreen,
                  arguments: {'weddingId': r.weddingHeaderId.toString()},
                  (route) => false);
              // });
            }
          } else {
            setLoading(false);
            EasyLoading.showError(r.validationMessage ?? "", duration: const Duration(seconds: 6));
          }

          // });
        } else {
          EasyLoading.showError(r.validationMessage ?? "", duration: const Duration(seconds: 6));
          setLoading(false);
        }
      });
      setLoading(false);
    } catch (e) {
      setLoading(false);
      EasyLoading.showError(e.toString() ?? "", duration: const Duration(seconds: 6));
      log("error in set wedding api == ${e.toString()}");
    }
  }

  Future<void> setPersonalEvents({
    required SetPersonalEventPostModel setPersonalEventPostModel,
    required BuildContext context,
    required WidgetRef ref,
    required bool isAddPhotos,
    Map<int, List<AssetEntity>>? images,
    List<File?>? files,
  }) async {
    setLoading(true);
    EasyLoading.show();
    print("--setPersonalEventSuccess ******");
    print("--setPersonalEventSuccess ******${setPersonalEventPostModel.toJson()}");

    print("${setPersonalEventPostModel.backgroundImageData.toString()}******");

    try {
      final result = await _repo.setPersonalEvents(
          setPersonalEventPostModel: setPersonalEventPostModel, token: token);
      result.fold(
        (l) {
          setLoading(false);
          debugPrintStack(stackTrace: l.stackTrace);
          EasyLoading.showError(l.message, duration: const Duration(seconds: 6));
          debugPrint(l.message);
        },
        (r) async {
          // print("----setPersonalEventSuccess ************ $r");
          // print("setPersonalEventSuccess validationMessage ************ ${r.validationMessage}");
          // print("---setPersonalEventSuccess ************ ${r.responseStatus}");
          setPersonalEventSuccess(r);
          if (r.responseStatus == true) {
            // print("setPersonalEventSuccess ************ ${isAddPhotos}");
            if (isAddPhotos) {
              PersonalEventCreateMemoriesTextPostModel model =
                  PersonalEventCreateMemoriesTextPostModel(
                aboutPost: "",
                personalEventHeaderId: r.personalEventHeaderId,
                createdOn: DateTime.now(),
              );
              // print(
              //     "setPersonalEventSuccess ************ ${personalEventCreateMemoriesTextPostModelToJson(model)}");
              await createEvenPosts(
                  model: model, ref: ref, images: images, context: context, file: files);
              await setLoading(false);
            } else {
              setLoading(false);
              await resetCtrAfterDone(ref);
              await Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.personalEventHomePageScreen,
                  arguments: {'personalEventId': r.personalEventHeaderId.toString()},
                  (route) => false);
              // });
            }
          } else {
            setLoading(false);
            EasyLoading.showError(r.validationMessage ?? "", duration: const Duration(seconds: 6));
          }
        },
      );
    } catch (e) {
      setLoading(false);
      EasyLoading.showError(e.toString() ?? "", duration: const Duration(seconds: 6));
      log("error in set personal event api => $e");
    }
  }

  Future createEvenPosts(
      {required BuildContext context,
      required PersonalEventCreateMemoriesTextPostModel model,
      required WidgetRef ref,
      Map<int, List<AssetEntity>>? images,
      List<File?>? file}) async {
    try {
      final result3 = await _repo.setPersonalEventMemoryPostText(
          personalEventCreateMemoriesTextPostModel: model, token: token);
      result3.fold(
        (l) {
          setLoading(false);
          debugPrintStack(stackTrace: l.stackTrace);
          EasyLoading.showError(l.message ?? "", duration: const Duration(seconds: 6));
          debugPrint(l.message);
        },
        (r) async {
          print("setPersonalEventSuccess image  ************ ${r}");
          print("setPersonalEventSuccess ************ ${r.responseStatus}");
          print("setPersonalEventSuccess ************ ${r.statusCode}");
          print("setPersonalEventSuccess ************ ${r.validationMessage}");
          if (r.responseStatus == true) {
            print("createEventActivity response *****${r.responseStatus}");
            print("createEventActivity response *****${r.validationMessage}");
            EasyLoading.dismiss();
            if (images != null) {
              int tPhotos = 0;
              int totPhotos = images.values.fold(0, (sum, photos) => sum + photos.length);
              // totPhotos > 0 ? Navigator.pop(context) : null;
              for (int key in images.keys) {
                List<AssetEntity>? photos = images[key];
                if (photos != null && photos.isNotEmpty) {
                  showUploadDialog(totPhotos, (tPhotos + 1), context);
                  for (int i = 0; i < photos.length; i++) {
                    tPhotos++;
                    bool isUpload = await uploadImages(
                        context, model.personalEventHeaderId ?? 0, r.personalEventPostId ?? 0,
                        pic: photos[i], fileImage: null, ref: ref);

                    if (!isUpload) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return;
                    }
                  }
                  await setLoading(false);
                  EasyLoading.showSuccess('Event Created Successfully');
                  await resetCtrAfterDone(ref);
                  if (context.mounted) {
                    await Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.personalEventHomePageScreen,
                      arguments: {'personalEventId': model.personalEventHeaderId.toString()},
                      (route) => false,
                    );
                  }
                }
              }
            } else if (file != null && file.isNotEmpty) {
              int tPhotos = 0;
              int totPhotos = file.length;
              for (int i = 0; i < file.length; i++) {
                tPhotos++;
                showUploadDialog(totPhotos, tPhotos, context);
                bool isUpload = await uploadImages(
                    context, model.personalEventHeaderId ?? 0, r.personalEventPostId ?? 0,
                    fileImage: file[i], pic: null, ref: ref);
                if (!isUpload) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  return;
                }
              }
              if (tPhotos == (file.length)) {
                print(
                    "asfeswdfhytfght **************************************** ${model.personalEventHeaderId}");
                await setLoading(false);
                // Navigator.pop(context);
                EasyLoading.showSuccess('Event Created Successfully');
                await resetCtrAfterDone(ref);
                if (context.mounted) {
                  await Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.personalEventHomePageScreen,
                    arguments: {'personalEventId': model.personalEventHeaderId.toString()},
                    (route) => false,
                  );
                }
              }
            } else {
              await setLoading(false);
              await resetCtrAfterDone(ref);
              if (context.mounted) {
                await Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.personalEventHomePageScreen,
                  arguments: {'personalEventId': model.personalEventHeaderId.toString()},
                  (route) => false,
                );
              }
            }
          }
        },
      );
    } catch (e) {
      EasyLoading.showError(e.toString() ?? "", duration: const Duration(seconds: 6));
      log("create event activity error => $e");
    }
  }

  Future<bool> uploadImages(context, int personalEventHeaderId, personalEventPostId,
      {AssetEntity? pic, File? fileImage, required WidgetRef ref}) async {
    bool imageuploadResponse = false;
    try {
      File? file = pic != null ? (await pic.file) : fileImage;
      var path = file?.path;
      print('file path **********--------------$path');
      print('file personalEventHeaderId **********--------------$personalEventHeaderId');
      print('file personalEventPostId **********--------------$personalEventPostId');
      String bgExt = getFileExtension(path: path ?? '');
      //Uint8List? stringPPic = file?.readAsBytesSync();
      Uint8List? compressedPPic = await ImagePickerBottomSheet.compressFile(File(path ?? ''));
      // Uint8List? stringPPic = await ImagePickerBottomSheet.compressFile(File(path ?? ''));
      String bgImage = base64.encode(compressedPPic ?? []);
      print(compressedPPic.toString());
      print(bgExt);
      print(bgImage);
      PersonalEventCreateMemoriesPhotoPostModel model = PersonalEventCreateMemoriesPhotoPostModel(
        personalEventHeaderId: personalEventHeaderId,
        personalEventPostId: personalEventPostId,
        imageExtension: bgExt,
        imageData: bgImage,
        createdOn: DateTime.now(),
      );
      final response = await _repo.setPersonalEventMemoryPostPhoto(
          personalEventCreateMemoriesPhotoPostModel: model, token: token);
      response.fold(
        (l) {
          print('-----setPersonalEventMemoryPostPhoto---${response}');
          setLoading(false);
          EasyLoading.showError(l.message ?? "", duration: const Duration(seconds: 6));
          return false;
        },
        (r) {
          if (r.responseStatus == true) {
            imageuploadResponse = r.responseStatus!;
            return r.responseStatus;
          } else {
            setLoading(false);
            EasyLoading.showError(r.validationMessage ?? "", duration: const Duration(seconds: 6));
            return r.responseStatus;
          }
        },
      );
    } catch (e) {
      EasyLoading.showError(e.toString() ?? "", duration: const Duration(seconds: 6));
      log("upload images error => $e");
      return false;
    }
    return imageuploadResponse;
  }

  joinEvent({
    required String eventID,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    /*final reseult2 = await _repo.fetchHomeWeddingDetailsModel(
        weddingHeaderId: eventID, token: token);
    reseult2.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      //
    }, (r1) {
      _isLoading = false;
      setHomeWeddingDetailsModel(r1);
      resetCtrAfterDone(ref);
      eventID == '1' ?
      Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.weddingEventHomePageScreen,
          arguments: {'weddingId': r1.weddingHeaderId.toString()},
              (route) => false)
          : Navigator.pushNamedAndRemoveUntil(
          context,
          Routes.personalEventHomePageScreen,
          arguments: {'personalEventId': r1.weddingHeaderId.toString()},
              (route) => false);
    });*/
    setLoading(false);
  }

  resetCtrAfterDone(WidgetRef ref) {
    ref.watch(infoVenueController).resetData();
    ref.read(weddingStylesCtr).clearStyles();
    ref.read(weddingActivityCtr).clearRitualss();
    ref.read(weddingCoupleCtr).clearCoupleNames();
    ref.read(eventTitleCtr).clearTitle();
    ref.read(eventDatesCtr).clearDates();
    ref.read(weddingCreateEventVisibilityCtr).resetSelection();
    ref.read(createEventController).resetAllData();
    ref.read(personalEventVisibilityCtr).resetSelection();
    ref.read(personalEventThemesCtr).clearThemes();
    ref.read(personalEventActivityCtr).clearActivity();
    ref.watch(createEventExpandedCtr).resetExpand();
  }

  Future redeemEventCode(
      {required String redeemCode,
      required BuildContext context,
      required int eventTypeMasterId,
      required String userEmail}) async {
    try {
      EasyLoading.show();
      var url = ApiUrl.redeemEventCode;
      await ApiService.fetchApi(
          context: context,
          url: url,
          isLoader: false,
          params: {
            "code": redeemCode,
            "redeemDate": DateTime.now().toIso8601String(),
            "eventTypeMasterId": eventTypeMasterId,
            "email": userEmail
          },
          onError: (res) {
            print("error == $res");
          },
          onSuccess: (res) {
            print("res *******************$res");
            textFieldController.text = "";
            res['responseStatus'].toString().trim().toLowerCase() == 'false'
                ? EasyLoading.showError(res['validationMessage'].toString(),
                    duration: const Duration(seconds: 6))
                : Navigator.pop(context);
            res['responseStatus'].toString().trim().toLowerCase() == 'false'
                ? null
                : EasyLoading.showSuccess(res['validationMessage'].toString());
            EasyLoading.dismiss();
            print("message == $res");
            notifyListeners();
          });
    } catch (e) {
      print("API error == ${e.toString()}");
    }
  }

  TextEditingController textFieldController = TextEditingController();
  Future showReddemDialog(BuildContext context, {required void Function() onTap}) {
    return showDialog<String>(
        context: context,
        builder: (context) => TDialog(
            title: "Redeem Code",
            actionButtonText: "Redeem",
            bodyText: "",
            textField: Padding(
              padding: EdgeInsets.only(left: 10.h, right: 10.h, top: 5, bottom: 20),
              child: TextField(
                controller: textFieldController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: TAppColors.buttonBlue, width: 2)),
                  hintText: "Enter Your Reddem Code",
                ),
              ),
            ),
            onActionPressed: onTap));
  }
}

/// 12932 Rvpatel
