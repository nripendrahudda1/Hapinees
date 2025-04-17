import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_personal_event_post_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/data/apis/personal_event_home_apis.dart';
import 'package:Happinest/modules/events/update_wedding_event/data/apis/personal_event/update_personal_event_apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';

final updatePersonalEventController = ChangeNotifierProvider((ref) {
  final api = ref.watch(updatePersonalEventApisController);
  return UpdatePersonalEventController(repo: api);
});

class UpdatePersonalEventController extends ChangeNotifier {
  final UpdatePersonalEventDatasource _repo;

  UpdatePersonalEventController({required UpdatePersonalEventDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  Future<void> updatePersonalEvent({
    required UpdatePersonalEventPostModel updatePersonalEventPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    log(updatePersonalEventPostModelToJson(updatePersonalEventPostModel));
    String token = PreferenceUtils.getString(PreferenceKey.accessToken);
    final result = await _repo.updateEvent(
      token: token,
      updatePersonalEventPostModel: updatePersonalEventPostModel,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      EasyLoading.dismiss();
      if (r.responseStatus == true) {
        final reseult2 = await ref
            .read(personalEventHomeApiController)
            .fetchHomePersonalEventsDetailsModel(
                personalEventHeaderId:
                    updatePersonalEventPostModel.personalEventHeaderId.toString(),
                token: token);
        reseult2.fold((l) {
          EasyLoading.dismiss();
          debugPrintStack(stackTrace: l.stackTrace);
          debugPrint(l.message);
        }, (r1) async {
          EasyLoading.dismiss();
          await ref.read(personalEventHomeController).setHomePersonalEventDetailsModel(r1);
          if (updatePersonalEventPostModel.personalEventThemeName != '' &&
              updatePersonalEventPostModel.personalEventThemeName != null) {
            await ref.read(personalEventHomeController).getEventActivity(
                eventId: r1.personalEventHeaderId.toString(), context: context, ref: ref);
          }
          await ref.read(personalEventGuestInviteController).getPersonalEventInvites(
              eventHeaderId: r1.personalEventHeaderId.toString(),
              isLoaderShow: true,
              ref: ref,
              context: context);
          ref.watch(personalEventHomeController).setHomePersonalEventInviteModel(ref
              .read(personalEventGuestInviteController)
              .getAllInvitedUsers
              ?.personalEventInviteList);
          Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.personalEventHomePageScreen,
              arguments: {
                'personalEventId': updatePersonalEventPostModel.personalEventHeaderId.toString()
              },
              (route) => false);
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
