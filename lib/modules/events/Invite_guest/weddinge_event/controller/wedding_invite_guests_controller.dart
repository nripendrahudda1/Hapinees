import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/make_cohost_wedding_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/send_wedding_invite_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/searched_wedding_invites_model.dart';
import '../../../../../utility/preferenceutils.dart';
import '../../../../../utility/show_alert.dart';
import '../apis/wedding_invite_guest_apis.dart';

final weddingEventGuestInviteController = ChangeNotifierProvider((ref) {
  final api = ref.watch(weddingEventGuestInviteApiController);
  return WeddingEventGuestInviteController(repo: api);
});

class WeddingEventGuestInviteController extends ChangeNotifier {
  final WeddingEventGuestInviteDatasource _repo;
  WeddingEventGuestInviteController({required WeddingEventGuestInviteDatasource repo})
      : _repo = repo,
        super();
  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  GetAllWeddingEventInvitedUsers? _getAllInvitedUsers;
  GetAllWeddingEventInvitedUsers? get getAllInvitedUsers => _getAllInvitedUsers;
  setWeddingInvites(GetAllWeddingEventInvitedUsers? model) {
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

  Future<void> getWeddingInvites({
    required String weddingHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _getAllInvitedUsers = null;
    EasyLoading.show();
    setLoading(true);

    final result = await _repo.getWeddingInvites(
      weddingHeaderId: weddingHeaderId,
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
      if (r.statusCode == 0 && r.responseStatus == true && r.weddingInviteList == null) {
        setWeddingInvites(null);
      } else {
        setWeddingInvites(r);
      }
    });
    setLoading(false);
  }

  Future<void> getWeddingInvitesSecondTime({
    required String weddingHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _getAllInvitedUsers = null;
    setLoading(true);

    final result = await _repo.getWeddingInvites(
      weddingHeaderId: weddingHeaderId,
      token: token,
    );
    result.fold((l) {
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      _isLoading = false;
      if (r.statusCode == 0 && r.responseStatus == true) {
        setWeddingInvites(null);
      } else {
        setWeddingInvites(r);
      }
    });
    setLoading(false);
  }

  Future<void> sendWeddingInvite({
    required SendWeddingInvitePostModel sendWeddingInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.setWeddingInvite(
      sendWeddingInvitePostModel: sendWeddingInvitePostModel,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      EasyLoading.dismiss();
      debugPrint(r.validationMessage);
      await getWeddingInvitesSecondTime(
        weddingHeaderId: sendWeddingInvitePostModel.weddingHeaderId.toString(),
        ref: ref,
        context: context,
      );
      EasyLoading.dismiss();
      EasyLoading.showSuccess(r.validationMessage ?? "Invited Success.");
    });
  }

  Future<void> actionOnWeddingInvite({
    required ActionOnWeddingInvitePostModel actionOnWeddingInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.actionOnWeddingInvite(
      actionOnWeddingInvitePostModel: actionOnWeddingInvitePostModel,
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
      await getWeddingInvites(
        weddingHeaderId: actionOnWeddingInvitePostModel.weddingHeaderId.toString(),
        context: context,
        ref: ref,
      );
    });
  }

  Future<void> actionOnWeddingInviteHome({
    required ActionOnWeddingInvitePostModel actionOnWeddingInvitePostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.actionOnWeddingInvite(
      actionOnWeddingInvitePostModel: actionOnWeddingInvitePostModel,
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
      await getWeddingInvites(
        weddingHeaderId: actionOnWeddingInvitePostModel.weddingHeaderId.toString(),
        context: context,
        ref: ref,
      );
      EasyLoading.dismiss();
    });
    EasyLoading.dismiss();
  }

  Future<void> makeWeddingCohost({
    required MakeCoHostWeddingPostModel makeCoHostPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.makeWeddingCohost(
      makeCoHostPostModel: makeCoHostPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      debugPrint(r.validationMessage);
      await getWeddingInvites(
        weddingHeaderId: makeCoHostPostModel.weddingHeaderId.toString(),
        context: context,
        ref: ref,
      );
    });
  }

  SearchedWeddingInvtesModel? _searchedWeddingInvtesModel;
  SearchedWeddingInvtesModel? get searchedWeddingInvtesModel => _searchedWeddingInvtesModel;
  setSearchedInviteModels(SearchedWeddingInvtesModel? model) {
    _searchedWeddingInvtesModel = model;
    notifyListeners();
  }

  Future<void> getAllSearchedWeddingInviteUsers({
    required String weddingHeaderId,
    required String searchWord,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    _searchedWeddingInvtesModel = null;
    final result = await _repo.getAllSearchedWeddingInviteUsers(
      weddingHeaderId: weddingHeaderId,
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
      setSearchedInviteModels(r);
      EasyLoading.dismiss();
    });
  }
}
