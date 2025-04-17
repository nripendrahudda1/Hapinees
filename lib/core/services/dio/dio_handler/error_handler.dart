import 'package:dio/dio.dart';
import 'package:Happinest/core/services/dio/dio_handler/data_scource_extension.dart';
import 'data_scource_enum.dart';

class ErrorHandler implements Exception {
  late String failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null && error.response!.data != null) {
          print('Error: ${error.response?.data}');
          return
            error.response == null  || error.response == '' ? error.response?.statusMessage:
            error.response?.data == null  || error.response?.data == '' ? error.response?.statusMessage:
            error.response?.data?['validationMessage'] ??
            error.response?.statusMessage ??
            error.response?.statusMessage ??
            error.message ??
              "";
        } else {
          return DataSource.DEFAULT.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }
}