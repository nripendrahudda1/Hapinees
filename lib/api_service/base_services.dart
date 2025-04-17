import 'dart:convert';
import 'dart:io';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:Happinest/utility/loader.dart';
import 'package:Happinest/utility/preferenceutils.dart';
import 'app_exception.dart';

enum APIType { aPost, aGet, aPut, aPatch }

class APIService {
  var response;
  static String baseURL_ = ApiUrl.baseURL;
  static String contentType = ApiUrl.contentTypeHeader;

  Future getResponse(
      {required String url,
      bool istoken = true,
      APIType? apitype,
      Map<String, dynamic>? body,
      Map<String, String>? header,
      bool fileUpload = false}) async {
    var token = PreferenceUtils.getString(PreferenceKey.accessToken);
    print("Bearer $token");
    Map<String, String> headers = istoken
        ? {'Content-Type': contentType, 'Authorization': "Bearer $token"}
        : {'Content-Type': contentType};
    try {
      if (apitype == APIType.aGet) {
        final result =
            await http.get(Uri.parse(baseURL_ + url), headers: headers);
        response = returnResponse(result.statusCode, result.body);
      } else if (apitype == APIType.aPost) {
        debugPrint("--REQUEST PARAMETER URL--  $url");
        debugPrint("---REQUEST PARAMETER-- $body");
        debugPrint("---REQUEST BaseURL-- $baseURL_");
        debugPrint("--headers ---$headers");
        final result = await http.post(Uri.parse(baseURL_ + url),
            body: json.encode(body), headers: headers);

        debugPrint("resp${result.body}");
        debugPrint(result.statusCode.toString());
        response = returnResponse(result.statusCode, result.body);
      } else if (apitype == APIType.aPut) {
        final result =
            await http.put(Uri.parse(baseURL_ + url), headers: headers);
        response = returnResponse(result.statusCode, result.body);
        //debugPrint("RES status code ${result.statusCode}");
        //debugPrint("res${result.body}");
      }
    } on SocketException {
      throw FetchDataException('No Internet access');
    }

    return response;
  }

  returnResponse(int status, String result) {
    Loader.hideLoader();
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 201:
        return jsonDecode(result);
      case 400:
        return jsonDecode(result);
      case 401:
        throw UnauthorisedException('Unauthorised user');
      case 404:
        throw ServerException('Server Error');
      case 500:
      default:
        throw FetchDataException('Internal Server Error');
    }
  }
}
