import 'dart:developer';

import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:flutter/material.dart';
import 'package:Happinest/models/country_model.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:Happinest/utility/constants/constants.dart';

import '../models/tinmeline_category_model.dart';
import '../models/visibility_model.dart';
import '../utility/constants/images/image_name.dart';

List<CountryModel> countryData = [];
// List<TripTypeModel> tripTypeList = [];
List<TimelineCatogoryGroupsModel> timelineCategoryList = [];
UserModel? myProfileData;
bool storyVisibility = false;
bool setTheme = false;
List<VisibilityModel> visibilityList = [
  VisibilityModel('Private', 1, TImageName.visibilityPrivate),
  VisibilityModel('Public', 2, TImageName.visibilityPublic),
  VisibilityModel('Followers', 3, TImageName.visibilityFriends),
];

Future commonDefaultApis() {
  return Future.wait([
    CommonAPIFn.updateDivicetoken(),
    // CommonAPIFn.getCountry(),
    // CommonAPIFn.getTripType(),
    // CommonAPIFn.getTimelineCategory(),
    CommonAPIFn.getNotificationSettings()
  ]);
}

class CommonAPIFn {
  /*static Future getCountry() async {
    var url = dotenv.get('API_GetCountry');
    return ApiService.fetchApiWithoutContext(
      get: true,
      url: url,
      onSuccess: (value) {
        countryData = [];
        for (var element in (value as List)) {
          countryData.add(CountryModel.fromJson(element));
        }
      },
    );
  }*/

  static Future getNotificationSettings() async {
    var url = ApiUrl.getUserNotificationDetail;
    await ApiService.fetchApiWithoutContext(
      url: url,
      get: true,
      onSuccess: (res) {
        storyVisibility = res['publicTrips'].toString().toLowerCase() == 'true' ? true : false;
      },
    );
  }

  static Future updateDivicetoken() async {
    var url = ApiUrl.updateDeviceToken;
    if (fcmtoken != null) {
      return ApiService.fetchApiWithoutContext(
        params: {
          'token': fcmtoken.toString(),
        },
        url: url,
        onSuccess: (response) {
          log("divice token update = ${response.toString()}");
        },
        onError: (response) {
          log("divice token update error = ${response.toString()}");
        },
      );
    }
  }

  /*static Future getTripType() async {
    var url = dotenv.get('API_GetTripType');
    return ApiService.fetchApiWithoutContext(
      get: true,
      url: url,
      onSuccess: (value) {
        tripTypeList = [];
        for (var element in (value as List)) {
          tripTypeList.add(TripTypeModel.fromJson(element));
        }
      },
    );
  }*/

  /*static Future getTimelineCategory() async {
    var url = dotenv.get('API_GetCategoryGroups');
    ApiService.fetchApiWithoutContext(
      url: url,
      get: true,
      onSuccess: (value) {
        timelineCategoryList = [];
        for (var element in (value['catogoryGroups'] as List)) {
          timelineCategoryList
              .add(TimelineCatogoryGroupsModel.fromJson(element));
        }
        debugPrint(timelineCategoryList.toString());
      },
    );
  }*/
}
