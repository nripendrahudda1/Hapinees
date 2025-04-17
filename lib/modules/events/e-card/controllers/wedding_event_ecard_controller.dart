import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/create_event_models/home/wedding_all_images_model.dart';
import '../../../../routes/app_router.dart';
import '../../../../utility/preferenceutils.dart';
import '../data/apis/wedding_event_ecard_apis.dart';


final weddingEventECardCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(weddingEventECardApisController);
  return WeddingEventECardController(repo: api);
});

class WeddingEventECardController extends ChangeNotifier {
  final WeddingEventECardDatasource _repo;
  WeddingEventECardController({required WeddingEventECardDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  WeddingAllImagesModel? _weddingAllImagesModel;
  WeddingAllImagesModel? get weddingAllImagesModel => _weddingAllImagesModel;
  setWeddingAllImagesModel(WeddingAllImagesModel? model) {
    _weddingAllImagesModel = model;
    notifyListeners();
  }


  String? _currentImage;
  String? get currentImage => _currentImage;
  setCurrentImage(String? model) {
    _currentImage = model;
    notifyListeners();
  }

  Widget? _selectedImage;
  Widget? get selectedImage => _selectedImage;
  setSelectedImage(Widget? image) {
    _selectedImage = image;
    notifyListeners();
  }


  Future<void> fetchAllWeddingImages({
    required WidgetRef ref,
    required BuildContext context,
    required String weddingHeaderId,
  }) async {
    EasyLoading.show();
    _weddingAllImagesModel = null;
    setLoading(true);
    final result = await _repo.fetchAllWeddingImages(
      weddingHeaderId: weddingHeaderId,
      token: PreferenceUtils.getString(PreferenceKey.accessToken),
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      _isLoading = false;
      setWeddingAllImagesModel(r);
      EasyLoading.dismiss();
      if(_weddingAllImagesModel != null && _weddingAllImagesModel?.weddingPhotoList?.length != 0){
        setCurrentImage(_weddingAllImagesModel?.weddingPhotoList?[0].imageUrl ?? '');
        Navigator.pushNamed(context, Routes.weddingECardScreen);
      }else{
        EasyLoading.showError('No Images Found!',duration: const Duration(seconds: 6));
      }
    });
    EasyLoading.dismiss();
    setLoading(false);
  }


  clear(){
    _weddingAllImagesModel = null;
    notifyListeners();
  }
}
