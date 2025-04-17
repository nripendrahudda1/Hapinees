import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:flutter/foundation.dart';
import 'package:Happinest/api_service/base_services.dart';
import 'package:Happinest/utility/loader.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  String email = '';
  bool loginSuccess = false;
  String error = '';
  String forgotPassword = ApiUrl.resetPassword;
  String auth = ApiUrl.authentication;

  Future<void> forgotPasswod(String emailID) async {
    notifyListeners();
    // Validate email
    if (email.isEmpty) {
      error = 'Email are required';
      notifyListeners();
      return;
    }

    // Make an API call for ForgotPassword
    var response = await APIService().getResponse(
        url: "$auth$emailID/$forgotPassword",
        apitype: APIType.aGet,
        header: {});
    if (kDebugMode) {}
    Loader.hideLoader();
    if (response != null) {
      loginSuccess = response['responseStatus'];
      error = response['validationMessage'];
    } else {
      loginSuccess = false;
      error = 'Enter valid email';
    }

    notifyListeners();
  }
}
