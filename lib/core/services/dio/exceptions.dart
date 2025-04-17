import 'package:dio/dio.dart';

class DioExceptions implements Exception{
  String message = 'Error Not Specified yet!';
  String _handleError(int? statusCode, dynamic error){
    switch(statusCode){
      case 400 :
        return "Bad Request";
      case 404:
        return error["data"]["error"];
      case 422 :
        print("IM HER");
        return error["data"]["error"];
      case 500:
        return "Internal server error";
      default:
        return "Ops! Something went wrong!";
    }
  }

  @override
  String toSting()=> message;

  DioExceptions.fromDioError(DioException dioError){
    switch(dioError.type){
      case DioExceptionType.connectionTimeout:
        message = "Connection Timeout with API server!";
        break;
      case DioExceptionType.sendTimeout:
        message = "Send Timeout in connection with API server!";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive Timeout in connection with API server!";
        break;
      case DioExceptionType.unknown:
        print("Im here");
        message =
            _handleError(dioError.response?.statusCode, dioError.response?.data);
        break;
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection failed to established due to internet loss";
        break;
      default:
        message = 'Something went wrong!';
        break;
    }
  }
}