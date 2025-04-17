import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/update_personal_event_post_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/common_model/general_response_model.dart';

final updatePersonalEventApisController = Provider<UpdatePersonalEventDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UpdatePersonalEventImplements(dioClient: dioClient);
});

abstract class UpdatePersonalEventDatasource {
  FutureEither<GeneralResponseModel> updateEvent({
    required UpdatePersonalEventPostModel updatePersonalEventPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> deletePersonalEvent({
    required String personalEventHeaderId,
    required String token,
  });

  FutureEither<PersonalEventActivitiesList> fetchPersonalEventActivitiesModel({
    required String personalEventHeaderId,
    required String token,
  });

  FutureEither<PersonalEventActivityModel> fetchPersonalEventActivityMaster({
    required String language,
    required int personalEventThemeMasterId,
    required String token,
  });
}

class UpdatePersonalEventImplements implements UpdatePersonalEventDatasource {
  final DioClient dioClient;
  UpdatePersonalEventImplements({required this.dioClient});

  @override
  FutureEither<GeneralResponseModel> updateEvent({
    required UpdatePersonalEventPostModel updatePersonalEventPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.updatePersonalEvent}';
      log("API Calling ${url} --> ${updatePersonalEventPostModelToJson(updatePersonalEventPostModel)}");
      // print(
      // "API Calling ${url} --> ${updatePersonalEventPostModelToJson(updatePersonalEventPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: updatePersonalEventPostModelToJson(updatePersonalEventPostModel));
      print("response ------------------ updateEvent \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> deletePersonalEvent({
    required String personalEventHeaderId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${ApiUrl.deletePersonalEvent}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.post(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ deletePersonalEvent \n$response");
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
  FutureEither<PersonalEventActivityModel> fetchPersonalEventActivityMaster({
    required String language,
    required int personalEventThemeMasterId,
    required String token,
  }) async {
    try {
      // print('Tapped $weddingStyleMasterId');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventThemeMasterId/$language/${ApiUrl.getPersonalEventActivityMasters}';
      print("API Calling ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ fetchPersonalEventActivityMaster \n$response");
      return Right(PersonalEventActivityModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
