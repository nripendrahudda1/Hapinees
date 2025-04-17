import 'dart:developer';

import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/modules/profile/model/setProfile_user_model.dart';
import 'package:Happinest/modules/profile/model/stories_model.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../common/common_default_apis.dart';
import '../../../models/popular_authors_model.dart';
import '../../../utility/API/fetch_api.dart';
import '../../account/usermodel/usermodel.dart';
import '../../setting screen/settings_model.dart';
import '../apis/profile_apis.dart';
import '../model/stories_model.dart';

final profileCtr = ChangeNotifierProvider((ref) {
  final dioClient = ref.watch(profileApisController);
  return ProfileController(repo: dioClient);
});

class ProfileController extends ChangeNotifier {
  final ProfileDatasource _repo;
  ProfileController({required ProfileDatasource repo})
      : _repo = repo,
        super();
  List<Stories>? stories;
  CompanySettings? data;
  UserModel? profileData;
  bool isOtherProfile = false;
  int userProCurrPage = 0;
  int currEventPage = 0,
      selectedFavType = 0,
      currFavPostPage = 0,
      currFavLocationPage = 0,
      currFavEventsPage = 0,
      currFavAuthorPage = 0;
  PopulerAuthorsModel? authorsList;
  PageController pageController = PageController(viewportFraction: 0.47);
  final ScrollController scrollController = ScrollController();
  final ScrollController eventController = ScrollController();
  final ScrollController favAuthorsController = ScrollController();
  final ScrollController favPostController = ScrollController();
  final ScrollController favLocationController = ScrollController();
  final ScrollController favEventsController = ScrollController();

  bool isEventScrollingFromPinCLick = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  List<String> favTypeList = ["Authors", "Events", "Location", "Post"];

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
    try {
      var url = '${ApiUrl.authentication}$userID/${ApiUrl.getUserDetails}';
      await ApiService.fetchApi(
        context: context,
        url: url,
        get: true,
        isLoader: false,
        onSuccess: (response) {
          profileData = UserModel.fromJson(response);
          isOtherProfile ? null : myProfileData = profileData;
          notifyListeners();
        },
      );
    } catch (e) {
      log("error in get user details == ${e.toString()}");
    }
  }

  filteredHostedPosts(bool isMyFeed /*String? momentName*/) {
    stories = [];
    if (isMyFeed) {
      print("filteredMomentsPosts $stories");
      stories?.forEach((post) {
        // post.postMedias?.forEach((media) {
        //   if(media.ritualName == momentName){
        // _personalEventPosts.add(post);
        // }
        // });
        if (post.createdBy?.email.toString() == PreferenceUtils.getString(PreferenceKey.email)) {
          stories?.add(post);
        }
      });
    } else {
      // stories?.addAll(_personalEventAllMemoriesModel?.personalEventPosts ?? []);
    }
    notifyListeners();
  }

  getMyStory(
    SetProfileModel setProfilegetModeModel,
    BuildContext context,
    bool isLoader,
  ) async {
    if (isLoader) {
      _isLoading = true;
      EasyLoading.show();
      var url = '${ApiUrl.authentication}${ApiUrl.getStories}';
      await ApiService.fetchApi(
        context: context,
        url: url,
        params: setProfilePostModelToJson(setProfilegetModeModel),
        isLoader: isLoader,
        onSuccess: (res) {
          debugPrint(res.toString());
          if (res['statusCode'].toString() == '1') {
            stories = [];
            for (var element in (res['stories'] as List)) {
              stories?.add(Stories.fromJson(element));
            }
          } else {
            // EasyLoading.showError(res['validationMessage'].toString());
          }
          if (stories != null && stories != []) {
            stories?.sort(
              (a, b) =>
                  DateTime.parse(b.startDate ?? '').compareTo(DateTime.parse(a.startDate ?? '')),
            );
          }
          _isLoading = false;
        },
      );
    }
    _isLoading = false;
    notifyListeners();
    EasyLoading.dismiss();
    return false;
  }

  getFavAuthors(BuildContext context) async {
    var url = '${ApiUrl.authentication}${ApiUrl.getPopularAuthor}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      params: {'offset': null, 'noOfRecords': null},
      isLoader: true,
      onSuccess: (res) {
        authorsList = PopulerAuthorsModel.fromJson(res);
        notifyListeners();
      },
    );
    return false;
  }

  // void animateToUserProfile(int index) {
  //   double itemWidth = 0.34.sw;
  //   double separatorWidth = 20.w;
  //   double targetPosition = index * (itemWidth + separatorWidth);
  //   updateMapScrollingAction(true);
  //   scrollController.animateTo(
  //     targetPosition,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  // }

  void animateToUserProfile(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 20.w;
    double totalItemWidth = itemWidth + separatorWidth;

    double viewportWidth = dwidth ?? 0; // Total available width
    double centerOffset = (viewportWidth / 2) - (itemWidth / 2); // Center the item

    double targetPosition = (index * totalItemWidth) - centerOffset;
    targetPosition =
        targetPosition.clamp(0, scrollController.position.maxScrollExtent); // Prevent overflow

    updateMapScrollingAction(true);
    scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void animateToEventPage(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double totalItemWidth = itemWidth + separatorWidth;

    double viewportWidth = dwidth ?? 0; // Get viewport width
    double centerOffset = (viewportWidth / 2) - (itemWidth / 2); // Center the item

    double targetPosition = (index * totalItemWidth) - centerOffset;

    // Ensure targetPosition is within the valid scroll range
    targetPosition = targetPosition.clamp(0, eventController.position.maxScrollExtent);

    updateMapScrollingAction(true);
    eventController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void updateMapScrollingAction(bool action) {
    isEventScrollingFromPinCLick = action;
    notifyListeners();
  }

  void animateToFavPostPage(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double targetPosition = index * (itemWidth + separatorWidth);

    favPostController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void animateToFavLocationPage(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double targetPosition = index * (itemWidth + separatorWidth);

    favLocationController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void animateToFavEventPage(int index) {
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double targetPosition = index * (itemWidth + separatorWidth);

    favEventsController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
