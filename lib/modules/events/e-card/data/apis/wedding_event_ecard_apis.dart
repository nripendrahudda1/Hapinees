import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../models/create_event_models/home/wedding_all_images_model.dart';


final weddingEventECardApisController = Provider<WeddingEventECardDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WeddingEventECardImplements(dioClient: dioClient);
});


abstract class WeddingEventECardDatasource {


  FutureEither<WeddingAllImagesModel> fetchAllWeddingImages({
    required String weddingHeaderId,
    required String token,
  });
  
}

class WeddingEventECardImplements implements WeddingEventECardDatasource{
  final DioClient dioClient;
  WeddingEventECardImplements({required this.dioClient});


  @override
  FutureEither<WeddingAllImagesModel> fetchAllWeddingImages({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      print('Tapped');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.getWeddingPhoto}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.post(
        url,
        options: Options(
          headers: header(
              authToken: "Bearer $token",
              contentType: ApiUrl.contentTypeHeader
          ),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      print("response ------------------ fetchAllWeddingImages \n$response");
      return Right(WeddingAllImagesModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}