
import 'dart:developer';

import 'package:Happinest/models/create_event_models/activity_photo_response_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_activity_photo_phost_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_activity_post_model.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/common_model/general_response_model.dart';

final updateActivityApisController = Provider<UpdateEventActivityDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UpdateEventActivityImplements(dioClient: dioClient);
});

abstract class UpdateEventActivityDatasource {

  FutureEither<GeneralResponseModel>  updateActivity({
    required UpdateActivityPostModel updateActivityPostModel,
    required String token,
  });


  FutureEither<ActivityPhotoResponseModel>  getActivityImages({
    required String personalEventActivityId,
    required String token,
  });

  FutureEither<GeneralResponseModel>   deletePersonalEventActivity({
    required int personalEventActivityId,
    required String token,
  });

  FutureEither<GeneralResponseModel> setPersonalEventActivityPhoto({
    required String token,
    required SetPersonalEventActivityPhotoPostModel setPersonalEventActivityPhotoPostModel,
  });

  FutureEither<GeneralResponseModel>   deletePersonalEventActivityPhoto({
    required String personalEventActivityPhotoId,
    required String token,
  });
}

class UpdateEventActivityImplements implements UpdateEventActivityDatasource {
  final DioClient dioClient;
  UpdateEventActivityImplements({required this.dioClient});

  @override
  FutureEither<GeneralResponseModel>  updateActivity({
    required UpdateActivityPostModel updateActivityPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.updatePersonalEventActivity}';
      print("API Calling ${url} --> ${updateActivityPostModelToJson(updateActivityPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                // authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: updateActivityPostModelToJson(updateActivityPostModel)
      );
      print("response ------------------ updateActivity \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>  deletePersonalEventActivity({
    required int personalEventActivityId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventActivityId/${ApiUrl.deletePersonalEventActivity}';
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
      print("response ------------------ deletePersonalEventActivity \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<ActivityPhotoResponseModel>  getActivityImages({
    required String personalEventActivityId ,
    required String token,
  }) async {
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.event}$personalEventActivityId/${ApiUrl.getPersonalEventActivityPhoto}';
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
      print("response ------------------ getActivityImages \n$response");
      return Right(ActivityPhotoResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel> setPersonalEventActivityPhoto({
    required String token,
    required SetPersonalEventActivityPhotoPostModel setPersonalEventActivityPhotoPostModel,
}) async {
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventActivityPhoto}';
      print("setPersonalEventActivityPhoto api call ----------------------------------------- $url");
      log(setPersonalEventActivityPhotoPostModelToJson(setPersonalEventActivityPhotoPostModel));
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: setPersonalEventActivityPhotoPostModelToJson(setPersonalEventActivityPhotoPostModel)
      );
      print("setPersonalEventActivityPhoto api call response ********-------------- \n$response");

      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      print("error **************** ${error.toString()}");
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> deletePersonalEventActivityPhoto({
    required String personalEventActivityPhotoId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventActivityPhotoId/${ApiUrl.deletePersonalEventActivityPhoto}';
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
      print("response ------------------ deletePersonalEventActivityPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}