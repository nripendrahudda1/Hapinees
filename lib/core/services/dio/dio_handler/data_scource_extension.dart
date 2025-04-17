import 'package:Happinest/core/services/dio/dio_handler/response_messages.dart';

import 'data_scource_enum.dart';

extension DataSourceExtension on DataSource {
  String getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return "success";
      case DataSource.NO_CONTENT:
        return  "success with not content";
      case DataSource.BAD_REQUEST:
        return  "bad request. try again later";
      case DataSource.FORBIDDEN:
        return  "forbidden request. try again later";
      case DataSource.UNAUTORISED:
        return  "user unauthorized; try again later";
      case DataSource.NOT_FOUND:
        return  "url not found; try again later";
      case DataSource.INTERNAL_SERVER_ERROR:
        return
          "some thing went wrong; try again later";
      case DataSource.CONNECT_TIMEOUT:
        return "time out; try again late";
      case DataSource.CANCEL:
        return  ResponseMessage.CANCEL;
      case DataSource.RECIEVE_TIMEOUT:
        return
          "time out; try again late";
      case DataSource.SEND_TIMEOUT:
        return  "time out; try again late";
      case DataSource.CACHE_ERROR:
        return  "cache error; try again later";
      case DataSource.NO_INTERNET_CONNECTION:
        return
          "Please check your internet connection";
      case DataSource.DEFAULT:
        return  "some thing went wrong; try again later";
    }
  }
}