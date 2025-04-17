class ErrorStrings{
  static const  String success = "success";
  static const  String bad_request_error = "bad request. try again later";
  static const  String no_content = "success with not content";
  static const  String forbidden_error = "forbidden request. try again later";
  static const  String unauthorized_error = "user unauthorized; try again later";
  static const  String not_found_error = "url not found; try again later";
  static const  String conflict_error = "conflict found; try again later";
  static const  String internal_server_error = "some thing went wrong; try again later";
  static const  String unknown_error = "some thing went wrong; try again later";
  static const  String timeout_error = "time out; try again late";
  static const  String default_error = "some thing went wrong; try again later";
  static const  String cache_error = "cache error; try again later";
  static const  String no_internet_error = "Please check your internet connection";

}

class DioErrorStrings {
  static const String success = ErrorStrings.success;
  // error handler
  static const String strBadRequestError = ErrorStrings.bad_request_error;
  static const String strNoContent = ErrorStrings.no_content;
  static const String strForbiddenError = ErrorStrings.forbidden_error;
  static const String strUnauthorizedError = ErrorStrings.unauthorized_error;
  static const String strNotFoundError = ErrorStrings.not_found_error;
  static const String strConflictError = ErrorStrings.conflict_error;
  static const String strInternalServerError = ErrorStrings.internal_server_error;
  static const String strUnknownError = ErrorStrings.unknown_error;
  static const String strTimeoutError = ErrorStrings.timeout_error;
  static const String strDefaultError = ErrorStrings.default_error;
  static const String strCacheError = ErrorStrings.cache_error;
  static const String strNoInternetError = ErrorStrings.no_internet_error;
}