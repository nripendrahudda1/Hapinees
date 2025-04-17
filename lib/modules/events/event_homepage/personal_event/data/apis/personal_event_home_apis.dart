import 'dart:math';

import 'package:Happinest/models/create_event_models/create_personal_event_models/activity_photo_all_comments_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/activity_photo_like_user_models.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/activity_photo_comment_like_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/activity_photo_comment_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/like_activity_photo_post_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/common_model/general_response_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/personal_event_comment_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/personal_event_like_users_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/personal_event_views_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/personal_event_write_comment_post_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/post_models/like_personal_event_post_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/post_models/personal_event_comment_like_post_model.dart';
import '../../../../../../models/create_event_models/create_personal_event_models/post_models/personal_event_view_post_model.dart';

final personalEventHomeApiController = Provider<PersonalEventHomeDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PersonalEventHomeImplements(dioClient: dioClient);
});

abstract class PersonalEventHomeDatasource {
  FutureEither<HomePersonalEventDetailsModel> fetchHomePersonalEventsDetailsModel({
    required String personalEventHeaderId,
    required String token,
  });
//Update Invite Staus

  FutureEither<GeneralResponseModel> updatePersonalEventInviteStatus({
    required String personalEventHeaderId,
    required int inviteStatus,
    required String token,
  });

  FutureEither<PersonalEventActivitiesList> fetchPersonalEventActivitiesModel({
    required String personalEventHeaderId,
    required String token,
  });

  FutureEither<GeneralResponseModel> likeActivityPhoto({
    required LikeActivityPhotoPostModel likeActivityPhotoPostModel,
    required String token,
  });

  FutureEither<ActivityPhotoLikeUserModel> getAllActivityPhotoLikes({
    required String personalEventActivityPhotoId,
    required String token,
  });

  /*FutureEither<ActivityPhotoAllCommentsModel>  getActivityPhotoAllComments({
    required String personalEventActivityPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<GeneralResponseModel>   writeActivityPhotoComment({
    required ActivityPhotoCommentPostModel activityPhotoCommentPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> activityPhotoCommentLike({
    required ActivityPhotoCommentLikePostModel activityPhotoCommentLikePostModel,
    required String token,
  });*/

  FutureEither<PersonalEventLikeUsersModel> getAllPersonalEventLikes({
    required String eventHeaderId,
    required String token,
  });

  FutureEither<GeneralResponseModel> likePersonalEvent({
    required LikePersonalEventPostModel likeEventPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> setPersonalEventView({
    required PersonalEventViewPostModel personalEventViewPostModel,
    required String token,
  });

  FutureEither<PersonalEventViewsModel> getAllPersonalEventViews({
    required String personalEventHeaderId,
    required String token,
  });

  FutureEither<GeneralResponseModel> writePersonalEventComment({
    required PersonalEventWriteCommentPostModel eventWriteCommentPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> likePersonalEventComment({
    required LikePersonalEventCommentPostModel likeCommentPostModel,
    required String token,
  });

  FutureEither<PersonalEventCommentModel> getPersonalEventAllComments({
    required String personalEventHeaderId,
    required bool shortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  });
}

class PersonalEventHomeImplements implements PersonalEventHomeDatasource {
  final DioClient dioClient;

  PersonalEventHomeImplements({required this.dioClient});

  @override
  FutureEither<HomePersonalEventDetailsModel> fetchHomePersonalEventsDetailsModel({
    required String personalEventHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${DateTime.now().toIso8601String()}/${ApiUrl.getPersonalEvent}';
      print("API Calling EventsDetailsModel ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 15),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );

      print("response ------------------ fetchHomePersonalEventsDetailsModel \n$response");
      return Right(HomePersonalEventDetailsModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> updatePersonalEventInviteStatus({
    required String personalEventHeaderId,
    required int inviteStatus,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.updatePersonalEventStatus}?PersonalEventInviteId=$personalEventHeaderId&InviteStatus=$inviteStatus';
      print("API PersonalEventInviteStatus-- ${url} --> null");
      final response = await dioClient.post(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ fetchPersonalEventActivitiesModel \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventActivitiesList> fetchPersonalEventActivitiesModel({
    required String personalEventHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${ApiUrl.getPersonalEventActivities}';
      print("API Calling ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ fetchPersonalEventActivitiesModel \n$response");
      return Right(PersonalEventActivitiesList.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likeActivityPhoto({
    required LikeActivityPhotoPostModel likeActivityPhotoPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setActivityPhotoLike}';
      print(
          "API Calling ${url} --> ${likeActivityPhotoPostModelToJson(likeActivityPhotoPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likeActivityPhotoPostModelToJson(likeActivityPhotoPostModel));
      print("response ------------------ likeActivityPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<ActivityPhotoLikeUserModel> getAllActivityPhotoLikes({
    required String personalEventActivityPhotoId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventActivityPhotoId/${ApiUrl.getActivityPhotoLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllActivityPhotoLikes \n$response");
      return Right(ActivityPhotoLikeUserModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  /* @override
  FutureEither<ActivityPhotoAllCommentsModel>  getActivityPhotoAllComments({
    required String personalEventActivityPhotoId,
    required bool sortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventActivityPhotoId/$sortByPopular/${ApiUrl.getActivityPhotoComments}?offset=$offset&noOfRecords=$noOfRecords';
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
      print("response ------------------ getActivityPhotoAllComments \n$response");
      return Right(ActivityPhotoAllCommentsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>   writeActivityPhotoComment({
    required ActivityPhotoCommentPostModel activityPhotoCommentPostModel,
    required String token,
  }) async {
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setActivityPhotoComment}';
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
          data: activityPhotoCommentPostModelToJson(activityPhotoCommentPostModel)
      );
      print("response ------------------ writeActivityPhotoComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> activityPhotoCommentLike({
    required ActivityPhotoCommentLikePostModel activityPhotoCommentLikePostModel,
    required String token,
  }) async {
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setActivityPhotoCommentLike}';
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
          data: activityPhotoCommentLikePostModelToJson(activityPhotoCommentLikePostModel)
      );
      print("response ------------------ activityPhotoCommentLike \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }*/

  @override
  FutureEither<PersonalEventLikeUsersModel> getAllPersonalEventLikes({
    required String eventHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$eventHeaderId/${ApiUrl.getPersonalEventLikeUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllPersonalEventLikes \n$response");
      return Right(PersonalEventLikeUsersModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likePersonalEvent({
    required LikePersonalEventPostModel likeEventPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventLike}';
      print("API Calling ${url} --> ${likePersonalEventPostModelToJson(likeEventPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likePersonalEventPostModelToJson(likeEventPostModel));
      print("response ------------------ likePersonalEvent \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setPersonalEventView({
    required PersonalEventViewPostModel personalEventViewPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventView}';
      print(
          "API Calling ${url} --> ${personalEventViewPostModelToJson(personalEventViewPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventViewPostModelToJson(personalEventViewPostModel));
      print("response ------------------ setPersonalEventView \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventViewsModel> getAllPersonalEventViews({
    required String personalEventHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${ApiUrl.getPersonalEventViewUsers}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllPersonalEventViews \n$response");
      return Right(PersonalEventViewsModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> writePersonalEventComment({
    required PersonalEventWriteCommentPostModel eventWriteCommentPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventComment}';
      print(
          "API Calling ${url} --> ${personalEventWriteCommentPostModelToJson(eventWriteCommentPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: personalEventWriteCommentPostModelToJson(eventWriteCommentPostModel));
      print("response ------------------ writePersonalEventComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> likePersonalEventComment({
    required LikePersonalEventCommentPostModel likeCommentPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventCommentLike}';
      print(
          "API Calling ${url} --> ${likePersonalEventCommentPostModelToJson(likeCommentPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: likePersonalEventCommentPostModelToJson(likeCommentPostModel));
      print("response ------------------ likePersonalEventComment \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventCommentModel> getPersonalEventAllComments({
    required String personalEventHeaderId,
    required bool shortByPopular,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/$shortByPopular/${ApiUrl.getPersonalEventComments}?offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getPersonalEventAllComments \n$response");
      return Right(PersonalEventCommentModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
