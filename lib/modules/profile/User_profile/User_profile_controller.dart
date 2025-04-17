import 'dart:developer';
import 'dart:ffi';
import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/modules/profile/model/setProfile_user_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../utility/API/fetch_api.dart';
import '../../account/usermodel/usermodel.dart';
import '../../setting screen/settings_model.dart';
import '../model/stories_model.dart';

final userprofileCtr = ChangeNotifierProvider((ref) => UserprofileController());

class UserprofileController extends ChangeNotifier {
  List<Stories>? stories;
  CompanySettings? data;
  UserModel? profileData;
  bool isOtherProfile = false;

  getCompanySettings(BuildContext context, bool loader) async {
    var url = '${ApiUrl.authentication}${ApiUrl.getCompanySetting}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: loader,
      isLoader: false,
      onSuccess: (res) {
        data = CompanySettings.fromJson(res);
        notifyListeners();
      },
    );
  }

  getUserDetails(BuildContext context, String userID) async {
    var url = '${ApiUrl.authentication}$userID/${ApiUrl.getUserDetails}';
    EasyLoading.show();
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (response) {
        profileData = UserModel.fromJson(response);
        // isOtherProfile ? null : myProfileData = profileData;
        notifyListeners();
        EasyLoading.dismiss();
      },
      onError: (res) {
        log("error in get user data == ${res.toString()}");
        EasyLoading.dismiss();
      },
    );
  }

  getMyStory(SetProfileModel setProfilegetModeModel, BuildContext context,
      {required bool isLoader}) async {
    var url = '${ApiUrl.authentication}${ApiUrl.getStories}';
    if (isLoader) {
      EasyLoading.show();

      await ApiService.fetchApi(
        context: context,
        url: url,
        params: setProfilePostModelToJson(setProfilegetModeModel),
        isLoader: isLoader,
        onSuccess: (res) {
          debugPrint('res.toString()');
          debugPrint(res.toString());
          if (res['statusCode'].toString() == '1') {
            stories = [];
            for (var element in (res['stories'] as List)) {
              stories?.add(Stories.fromJson(element));
            }
          } else if (res['statusCode'].toString() == '4') {
            print("statusCode ******** 4");
            stories = null;
          } else {
            EasyLoading.showError(res['validationMessage'].toString());
          }

          if (stories != null && stories != []) {
            stories?.sort(
              (a, b) =>
                  DateTime.parse(b.startDate ?? '').compareTo(DateTime.parse(a.startDate ?? '')),
            );
          }

          EasyLoading.dismiss();
        },
      );
    } else {
      log("user id not found");
      EasyLoading.dismiss();
      EasyLoading.showError("user id not found");
    }
    notifyListeners();
    return false;
  }
}
