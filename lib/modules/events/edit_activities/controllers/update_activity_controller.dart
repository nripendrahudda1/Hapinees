

import 'package:Happinest/models/create_event_models/activity_photo_response_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_activity_photo_phost_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_activity_post_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../common/common_imports/apis_commons.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../data/apis/update_activity_apis.dart';

final updateActivityController = ChangeNotifierProvider((ref) {
  final api = ref.watch(updateActivityApisController);
  return UpdateActivityController(repo: api);
});

class UpdateActivityController extends ChangeNotifier {
  final UpdateEventActivityDatasource _repo;
  UpdateActivityController({required UpdateEventActivityDatasource repo}) : _repo = repo , super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  String token = PreferenceUtils.getString(PreferenceKey.accessToken);


  ActivityPhotoResponseModel? _activityImagesModel;
  ActivityPhotoResponseModel? get activityImagesModel => _activityImagesModel;
  setActivityImagesModel(ActivityPhotoResponseModel? model){
    print("ActivityPhotoResponseModel");
    _activityImagesModel = model;
    if(_activityImagesModel!= null && _activityImagesModel?.personalEventActivityPhotos?.length!=0){
      List<String> temp = [];
      List<int> temp2 = [];
      _activityImagesModel!.personalEventActivityPhotos?.forEach((activityImageModel) {
        temp.add(activityImageModel.imageUrl ?? '');
        temp2.add(activityImageModel.personalEventActivityPhotoId ?? 0);
      });
      setActivityImages(temp);
      setActivityImageIds(temp2);
    }
    notifyListeners();
  }

  List<String> _activityImages = [];
  List<String>  get activityImages => _activityImages;
  setActivityImages(List<String>  images){
    _activityImages = [];
    _activityImages = images;
    notifyListeners();
  }

  List<int> _activityImageIds = [];
  List<int>  get activityImageIds => _activityImageIds;
  setActivityImageIds(List<int>  images){
    _activityImageIds = [];
    _activityImageIds = images;
    notifyListeners();
  }

  Future<void> getActivityImages({
    required String personalEventActivityId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    _activityImagesModel = null;
    _activityImages = [];
    // EasyLoading.show();
    final result = await _repo.getActivityImages(personalEventActivityId: personalEventActivityId, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

      // EasyLoading.dismiss();
    }, (r) async{
      print('Image uRL: ${r.validationMessage}');
      // EasyLoading.dismiss();
      setActivityImagesModel(r);
    });
    EasyLoading.dismiss();
  }


  Future<void> updateActivity({
    required String? personalEventHeaderId,
    required UpdateActivityPostModel updateActivityPostModel,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    final result = await _repo.updateActivity(updateActivityPostModel: updateActivityPostModel, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) async{
      if(r.validationMessage == "Success"){
        await ref.read(personalEventHomeController).getEventActivity(
          eventId: personalEventHeaderId.toString() ?? '',
          context: context,
          ref: ref,
        );
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushNamedAndRemoveUntil(
            context, Routes.personalEventHomePageScreen,
            arguments: {
              'personalEventId': updateActivityPostModel.personalEventHeaderId.toString(),
            },
                (route) => false,
          );
        });
      }

    });
    setLoading(false);
  }


  Future<void> deletePersonalEventActivity({
    required int personalEventActivityId,
    required WidgetRef ref,
  }) async {
    // EasyLoading.show();
    final result = await _repo.deletePersonalEventActivity(personalEventActivityId: personalEventActivityId, token: token);
    result.fold((l) {
      // EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) {

      // print('Can POOP: ${Navigator.canPop(context)}');
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   Future.delayed(timeStamp, (){
      //     // Navigator.canPop(context);
      //     print('Can POOP: ${Navigator.canPop(context)}');

      // EasyLoading.dismiss();
      //   });
      // });

    });
    // EasyLoading.dismiss();
    setLoading(false);
  }


  Future<void> setPersonalEventActivityPhoto({
    required SetPersonalEventActivityPhotoPostModel setPersonalEventActivityPhotoPostModel,
    required BuildContext context,
    required Function() onSuccess,
    required WidgetRef ref,
  }) async {
    try {
      setLoading(true);
      String token = PreferenceUtils.getString(PreferenceKey.accessToken);
      final result = await _repo.setPersonalEventActivityPhoto(
          setPersonalEventActivityPhotoPostModel: setPersonalEventActivityPhotoPostModel,
          token: token);
      result.fold((l) {
        EasyLoading.showError(l.message,duration: const Duration(seconds: 6));
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        print("setPersonalEventActivityPhoto ************** l ${l.message}");
      }, (r) async {
        if(r.responseStatus == true) {
          onSuccess.call();
        } else {
          EasyLoading.showError('${r.validationMessage}',duration: const Duration(seconds: 6));
        }
        print(setPersonalEventActivityPhotoPostModel.imageData);
        print("setPersonalEventActivityPhoto ************** r $r");
      });
      setLoading(false);
    } catch (e) {
      print("setPersonalEventActivityPhoto error => $e");
    }
  }

  Future<void> deletePersonalEventActivityPhoto({
    required String personalEventActivityPhotoId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    final result = await _repo.deletePersonalEventActivityPhoto(personalEventActivityPhotoId: personalEventActivityPhotoId, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) async{

    });
    setLoading(false);
  }
}