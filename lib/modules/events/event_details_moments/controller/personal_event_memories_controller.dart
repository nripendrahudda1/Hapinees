import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/perosnal_event_post_all_comment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_create_memories_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_post_like_user_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_post_like_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_like_post.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_post_model.dart';
import 'package:Happinest/modules/events/event_details_moments/data/apis/personal_event_memories_apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_photo_model.dart';

final personalEventMemoriesController = ChangeNotifierProvider((ref) {
  final api = ref.watch(personalEventMemoriesApiController);
  return PersonalEventMemoriesControllerController(repo: api);
});

class PersonalEventMemoriesControllerController extends ChangeNotifier {
  final PersonalEventMemoriesDatasource _repo;

  PersonalEventMemoriesControllerController({required PersonalEventMemoriesDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  PersonalEventAllMomentsModel? _personalEventAllMemoriesModel;
  PersonalEventAllMomentsModel? get personalEventAllMemoriesModel => _personalEventAllMemoriesModel;

  setPersonalEventAllMemoriesModelModel(PersonalEventAllMomentsModel? model) {
    _personalEventAllMemoriesModel = model;
    _personalEventPosts = model?.personalEventPosts ?? [];
    _personalEventPosts = model?.personalEventPosts ?? [];
    notifyListeners();
  }
  // // Update Personal
  // updatePersonalEventAllMemoriesModelModel(PersonalEventAllMomentsModel? model) {
  //   _personalEventAllMemoriesModel = model;
  //   _personalEventPosts = model?.personalEventPosts ?? [];
  //   _personalEventPosts = model?.personalEventPosts ?? [];
  //   notifyListeners();
  // }

  List<PersonalEventPost> _personalEventPosts = [];
  List<PersonalEventPost> get personalEventPosts => _personalEventPosts;

  filteredMomentsPosts(bool isMyFeed /*String? momentName*/) {
    _personalEventPosts = [];
    if (isMyFeed) {
      print("filteredMomentsPosts $_personalEventPosts");
      _personalEventAllMemoriesModel?.personalEventPosts?.forEach((post) {
        // post.postMedias?.forEach((media) {
        //   if(media.ritualName == momentName){
        // _personalEventPosts.add(post);
        // }
        // });
        if (post.createdBy?.email.toString() == PreferenceUtils.getString(PreferenceKey.email)) {
          _personalEventPosts.add(post);
        }
      });
    } else {
      _personalEventPosts.addAll(_personalEventAllMemoriesModel?.personalEventPosts ?? []);
    }
    notifyListeners();
  }

  Future<void> getAllMemories({
    required String personalEventHeaderId,
    required String token,
    required int pageCount,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    print('personal event header id: $personalEventHeaderId');
    _personalEventAllMemoriesModel = null;
    _personalEventAllMemoriesModel?.personalEventPosts?.clear();
    EasyLoading.show();
    setLoading(true);
    final result = await _repo.getAllMemories(
        personalEventHeaderId: personalEventHeaderId, token: token, pageNumber: pageCount);
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      EasyLoading.dismiss();
      _isLoading = false;
      setPersonalEventAllMemoriesModelModel(r);
    });
    setLoading(false);
  }

  PersonalEventCreateMemoriesModel? _personalEventCreateMemoriesModel;
  PersonalEventCreateMemoriesModel? get personalEventCreateMemoriesModel =>
      _personalEventCreateMemoriesModel;
  setPersonalEventCreateMemoriesModel(PersonalEventCreateMemoriesModel? model) {
    _personalEventCreateMemoriesModel = model;
    notifyListeners();
  }

  Future<void> setPersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    String? mediaData,
    String? mediaExtension,
    List<String>? mediaDatas,
    List<String>? mediaExtensions,
    required bool isTextPost,
    required bool isSingleMediaPost,
    required bool isMultiMediaPost,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    setLoading(true);
    final result = await _repo.setPersonalEventMemoryPostText(
        token: token,
        personalEventCreateMemoriesTextPostModel: personalEventCreateMemoriesTextPostModel);
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      setPersonalEventCreateMemoriesModel(r);

      if (r.statusCode == 12 && r.responseStatus == false) {
        EasyLoading.showError(r.validationMessage ?? 'Not Created Post !!');
      }
      if (isTextPost) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          debugPrint('In Text post!');
          await Future.delayed(const Duration(seconds: 1));
          getAllMemories(
            personalEventHeaderId:
                personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
            token: token,
            pageCount: 0,
            ref: ref,
            context: context,
          );
          EasyLoading.dismiss();
        });
      } else if (isSingleMediaPost) {
        debugPrint('In Single media post!');
        PersonalEventCreateMemoriesPhotoPostModel mediaModel =
            PersonalEventCreateMemoriesPhotoPostModel(
                personalEventHeaderId:
                    personalEventCreateMemoriesTextPostModel.personalEventHeaderId,
                personalEventPostId: r.personalEventPostId,
                imageData: mediaData,
                imageExtension: mediaExtension,
                createdOn: DateTime.now());

        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await setPersonalEventPostMedia(
          ref: ref,
          context: context,
          token: token,
          personalEventCreateMemoriesPhotoPostModel: mediaModel,
        );
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            getAllMemories(
              personalEventHeaderId:
                  personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
              token: token,
              pageCount: 0,
              ref: ref,
              context: context,
            );
          },
        );

        EasyLoading.dismiss();
        // });
      } else if (isMultiMediaPost) {
        debugPrint('In Multi media post!');
        for (int index = 0; index < mediaDatas!.length; index++) {
          PersonalEventCreateMemoriesPhotoPostModel mediaModel =
              PersonalEventCreateMemoriesPhotoPostModel(
                  personalEventHeaderId:
                      personalEventCreateMemoriesTextPostModel.personalEventHeaderId,
                  personalEventPostId: r.personalEventPostId,
                  imageData: mediaDatas[index],
                  imageExtension: mediaExtensions![index],
                  createdOn: DateTime.now());
          await setPersonalEventPostMedia(
            ref: ref,
            token: token,
            context: context,
            personalEventCreateMemoriesPhotoPostModel: mediaModel,
          );
        }
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
        await Future.delayed(const Duration(seconds: 1));
        getAllMemories(
          personalEventHeaderId:
              personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
          token: token,
          pageCount: 0,
          ref: ref,
          context: context,
        );
        EasyLoading.dismiss();
        // });
      }
    });
    setLoading(false);
  }

// UpdatePersonalEventMemoryPostText

  Future<void> updatePersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    String? mediaData,
    String? mediaExtension,
    List<String>? mediaDatas,
    List<String>? mediaExtensions,
    required bool isTextPost,
    required bool isSingleMediaPost,
    required bool isMultiMediaPost,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    setLoading(true);
    final result = await _repo.updatePersonalEventMemoryPostText(
        token: token,
        personalEventCreateMemoriesTextPostModel: personalEventCreateMemoriesTextPostModel);
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) async {
      setPersonalEventCreateMemoriesModel(r);

      if (r.statusCode == 12 && r.responseStatus == false) {
        EasyLoading.showError(r.validationMessage ?? 'Not Created Post !!');
      }
      if (isTextPost) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          debugPrint('In Text post!');
          await Future.delayed(const Duration(seconds: 1));
          getAllMemories(
            personalEventHeaderId:
                personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
            token: token,
            pageCount: 0,
            ref: ref,
            context: context,
          );
          EasyLoading.dismiss();
        });
      } else if (isSingleMediaPost) {
        debugPrint('In Single media post!');
        PersonalEventCreateMemoriesPhotoPostModel mediaModel =
            PersonalEventCreateMemoriesPhotoPostModel(
                personalEventHeaderId:
                    personalEventCreateMemoriesTextPostModel.personalEventHeaderId,
                personalEventPostId: r.personalEventPostId,
                imageData: mediaData,
                imageExtension: mediaExtension,
                createdOn: DateTime.now());

        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await setPersonalEventPostMedia(
          ref: ref,
          context: context,
          token: token,
          personalEventCreateMemoriesPhotoPostModel: mediaModel,
        );
        await Future.delayed(
          const Duration(seconds: 1),
          () {
            getAllMemories(
              personalEventHeaderId:
                  personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
              token: token,
              pageCount: 0,
              ref: ref,
              context: context,
            );
          },
        );

        EasyLoading.dismiss();
        // });
      } else if (isMultiMediaPost) {
        debugPrint('In Multi media post!');
        for (int index = 0; index < mediaDatas!.length; index++) {
          PersonalEventCreateMemoriesPhotoPostModel mediaModel =
              PersonalEventCreateMemoriesPhotoPostModel(
                  personalEventHeaderId:
                      personalEventCreateMemoriesTextPostModel.personalEventHeaderId,
                  personalEventPostId: r.personalEventPostId,
                  imageData: mediaDatas[index],
                  imageExtension: mediaExtensions![index],
                  createdOn: DateTime.now());
          await setPersonalEventPostMedia(
            ref: ref,
            token: token,
            context: context,
            personalEventCreateMemoriesPhotoPostModel: mediaModel,
          );
        }
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
        await Future.delayed(const Duration(seconds: 1));
        getAllMemories(
          personalEventHeaderId:
              personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
          token: token,
          pageCount: 0,
          ref: ref,
          context: context,
        );
        EasyLoading.dismiss();
        // });
      }
    });
    setLoading(false);
  }

  Future<void> deletePersonalEventPostMedia({
    required DeletePersonalEventPostMomentPhotoModel personalEventCreateMemoriesTextPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.deletePersonalEventMemoryPostPhoto(
        token: token, deletePersonalEventPostPhotoModel: personalEventCreateMemoriesTextPostModel);
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      EasyLoading.dismiss();
      debugPrint(r.validationMessage);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        debugPrint('In Text post!');
        await Future.delayed(const Duration(seconds: 1));
        getAllMemories(
          personalEventHeaderId:
              personalEventCreateMemoriesTextPostModel.personalEventHeaderId.toString(),
          token: token,
          pageCount: 0,
          ref: ref,
          context: context,
        );
        EasyLoading.dismiss();
      });
    });
  }

  Future<void> setPersonalEventPostMedia({
    required PersonalEventCreateMemoriesPhotoPostModel personalEventCreateMemoriesPhotoPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setPersonalEventMemoryPostPhoto(
        token: token,
        personalEventCreateMemoriesPhotoPostModel: personalEventCreateMemoriesPhotoPostModel);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> likeMemoryPost({
    required PersonalEventSetLikePostModel personalEventSetLikePostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setMemoryPostLike(
      personalEventSetLikePostModel: personalEventSetLikePostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  PersonalEventPostLikesUsersModel? _postLikesUserModel;
  PersonalEventPostLikesUsersModel? get postLikesUserModel => _postLikesUserModel;
  setPostLikesUserModel(PersonalEventPostLikesUsersModel? model) {
    _postLikesUserModel = model;
    notifyListeners();
  }

  Future<PersonalEventPostLikesUsersModel?> getMemoryPostLikes({
    required String personalEventPostId,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    // EasyLoading.show();
    final result = await _repo.getMemoryPostLikes(
      personalEventPostId: personalEventPostId,
      token: token,
    );
    result.fold((l) {
      // EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
      setPostLikesUserModel(r);
      // EasyLoading.dismiss();
      return r;
    });
    return _postLikesUserModel;
    // EasyLoading.dismiss();
  }

  PersonalEventPostAllCommentsModel? _postAllCommentsModel;
  PersonalEventPostAllCommentsModel? get postAllCommentsModel => _postAllCommentsModel;
  setPostAllCommentsModel(PersonalEventPostAllCommentsModel? model) {
    _postAllCommentsModel = model;
    notifyListeners();
  }

  Future<void> getMemoryPostAllCommentsFirstTime({
    required String personalEventPostId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.getMemoryPostAllComments(
      personalEventPostId: personalEventPostId,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

      EasyLoading.dismiss();
    }, (r) {
      EasyLoading.dismiss();
      setPostAllCommentsModel(r);
    });
  }

  Future<PersonalEventPostAllCommentsModel?> getMemoryPostAllComments({
    required String personalEventPostId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.getMemoryPostAllComments(
      personalEventPostId: personalEventPostId,
      noOfRecords: noOfRecords,
      offset: offset,
      sortByPopular: sortByPopular,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);

      EasyLoading.dismiss();
    }, (r) {
      setPostAllCommentsModel(r);
      return r;
    });
    return _postAllCommentsModel;
  }

  Future<void> deletePost({
    required DeletePersonalEventPostModel deletePersonalEventPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.deletePost(
      deletePersonalEventPostModel: deletePersonalEventPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> setPostCommentPostLike({
    required PersonalEventSetPostCommentLikeModel personalEventSetPostCommentLikeModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setPostCommentPostLike(
      personalEventSetPostCommentLikeModel: personalEventSetPostCommentLikeModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }

  Future<void> setPostComment({
    required PersonalEventPostCommentPostModel personalEventPostCommentPostModel,
    required WidgetRef ref,
    required BuildContext context,
    required String token,
  }) async {
    final result = await _repo.setPostComment(
      personalEventPostCommentPostModel: personalEventPostCommentPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }
}
