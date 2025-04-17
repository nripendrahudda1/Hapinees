import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_ritual_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/ritual_image_response_model.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/delete_wedding_ritual_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/set_events_model/set_wedding_ritual_photo_post_model.dart';
import '../../../../../common/common_model/general_response_model.dart';


final updateRitualApisController = Provider<UpdateRitualDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return UpdateRitualImplements(dioClient: dioClient);
});


abstract class UpdateRitualDatasource {

  FutureEither<GeneralResponseModel>  updateRitual({
    required UpdateRitualPostModel updateRitualPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel>  setWeddingRitualPhoto({
    required SetWeddingRitualPhotoPostModel setWeddingRitualPhotoPostModel,
    required String token,
  });

  FutureEither<RitualImagesResponseModel>  getRitualImages({
    required String weddingRitualId ,
    required String token,
  });

  FutureEither<GeneralResponseModel>   deleteWeddingRitual({
    required DeleteWeddingRitualPostModel deleteWeddingRitualPostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel>   deleteWeddingRitualPhoto({
    required String weddingRitualPhotoId,
    required String token,
  });
}

class UpdateRitualImplements implements UpdateRitualDatasource{
  final DioClient dioClient;
  UpdateRitualImplements({required this.dioClient});

  @override
  FutureEither<GeneralResponseModel>  updateRitual({
    required UpdateRitualPostModel updateRitualPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.updateWeddingRitual}';
      print("API Calling ${url} --> ${updateRitualPostModelToJson(updateRitualPostModel)}");
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
          data: updateRitualPostModelToJson(updateRitualPostModel)
      );
      print("response ------------------ updateRitual \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>  setWeddingRitualPhoto({
    required SetWeddingRitualPhotoPostModel setWeddingRitualPhotoPostModel,
    required String token,
  }) async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingRitualPhoto}';
      print("API Calling ${url} --> ${setWeddingRitualPhotoPostModelToJson(setWeddingRitualPhotoPostModel)}");
      // String url = '${ApiUrl.baseURL}WeddingEvent/${ApiUrl.setWeddingRitualPhoto}';
      final response = await dioClient.post(
          url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(
                authToken: "Bearer $token",
                contentType: ApiUrl.contentTypeHeader
            ),
          ),
          data: setWeddingRitualPhotoPostModelToJson(setWeddingRitualPhotoPostModel)
      );
      print("response ------------------ setWeddingRitualPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }


  @override
  FutureEither<GeneralResponseModel>  deleteWeddingRitual({
    required DeleteWeddingRitualPostModel deleteWeddingRitualPostModel,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.deleteWeddingRitual}';
      print("API Calling ${url} --> ${deleteWeddingRitualPostModelToJson(deleteWeddingRitualPostModel)}");
      final response = await dioClient.post(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(
              authToken: "Bearer $token",
              contentType: ApiUrl.contentTypeHeader
          ),
        ),
        data: deleteWeddingRitualPostModelToJson(deleteWeddingRitualPostModel)
      );
      print("response ------------------ deleteWeddingRitual \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<RitualImagesResponseModel>  getRitualImages({
    required String weddingRitualId ,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingRitualId/${ApiUrl.getWeddingRitualPhoto}';
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
      print("response ------------------ getRitualImages \n$response");
      return Right(RitualImagesResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel>   deleteWeddingRitualPhoto({
    required String weddingRitualPhotoId,
    required String token,
  })async{
    try{
      String url = '${ApiUrl.baseURL}${ApiUrl.deleteWeddingRitualPhoto}';
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
          data: json.encode(
           {
             'weddingRitualPhotoId': weddingRitualPhotoId
           }
          )
      );
      print("response ------------------ deleteWeddingRitualPhoto \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

}