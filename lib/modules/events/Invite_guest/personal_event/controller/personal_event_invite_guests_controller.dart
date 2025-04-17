import 'package:Happinest/models/create_event_models/create_personal_event_models/email_template_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/make_co_host_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_email_post_template.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import '../../../../../utility/show_alert.dart';
import '../apis/personal_event_invite_guest_apis.dart';

final personalEventGuestInviteController = ChangeNotifierProvider((ref) {
  final api = ref.watch(personalEventGuestInviteApiController);
  return PersonalEventGuestInviteController(repo: api);
});

class PersonalEventGuestInviteController extends ChangeNotifier {
  final PersonalEventGuestInviteDatasource _repo;

  PersonalEventGuestInviteController({required PersonalEventGuestInviteDatasource repo})
      : _repo = repo,
        super();
  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  final searchCtr = TextEditingController();

  bool _isFindGuest = false;
  bool get isFindGuest => _isFindGuest;
  setFindGuest(bool status) {
    _isFindGuest = status;
    if (status == false) {
      setSearchedPersonalEventInvitesModel(null);
    }
    notifyListeners();
  }

  GetAllPersonalEventInvitedUsers? _getAllInvitedUsers;
  GetAllPersonalEventInvitedUsers? get getAllInvitedUsers => _getAllInvitedUsers;
  setPersonalEventInvites(GetAllPersonalEventInvitedUsers? model) {
    _getAllInvitedUsers = model;
    notifyListeners();
  }

  bool _isInvited = false;
  bool get isInvited => _isInvited;
  setInvitedStat(bool val) {
    _isInvited = val;
    notifyListeners();
  }

  int? _inviteId;
  int? get inviteId => _inviteId;
  setInvitId(int? val) {
    _inviteId = val;
    notifyListeners();
  }

  clear() {
    _isInvited = false;
    _inviteId = null;
    notifyListeners();
  }

  Future<void> getPersonalEventInvites({
    required String eventHeaderId,
    bool? isLoaderShow,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _getAllInvitedUsers = null;
    if (isLoaderShow == true) {
      EasyLoading.show();
    }
    setLoading(true);

    final result = await _repo.getPersonalEventInvites(
      eventHeaderId: eventHeaderId,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      //
    }, (r) {
      EasyLoading.dismiss();
      _isLoading = false;
      if (r.personalEventInviteList != null) {
        setPersonalEventInvites(r);
      } else {
        setPersonalEventInvites(null);
      }
    });
    setLoading(false);
  }

  /// Get Email Template
  ///
  EmailTemplate? _getEmailTemplateType;
  EmailTemplate? get getEmailTemplateType => _getEmailTemplateType;
  setEmailTemplate(EmailTemplate? model) {
    _getEmailTemplateType = model;
    notifyListeners();
  }

  Future<void> getEmailTemplateData({
    required String eventHeaderId,
    required String templateType,
    bool? isLoaderShow,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _getAllInvitedUsers = null;
    if (isLoaderShow == true) {
      EasyLoading.show();
    }
    setLoading(true);

    final result = await _repo.getEmailTemplate(
      eventHeaderId: eventHeaderId,
      templateType: templateType,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      //
    }, (r) {
      EasyLoading.dismiss();
      _isLoading = false;
      if (r != null) {
        setEmailTemplate(r);
      } else {
        setEmailTemplate(null);
      }
    });
    setLoading(false);
  }

  Future<void> sendEmailToGuest({
    required SendPostEmailTemplateModel sendEmailPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.sendEmailToGuest(
      sendEmailPostModel: sendEmailPostModel,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      EasyLoading.showError(l.message);
    }, (r) async {
      debugPrint(r.validationMessage);
      EasyLoading.dismiss();
      EasyLoading.showSuccess(r.validationMessage ?? '');
    });
  }

  Future<void> getPersonalEventInvitesSecondTime({
    required String eventHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _getAllInvitedUsers = null;
    setLoading(true);

    final result = await _repo.getPersonalEventInvites(
      eventHeaderId: eventHeaderId,
      token: token,
    );
    result.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      _isLoading = false;
      if (r.personalEventInviteList != null) {
        setPersonalEventInvites(r);
      } else {
        setPersonalEventInvites(null);
      }
    });
    setLoading(false);
  }

  Future<void> sendPersonalEventInvite({
    required SendPersonalEventInvitePostModel sendPersonalEventInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.setPersonalEventInvite(
      sendPersonalEventInvitePostModel: sendPersonalEventInvitePostModel,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      EasyLoading.showError(l.message);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      debugPrint(r.validationMessage);
      await getPersonalEventInvitesSecondTime(
        eventHeaderId: sendPersonalEventInvitePostModel.personalEventHeaderId.toString(),
        ref: ref,
        context: context,
      );
      EasyLoading.dismiss();
      EasyLoading.showSuccess(r.validationMessage ?? "Invited Success.");
    });
  }

  Future<void> actionOnPersonalEventInvite({
    required ActionOnPersonalEventInvitePostModel actionOnPersonalEventInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.actionOnPersonalEventInvite(
      actionOnPersonalEventInvitePostModel: actionOnPersonalEventInvitePostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      TMessaging.showSnackBar(
        context,
        l.message,
      );
    }, (r) async {
      debugPrint(r.validationMessage);
      await getPersonalEventInvites(
        eventHeaderId: actionOnPersonalEventInvitePostModel.personalEventHeaderId.toString(),
        context: context,
        ref: ref,
      );
    });
  }

  Future<void> actionOnPersonalEventInviteHome({
    required ActionOnPersonalEventInvitePostModel actionOnPersonalEventInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.actionOnPersonalEventInvite(
      actionOnPersonalEventInvitePostModel: actionOnPersonalEventInvitePostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      // TMessaging.showSnackBar(
      //   context,
      //   l.message,
      // );
      EasyLoading.dismiss();
    }, (r) async {
      debugPrint(r.validationMessage);
      await getPersonalEventInvites(
        eventHeaderId: actionOnPersonalEventInvitePostModel.personalEventHeaderId.toString(),
        context: context,
        isLoaderShow: false,
        ref: ref,
      );
      EasyLoading.dismiss();
    });
    EasyLoading.dismiss();
  }

  Future<void> makePersonalEventCoHost({
    required MakeCoHostPersonalEventPostModel makeCoHostPersonalEventPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.makePersonalEventCoHost(
      makeCoHostPostModel: makeCoHostPersonalEventPostModel,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      EasyLoading.showError(l.message ?? '');
    }, (r) async {
      debugPrint(r.validationMessage);
      await getPersonalEventInvites(
          eventHeaderId: makeCoHostPersonalEventPostModel.personalEventHeaderId.toString(),
          context: context,
          ref: ref,
          isLoaderShow: false);
      EasyLoading.dismiss();
      EasyLoading.showSuccess(r.validationMessage ?? '');
    });
  }

  SearchedPersonalEventInvitesModel? _searchedPersonalEventInvitesModel;
  SearchedPersonalEventInvitesModel? get searchedPersonalEventInvitesModel =>
      _searchedPersonalEventInvitesModel;
  setSearchedPersonalEventInvitesModel(SearchedPersonalEventInvitesModel? model) {
    _searchedPersonalEventInvitesModel = model;
    notifyListeners();
  }

  Future<void> getAllSearchedPersonalEventInviteUsers({
    required String personalEventHeaderId,
    required String searchWord,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
  }) async {
    EasyLoading.show();
    final result = await _repo.getAllSearchedPersonalEventInviteUsers(
      personalEventHeaderId: personalEventHeaderId,
      token: token,
      noOfRecords: noOfRecords,
      offset: offset,
      search: searchWord,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      _searchedPersonalEventInvitesModel = null;
      setSearchedPersonalEventInvitesModel(r);
      EasyLoading.dismiss();
    });
  }
}
