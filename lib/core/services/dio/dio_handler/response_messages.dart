import 'dio_error_strings.dart';

class ResponseMessage {
  static const String SUCCESS = DioErrorStrings.success; // success with data
  static const String NO_CONTENT = DioErrorStrings.success; // success with no data (no content)
  static const String BAD_REQUEST = DioErrorStrings.strBadRequestError; // failure, API rejected request
  static const String UNAUTORISED = DioErrorStrings.strUnauthorizedError; // failure, user is not authorised
  static const String FORBIDDEN = DioErrorStrings.strForbiddenError; //  failure, API rejected request
  static const String INTERNAL_SERVER_ERROR = DioErrorStrings.strInternalServerError; // failure, crash in server side
  static const String NOT_FOUND = DioErrorStrings.strNotFoundError; // failure, crash in server side

  // local status code
  static const String CONNECT_TIMEOUT = DioErrorStrings.strTimeoutError;
  static const String CANCEL = DioErrorStrings.strDefaultError;
  static const String RECIEVE_TIMEOUT = DioErrorStrings.strTimeoutError;
  static const String SEND_TIMEOUT = DioErrorStrings.strTimeoutError;
  static const String CACHE_ERROR = DioErrorStrings.strCacheError;
  static const String NO_INTERNET_CONNECTION = DioErrorStrings.strNoInternetError;
  static const String DEFAULT = DioErrorStrings.strDefaultError;
}