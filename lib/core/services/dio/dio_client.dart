import 'package:dio/dio.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../dio/end_points.dart';
import 'package:riverpod/riverpod.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

class DioClient {
  static BaseOptions options = BaseOptions(
      baseUrl: Endpoints.baseUrl,
      receiveTimeout: Endpoints.receiveTimeOut,
      connectTimeout: Endpoints.connectionTimeOut,
      contentType: "application/json");

  late Dio _dio;
  DioClient() {
    print("Dio initialixzation :::: ");
    _dio = Dio(options);
    //_dio.interceptors.add(RequestsInspectorInterceptor());
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryparams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onRecieneProgress,
  }) async {
    final Response response = await _dio.get(uri,
        queryParameters: queryparams,
        options: options,
        onReceiveProgress: onRecieneProgress,
        cancelToken: cancelToken);
    return response.data;
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryparams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onRecieneProgress,
  }) async {
    final Response response = await _dio.post(uri,
        data: data,
        queryParameters: queryparams,
        options: options,
        onReceiveProgress: onRecieneProgress,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken);
    // if(response.statusCode! < 200 && response.statusCode! > 210){
    //   throw ServerException();
    // }

    return response.data;
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryparams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onRecieneProgress,
  }) async {
    final Response response = await _dio.put(uri,
        data: data,
        queryParameters: queryparams,
        options: options,
        onReceiveProgress: onRecieneProgress,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken);
    // if(response.statusCode! < 200 && response.statusCode! > 210){
    //   throw ServerException();
    // }

    return response.data;
  }

  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryparams,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onRecieneProgress,
  }) async {
    print('Called ~!');
    final Response response = await _dio.delete(uri,
        data: data,
        queryParameters: queryparams,
        options: options,
        cancelToken: cancelToken);
    // if(response.statusCode! < 200 && response.statusCode! > 210){
    //   throw ServerException();
    // }

    return response.data;
  }
}
