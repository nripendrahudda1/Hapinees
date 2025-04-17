import 'package:flutter/foundation.dart';
import 'package:Happinest/api_service/base_services.dart';
import 'package:Happinest/utility/loader.dart';

class VerifyViewModel extends ChangeNotifier {
  String pincode = '';
  bool loginSuccess = false;
  String error = '';

  /*Future<void> verifyOTP(Map<String, dynamic> reqBody) async {
    notifyListeners();

    // Validate pin and password here
    if (pincode.isEmpty) {
      error = 'OTP is required';
      notifyListeners();
      return;
    }

    // Make an API call
    var response = await APIService().getResponse(
        url: signUpAPI, apitype: APIType.aPost, body: reqBody, header: {}, istoken: false);
    if (kDebugMode) {
      // print(' API Response==>$response');
    }
    Loader.hideLoader();
    if (kDebugMode) {
      print(' API Response==>$response');
    }
    if (response.statusCode == 200) {
      // Successfully Send OTP in
      loginSuccess = true;
    } else {
      // Opt failed
      loginSuccess = false;
      error = 'Opt verified failed. Please try again.';
    }
    notifyListeners();
  }*/
}
