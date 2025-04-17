import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:flutter/foundation.dart';
import 'package:Happinest/api_service/base_services.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/utility/loader.dart';

import '../../../../common/common_default_apis.dart';
import '../../../../utility/preferenceutils.dart';

class LoginViewModel extends ChangeNotifier {
  String email = '';
  String password = '';
  bool loginSuccess = false;
  String error = '';
  String signInAPI = ApiUrl.signIn;

  UserModel? userResponse;

  Future<UserModel?> login(Map<String, dynamic> reqBody) async {
    notifyListeners();

    // Validate email and password here
    if (email.isEmpty || password.isEmpty) {
      error = 'Email and password are required';
      notifyListeners();
      return null;
    }
    // Make an API call for login
    var response = await APIService().getResponse(
        url: signInAPI, istoken: false, apitype: APIType.aPost, body: reqBody, header: {});
    Loader.hideLoader();
    if (response != null) {
      // Successfully logged in
      loginSuccess = true;
      userResponse = UserModel.fromJson(response);
      print('userViewModel.userResponse!.token.toString() *****************');
      print(userResponse?.token.toString());
      myProfileData = userResponse;
      return userResponse;
    } else {
      // SignUp failed
      loginSuccess = false;
      error = 'Login failed. Please try again.';
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> socialLogin(Map<String, dynamic> reqBody) async {
    notifyListeners();
    // Make an API call for login
    var response = await APIService().getResponse(
      url: signInAPI,
      apitype: APIType.aPost,
      body: reqBody,
      header: {},
      istoken: false,
    );
    if (kDebugMode) {}
    Loader.hideLoader();
    if (response != null) {
      // Successfully logged in
      loginSuccess = true;
      userResponse = UserModel.fromJson(response);
      myProfileData = userResponse;
      // if (userResponse != null &&
      //     userResponse!.runningTripId != null &&
      //     userResponse!.runningTripId != 0) {
      //   PreferenceUtils.setString(PreferenceKey.liveTripId, userResponse!.runningTripId.toString());
      //   PreferenceUtils.setString(
      //       PreferenceKey.minDistance, userResponse!.minDistanceForLocationTracking.toString());
      //   PreferenceUtils.setString(
      //       PreferenceKey.minDuration, userResponse!.minDurationForLocationTracking.toString());
      //   PreferenceUtils.setString(
      //       PreferenceKey.liveTripName, userResponse!.runningTripName.toString());
      //   PreferenceUtils.setString(
      //       PreferenceKey.liveTripTypeID, userResponse!.travelTypeId.toString());
      // }
      return userResponse;
    } else {
      // SignUp failed
      loginSuccess = false;
      error = 'Login failed. Please try again.';
      notifyListeners();
      return null;
    }
  }
}
