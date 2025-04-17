import 'package:Happinest/core/api_urls.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:requests_inspector/requests_inspector.dart';
import '../constants/constants.dart';
import 'package:dio/dio.dart';

Future<dynamic> fetchApiWithoutContext(
    {required String url,
    bool? get,
    Object? params,
    Function(dynamic response)? onSuccess,
    Function(dynamic response)? onError,
    bool errorLogShow = false}) async {
  try {
    final String baseURL_ = ApiUrl.baseURL;
    // EasyLoading.show();
    print("API Calling ${baseURL_ + url} --> ${params.toString()}");
    var response = get == null
        ? await dio.post(
            baseURL_ + url,
            data: params,
          )
        : await dio.get(
            baseURL_ + url,
            data: params,
          );
    if (kDebugMode) {
      print(response.data.toString());
    }

    if (response.statusCode == 200) {
      debugPrint("Got Data Successfully");
      // EasyLoading.dismiss();
      onSuccess != null ? onSuccess(response.data) : null;
      return response.data;
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        //print(response.data.toString());
      }
      onError != null ? onError(response.data) : null;
      // EasyLoading.dismiss();
      // EasyLoading.showError('Invalid request parameters');
    } else if (response.statusCode == 401) {
      onError != null ? onError(response) : null;
      // EasyLoading.showError('Session Expired !! Please Restart Application');
    } else if (response.statusCode == 403) {
      // EasyLoading.showError('Request Forbidden');
    } else if (response.statusCode == 404) {
      // EasyLoading.showError('Data Not Found');
    } else if (response.statusCode == 503) {
      // EasyLoading.showError('Service Unavailables');
    } else {
      // EasyLoading.showError("Didn't Get Data From API");
      return null;
    }
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError(e.toString(), duration: const Duration(seconds: 6));
    debugPrint(e.toString());
  }
}
// }

// import 'package:dio/dio.dart';

class ApiService {
  static void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add any common headers or configurations here
        return handler.next(options); // continue
      },
      onResponse: (response, handler) {
        // Handle response if needed
        return handler.next(response); // continue
      },
      onError: (DioException error, handler) {
        // Handle errors if needed
        return handler.next(error); // continue
      },
    ));
    //dio.interceptors.add(RequestsInspectorInterceptor());
  }

  static Future<dynamic> fetchApi({
    required BuildContext context,
    required String url,
    bool? get,
    Object? params,
    Function(dynamic res)? onSuccess,
    Function(dynamic res)? onError,
    bool? isLoader,
    bool? isParams,
    bool errorLogShow = false,
  }) async {
    _setupInterceptors(); // Setup interceptors for the first call

    final String baseURL_ = ApiUrl.baseURL;
    // (isLoader ?? true) ? EasyLoading.show() : null;
    print("API Calling ${baseURL_ + url} --> ${params.toString()}");

    try {
      Response response = get == null
          ? await dio.post(
              baseURL_ + url,
              data: params,
              queryParameters: (isParams ?? false)
                  ? params != null
                      ? (params as Map<String, dynamic>)
                      : null
                  : null,
            )
          : await dio.get(
              baseURL_ + url,
              queryParameters: params != null ? (params as Map<String, dynamic>) : null,
            );

      if (response.statusCode == 200) {
        (isLoader ?? true) ? EasyLoading.dismiss() : null;
        onSuccess != null ? await onSuccess(response.data) : null;
        return response.data;
      } else if (response.statusCode == 400) {
        onError != null ? await onError(response.data) : null;
        EasyLoading.dismiss();
      } else if (response.statusCode == 401) {
        onError != null ? onError(response) : null;
        (isLoader ?? true)
            ? EasyLoading.showError('Session Expired !! Please Restart Application',
                    duration: const Duration(seconds: 6))
                .then((value) {
                Navigator.pushNamedAndRemoveUntil(context, Routes.walkthrough, (route) => false);
              })
            : null;
      } else if (response.statusCode == 403) {
        (isLoader ?? true)
            ? EasyLoading.showError('Request Forbidden', duration: const Duration(seconds: 6))
                .then((value) {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              })
            : null;
      } else if (response.statusCode == 404) {
        (isLoader ?? true)
            ? EasyLoading.showError('Data Not Found', duration: const Duration(seconds: 6))
                .then((value) {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              })
            : null;
      } else if (response.statusCode == 503) {
        (isLoader ?? true)
            ? EasyLoading.showError('Service Unavailables', duration: const Duration(seconds: 6))
                .then((value) {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              })
            : null;
      } else {
        (isLoader ?? true)
            ? EasyLoading.showError(response.data['validationMessage'].toString(),
                    duration: const Duration(seconds: 6))
                .then((value) {
                Navigator.canPop(context) ? Navigator.pop(context) : null;
              })
            : null;
        debugPrint(response.toString());
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      if (errorLogShow) {
        EasyLoading.showError(e.toString(), duration: const Duration(seconds: 6));
        debugPrint(e.toString());
      }
    }
  }

  static Future<dynamic> fetchApiWithoutContext(
      {required String url,
      bool? get,
      Object? params,
      Function(dynamic response)? onSuccess,
      Function(dynamic response)? onError,
      bool errorLogShow = false}) async {
    try {
      final String baseURL_ = ApiUrl.baseURL;
      // EasyLoading.show();
      print("API Calling ${baseURL_ + url} --> ${params.toString()}");
      var response = get == null
          ? await dio.post(
              baseURL_ + url,
              data: params,
            )
          : await dio.get(
              baseURL_ + url,
              data: params,
            );
      if (kDebugMode) {
        print(response.data.toString());
      }

      if (response.statusCode == 200) {
        debugPrint("Got Data Successfully");
        // EasyLoading.dismiss();
        onSuccess != null ? onSuccess(response.data) : null;
        return response.data;
      } else if (response.statusCode == 400) {
        if (kDebugMode) {
          //print(response.data.toString());
        }
        onError != null ? onError(response.data) : null;
        // EasyLoading.dismiss();
        // EasyLoading.showError('Invalid request parameters');
      } else if (response.statusCode == 401) {
        onError != null ? onError(response) : null;
        // EasyLoading.showError('Session Expired !! Please Restart Application');
      } else if (response.statusCode == 403) {
        // EasyLoading.showError('Request Forbidden');
      } else if (response.statusCode == 404) {
        // EasyLoading.showError('Data Not Found');
      } else if (response.statusCode == 503) {
        // EasyLoading.showError('Service Unavailables');
      } else {
        // EasyLoading.showError("Didn't Get Data From API");
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString(), duration: const Duration(seconds: 6));
      debugPrint(e.toString());
    }
  }
}
