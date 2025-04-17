import 'dart:async';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/wedding_event_comment_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/like_ritual_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/wedding_comment_like_post_model.dart';

import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/event_write_comment_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/like_wedding_event_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/ritual_photo_comment_like_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/ritual_photo_comment_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/wedding_view_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/ritual_photo_all_comments_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/ritual_photo_like_user_models.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_like_users_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_views_model.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../../utility/preferenceutils.dart';
import '../data/apis/wedding_event_home_apis.dart';

final weddingEventHomeController = ChangeNotifierProvider((ref) {
  final api = ref.watch(weddingEventHomeApiController);
  return WeddingEventHomeController(repo: api);
});

class WeddingEventHomeController extends ChangeNotifier {
  final WeddingEventHomeDatasource _repo;
  WeddingEventHomeController({required WeddingEventHomeDatasource repo})
      : _repo = repo,
        super();

  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

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

  HomeWeddingDetailsModel? _homeWeddingDetails;
  HomeWeddingDetailsModel? get homeWeddingDetails => _homeWeddingDetails;
  setHomeWeddingDetailsModel(HomeWeddingDetailsModel? model) {
    _homeWeddingDetails = model;
    notifyListeners();
  }

  Future<void> getWedding({
    required String weddingId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    _homeWeddingDetails = null;
    print('tapped');
    EasyLoading.show();
    final reseult =
        await _repo.fetchHomeWeddingDetailsModel(weddingHeaderId: weddingId, token: token);
    reseult.fold((l) {
      setHomeLoading(false);
      EasyLoading.showError('${l.message}', duration: const Duration(seconds: 6));
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      EasyLoading.dismiss();

      //
    }, (r1) {
      setHomeWeddingDetailsModel(r1);
      getUserRole(model: r1);
      EasyLoading.dismiss();
      _isHomeLoading = false;
    });
    setHomeLoading(false);
    EasyLoading.dismiss();
  }

  UserRoleEnum _userRoleEnum = UserRoleEnum.Host;
  UserRoleEnum get userRoleEnum => _userRoleEnum;
  setUserRole({required UserRoleEnum uenum}) {
    _userRoleEnum = uenum;
    notifyListeners();
  }

  getUserRole({required HomeWeddingDetailsModel model}) {
    print('Getting called!');

    if (myProfileData == null || model.createdBy == null) {
      print('User details or model createdBy is null.');
      print('User details $myProfileData');
      print('model createdBy details ${model.createdBy}');
      return;
    }

    if (model.createdBy!.email == myProfileData!.email) {
      print('User is the host.');
      setUserRole(uenum: UserRoleEnum.Host);
      return;
    }

    bool isCoHost = false;
    bool isGuest = false;

    for (var invitedUser in model.weddingInviteList ?? []) {
      if (invitedUser.isCoHost ?? false) {
        isCoHost = true;
      } else if (invitedUser.inviteStatus == '2') {
        isGuest = true;
      }
    }

    if (isCoHost) {
      print('User is a co-host.');
      setUserRole(uenum: UserRoleEnum.CoHost);
      return;
    } else if (isGuest) {
      print('User is a guest.');
      setUserRole(uenum: UserRoleEnum.Guest);
      return;
    } else {
      print('User is a public user.');
      setUserRole(uenum: UserRoleEnum.PublicUser);
    }
  }

  WeddingEventCommentModel? _eventCommentModel;
  WeddingEventCommentModel? get eventCommentModel => _eventCommentModel;
  setEventCommentModel(WeddingEventCommentModel? model) {
    _eventCommentModel = model;
    notifyListeners();
  }

  Future<void> getAllWeddingEventComments({
    required String weddingHeaderId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
  }) async {
    _eventCommentModel = null;
    EasyLoading.show();
    setLoading(true);

    final result = await _repo.getWeddingEventAllComments(
      weddingHeaderId: weddingHeaderId,
      token: token,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      EasyLoading.dismiss();
      _isLoading = false;
      setEventCommentModel(r);
    });
    setLoading(false);
  }

  Future<void> getWeddingAllCommentsSecondTime({
    required String weddingHeaderId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _eventCommentModel = null;
    final result = await _repo.getWeddingEventAllComments(
      weddingHeaderId: weddingHeaderId,
      token: token,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setEventCommentModel(r);
    });
  }

  Future<void> writeWeddingComment({
    required int weddingHeaderId,
    required String comment,
    int? parentComentId,
    required DateTime commentedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    WeddingEventWriteCommentPostModel model = WeddingEventWriteCommentPostModel(
      weddingHeaderId: weddingHeaderId,
      comment: comment,
      parentCommentId: parentComentId,
      commentedOn: commentedOn,
    );

    final result = await _repo.writeWeddingEventComment(
      eventWriteCommentPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> likeWeddingComment({
    required bool isUnLike,
    required int weddingCommentId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikeWeddingCommentPostModel model = LikeWeddingCommentPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      weddingCommentId: weddingCommentId,
    );

    final result = await _repo.likeWeddingComment(
      likeCommentPostmodel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> likeWeddingEvent({
    required bool isUnLike,
    required int weddingHeaderId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikeWeddingPostModel model = LikeWeddingPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      weddingHeaderId: weddingHeaderId,
    );

    final result = await _repo.likeWeddingEvent(
      likeEventPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> likeRitualPhoto({
    required bool isUnLike,
    required int weddingRitualPhotoId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikeRitualPhotoPostModel model = LikeRitualPhotoPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      weddingRitualPhotoId: weddingRitualPhotoId,
    );

    final result = await _repo.likeRitualPhoto(
      likeRitualPhotoPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> followUser({
    required String followerId,
    required int followStatus,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.followUser(
      followerId: followerId,
      followRequestStatus: followStatus,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint('followUser Error: ${l.message}');
    }, (r) {
      EasyLoading.dismiss();
      final personalEventCtr = ref.watch(homectr);
      personalEventCtr.getPopolarsAuthors(context, false);
      debugPrint('$r');
    });
  }

  WeddingLikeUsersModel? _weddingLikeUsersModel;
  WeddingLikeUsersModel? get weddingLikeUsersModel => _weddingLikeUsersModel;
  setWeddingLikeUsersModel(WeddingLikeUsersModel? model) {
    _weddingLikeUsersModel = model;
    notifyListeners();
  }

  Future<void> getAllWeddingLikedUsers({
    required String weddingHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _weddingLikeUsersModel = null;
    final result = await _repo.getAllWeddingLikes(
      weddingHeaderId: weddingHeaderId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      print('Wedding liked users: ${r.weddingLikeUsers?.length}');
      setWeddingLikeUsersModel(r);
    });
  }

  RitualPhotoUserLikesModel? _ritualPhotoUserLikesModel;
  RitualPhotoUserLikesModel? get ritualPhotoUserLikesModel => _ritualPhotoUserLikesModel;
  setRitualPhotoUserLikesModel(RitualPhotoUserLikesModel? model) {
    _ritualPhotoUserLikesModel = model;
    notifyListeners();
  }

  Future<void> getAllRitualPhotoLikes({
    required String weddingRitualPhotoId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _ritualPhotoUserLikesModel = null;
    final result = await _repo.getAllRitualPhotoLikes(
      weddingRitualPhotoId: weddingRitualPhotoId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setRitualPhotoUserLikesModel(r);
    });
  }

  RitualPhotoAllCommentsModel? _ritualPhotoAllCommentsModel;
  RitualPhotoAllCommentsModel? get ritualPhotoAllCommentsModel => _ritualPhotoAllCommentsModel;
  setRitualPhotoAllCommentsModel(RitualPhotoAllCommentsModel? model) {
    _ritualPhotoAllCommentsModel = model;
    notifyListeners();
  }

  Future<void> getRitualPhotoAllComments({
    required String weddingRitualPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _ritualPhotoAllCommentsModel = null;

    final result = await _repo.getRitualPhotoAllComments(
      weddingRitualPhotoId: weddingRitualPhotoId,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      print('RitualPhotoAllComments Lenght: ${r.comments?.length}');
      setRitualPhotoAllCommentsModel(r);
    });
  }

  Future<void> getRitualPhotoAllCommentsFirstTime({
    required String weddingRitualPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _ritualPhotoAllCommentsModel = null;
    // EasyLoading.show();
    final result = await _repo.getRitualPhotoAllComments(
      weddingRitualPhotoId: weddingRitualPhotoId,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

      // EasyLoading.dismiss();
    }, (r) {
      // EasyLoading.dismiss();
      setRitualPhotoAllCommentsModel(r);
    });
  }

  Future<void> writeRitualPhotoComment({
    required int weddingRitualPhotoId,
    required String comment,
    int? parentComentId,
    required DateTime commentedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    RitualPhotoCommentPostModel model = RitualPhotoCommentPostModel(
      weddingRitualPhotoId: weddingRitualPhotoId,
      comment: comment,
      parentCommentId: parentComentId,
      commentedOn: commentedOn,
    );

    final result = await _repo.writeRitualPhotoComment(
      ritualPhotoCommenPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> ritualPhotoCommentLike({
    required bool isUnLike,
    required int weddingRitualPhotoCommentId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    RitualPhotoCommenLikePostModel model = RitualPhotoCommenLikePostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      weddingRitualPhotoCommentId: weddingRitualPhotoCommentId,
    );

    final result = await _repo.ritualPhotoCommentLike(
      ritualPhotoCommenLikePostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  WeddingViewsModel? _weddingViewsModel;
  WeddingViewsModel? get weddingViewsModel => _weddingViewsModel;
  setWeddingViewsModel(WeddingViewsModel? model) {
    _weddingViewsModel = model;
    notifyListeners();
  }

  Future<void> getAllWeddingViews({
    required String weddingHeaderId,
    required WidgetRef ref,
  }) async {
    _weddingViewsModel = null;
    final result = await _repo.getAllWeddingViews(
      weddingHeaderId: weddingHeaderId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setWeddingViewsModel(r);
    });
  }

  Future<void> setWeddingView({
    required WeddingViewPostModel weddingViewPostModel,
    required WidgetRef ref,
  }) async {
    final result = await _repo.setWeddingView(
      weddingViewPostModel: weddingViewPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  clearData() {
    _eventCommentModel = null;
    _ritualPhotoUserLikesModel = null;
    _weddingLikeUsersModel = null;
    _weddingViewsModel = null;
    _homeWeddingDetails = null;
    notifyListeners();
  }
}
