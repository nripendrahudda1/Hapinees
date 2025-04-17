import 'dart:developer';

import 'package:Happinest/api_service/base_services.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';

class ProfileViewModel extends ChangeNotifier {
  String displayName = '';
  String firstName = '';
  String lastName = '';
  String mobile = '';
  String abount = '';
  String dob = '';
  String address = '';
  String dietpreference = '';
  bool loginSuccess = false;
  String error = '';
  UserModel? userResponse;

// --- API Request Methods ---
  String updateProfile = ApiUrl.updateUserProfile;
  String updateProfilePicture = ApiUrl.updateUserPicture;
  String updateBackgroundImage = ApiUrl.updateBackgroundPicture;

// --- Update Profile Request ---
  Future<UserModel?> updateUserProfile(
      Map<String, dynamic> reqBody, BuildContext context) async {
    // --- Make an API call for login ---
    var response = await APIService().getResponse(
      url: updateProfile,
      apitype: APIType.aPost,
      body: reqBody,
    );
    Loader.hideLoader();
    if (response != null) {
      // Successfully logged in
      loginSuccess = true;
      log('signup successfully');
      userResponse = UserModel.fromJson(response);
      log(userResponse.toString());
      userResponse != null ? Utility.saveData(userResponse!, context,isUpdate: true) : null;
      log('signup successfully');
      notifyListeners();
      log('signup successfully');
      return userResponse;
    } else {
      // SignUp failed
      loginSuccess = false;
      error = 'Login failed. Please try again.';
    }
    notifyListeners();
    return null;
  }
}
