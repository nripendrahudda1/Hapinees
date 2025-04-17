import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/occasion_create_post_moment_response_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/occasion_event_all_moment_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_all_comments_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_likes_users_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_create_post_moment_post_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_like_post_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_comment_like_post_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_comment_post_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_for_ritual_post_model.dart';
import '../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_post_model.dart';
import '../data/apis/occasion_event_memories_apis.dart';

final occasionEventMemoriesController = ChangeNotifierProvider((ref) {
  final api = ref.watch(occasionEventMemoriesApiController);
  return OccasionEventMemoriesControllerController(repo: api);
});

class OccasionEventMemoriesControllerController extends ChangeNotifier {
  final OccasionEventMemoriesDatasource _repo;
  OccasionEventMemoriesControllerController({required OccasionEventMemoriesDatasource repo})
      : _repo = repo,
        super();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  OccasionEventAllMomentsModel? _eventAllMemoriesModel;
  OccasionEventAllMomentsModel? get eventAllMemoriesModel => _eventAllMemoriesModel;
  setEventAllMemoriesModelModel(OccasionEventAllMomentsModel? model) {
    _eventAllMemoriesModel = model;
    notifyListeners();
  }

  List<Post> _posts = [];
  List<Post> get posts => _posts;

  filteredMomentsPosts(String? momentName){
    _posts = [];
    _eventAllMemoriesModel?.posts?.forEach((post) {
      post.postMedias?.forEach((media) {
        if(media.ritualName == momentName){
          _posts.add(post);
        }
      });
    });
  }

  Future<void> getAllMemories({
    required String weddingHeaderId,
    required String eventTypeMasterId,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    print('wedding header id: $weddingHeaderId');
    print('eventTypeMasterId: $eventTypeMasterId');
    // _eventAllMemoriesModel = null;
    EasyLoading.show();
    setLoading(true);

    final result = await _repo.getAllMemories(
      weddingHeaderId: weddingHeaderId,
      eventTypeMasterId: eventTypeMasterId,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      EasyLoading.dismiss();
      _isLoading = false;
      setEventAllMemoriesModelModel(r);
    });
    setLoading(false);
  }

  OccasionCreatePostMemoryResponseModel? _createEventMemoryResponseModel;
  OccasionCreatePostMemoryResponseModel? get createEventMemoryResponseModel =>
      _createEventMemoryResponseModel;
  setCreateEventMemoryResponseModel(OccasionCreatePostMemoryResponseModel? model) {
    _createEventMemoryResponseModel = model;
    notifyListeners();
  }

  Future<void> writeEventMemoryPost({
    required OccasionCreatePostMemoryPostModel createEventMemoryPostModel,
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

    final result = await _repo.writeEventMemoryPost(
        token: token, createEventMemoryPostModel: createEventMemoryPostModel);
    result.fold((l) {
      EasyLoading.dismiss();
      setLoading(false);
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async {
      setCreateEventMemoryResponseModel(r);
      if (isTextPost) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
          debugPrint('In Text post!');
          await Future.delayed(const Duration(seconds: 1));
          getAllMemories(
            weddingHeaderId: createEventMemoryPostModel.occasionId.toString(),
            token: token,
            eventTypeMasterId:
                createEventMemoryPostModel.eventTypeMasterId.toString(),
            ref: ref,
            context: context,
          );
          EasyLoading.dismiss();
        });
      } else if (isSingleMediaPost) {
        debugPrint('In Single media post!');
        OccasionSetPostMediaPostModel mediaModel =
            OccasionSetPostMediaPostModel(
                occasionPostId: r.occasionPostId,
                mediaData: mediaData,
                mediaExtention: mediaExtension,
                createdOn: DateTime.now());

        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          await setOccasionPostMedia(
            ref: ref,
            context: context,
            token: token,
            memoryPostMediaPostModel: mediaModel,
          );
          await Future.delayed(const Duration(seconds: 1), () {
            getAllMemories(
              weddingHeaderId: createEventMemoryPostModel.occasionId.toString(),
              token: token,
              eventTypeMasterId:
              createEventMemoryPostModel.eventTypeMasterId.toString(),
              ref: ref,
              context: context,
            );
          },);

          EasyLoading.dismiss();
        // });
      } else if (isMultiMediaPost) {
        debugPrint('In Multi media post!');
        for (int index = 0; index < mediaDatas!.length; index++) {
          OccasionSetPostMediaPostModel mediaModel =
              OccasionSetPostMediaPostModel(
                  occasionPostId: r.occasionPostId,
                  mediaData: mediaDatas[index],
                  mediaExtention: mediaExtensions![index],
                  createdOn: DateTime.now());
          await setOccasionPostMedia(
            ref: ref,
            token: token,
            context: context,
            memoryPostMediaPostModel: mediaModel,
          );
        }
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
          await Future.delayed(const Duration(seconds: 1));
          getAllMemories(
              weddingHeaderId: createEventMemoryPostModel.occasionId.toString(),
            token: token,
          eventTypeMasterId:
          createEventMemoryPostModel.eventTypeMasterId.toString(),
          ref: ref,
          context: context,
          );
          EasyLoading.dismiss();
        // });
      }
    });
    setLoading(false);
  }

  Future<void> setOccasionPostMedia({
    required OccasionSetPostMediaPostModel memoryPostMediaPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setOccasionPostMedia(
        token: token, memoryPostMediaPostModel: memoryPostMediaPostModel);
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }



Future<void> setPostComment({
  required OccasionSetPostCommentPostModel setPostCommentPostModel,
  required WidgetRef ref,
  required BuildContext context,
  required String token,
  }) async {

    final result = await _repo.setPostComment(
      setPostCommentPostModel: setPostCommentPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      debugPrint(r.validationMessage);

    });
  }




  OccasionPostLikesUsersModel? _postLikesUserModel;
  OccasionPostLikesUsersModel? get postLikesUserModel =>
      _postLikesUserModel;
  setPostLikesUserModel(OccasionPostLikesUsersModel? model) {
    _postLikesUserModel = model;
    notifyListeners();
  }



  Future<OccasionPostLikesUsersModel?> getMemoryPostLikes({
    required String postId,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    // EasyLoading.show();
    final result = await _repo.getMemoryPostLikes(
      postId: postId,
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


  Future<void> likeMemoryPost({
    required OccasionSetLikePostModel likeWeddingPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {

    final result = await _repo.likeMemoryPost(
      likeWeddingPostModel: likeWeddingPostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      debugPrint(r.validationMessage);
    });
  }


  OccasionPostAllCommentsModel? _postAllCommentsModel;
  OccasionPostAllCommentsModel? get postAllCommentsModel =>
      _postAllCommentsModel;
  setPostAllCommentsModel(OccasionPostAllCommentsModel? model) {
    _postAllCommentsModel = model;
    notifyListeners();
  }


  Future<void> getMemoryPostAllCommentsFirstTime({
    required String postId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    EasyLoading.show();
    final result = await _repo.getMemoryPostAllComments(
      postId: postId,
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

  Future<OccasionPostAllCommentsModel?> getMemoryPostAllComments({
    required String postId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.getMemoryPostAllComments(
      postId: postId,
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




  Future<void> setPostCommentPostLike({
    required OccasionSetPostCommentLikePostModel setPostCommentLikePostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.setPostCommentPostLike(
      setPostCommentLikePostModel: setPostCommentLikePostModel,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      debugPrint(r.validationMessage);
    });

  }


  Future<void> deletePost({
    required String postId,
    required String token,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    final result = await _repo.deletePost(
      postId: postId,
      token: token,
    );
    result.fold((l) {
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) {
      debugPrint(r.validationMessage);
    });

  }

  Future<void> setPostRitualMediaPost({
    required OccasionSetPostMediaForRitualPostModel ritualMediaPostModel,
    required String token,
    required WidgetRef ref,
    required BuildContext context,

  })async {
    EasyLoading.show();
    final result = await _repo.setPostRitualMediaPost(
      ritualMediaPostModel: ritualMediaPostModel,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async{
      debugPrint(r.validationMessage);
      await getAllMemories(
          weddingHeaderId: ritualMediaPostModel.weddingHeaderId.toString(),
          eventTypeMasterId: 1.toString(),
          token: token,
          ref: ref,
          context: context
      );
      EasyLoading.dismiss();
    });

  }


  Future<void> removePostRitualMediaPost({
    required String weddingHeaderId,
    required String postMediaId,
    required String token,
    required WidgetRef ref,
    required BuildContext context,

  })async {
    EasyLoading.show();
    final result = await _repo.removePostRitualMediaPost(
      postMediaId: postMediaId,
      token: token,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      debugPrintStack(stackTrace: l.stackTrace);
      debugPrint(l.message);
      
    }, (r) async{
      debugPrint(r.validationMessage);
      await getAllMemories(
          weddingHeaderId: weddingHeaderId.toString(),
          eventTypeMasterId: 1.toString(),
          token: token,
          ref: ref,
          context: context
      );
      EasyLoading.dismiss();
    });

  }

}
