import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:flutter/foundation.dart';
import 'package:Happinest/api_service/base_services.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/utility/loader.dart';

class SignUPViewModel extends ChangeNotifier {
  // --Local Varibale ---
  String email = '';
  String password = '';
  bool loginSuccess = false;
  String error = '';

  String signUpAPI = ApiUrl.signUp;
  UserModel? userResponse;

  Future<UserModel?> signup(Map<String, dynamic> reqBody) async {
    notifyListeners();
    // Validate email and password here
    if (email.isEmpty || password.isEmpty) {
      error = 'Email and password are required';
      notifyListeners();
      return null;
    }

    // Make an API call for SignUP
    var response = await APIService().getResponse(
      url: signUpAPI,
      istoken: false,
      apitype: APIType.aPost,
      body: reqBody,
      header: {},
    );
  
    Loader.hideLoader();
    if (response != null) {
      // Successfully SingUp in
      loginSuccess = true;
      userResponse = UserModel.fromJson(response);
      
      notifyListeners();
      return userResponse;
    } else {
      // SingUp failed
      loginSuccess = false;
      error = 'SingUp failed. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> socialSignup(Map<String, dynamic> reqBody) async {
    notifyListeners();
    // Make an API call for SignUP
    var response = await APIService().getResponse(
        url: signUpAPI, apitype: APIType.aPost, body: reqBody, header: {}, istoken: false);
    if (kDebugMode) {
      print(' API Response==>$response');
    }
    Loader.hideLoader();
    if (response != null) {
      // Successfully SingUp in
      loginSuccess = true;
      userResponse = UserModel.fromJson(response);
      notifyListeners();
      return userResponse;
    } else {
      // SingUp failed
      loginSuccess = false;
      error = 'SingUp failed. Please try again.';
      notifyListeners();
      return null;
    }
  }
}
