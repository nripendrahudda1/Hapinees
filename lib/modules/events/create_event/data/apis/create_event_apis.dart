import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_event_activity_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_personal_event_post_model.dart';
import 'package:Happinest/utility/database_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_ritual_post_model.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_model/general_response_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_activity_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/event_types_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/personal_event_theme_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/update_wedding_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/set_personal_event_success_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/set_wedding_success_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/wedding_styles_model.dart';
import '../../../../../models/create_event_models/moments/personal_event_moments/personal_event_create_memories_model.dart';
import '../../../../../models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_photo_post_model.dart';
import '../../../../../models/create_event_models/moments/personal_event_moments/post_model/personal_event_create_memories_text_post_model.dart';

final createEventApisController = Provider<CreateEventDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CreateEventImplements(dioClient: dioClient);
});

abstract class CreateEventDatasource {
  // FutureEither<UserAdminMasjidsModel> getUserAdminMasjids({required FormData formData, required String token});
  FutureEither<EventTypesModel> fetchAllEventTypes({
    required String eventCategoryMasterId,
    required String language,
  });

  FutureEither<WeddingStylesModel> fetchWeddingStyle({
    required String language,
  });

  FutureEither<WeddingRitualsModel> fetchWeddingRitualsMaster({
    required String language,
    required String weddingStyleMasterId,
  });

  FutureEither<SetWeddingSuccessModel> setWedding(
      {required SetWeddingPostModel setWeddingPostModel, required String token});

  FutureEither<SetWeddingSuccessModel> updateRitual({
    required UpdateRitualPostModel updateRitualPostModel,
    required String token,
  });

  FutureEither<SetWeddingSuccessModel> updateWedding({
    required UpdateWeddingPostModel updateWeddingPostModel,
    required String token,
  });

  FutureEither<PersonalEventThemeModel> getPersonalEventThemes({
    required String token,
    required int eventTypeMasterId,
  });

  FutureEither<SetPersonalEventSuccessModel> setPersonalEvents(
      {required SetPersonalEventPostModel setPersonalEventPostModel, required String token});

  FutureEither<GeneralResponseModel> setPersonalEventActivity({
    required SetPersonalEventActivityPostModel setPersonalEventActivityPostModel,
    required String token,
  });

  FutureEither<PersonalEventActivityModel> fetchPersonalEventActivityMaster({
    required String language,
    required int personalEventThemeMasterId,
    required String token,
  });

  FutureEither<PersonalEventCreateMemoriesModel> setPersonalEventMemoryPostText({
    required PersonalEventCreateMemoriesTextPostModel personalEventCreateMemoriesTextPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> setPersonalEventMemoryPostPhoto({
    required PersonalEventCreateMemoriesPhotoPostModel personalEventCreateMemoriesPhotoPostModel,
    required String token,
  });
}

// MAP LOcal DATA
Map<String, dynamic> deepConvert(Map<dynamic, dynamic> map) {
  return map.map((key, value) {
    if (value is Map) {
      return MapEntry(key.toString(), deepConvert(value));
    } else if (value is List) {
      return MapEntry(key.toString(), value.map((e) => e is Map ? deepConvert(e) : e).toList());
    } else {
      return MapEntry(key.toString(), value);
    }
  });
}

class CreateEventImplements implements CreateEventDatasource {
  final DioClient dioClient;
  CreateEventImplements({required this.dioClient});
  final dbManager = DatabaseManager();

  @override
  FutureEither<EventTypesModel> fetchAllEventTypes({
    required String eventCategoryMasterId,
    required String language,
  }) async {
    var eventData = dbManager.getObject(DBKeys.eventData);

    if (eventData != null && eventData is Map) {
      final jsonData = deepConvert(eventData);
      return Right(EventTypesModel.fromJson(jsonData));
    }
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.event}1/$language/${ApiUrl.getEventTypesMaster}';
      print("****************************************");
      print("API Calling Event Name ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          // headers: header(authToken: "Bearer $token"),
        ),
      );
      await dbManager.saveObject(DBKeys.eventData, response);
      print("response ------------------ fetchAllEventTypes \n$response");
      return Right(EventTypesModel.fromJson(response));
    } catch (error, st) {
      print('ERROR HERE: $error');
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingStylesModel> fetchWeddingStyle({
    required String language,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$language/${ApiUrl.getWeddingStyleMasters}';
      print("API Calling ${url} --> null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
        ),
        // data: formData
      );
      print("response ------------------ fetchWeddingStyle \n$response");
      return Right(WeddingStylesModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingRitualsModel> fetchWeddingRitualsMaster({
    required String language,
    required String weddingStyleMasterId,
  }) async {
    try {
      print('Tapped $weddingStyleMasterId');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingStyleMasterId/$language/${ApiUrl.getWeddingRitualMasters}';
      print("API Calling ${url} --> null");

      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
        ),
        // data: formData
      );
      print("response ------------------ fetchWeddingRitualsMaster \n$response");
      return Right(WeddingRitualsModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SetWeddingSuccessModel> setWedding(
      {required SetWeddingPostModel setWeddingPostModel, required String token}) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.weddingEvent}${ApiUrl.setWedding}';
      print("API Calling ${url} --> ${setWeddingPostModelToJson(setWeddingPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: setWeddingPostModelToJson(setWeddingPostModel));
      print("response ------------------ setWedding \n$response");
      return Right(SetWeddingSuccessModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SetWeddingSuccessModel> updateRitual({
    required UpdateRitualPostModel updateRitualPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.updateWeddingRitual}';
      print("API Calling ${url} --> ${updateRitualPostModelToJson(updateRitualPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: updateRitualPostModelToJson(updateRitualPostModel));
      print("response ------------------ updateRitual \n$response");
      return Right(SetWeddingSuccessModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SetWeddingSuccessModel> updateWedding({
    required UpdateWeddingPostModel updateWeddingPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.weddingEvent}${ApiUrl.updateWedding}';
      print("API Calling ${url} --> ${updateWeddingPostModelToJson(updateWeddingPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: updateWeddingPostModelToJson(updateWeddingPostModel));
      print("response ------------------ updateWedding \n$response");
      return Right(SetWeddingSuccessModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<PersonalEventThemeModel> getPersonalEventThemes(
      {required String token, required int eventTypeMasterId}) async {
    try {
      var url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$eventTypeMasterId/EN/${ApiUrl.getPersonalEventThemesMaster}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ));
      print("response ------------------ getPersonalEventThemes \n$response");
      return Right(PersonalEventThemeModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SetPersonalEventSuccessModel> setPersonalEvents(
      {required SetPersonalEventPostModel setPersonalEventPostModel, required String token}) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEvent}';
      print("API Calling ${url} --> ${setPersonalEventPostModelToJson(setPersonalEventPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: setPersonalEventPostModelToJson(setPersonalEventPostModel));
      print("response ------------------ setPersonalEvents \n$response");
      return Right(SetPersonalEventSuccessModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> setPersonalEventActivity({
    required SetPersonalEventActivityPostModel setPersonalEventActivityPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventActivity}';
      print(
          "API Calling ${url} --> ${setPersonalEventActivityPostModelToJson(setPersonalEventActivityPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: setPersonalEventActivityPostModelToJson(setPersonalEventActivityPostModel));
      print("response ------------------ setPersonalEventActivity \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
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
      print("response ------------------ fetchPersonalEventActivityMaste_r \n$response");
      return Right(PersonalEventActivityModel.fromJson(response));
    } catch (error, st) {
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
      print("response ------------------ setPersonalEventMemoryPostPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
