import 'package:Happinest/models/create_event_models/home/home_wedding_details_model.dart';
import 'package:Happinest/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/wedding_event_comment_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/event_write_comment_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/like_wedding_event_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/like_ritual_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/ritual_photo_comment_like_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/ritual_photo_all_comments_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/wedding_views_model.dart';
import 'package:Happinest/common/common_model/general_response_model.dart';
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../models/create_event_models/create_wedding_models/post_models/ritual_photo_comment_post_model.dart';
import '../../../../../../models/create_event_models/create_wedding_models/post_models/wedding_comment_like_post_model.dart';
import '../../../../../../models/create_event_models/create_wedding_models/post_models/wedding_view_post_model.dart';
import '../../../../../../models/create_event_models/create_wedding_models/ritual_photo_like_user_models.dart';
import '../../../../../../models/create_event_models/create_wedding_models/wedding_like_users_model.dart';

final weddingEventHomeApiController = Provider<WeddingEventHomeDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WeddingEventHomeImplements(dioClient: dioClient);
});

abstract class WeddingEventHomeDatasource {
  FutureEither<HomeWeddingDetailsModel> fetchHomeWeddingDetailsModel({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<WeddingEventCommentModel> getWeddingEventAllComments({
    required String weddingHeaderId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<WeddingLikeUsersModel> getAllWeddingLikes({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<GeneralResponseModel> writeWeddingEventComment({
    required WeddingEventWriteCommentPostModel eventWriteCommentPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> likeWeddingComment({
    required LikeWeddingCommentPostModel likeCommentPostmodel,
    required String token,
  });

  FutureEither<GeneralResponseModel> likeWeddingEvent({
    required LikeWeddingPostModel likeEventPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> likeRitualPhoto({
    required LikeRitualPhotoPostModel likeRitualPhotoPostModel,
    required String token,
  });

  FutureEither<RitualPhotoUserLikesModel> getAllRitualPhotoLikes({
    required String weddingRitualPhotoId,
    required String token,
  });

  FutureEither<GeneralResponseModel> writeRitualPhotoComment({
    required RitualPhotoCommentPostModel ritualPhotoCommenPostModel,
    required String token,
  });

  FutureEither<RitualPhotoAllCommentsModel> getRitualPhotoAllComments({
    required String weddingRitualPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<GeneralResponseModel> ritualPhotoCommentLike({
    required RitualPhotoCommenLikePostModel ritualPhotoCommenLikePostModel,
    required String token,
  });

  FutureEither<WeddingViewsModel> getAllWeddingViews({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<GeneralResponseModel> setWeddingView({
    required WeddingViewPostModel weddingViewPostModel,
    required String token,
  });

  FutureEither followUser({
    required String followerId,
    required String token,
    required int followRequestStatus,
  });
}

class WeddingEventHomeImplements implements WeddingEventHomeDatasource {
  final DioClient dioClient;
  WeddingEventHomeImplements({required this.dioClient});

  @override
  FutureEither<HomeWeddingDetailsModel> fetchHomeWeddingDetailsModel({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${DateTime.now().toIso8601String()}/${ApiUrl.getWedding}';
      print("API Calling ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
        // data: formData
      );
      print("response ------------------ fetchHomeWeddingDetailsModel \n$response");
      return Right(HomeWeddingDetailsModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingEventCommentModel> getWeddingEventAllComments({
    required String weddingHeaderId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/$sortByPopular/${ApiUrl.getWeddingComments}?offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getWeddingEventAllComments \n$response");
      return Right(WeddingEventCommentModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> writeWeddingEventComment({
    required WeddingEventWriteCommentPostModel eventWriteCommentPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingComment}';
      print(
          "API Calling ${url} --> ${eventWriteCommentPostModelToJson(eventWriteCommentPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: eventWriteCommentPostModelToJson(eventWriteCommentPostModel));
      print("response ------------------ writeWeddingEventComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likeWeddingComment({
    required LikeWeddingCommentPostModel likeCommentPostmodel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingCommentLike}';
      print("API Calling ${url} --> ${likeCommentPostmodelToJson(likeCommentPostmodel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likeCommentPostmodelToJson(likeCommentPostmodel));
      print("response ------------------ likeWeddingComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likeWeddingEvent({
    required LikeWeddingPostModel likeEventPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingLike}';
      print("API Calling ${url} --> ${likeWeddingPostModelToJson(likeEventPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likeWeddingPostModelToJson(likeEventPostModel));
      print("response ------------------ likeWeddingEvent \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingLikeUsersModel> getAllWeddingLikes({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.getWeddingLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllWeddingLikes \n$response");
      return Right(WeddingLikeUsersModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<RitualPhotoUserLikesModel> getAllRitualPhotoLikes({
    required String weddingRitualPhotoId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingRitualPhotoId/${ApiUrl.getRitualPhotoLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllRitualPhotoLikes \n$response");
      return Right(RitualPhotoUserLikesModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likeRitualPhoto({
    required LikeRitualPhotoPostModel likeRitualPhotoPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setRitualPhotoLike}';
      print("API Calling ${url} --> ${likeRitualPhotoPostModelToJson(likeRitualPhotoPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likeRitualPhotoPostModelToJson(likeRitualPhotoPostModel));
      print("response ------------------ likeRitualPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither followUser({
    required String followerId,
    required String token,
    required int followRequestStatus,
  }) async {
    try {
      final loginUserID = getUserID();
      String url =
          '${ApiUrl.baseURL}User/$loginUserID/$followerId/${ApiUrl.followUser}?followRequestStatus=$followRequestStatus';

      print("API Calling  followUser${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ followUser \n$response");
      return Right(response);
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> writeRitualPhotoComment({
    required RitualPhotoCommentPostModel ritualPhotoCommenPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setRitualPhotoComment}';
      print(
          "API Calling ${url} --> ${ritualPhotoCommentPostModelToJson(ritualPhotoCommenPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: ritualPhotoCommentPostModelToJson(ritualPhotoCommenPostModel));
      print("response ------------------ writeRitualPhotoComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<RitualPhotoAllCommentsModel> getRitualPhotoAllComments({
    required String weddingRitualPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingRitualPhotoId/$sortByPopular/${ApiUrl.getRitualPhotoComments}?offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getRitualPhotoAllComments \n$response");
      return Right(RitualPhotoAllCommentsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> ritualPhotoCommentLike({
    required RitualPhotoCommenLikePostModel ritualPhotoCommenLikePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setRitualPhotoCommentLike}';
      print(
          "API Calling ${url} --> ${ritualPhotoCommenLikePostModelToJson(ritualPhotoCommenLikePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: ritualPhotoCommenLikePostModelToJson(ritualPhotoCommenLikePostModel));
      print("response ------------------ ritualPhotoCommentLike \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingViewsModel> getAllWeddingViews({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.getWeddingViewUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllWeddingViews \n$response");
      return Right(WeddingViewsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setWeddingView({
    required WeddingViewPostModel weddingViewPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingView}';
      print("API Calling ${url} --> ${weddingViewPostModelToJson(weddingViewPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: weddingViewPostModelToJson(weddingViewPostModel));
      print("response ------------------ setWeddingView \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
