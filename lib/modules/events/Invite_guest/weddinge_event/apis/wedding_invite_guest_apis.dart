import 'package:flutter/cupertino.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/make_cohost_wedding_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/send_wedding_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/send_wedding_invite_response_model.dart';
import 'package:Happinest/common/common_model/general_response_model.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/searched_wedding_invites_model.dart';
import '../../../../../common/common_imports/apis_commons.dart';

final weddingEventGuestInviteApiController = Provider<WeddingEventGuestInviteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WeddingEventGuestInviteImplements(dioClient: dioClient);
});

abstract class WeddingEventGuestInviteDatasource {
  FutureEither<GetAllWeddingEventInvitedUsers> getWeddingInvites({
    required String weddingHeaderId,
    required String token,
  });

  FutureEither<SendWeddingInviteResponseModel> setWeddingInvite({
    required SendWeddingInvitePostModel sendWeddingInvitePostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> actionOnWeddingInvite({
    required ActionOnWeddingInvitePostModel actionOnWeddingInvitePostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> makeWeddingCohost({
    required MakeCoHostWeddingPostModel makeCoHostPostModel,
    required String token,
  });

  FutureEither<SearchedWeddingInvtesModel> getAllSearchedWeddingInviteUsers({
    required String weddingHeaderId,
    required String search,
    required int offset,
    required int noOfRecords,
    required String token,
  });
}

class WeddingEventGuestInviteImplements implements WeddingEventGuestInviteDatasource {
  final DioClient dioClient;

  WeddingEventGuestInviteImplements({required this.dioClient});

  @override
  FutureEither<GetAllWeddingEventInvitedUsers> getWeddingInvites({
    required String weddingHeaderId,
    required String token,
  }) async {
    try {
      print('HeaderId: $weddingHeaderId');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${DateTime.now().toIso8601String()}/${ApiUrl.getWeddingInvites}';
      print('----url---: $url');
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getWeddingInvites \n$response");
      return Right(GetAllWeddingEventInvitedUsers.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SendWeddingInviteResponseModel> setWeddingInvite({
    required SendWeddingInvitePostModel sendWeddingInvitePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setWeddingInvite}';
      print(
          "API Calling ${url} --> ${sendWeddingInvitePostModelToJson(sendWeddingInvitePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: sendWeddingInvitePostModelToJson(sendWeddingInvitePostModel));
      print("response ------------------ setWeddingInvite \n$response");
      return Right(SendWeddingInviteResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> actionOnWeddingInvite({
    required ActionOnWeddingInvitePostModel actionOnWeddingInvitePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.actionOnWeddingInvite}';
      print(
          "API Calling ${url} --> ${actionOnWeddingInvitePostModelToJson(actionOnWeddingInvitePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: actionOnWeddingInvitePostModelToJson(actionOnWeddingInvitePostModel));
      print("response ------------------ actionOnWeddingInvite \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> makeWeddingCohost({
    required MakeCoHostWeddingPostModel makeCoHostPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.makeWeddingCoHost}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: makeCoHostPostModelToJson(makeCoHostPostModel));
      print("response ------------------ makeWeddingCohost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SearchedWeddingInvtesModel> getAllSearchedWeddingInviteUsers({
    required String weddingHeaderId,
    required String search,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.weddingEvent}$weddingHeaderId/${ApiUrl.searchWeddingInvite}?search=$search&offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 120),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllSearchedWeddingInviteUsers \n$response");
      return Right(SearchedWeddingInvtesModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
