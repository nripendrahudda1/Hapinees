import 'package:flutter/cupertino.dart';
import 'package:Happinest/common/common_model/general_response_model.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/occasion_create_post_moment_response_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/occasion_event_all_moment_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_all_comments_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/occasion_post_likes_users_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_create_post_moment_post_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_like_post_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_comment_like_post_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_comment_post_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_for_ritual_post_model.dart';
import '../../../../../models/create_event_models/moments/occasion_event_moments/post_models/occasion_set_post_media_post_model.dart';

final occasionEventMemoriesApiController = Provider<OccasionEventMemoriesDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OccasionEventMemoriesImplements(dioClient: dioClient);
});


abstract class OccasionEventMemoriesDatasource {

  FutureEither<OccasionEventAllMomentsModel>  getAllMemories({
    required String eventTypeMasterId,
    required String weddingHeaderId,
    required String token,
  });


  FutureEither<OccasionCreatePostMemoryResponseModel>   writeEventMemoryPost({
    required OccasionCreatePostMemoryPostModel createEventMemoryPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> setOccasionPostMedia({
    required OccasionSetPostMediaPostModel memoryPostMediaPostModel,
    required String token,
  });

  FutureEither<OccasionPostLikesUsersModel>  getMemoryPostLikes({
    required String postId,
    required String token,
  });

  FutureEither<GeneralResponseModel>   likeMemoryPost({
    required OccasionSetLikePostModel likeWeddingPostModel,
    required String token,
  });

  FutureEither<OccasionPostAllCommentsModel>   getMemoryPostAllComments({
    required String postId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<GeneralResponseModel>   setPostComment({
    required OccasionSetPostCommentPostModel setPostCommentPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel>   setPostCommentPostLike({
    required OccasionSetPostCommentLikePostModel setPostCommentLikePostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel>   deletePost({
    required String postId,
    required String token,
  });

  FutureEither<GeneralResponseModel>   setPostRitualMediaPost({
    required OccasionSetPostMediaForRitualPostModel ritualMediaPostModel,
    required String token,
  });


  FutureEither<GeneralResponseModel>   removePostRitualMediaPost({
    required String postMediaId,
    required String token,
  });


}

class OccasionEventMemoriesImplements implements OccasionEventMemoriesDatasource{
  final DioClient dioClient;
  OccasionEventMemoriesImplements({required this.dioClient});

  @override
  FutureEither<OccasionEventAllMomentsModel>  getAllMemories({
    required String eventTypeMasterId,
    required String weddingHeaderId,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.occasion}$eventTypeMasterId/$weddingHeaderId/${ApiUrl.getOccasionPost}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 20),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
      );
      print("response ------------------ getAllMemories \n$response");
      return Right(OccasionEventAllMomentsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<OccasionCreatePostMemoryResponseModel>   writeEventMemoryPost({
    required OccasionCreatePostMemoryPostModel createEventMemoryPostModel,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setOccasionPost}';
      print("API Calling ${url} --> ${occasionCreatePostMemoryPostModelToJson(createEventMemoryPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionCreatePostMemoryPostModelToJson(createEventMemoryPostModel)
      );
      print("response ------------------ writeEventMemoryPost \n$response");
      return Right(OccasionCreatePostMemoryResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel> setOccasionPostMedia({
    required OccasionSetPostMediaPostModel memoryPostMediaPostModel,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setOccasionPostMedia}';
      print("API Calling ${url} --> ${occasionSetPostMediaPostModelToJson(memoryPostMediaPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionSetPostMediaPostModelToJson(memoryPostMediaPostModel)
      );
      print("response ------------------ setOccasionPostMedia \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<OccasionPostLikesUsersModel>  getMemoryPostLikes({
    required String postId,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.occasion}$postId/${ApiUrl.getOccasionPostLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(
              authToken: "Bearer $token",
              contentType: ApiUrl.contentTypeHeader
          ),
        ),
      );
      print("response ------------------ getMemoryPostLikes \n$response");
      return Right(OccasionPostLikesUsersModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>   likeMemoryPost({
    required OccasionSetLikePostModel likeWeddingPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setOccasionPostLike}';
      print("API Calling ${url} --> ${occasionSetLikePostModelToJson(likeWeddingPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionSetLikePostModelToJson(likeWeddingPostModel)
      );
      print("response ------------------ likeMemoryPost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }




  @override
  FutureEither<OccasionPostAllCommentsModel>   getMemoryPostAllComments({
    required String postId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.occasion}$postId/$sortByPopular/${ApiUrl.getOccasionPostComment}?offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(
              authToken: "Bearer $token",
              contentType: ApiUrl.contentTypeHeader
          ),
        ),
      );
      print("response ------------------ getMemoryPostAllComments \n$response");
      return Right(OccasionPostAllCommentsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel>   setPostComment({
    required OccasionSetPostCommentPostModel setPostCommentPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setOccasionPostComment}';
      print("API Calling ${url} --> ${occasionSetPostCommentPostModelToJson(setPostCommentPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionSetPostCommentPostModelToJson(setPostCommentPostModel)
      );
      print("response ------------------ setPostComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel>   setPostCommentPostLike({
    required OccasionSetPostCommentLikePostModel setPostCommentLikePostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setOccasionPostCommentLike}';
      print("API Calling ${url} --> ${occasionSetPostCommentLikePostModelToJson(setPostCommentLikePostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionSetPostCommentLikePostModelToJson(setPostCommentLikePostModel)
      );
      print("response ------------------ setPostCommentPostLike \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>   deletePost({
    required String postId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.occasion}$postId/${ApiUrl.deleteOccasionPost}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
      );
      print("response ------------------ deletePost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel>   setPostRitualMediaPost({
    required OccasionSetPostMediaForRitualPostModel ritualMediaPostModel,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setPostMediaForRitual}';
      print("API Calling ${url} --> ${occasionSetPostMediaForRitualPostModelToJson(ritualMediaPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: occasionSetPostMediaForRitualPostModelToJson(ritualMediaPostModel)
      );
      print("response ------------------ setPostRitualMediaPost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>   removePostRitualMediaPost({
    required String postMediaId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.occasion}$postMediaId/${ApiUrl.removePostMediaForRitual}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          // data: setPostRitualMediaPostModelToJson(ritualMediaPostModel)
      );
      print("response ------------------ removePostRitualMediaPost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

}