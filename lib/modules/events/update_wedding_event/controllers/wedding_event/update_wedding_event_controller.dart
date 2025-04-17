import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/data/apis/wedding_event_home_apis.dart';
import 'package:Happinest/modules/events/update_wedding_event/data/apis/wedding_event/update_event_apis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../models/create_event_models/create_wedding_models/event_types_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/update_wedding_event_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/set_wedding_success_model.dart';
import '../../../../../utility/preferenceutils.dart';

final updateWeddingEventController = ChangeNotifierProvider((ref) {
  final api = ref.watch(updateWeddingEventApisController);
  return UpdateWeddingEventController(repo: api);
});

class UpdateWeddingEventController extends ChangeNotifier {
  final UpdateWeddingEventDatasource _repo;
  UpdateWeddingEventController({required UpdateWeddingEventDatasource repo})
      : _repo = repo,
        super();

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

  SetWeddingSuccessModel? _setWeddingSuccessModel;
  SetWeddingSuccessModel? get setWeddingSuccessModel => _setWeddingSuccessModel;
  setWeddingSuccess(SetWeddingSuccessModel? model) {
    _setWeddingSuccessModel = model;
    notifyListeners();
  }

  Future<void> updateEvent({
    required UpdateWeddingEventPostModel updateEventPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    final result = await _repo.updateEvent(
      token: token,
      updateEventPostModel: updateEventPostModel,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async {
      EasyLoading.dismiss();
      if (r.responseStatus == true) {
        final reseult2 = await ref
            .read(weddingEventHomeApiController)
            .fetchHomeWeddingDetailsModel(
                weddingHeaderId:
                    updateEventPostModel.weddingHeaderId.toString(),
                token: token);
        reseult2.fold((l) {
          EasyLoading.dismiss();
          debugPrintStack(stackTrace: l.stackTrace);
          debugPrint(l.message);
          
        }, (r1) async {
          EasyLoading.dismiss();
          await ref
              .read(weddingEventHomeController)
              .setHomeWeddingDetailsModel(r1);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
          // Navigator.pushNamedAndRemoveUntil(
          //     context,
          //     arguments: {
          //       'weddingId': null
          //     },
          //     Routes.eventHomePageScreen,
          //         (route) => false);
        });
      }
    });
    EasyLoading.dismiss();
  }
}
