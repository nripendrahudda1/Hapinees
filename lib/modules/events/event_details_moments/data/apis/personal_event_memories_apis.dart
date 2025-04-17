import 'package:Happinest/common/common_model/general_response_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/perosnal_event_post_all_comment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_create_memories_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_post_like_user_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_post_set_comment_response_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_post_like_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_like_post.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/personal_event_set_post_comment_post_model.dart';
import 'package:Happinest/models/create_event_models/moments/personal_event_moments/post_model/delete_personal_event_post_post_photo_model.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';

final personalEventMemoriesApiController = Provider<PersonalEventMemoriesDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PersonalEventMemoriesImplements(dioClient: dioClient);
});

abstract class PersonalEventMemoriesDatasource {
  FutureEither<PersonalEventAllMomentsModel> getAllMemories({
    required String personalEventHeaderId,
    required String token,
    required int pageNumber,
  });

  FutureEither<PersonalEventCreateMemoriesModel> setPersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    required String token,
  });

  // Update PersonalEventMemoryPostText
  FutureEither<PersonalEventCreateMemoriesModel> updatePersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    required String token,
  });

// Delete PersonalEventMemoryPostPhoto
  FutureEither<GeneralResponseModel> deletePersonalEventMemoryPostPhoto({
    required DeletePersonalEventPostMomentPhotoModel deletePersonalEventPostPhotoModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> setPersonalEventMemoryPostPhoto({
    required PersonalEventCreateMemoriesPhotoPostModel personalEventCreateMemoriesPhotoPostModel,
    required String token,
  });

  FutureEither<PersonalEventPostLikesUsersModel> getMemoryPostLikes({
    required String personalEventPostId,
    required String token,
  });

  FutureEither<GeneralResponseModel> setMemoryPostLike({
    required PersonalEventSetLikePostModel personalEventSetLikePostModel,
    required String token,
  });

  FutureEither<PersonalEventPostAllCommentsModel> getMemoryPostAllComments({
    required String personalEventPostId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<PersonalEventPostSetCommentModel> setPostComment({
    required PersonalEventPostCommentPostModel personalEventPostCommentPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> setPostCommentPostLike({
    required PersonalEventSetPostCommentLikeModel personalEventSetPostCommentLikeModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> deletePost({
    required DeletePersonalEventPostModel deletePersonalEventPostModel,
    required String token,
  });
}

class PersonalEventMemoriesImplements implements PersonalEventMemoriesDatasource {
  final DioClient dioClient;

  PersonalEventMemoriesImplements({required this.dioClient});

  @override
  FutureEither<PersonalEventAllMomentsModel> getAllMemories(
      {required String personalEventHeaderId,
      required String token,
      required int pageNumber}) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/20/$pageNumber/${ApiUrl.getPersonalEventPosts}';
      print("API Calling ${url} --> Null");

      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 20),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );

      print("response ------------------ getAllMemories \n$response");
      return Right(PersonalEventAllMomentsModel.fromJson(response));
    } on DioException catch (error) {
      if (error.response?.statusCode == 404 ||
          error.response?.statusCode == 400 ||
          error.response?.statusCode == 500) {
        debugPrint("Error 400: Returning empty data");
        return Right(PersonalEventAllMomentsModel()); // ✅ Return an empty model instead of failure
      }
      return Left(Failure(ErrorHandler.handle(error).failure, error.stackTrace));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventCreateMemoriesModel> setPersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventPost}';
      print(
          "API Calling ${url} --> ${personalEventCreateMemoriesTextPostModelToJson(personalEventCreateMemoriesTextPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventCreateMemoriesTextPostModelToJson(
              personalEventCreateMemoriesTextPostModel));
      print("response ------------------ setPersonalEventMemoryPostText \n$response");
      return Right(PersonalEventCreateMemoriesModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

// Update MemEventMemory
  @override
  FutureEither<PersonalEventCreateMemoriesModel> updatePersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.updatePersonalEventPost}';
      print(
          "API Calling ${url} --> ${personalEventCreateMemoriesTextPostModelToJson(personalEventCreateMemoriesTextPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventCreateMemoriesTextPostModelToJson(
              personalEventCreateMemoriesTextPostModel));
      print("response ------------------ updatePersonalEventMemoryPostText \n$response");
      return Right(PersonalEventCreateMemoriesModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  /// Delete Post from Moments
  @override
  FutureEither<GeneralResponseModel> deletePersonalEventMemoryPostPhoto({
    required DeletePersonalEventPostMomentPhotoModel deletePersonalEventPostPhotoModel,
    required String token,
  }) async {
    try {
      int PersonalEventPostPhotoId =
          deletePersonalEventPostPhotoModel.personalEventPostPhotoId ?? 0;
      String baseUrl = '${ApiUrl.baseURL}${ApiUrl.deletePersonalEventPostPhoto}';
      String finalUrl = "$baseUrl?PersonalEventPostPhotoId=$PersonalEventPostPhotoId";

      print(
          "API Calling Delete ${finalUrl} --> ${deletePersonalEventPostMomentPhotoModelToJson(deletePersonalEventPostPhotoModel)}");
      final response = await dioClient.post(finalUrl,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: deletePersonalEventPostMomentPhotoModelToJson(deletePersonalEventPostPhotoModel));
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setPersonalEventMemoryPostPhoto({
    required PersonalEventCreateMemoriesPhotoPostModel personalEventCreateMemoriesPhotoPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventPostPhoto}';
      print(
          "API Calling ${url} --> ${personalEventCreateMemoriesPhotoPostModelToJson(personalEventCreateMemoriesPhotoPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventCreateMemoriesPhotoPostModelToJson(
              personalEventCreateMemoriesPhotoPostModel));
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventPostLikesUsersModel> getMemoryPostLikes({
    required String personalEventPostId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventPostId/${ApiUrl.getPersonalEventPostLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getMemoryPostLikes \n$response");
      return Right(PersonalEventPostLikesUsersModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setMemoryPostLike({
    required PersonalEventSetLikePostModel personalEventSetLikePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventPostLike}';
      print(
          "API Calling ${url} --> ${personalEventSetLikePostModelToJson(personalEventSetLikePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventSetLikePostModelToJson(personalEventSetLikePostModel));
      print("response ------------------ setMemoryPostLike \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventPostAllCommentsModel> getMemoryPostAllComments({
    required String personalEventPostId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventPostId/$sortByPopular/${ApiUrl.getPersonalEventPostComments}?offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getMemoryPostAllComments \n$response");
      return Right(PersonalEventPostAllCommentsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventPostSetCommentModel> setPostComment({
    required PersonalEventPostCommentPostModel personalEventPostCommentPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventPostComment}';
      print(
          "API Calling ${url} --> ${personalEventPostCommentPostModelToJson(personalEventPostCommentPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventPostCommentPostModelToJson(personalEventPostCommentPostModel));
      print("response ------------------ setPostComment \n$response");
      return Right(PersonalEventPostSetCommentModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setPostCommentPostLike({
    required PersonalEventSetPostCommentLikeModel personalEventSetPostCommentLikeModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventCommentLike}';
      print(
          "API Calling ${url} --> ${personalEventSetPostCommentLikeModelToJson(personalEventSetPostCommentLikeModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventSetPostCommentLikeModelToJson(personalEventSetPostCommentLikeModel));
      print("response ------------------ setPostCommentPostLike \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> deletePost({
    required DeletePersonalEventPostModel deletePersonalEventPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.deletePersonalEventPost}';
      print(
          "API Calling ${url} --> ${deletePersonalEventPostModelToJson(deletePersonalEventPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: deletePersonalEventPostModelToJson(deletePersonalEventPostModel));
      print("response ------------------ deletePost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
