

import 'package:Happinest/models/create_event_models/home/wedding_all_images_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../common/common_imports/apis_commons.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../data/apis/personal_event_ecard_apis.dart';

final personalEventECardCtr = ChangeNotifierProvider((ref) {
  final api = ref.watch(personalEventECardApisController);
  return PersonalEventECardController(repo: api);
});

class PersonalEventECardController extends ChangeNotifier {
  final PersonalEventECardDatasource _repo;
  PersonalEventECardController({required PersonalEventECardDatasource repo})
      : _repo = repo,
        super();

  List<WeddingPhotoList> personalEventAllImagesList = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  // WeddingPhotoList? _personalEventAllImagesModel;
  // WeddingPhotoList? get personalEventAllImagesModel => _personalEventAllImagesModel;
  setPersonalEventAllImagesModel(WeddingPhotoList? model) {
    personalEventAllImagesList.add(model!);
    // _personalEventAllImagesModel = model;
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


  Future<void> getActivityImages({
    required WidgetRef ref,
    required BuildContext context,
    required int personalEventActivityId,
  }) async {
    // EasyLoading.show();
    // _personalEventAllImagesModel = null;
    setLoading(true);
    final result = await _repo.getActivityImages(
      personalEventActivityId: personalEventActivityId.toString(),
      token: PreferenceUtils.getString(PreferenceKey.accessToken),
    );
    result.fold((l) {
      // EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      _isLoading = false;
      // setPersonalEventAllImagesModel(r);
      if(r.personalEventActivityPhotos?.length != 0) {
        for (int j = 0; j < r.personalEventActivityPhotos!.length; j++) {
          setPersonalEventAllImagesModel(WeddingPhotoList(imageUrl: r.personalEventActivityPhotos![j].imageUrl));
        }
      }
      // EasyLoading.dismiss();
    });
    // EasyLoading.dismiss();
    setLoading(false);
  }

  Future<void> fetchAndSetPersonalEventPhotos ({
    required List<int> activityId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    personalEventAllImagesList = [];
    for(int i = 0; i < activityId.length; i++) {
      await getActivityImages(ref: ref, context: context, personalEventActivityId: activityId[i]);
    }
    EasyLoading.dismiss();
    if(personalEventAllImagesList.length != 0) {
      setCurrentImage(personalEventAllImagesList[0].imageUrl ?? '');
      Navigator.pushNamed(context, Routes.personalEventECardScreen,arguments: {'isSingleImage':false});
    } else {
      EasyLoading.showError('No Images Found!',duration: const Duration(seconds: 6));
    }
  }


  clear(){
    personalEventAllImagesList = [];
    notifyListeners();
  }
}
