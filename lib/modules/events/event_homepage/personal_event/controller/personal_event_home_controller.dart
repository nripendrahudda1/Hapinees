import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/common_model/general_response_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/activity_photo_all_comments_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/activity_photo_like_user_models.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/activity_photo_comment_like_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/activity_photo_comment_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/like_activity_photo_post_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_comment_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_like_users_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_views_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_write_comment_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/like_personal_event_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/personal_event_comment_like_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/personal_event_view_post_model.dart';
import '../../../../../models/create_event_models/home/home_personal_event_details_model.dart';
import '../data/apis/personal_event_home_apis.dart';

final personalEventHomeController = ChangeNotifierProvider((ref) {
  final api = ref.watch(personalEventHomeApiController);
  return PersonalEventHomeController(repo: api);
});

class PersonalEventHomeController extends ChangeNotifier {
  final PersonalEventHomeDatasource _repo;
  PersonalEventHomeController({required PersonalEventHomeDatasource repo})
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

  HomePersonalEventDetailsModel? _homePersonalEventDetailsModel;
  HomePersonalEventDetailsModel? get homePersonalEventDetailsModel =>
      _homePersonalEventDetailsModel;
  setHomePersonalEventDetailsModel(HomePersonalEventDetailsModel? model) {
    _homePersonalEventDetailsModel = model;
    notifyListeners();
  }

  setHomePersonalEventActivityModel(List<PersonalEventActivityList>? model) {
    _homePersonalEventDetailsModel?.personalEventActivityList = model;
    notifyListeners();
  }

  setHomePersonalEventInviteModel(List<PersonalEventInviteList>? model) {
    _homePersonalEventDetailsModel?.personalEventInviteList = model;
    notifyListeners();
  }

  getContributorUserRole({required HomePersonalEventDetailsModel model}) {
    if (model.contributor == 1) {
      setContributorRole(uenum: ContributorType.public);
      return;
    } else if (model.contributor == 2) {
      setContributorRole(uenum: ContributorType.private);
      return;
    } else if (model.contributor == 3) {
      setContributorRole(uenum: ContributorType.guest);
      return;
    } else {
      setContributorRole(uenum: ContributorType.none);
    }
  }

  Future<void> getEvents({
    required String eventId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    print("tapperd getEvent");
    EasyLoading.show();
    final result = await _repo.fetchHomePersonalEventsDetailsModel(
        personalEventHeaderId: eventId, token: token);
    result.fold(
      (l) {
        setHomeLoading(false);
        EasyLoading.showError('${l.message}', duration: const Duration(seconds: 6));
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        EasyLoading.dismiss();
      },
      (r) async {
        if (r.responseStatus == false) {
          EasyLoading.showError(r.validationMessage ?? '');
        } else {
          print('response ^^^^^^^^^^^^^^^^^^^^^^^^^ ${r.createdBy?.email}');
          print('personalEventInviteId ^^^^^^^^^^^^^^^^^^^^^^^^^ ${r.personalEventInviteId}');
          await setHomePersonalEventDetailsModel(r);
          await getContributorUserRole(model: r);
          await getEventUserRole(model: r);
        }
        EasyLoading.dismiss();
        setHomeLoading(false);
        notifyListeners();
      },
    );
    setHomeLoading(false);
    EasyLoading.dismiss();
  }

  GeneralResponseModel? _genralModelResponse;
  GeneralResponseModel? get genralModelResponse => _genralModelResponse;
  setgenralModelResponseModel(GeneralResponseModel? model) {
    _genralModelResponse = model;
    notifyListeners();
  }

// Update Invite status for Personal Invite
  Future<void> updatePersonalEventStatus({
    required String personalEventInviteId,
    required int inviteStatus,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    print("tapperd getEvent");
    EasyLoading.show();
    final result = await _repo.updatePersonalEventInviteStatus(
        personalEventHeaderId: personalEventInviteId, token: token, inviteStatus: inviteStatus);
    result.fold(
      (l) {
        // setHomeLoading(false);
        EasyLoading.showError('${l.message}', duration: const Duration(seconds: 6));
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        EasyLoading.dismiss();
      },
      (r) async {
        if (r.responseStatus == false) {
          EasyLoading.showSuccess(r.validationMessage ?? '');
        } else {
          // await setHomePersonalEventDetailsModel(r);
          // await getEventUserRole(model: r);
        }
        EasyLoading.dismiss();
        setgenralModelResponseModel(r);
        EasyLoading.showSuccess(r.validationMessage ?? '');
        // final personalEventCtr =
        //     ref.read(personalEventHomeController).homePersonalEventDetailsModel;
        // await ref.read(personalEventHomeController).getEvents(
        //     eventId: (personalEventCtr?.personalEventHeaderId ?? 0).toString(),
        //     context: context,
        //     ref: ref);
        // await ref.read(personalEventGuestInviteController).getPersonalEventInvites(
        //     eventHeaderId: (personalEventCtr?.personalEventHeaderId ?? 0).toString(),
        //     ref: ref,
        //     isLoaderShow: true,
        //     context: context);

        setHomeLoading(false);
        notifyListeners();
      },
    );
    // setHomeLoading(false);
    EasyLoading.dismiss();
  }

  getEventUserRole({required HomePersonalEventDetailsModel model}) {
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

    for (var invitedUser in model.personalEventInviteList ?? []) {
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

  UserRoleEnum _userRoleEnum = UserRoleEnum.Host;
  UserRoleEnum get userRoleEnum => _userRoleEnum;
  setUserRole({required UserRoleEnum uenum}) {
    _userRoleEnum = uenum;
    notifyListeners();
  }

  ContributorType _contributorRoleEnum = ContributorType.public;
  ContributorType get contributorRoleEnum => _contributorRoleEnum;
  setContributorRole({required ContributorType uenum}) {
    _contributorRoleEnum = uenum;
    notifyListeners();
  }

  PersonalEventCommentModel? _personalEventCommentModel;
  PersonalEventCommentModel? get personalEventCommentModel => _personalEventCommentModel;
  setPersonalEventCommentModel(PersonalEventCommentModel? model) {
    _personalEventCommentModel = model;
    notifyListeners();
  }

  Future<void> getAllPersonalEventComments({
    required String personalEventHeaderId,
    required bool shortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _personalEventCommentModel = null;
    EasyLoading.show();
    setLoading(true);

    final result = await _repo.getPersonalEventAllComments(
      personalEventHeaderId: personalEventHeaderId,
      token: token,
      noOfRecords: noOfRecords,
      offset: offset,
      shortByPopular: shortByPopular,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setPersonalEventCommentModel(r);
      EasyLoading.dismiss();
      _isLoading = false;
    });
    setLoading(false);
  }

  Future<void> getPersonalEventAllCommentsSecondTime({
    required String personalEventHeaderId,
    required bool shortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _personalEventCommentModel = null;
    final result = await _repo.getPersonalEventAllComments(
      personalEventHeaderId: personalEventHeaderId,
      token: token,
      noOfRecords: noOfRecords,
      offset: offset,
      shortByPopular: shortByPopular,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setPersonalEventCommentModel(r);
    });
  }

  Future<void> writePersonalEventComment({
    required int personalEventHeaderId,
    required String comment,
    int? parentCommentId,
    required DateTime commentedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    PersonalEventWriteCommentPostModel model = PersonalEventWriteCommentPostModel(
      personalEventHeaderId: personalEventHeaderId,
      comment: comment,
      parentCommentId: parentCommentId,
      commentedOn: commentedOn,
    );

    final result = await _repo.writePersonalEventComment(
      eventWriteCommentPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
    notifyListeners();
  }

  Future<void> likePersonalEventComment({
    required bool isUnLike,
    required int personalEventCommentId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikePersonalEventCommentPostModel model = LikePersonalEventCommentPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      personalEventCommentId: personalEventCommentId,
    );

    final result = await _repo.likePersonalEventComment(
      likeCommentPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
    notifyListeners();
  }

  Future<void> likePersonalEvent({
    required bool isUnLike,
    required int personalEventHeaderId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikePersonalEventPostModel model = LikePersonalEventPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      personalEventHeaderId: personalEventHeaderId,
    );

    final result = await _repo.likePersonalEvent(
      likeEventPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
    notifyListeners();
  }

  PersonalEventLikeUsersModel? _personalEventLikeUsersModel;
  PersonalEventLikeUsersModel? get personalEventLikeUsersModel => _personalEventLikeUsersModel;
  setPersonalEventLikeUsersModel(PersonalEventLikeUsersModel? model) {
    _personalEventLikeUsersModel = model;
    notifyListeners();
  }

  Future<void> getAllPersonalEventLikedUsers({
    required String eventHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _personalEventLikeUsersModel = null;
    final result = await _repo.getAllPersonalEventLikes(eventHeaderId: eventHeaderId, token: token);

    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      print('Personal Event liked users: ${r.personalEventLikeUsers?.length}');
      setPersonalEventLikeUsersModel(r);
    });
    notifyListeners();
  }

  PersonalEventViewsModel? _personalEventViewsModel;
  PersonalEventViewsModel? get personalEventViewsModel => _personalEventViewsModel;
  setPersonalEventViewsModel(PersonalEventViewsModel? model) {
    _personalEventViewsModel = model;
    notifyListeners();
  }

  Future<void> getAllPersonalEventViews({
    required String personalEventHeaderId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _personalEventViewsModel = null;
    final result = await _repo.getAllPersonalEventViews(
      personalEventHeaderId: personalEventHeaderId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setPersonalEventViewsModel(r);
    });
    notifyListeners();
  }

  Future<void> setPersonalEventView({
    required PersonalEventViewPostModel personalEventViewPostModel,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setPersonalEventView(
      personalEventViewPostModel: personalEventViewPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
    notifyListeners();
  }

  // ###################--------------- personal event activity apis -----------######################

  Future<void> getEventActivity({
    required String eventId,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    print("tapperd getEventActivity \n $eventId \n $token");
    EasyLoading.show();
    final result =
        await _repo.fetchPersonalEventActivitiesModel(personalEventHeaderId: eventId, token: token);
    result.fold(
      (l) {
        setHomeLoading(false);
        EasyLoading.showError('${l.message}', duration: const Duration(seconds: 6));
        debugPrintStack(stackTrace: l.stackTrace);
        debugPrint(l.message);
        EasyLoading.dismiss();
      },
      (r) async {
        print('response ^^^^^^^^^^^^^^^^^^^^^^^^^ ${r}');
        await setHomePersonalEventActivityModel(r.personalEventActivityList);
        EasyLoading.dismiss();
        setHomeLoading(false);
        notifyListeners();
      },
    );
    setHomeLoading(false);
    EasyLoading.dismiss();
  }

  Future<void> likeActivityPhoto({
    required bool isUnLike,
    required int personalEventActivityPhotoId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    LikeActivityPhotoPostModel model = LikeActivityPhotoPostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      personalEventActivityPhotoId: personalEventActivityPhotoId,
    );

    final result = await _repo.likeActivityPhoto(
      likeActivityPhotoPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  ActivityPhotoLikeUserModel? _activityPhotoUserLikesModel;
  ActivityPhotoLikeUserModel? get activityPhotoUserLikesModel => _activityPhotoUserLikesModel;
  setActivityPhotoUserLikesModel(ActivityPhotoLikeUserModel? model) {
    _activityPhotoUserLikesModel = model;
    notifyListeners();
  }

  Future<void> getAllActivityPhotoLikes({
    required String personalEventActivityPhotoId,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _activityPhotoUserLikesModel = null;
    final result = await _repo.getAllActivityPhotoLikes(
      personalEventActivityPhotoId: personalEventActivityPhotoId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      setActivityPhotoUserLikesModel(r);
    });
  }

  /*Future<void> writeActivityPhotoComment({
    required int personalEventActivityPhotoId,
    required String comment,
    int? parentCommentId,
    required DateTime commentedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    print("writeActivityPhotoComment ********* ");
    ActivityPhotoCommentPostModel model = ActivityPhotoCommentPostModel(
      personalEventActivityPhotoId: personalEventActivityPhotoId,
      comment: comment,
      parentCommentId: parentCommentId ?? 0,
      commentedOn: commentedOn,
    );
    print(activityPhotoCommentPostModelToJson(model));
    final result = await _repo.writeActivityPhotoComment(
      activityPhotoCommentPostModel: model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  ActivityPhotoAllCommentsModel? _activityPhotoAllCommentsModel;
  ActivityPhotoAllCommentsModel? get activityPhotoAllCommentsModel => _activityPhotoAllCommentsModel;
  setActivityPhotoAllCommentsModel(ActivityPhotoAllCommentsModel? model) {
    _activityPhotoAllCommentsModel = model;
    notifyListeners();
  }

  Future<void> getActivityPhotoAllComments({
    required String personalEventActivityPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _activityPhotoAllCommentsModel = null;

    final result = await _repo.getActivityPhotoAllComments(
      personalEventActivityPhotoId: personalEventActivityPhotoId,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) {
      print('activity photo all comment Lenght: ${r.comments?.length}');
      setActivityPhotoAllCommentsModel(r);
    });
  }


  Future<void> getActivityPhotoAllCommentsFirstTime({
    required String personalEventActivityPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    _activityPhotoAllCommentsModel = null;
    // EasyLoading.show();
    final result = await _repo.getActivityPhotoAllComments(
      personalEventActivityPhotoId: personalEventActivityPhotoId,
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
      setActivityPhotoAllCommentsModel(r);
    });
  }


  Future<void> activityPhotoCommentLike({
    required bool isUnLike,
    required int personalEventPhotoCommentId,
    required DateTime likedOn,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    ActivityPhotoCommentLikePostModel model = ActivityPhotoCommentLikePostModel(
      isUnLike: isUnLike,
      likedOn: likedOn,
      personalEventActivityPhotoCommentId: personalEventPhotoCommentId,
    );

    final result = await _repo.activityPhotoCommentLike(
      activityPhotoCommentLikePostModel:  model,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

    }, (r) {
      debugPrint(r.validationMessage);
    });
  }*/

  clearData() {
    _personalEventViewsModel = null;
    _personalEventCommentModel = null;
    _personalEventLikeUsersModel = null;
    _homePersonalEventDetailsModel = null;
    notifyListeners();
  }
}
