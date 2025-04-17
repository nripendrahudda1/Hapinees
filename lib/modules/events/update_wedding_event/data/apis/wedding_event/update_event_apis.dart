import 'package:flutter/cupertino.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_wedding_event_post_model.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../models/create_event_models/create_wedding_models/wedding_rituals_model.dart';
import '../../../../../../common/common_model/general_response_model.dart';
import '../../../../../../models/create_event_models/update_event_models/wedding_ritual_update_model.dart';

// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIwMWYwNGI3NC1mMWJmLTQxZmQtOTI2ZS00MDJkODk4ZDdmMTIiLCJVc2VySWQiOiIyMDIxMyIsIkVtYWlsIjoic3RyaW5nIiwiZXhwIjoxNzA2NjA1MTEyLCJpc3MiOiJUcmF2ZWxvcnkiLCJhdWQiOiJUcmF2ZWxvcnkifQ.UcBWJRLJWUkz9EWMayBY5n7y46lylu6gejEEz2RHgIk

final updateWeddingEventApisController = Provider<UpdateWeddingEventDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UpdateWeddingEventImplements(dioClient: dioClient);
});


abstract class UpdateWeddingEventDatasource {

  FutureEither<GeneralResponseModel>  updateEvent({
    required UpdateWeddingEventPostModel updateEventPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel>  deleteWedding({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<WeddingRitualsUpdateModel> fetchWeddingRituals({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<WeddingRitualsModel> fetchWeddingRitualsMaster({
    required String language,
    required String weddingStyleMasterId,
  });
}

class UpdateWeddingEventImplements implements UpdateWeddingEventDatasource{
  final DioClient dioClient;
  UpdateWeddingEventImplements({required this.dioClient});

  @override
  FutureEither<GeneralResponseModel>  updateEvent({
    required UpdateWeddingEventPostModel updateEventPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.weddingEvent}${ApiUrl.updateWedding}';
      print("API Calling ${url} --> ${updateWeddingEventPostModelToJson(updateEventPostModel)}");
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: updateWeddingEventPostModelToJson(updateEventPostModel)
      );
      print("response ------------------ updateEvent \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel>  deleteWedding({
    required String weddingHeaderId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.deleteWedding}';
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
      print("response ------------------ deleteWedding \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<WeddingRitualsUpdateModel> fetchWeddingRituals({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      print('Tapped');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.getWeddingRituals}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,

        options: Options(
          headers: header(
              authToken: "Bearer $token",
              contentType: ApiUrl.contentTypeHeader
          ),
          receiveTimeout: const Duration(seconds: 10),
        ),
        // data: formData
      );
      print("response ------------------ fetchWeddingRituals \n$response");
      return Right(WeddingRitualsUpdateModel.fromJson(response));
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
      print('Tapped');
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

}