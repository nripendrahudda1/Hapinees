import 'dart:developer';

import 'package:Happinest/modules/home/Models/setdashboard_data_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/modules/home/Models/dashoard_det_trip_data_model.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import '../../../core/api_urls.dart';
import '../../../models/create_event_models/create_wedding_models/event_category_collection_model.dart';
import '../../../models/popular_authors_model.dart';
import '../../../utility/constants/strings/parameter.dart';
import '../../profile/notification/notification_model.dart';
import '../Models/occasion_home_model.dart';

final homectr = ChangeNotifierProvider((ref) => HomeController());

class HomeController extends ChangeNotifier {
  String userID = '';
  String deviceID = '';
  ModelDashboardTripData? tripData;
  OccasionDashboardModel? occasionData;
  PopulerAuthorsModel? authorsList;
  EventCategoryCollection? storyCategoryList;
  EventCategoryCollection? searchstoryCategoryList;
  TextEditingController searchController = TextEditingController();
  List<Authors> searchPopularAuthor = [];
  List<TrendingOccasions> searchEvents = [];
  FocusNode searchFieldFocus = FocusNode();
  bool isSearching = false;
  bool isLoadingMore = true;
  List<Notifications>? notifications;
  List iconList = [
    TImageName.icTravel,
    TImageName.icOccasion,
    TImageName.icConcert,
    TImageName.icSports,
    TImageName.icStartup,
    TImageName.icTech,
    TImageName.icPremier
  ];

  List eventTypeList = [
    'Travel',
    'Occasion',
    'Concert',
    'Sports',
    'Startup',
    'Tech',
    'Premier',
  ];

  int selectedStoryCollection = 0;
  int searchSelectedStoryCollection = 0;
  int selectedStoryType = 0;
  final Set<int> triggeredTypes = {};
  void resetTriggeredTypes() {
    triggeredTypes.clear();
    notifyListeners();
  }

  resetHomeData() {
    userID = '';
    deviceID = '';
    tripData = null;
    occasionData = null;
  }

  onSearch(BuildContext context, {required bool isLoader}) async {
    searchFieldFocus.unfocus();
    onPopularAuthorSearch(context, isLoader: isLoader);
    await onEventSearch(context, isLoader: isLoader);
  }

  onPopularAuthorSearch(BuildContext context, {required bool isLoader}) async {
    if (searchController.text.isNotEmpty) {
      if (isLoader == true) {
        EasyLoading.show();
      }
      var url = '${ApiUrl.authentication}${searchController.text}/0/100/${ApiUrl.searchAuthor}';
      await ApiService.fetchApi(
        context: context,
        url: url,
        get: true,
        isLoader: isLoader,
        onSuccess: (response) {
          isSearching = false;
          searchPopularAuthor = [];
          response['authorList'] != null && (response['authorList'] as List).isNotEmpty
              ? (response['authorList'] as List).forEach((element) {
                  searchPopularAuthor.add(Authors.fromJson(element));
                })
              : null;
          EasyLoading.dismiss();
        },
      );
      notifyListeners();
    }
  }

  getNotifications(BuildContext context) async {
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    var url = '${ApiUrl.authentication}$userID/${true}/${ApiUrl.getNotifications}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (value) {
        print("-------notifications--------${notifications}");
        notifications = value['notifications'] ?? [];
        notifyListeners();
      },
    );
  }

  onEventSearch(BuildContext context, {required bool isLoader}) async {
    searchEvents = [];
    if (searchController.text.isNotEmpty) {
      if (isLoader) {
        EasyLoading.show();
      }
      var url = '${ApiUrl.occasion}${searchController.text}/1/1/100/${ApiUrl.searchOccasion}';
      print("---onEventSearch---${url}");
      await ApiService.fetchApi(
        context: context,
        url: url,
        get: true,
        isLoader: isLoader,
        onSuccess: (response) {
          isSearching = false;
          response['occasionStories'] != null && (response['occasionStories'] as List).isNotEmpty
              ? (response['occasionStories'] as List).forEach((element) {
                  searchEvents.add(TrendingOccasions.fromJson(element));
                })
              : null;
          EasyLoading.dismiss();
        },
      );
      notifyListeners();
    }
  }

  /*Future<String?> initUniLinks(BuildContext context) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final initialLink = await getInitialUri();
      String host = dotenv.get('HOST');
      if (initialLink != null && initialLink.host == host) {
        debugPrint(initialLink.toString());
        String? tripID = initialLink.queryParameters['tripID'];
        debugPrint("redirecting to $tripID");
        tripID != null
            ? Navigator.pushNamed(context, Routes.memoriesRoute,
                arguments: [tripID, null])
            : null;
        return initialLink.queryParameters['tripID'];
      } else {
        return null;
      }
    } on PlatformException {
      return null;
    }
  }*/

  getStoryCatagoryCollection(BuildContext context) async {
    String url = '${ApiUrl.event}${ApiUrl.getGetEventModules}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: true,
      onSuccess: (response) {
        storyCategoryList = EventCategoryCollection.fromJson(response);
        print('storyCategoryList ********** ${storyCategoryList?.modules?.length}');
        // getStoryCategoryOccasion(context, true);
        notifyListeners();
      },
    );
  }

  getStoryCategoryOccasion(
      BuildContext context, bool isLoader, SetDashboardgetModel setDashboardgetModeModel) async {
    String url = '${ApiUrl.event}${ApiUrl.getDashBoardOccasion}';
    print("API Calling ${url} --> Null");
    if (isLoader) {
      //EasyLoading.show(status: 'loading...');
    }
    await ApiService.fetchApi(
      context: context,
      url: url,
      params: setDashboardPostModelToJson(setDashboardgetModeModel),
      isLoader: isLoader,
      onSuccess: (response) {
        print("response ------------------ getStoryCategoryOccasion \n$response");
        if (response['statusCode'].toString() == "12") {
          isLoadingMore = false;
          EasyLoading.showError(response['validationMessage'].toString(),
              duration: const Duration(seconds: 6));
          Navigator.pushNamedAndRemoveUntil(context, Routes.loginRoute, (route) => false);
        } else {
           isLoadingMore = true;
          occasionData = OccasionDashboardModel.fromJson(response);
        }
        notifyListeners();
        EasyLoading.dismiss();
      },
      onError: (res) {
        print("onError ------------------ getStoryCategoryOccasion \n$res");
      },
    );
    // : EasyLoading();
  }

  getPopolarsAuthors(BuildContext context, bool isLoaderShow) async {
    var url = '${ApiUrl.authentication}${ApiUrl.getPopularAuthor}';
    if (isLoaderShow) {
      // EasyLoading.show(status: 'loading...');
    }
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      params: {TPParameters.offset: null, TPParameters.noOfRecords: null},
      isLoader: true,
      onSuccess: (res) {
        authorsList = PopulerAuthorsModel.fromJson(res);
        notifyListeners();
        EasyLoading.dismiss();
      },
    );
    return false;
  }

  Future<bool> doFollow(BuildContext context,
      {required String userId, required num followRequestStatus}) async {
    notifyListeners();
    final loginUserID = getUserID();
    var status = false;
    EasyLoading.show();
    var url =
        '${ApiUrl.authentication}$loginUserID/$userId/${ApiUrl.followUser}?${TPParameters.followRequestStatus}=$followRequestStatus';
    print({"---followUser url----${url}"});
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (res) {
        print("----FollowResponse -----${res}");
        status = true;
        EasyLoading.dismiss();
        return status;
      },
      onError: (res) {
        status = false;
        EasyLoading.dismiss();
        return status;
      },
    );

    notifyListeners();
    return status;
  }

  // Future deleteRequest(BuildContext context, {required String userId}) async {
  //   notifyListeners();
  //   var url = '${ApiUrl.authentication}$userId/${ApiUrl.deleteFollowerUser}';
  //   await ApiService.fetchApi(
  //     context: context,
  //     url: url,
  //     isLoader: false,
  //     get: true,
  //     onSuccess: (res) {},
  //   );
  // }

  getDetails(
    BuildContext context,
    SetDashboardgetModel setDashboardgetModeModel,
  ) async {
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    deviceID = PreferenceUtils.getString(PreferenceKey.deviceID);
    await getStoryCatagoryCollection(context);
    await getUserDetails(context);
    await getPopolarsAuthors(context, authorsList == null ? true : false);
    // getTripData(context);
    // commonDefaultApis().then((value) => notifyListeners());
    await getStoryCategoryOccasion(
        context, occasionData == null ? true : false, setDashboardgetModeModel);
    // getTripData(context);
    // commonDefaultApis().then((value) => notifyListeners());
    //await getStoryCategoryOccasion(context, true);
    // initUniLinks(context);
    await getNotifications(context);
  }

  getUserDetails(
    BuildContext context,
  ) async {
    try {
      userID = (PreferenceUtils.getString(PreferenceKey.userId) == ''
          ? PreferenceUtils.getString(PreferenceKey.serveruserId)
          : PreferenceUtils.getString(PreferenceKey.serveruserId));
      var url = '${ApiUrl.authentication}$userID/${ApiUrl.getUserDetails}';
      await ApiService.fetchApi(
        context: context,
        url: url,
        get: true,
        isLoader: false,
        onSuccess: (response) {
          myProfileData = UserModel.fromJson(response);
          notifyListeners();
        },
      );
    } catch (e) {
      log("error in get user details == ${e.toString()}");
    }
  }
}
