import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/create_event_models/create_wedding_models/event_types_model.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/delete_wedding_ritual_post_model.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_ritual_photo_post_model.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/update_ritual_post_model.dart';
import '../../../../models/create_event_models/create_wedding_models/ritual_image_response_model.dart';
import '../../../../routes/app_router.dart';
import '../../../../utility/preferenceutils.dart';
import '../data/apis/update_ritual_apis.dart';

final updateRitualController = ChangeNotifierProvider((ref) {
  final api = ref.watch(updateRitualApisController);
  return UpdateRitualController(repo: api);
});

class UpdateRitualController extends ChangeNotifier {
  final UpdateRitualDatasource _repo;
  UpdateRitualController({required UpdateRitualDatasource repo})
      : _repo = repo,
        super();

  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  EventTypesModel? _evenTypesModel;
  EventTypesModel? get evenTypesModel => _evenTypesModel;
  setEventTypesModel(EventTypesModel? model) {
    _evenTypesModel = model;
    notifyListeners();
  }



  Future<void> updateRitual({
    required String? weddingHeaderId,
    required UpdateRitualPostModel updateRitualPostModel,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    final result = await _repo.updateRitual(updateRitualPostModel: updateRitualPostModel, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async{
      if(r.validationMessage == "Success"){
        await ref.read(weddingEventHomeController).getWedding(
            weddingId: weddingHeaderId.toString() ?? '',
            context: context,
            ref: ref,
        );
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushNamedAndRemoveUntil(
            context, Routes.weddingEventHomePageScreen,
            arguments: {
              'weddingId': updateRitualPostModel.weddingHeaderId.toString(),
            },
            (route) => false,
          );
        });
      }

    });
    setLoading(false);
  }


  Future<void> setWeddingRitualPhoto({
    required SetWeddingRitualPhotoPostModel setWeddingRitualPhotoPostModel,
    required BuildContext context,
    required Function() onSuccess,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    final result = await _repo.setWeddingRitualPhoto(setWeddingRitualPhotoPostModel: setWeddingRitualPhotoPostModel, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      EasyLoading.showError(l.message);
    }, (r) async{
      if(r.responseStatus == true) {
        onSuccess.call();
      } else {
        EasyLoading.showError(r.validationMessage.toString());
      }
    });
    setLoading(false);
  }

  Future<void> deleteWeddingRitual({
    required DeleteWeddingRitualPostModel deleteWeddingRitualPostModel,
    required WidgetRef ref,
  }) async {
    // EasyLoading.show();
    final result = await _repo.deleteWeddingRitual(deleteWeddingRitualPostModel: deleteWeddingRitualPostModel, token: token);
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

  Future<void> deleteWeddingRitualPhoto({
    required String weddingRitualPhotoId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    setLoading(true);
    final result = await _repo.deleteWeddingRitualPhoto(weddingRitualPhotoId: weddingRitualPhotoId, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async{

    });
    setLoading(false);
  }

  RitualImagesResponseModel? _ritualImagesModel;
  RitualImagesResponseModel? get ritualImagesModel => _ritualImagesModel;
  setRitualImagesModel(RitualImagesResponseModel? model){
    _ritualImagesModel = model;
    if(_ritualImagesModel!= null && _ritualImagesModel?.weddingRitualPhotos?.length!=0){
      List<String> temp = [];
      List<int> temp2 = [];
    _ritualImagesModel!.weddingRitualPhotos?.forEach((ritualImageModel) {
      temp.add(ritualImageModel.imageUrl ?? '');
      temp2.add(ritualImageModel.weddingRitualPhotoId ?? 0);
    });
      setRitualImages(temp);
      setRitualImageIds(temp2);
    }
    notifyListeners();
  }

  List<String> _ritualImages = [];
  List<String>  get ritualImages => _ritualImages;
  setRitualImages(List<String>  images){
    _ritualImages = [];
    _ritualImages = images;
    notifyListeners();
  }

  List<int> _ritualImageIds = [];
  List<int>  get ritualImageIds => _ritualImageIds;
  setRitualImageIds(List<int>  images){
    _ritualImageIds = [];
    _ritualImageIds = images;
    notifyListeners();
  }

  Future<void> getRitualImages({
    required String weddingRitualId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    _ritualImagesModel = null;
    _ritualImages = [];
    // EasyLoading.show();
    final result = await _repo.getRitualImages(weddingRitualId: weddingRitualId, token: token);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
      // EasyLoading.dismiss();
    }, (r) async{
      print('Image uRL: ${r.validationMessage}');
      // EasyLoading.dismiss();
      setRitualImagesModel(r);
    });
    EasyLoading.dismiss();
  }

}
