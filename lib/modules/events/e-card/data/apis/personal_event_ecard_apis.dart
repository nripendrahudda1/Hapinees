import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../models/create_event_models/activity_photo_response_model.dart';

final personalEventECardApisController = Provider<PersonalEventECardDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PersonalEventECardImplements(dioClient: dioClient);
});

abstract class PersonalEventECardDatasource {
  // FutureEither<PersonalEventAllImagesModel> fetchAllPersonalEventImages({
  //   required String personalEventHeaderId,
  //   required String token,
  // });

  FutureEither<ActivityPhotoResponseModel> getActivityImages({
    required String personalEventActivityId,
    required String token,
  });
}

class PersonalEventECardImplements implements PersonalEventECardDatasource {
  final DioClient dioClient;
  PersonalEventECardImplements({required this.dioClient});

  // @override
  // FutureEither<PersonalEventAllImagesModel> fetchAllPersonalEventImages({
  //   required String personalEventHeaderId,
  //   required String token,
  // }) async {
  //   try {
  //     print('Tapped');
  //     /// Todo : personal event url set
  //     String url =
  //         '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${ApiUrl.getWeddingPhoto}';
  //     print("API Calling ${url} --> Null");
  //     final response = await dioClient.post(
  //       url,
  //       options: Options(
  //         headers: header(
  //             authToken: "Bearer $token",
  //             contentType: ApiUrl.contentTypeHeader
  //         ),
  //         receiveTimeout: const Duration(seconds: 10),
  //       ),
  //     );
  //     return Right(PersonalEventAllImagesModel.fromJson(response));
  //   } catch (error, st) {
  //     return Left(Failure(ErrorHandler.handle(error).failure, st));
  //   }
  // }

  @override
  FutureEither<ActivityPhotoResponseModel> getActivityImages({
    required String personalEventActivityId,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.event}$personalEventActivityId/${ApiUrl.getPersonalEventActivityPhoto}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getActivityImages \n$response");
      return Right(ActivityPhotoResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
