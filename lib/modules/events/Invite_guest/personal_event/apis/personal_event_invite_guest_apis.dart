import 'package:Happinest/models/create_event_models/create_personal_event_models/email_template_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/set_email_post_template.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/common_model/general_response_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/make_co_host_personal_event_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/send_invite_personal_event_response_model.dart';

final personalEventGuestInviteApiController = Provider<PersonalEventGuestInviteDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return PersonalEventGuestInviteImplements(dioClient: dioClient);
});

abstract class PersonalEventGuestInviteDatasource {
  FutureEither<SendPersonalEventInviteResponseModel> setPersonalEventInvite({
    required SendPersonalEventInvitePostModel sendPersonalEventInvitePostModel,
    required String token,
  });

  FutureEither<SearchedPersonalEventInvitesModel> getAllSearchedPersonalEventInviteUsers({
    required String personalEventHeaderId,
    required String search,
    required int offset,
    required int noOfRecords,
    required String token,
  });

  FutureEither<GeneralResponseModel> actionOnPersonalEventInvite({
    required ActionOnPersonalEventInvitePostModel actionOnPersonalEventInvitePostModel,
    required String token,
  });

  FutureEither<GeneralResponseModel> makePersonalEventCoHost({
    required MakeCoHostPersonalEventPostModel makeCoHostPostModel,
    required String token,
  });

  FutureEither getPersonalEventInvites({
    required String eventHeaderId,
    required String token,
  });

  FutureEither getEmailTemplate({
    required String eventHeaderId,
    required String templateType,
    required String token,
  });

  FutureEither<GeneralResponseModel> sendEmailToGuest({
    required SendPostEmailTemplateModel sendEmailPostModel,
    required String token,
  });
}

class PersonalEventGuestInviteImplements implements PersonalEventGuestInviteDatasource {
  final DioClient dioClient;

  PersonalEventGuestInviteImplements({required this.dioClient});

  @override
  FutureEither<SendPersonalEventInviteResponseModel> setPersonalEventInvite({
    required SendPersonalEventInvitePostModel sendPersonalEventInvitePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.setPersonalEventInvite}';
      print(
          "API Calling ${url} --> ${sendPersonalEventInvitePostModelToJson(sendPersonalEventInvitePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: sendPersonalEventInvitePostModelToJson(sendPersonalEventInvitePostModel));
      print("response ------------------ setPersonalEventInvite \n$response");
      return Right(SendPersonalEventInviteResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<SearchedPersonalEventInvitesModel> getAllSearchedPersonalEventInviteUsers({
    required String personalEventHeaderId,
    required String search,
    required int offset,
    required int noOfRecords,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$personalEventHeaderId/${ApiUrl.searchPersonalEventInvite}?search=$search&offset=$offset&noOfRecords=$noOfRecords';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 120),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getAllSearchedPersonalEventInviteUsers \n$response");
      return Right(SearchedPersonalEventInvitesModel.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> actionOnPersonalEventInvite({
    required ActionOnPersonalEventInvitePostModel actionOnPersonalEventInvitePostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.actionOnPersonalEventInvite}';
      print(
          "API Calling ${url} --> ${actionOnPersonalEventInvitePostModelToJson(actionOnPersonalEventInvitePostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: actionOnPersonalEventInvitePostModelToJson(actionOnPersonalEventInvitePostModel));
      print("response ------------------ actionOnPersonalEventInvite \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> makePersonalEventCoHost({
    required MakeCoHostPersonalEventPostModel makeCoHostPostModel,
    required String token,
  }) async {
    try {
      String url = '${ApiUrl.baseURL}${ApiUrl.makePersonalEventCoHost}';
      print(
          "API Calling ${url} --> ${makeCoHostPersonalEventPostModelToJson(makeCoHostPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: makeCoHostPersonalEventPostModelToJson(makeCoHostPostModel));
      print("response ------------------ makePersonalEventCoHost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GetAllPersonalEventInvitedUsers> getPersonalEventInvites({
    required String eventHeaderId,
    required String token,
  }) async {
    try {
      print('HeaderId: $eventHeaderId');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.personalEvent}$eventHeaderId/${DateTime.now().toIso8601String()}/${ApiUrl.getPersonalEventInvites}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getPersonalEventInvites \n$response");
      return Right(GetAllPersonalEventInvitedUsers.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<EmailTemplate> getEmailTemplate({
    required String eventHeaderId,
    required String templateType,
    required String token,
  }) async {
    try {
      print('HeaderId: $eventHeaderId');
      String url =
          '${ApiUrl.baseURL}${ApiUrl.getEmailTemplateController}/$templateType/$eventHeaderId/${ApiUrl.getEmailTemplate}';
      print("API Calling ${url} --> Null");
      final response = await dioClient.get(
        url,
        options: Options(
          receiveTimeout: const Duration(seconds: 10),
          headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
        ),
      );
      print("response ------------------ getPersonalEventInvites \n$response");
      return Right(EmailTemplate.fromJson(response));
    } catch (error, st) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: st);
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }

  @override
  FutureEither<GeneralResponseModel> sendEmailToGuest({
    required SendPostEmailTemplateModel sendEmailPostModel,
    required String token,
  }) async {
    try {
      String url =
          '${ApiUrl.baseURL}${ApiUrl.getEmailTemplateController}/${ApiUrl.sendEmailTemplate}';
      print("API Calling ${url} --> ${sendPostEmailTemplateModelToJson(sendEmailPostModel)}");
      final response = await dioClient.post(url,
          options: Options(
            receiveTimeout: const Duration(seconds: 10),
            headers: header(authToken: "Bearer $token", contentType: ApiUrl.contentTypeHeader),
          ),
          data: sendPostEmailTemplateModelToJson(sendEmailPostModel));
      print("response ------------------ makePersonalEventCoHost \n$response");
      return Right(GeneralResponseModel.fromJson(response));
    } catch (error, st) {
      return Left(Failure(ErrorHandler.handle(error).failure, st));
    }
  }
}
