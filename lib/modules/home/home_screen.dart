import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/modules/home/Models/occasion_home_model.dart';
import 'package:Happinest/modules/home/Models/setdashboard_data_model.dart';
import 'package:Happinest/modules/home/widget/Shimmer_widget.dart';
import 'package:Happinest/modules/home/widget/home_story_type.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/modules/home/widget/home_popular_author.dart';
import 'package:Happinest/modules/home/widget/home_search_page.dart';
import 'package:Happinest/modules/profile/notification/notification_model.dart';
import 'package:Happinest/modules/profile/notification/notification_screen.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'Controllers/home_controller.dart';
import 'widget/home_story_collection.dart';
import 'widget/home_stroy_list_of_collection.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double blurIntensity = 0.0;
  bool isLoading = false, headerCollection = false;
  Color headerTextColor = TAppColors.white;
  final GlobalKey _homeSearchKey = GlobalKey();
  final GlobalKey _popularAuthorsKey = GlobalKey();
  final GlobalKey _storyCollectionKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();
  double _headerHeight = 0.08.sh;
  bool isHeaderHeightSet = false;
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  SetDashboardgetModel model = SetDashboardgetModel();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true && isFirst) {
      final _ = ref.read(homectr);
      setState(() {});
    }
    isFirst = true;
  }

  @override
  void initState() {
    print("home_screen_init call -----------------------------------");
    _scrollController.addListener(_onScroll);
    readNumberOfNotification();
    final _ = ref.read(homectr);
    final deviceID = PreferenceUtils.getString(PreferenceKey.deviceID);
    model = SetDashboardgetModel(
      offset: 1,
      noOfRecords: 10,
      deviceId: deviceID,
      sortEventsBy: "Trending",
      moduleId: 1,
    );
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _.tripData == null ? _.getDetails(context, model) : null;
    // _startNotificationFetching();
    super.initState();
  }

  void _startNotificationFetching() {
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      getNotifications(context); // Call the notification fetching function every 4 seconds
    });
  }

  int counter = 0;

  void readNumberOfNotification() async {
    final prefs = await SharedPreferences.getInstance();

// Try reading the counter value from persistent storage.
// If not present, null is returned, so default to 0.
    setState(() {
      counter = prefs.getInt('NotificationCounter') ?? 0;
    });
  }

  bool unReadOnly = true;
  NotificationModel? notificationData;
  List<Notifications> notificationList = [];
  int totalNotification = 0;

  String userID = '';
  String formattedDateTime = DateFormat("yyyy-MM-ddTHH:mm:ss.SS").format(DateTime.now());
  Timer? _timer; // Declare a Timer variable
  getNotifications(BuildContext context) async {
    notificationList = [];
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    var url = '${ApiUrl.authentication}$userID/$unReadOnly/${ApiUrl.getNotifications}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: true,
      onSuccess: (value) {
        setState(() {
          for (var element in (value['notifications'] ?? [])) {
            setState(() {
              notificationList.add(Notifications.fromJson(element));
            });
          }
        });
        setState(() async {
          if (totalNotification != notificationList.length) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setInt('NotificationCounter', notificationList.length);
            readNumberOfNotification();
            totalNotification = notificationList.length;
          }
        });
      },
    );
  }

  double? latitude;
  double? longitude;

  Future<void> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    print('Current Location Permission Status = $permission');
  }

  Future<void> locationServicesStatus() async {
    //  Geolocator.getLastKnownPosition();
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Currently, the emulator\'s Location Services Status = $isLocationServiceEnabled');
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _getHeaderHeight() {
    final headerContext = _headerKey.currentContext;
    final RenderBox? renderBox = headerContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      if (_headerHeight != (renderBox.size.height) - (topSfarea)) {
        setState(() {
          if (_headerHeight != 0.08.sh) {
            isHeaderHeightSet = true;
          }
          _headerHeight = (renderBox.size.height) - (topSfarea);
        });
      }
    }
  }

  void _onScroll() {
    double scrollPosition = _scrollController.position.pixels;
    double screenHeight = MediaQuery.of(context).size.height;
    double scrollPercentage = scrollPosition / screenHeight;
    int scrollPosition2 = screenHeight.toInt() ~/ 2.1;
    setState(() {
      blurIntensity = scrollPosition > 0 ? (scrollPercentage * 70).clamp(0.0, 30.0) : 0;
      headerCollection = scrollPosition.toInt() > scrollPosition2;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final popularContext = _popularAuthorsKey.currentContext;
      final storyContext = _storyCollectionKey.currentContext;
      final searchContext = _homeSearchKey.currentContext;
      if (popularContext != null && storyContext != null && searchContext != null) {
        final popularBox = popularContext.findRenderObject() as RenderBox;
        final storyBox = storyContext.findRenderObject() as RenderBox;
        final searchBox = searchContext.findRenderObject() as RenderBox;
        double popularPosition = popularBox.localToGlobal(Offset.zero).dy;
        double storyPosition = storyBox.localToGlobal(Offset.zero).dy;
        double searchPosition = searchBox.localToGlobal(Offset.zero).dy;
        if (storyPosition <= 0 + 80) {
          setState(() {
            headerTextColor = TAppColors.white;
          });
        } else if (popularPosition <= 0 - 20) {
          // tweak 20 as a threshold
          setState(() {
            headerTextColor = TAppColors.text1Color;
          });
        } else if (searchPosition < 75 && searchPosition > 0) {
          setState(() {
            headerTextColor = TAppColors.text1Color;
          });
        } else {
          setState(() {
            headerTextColor = TAppColors.white;
          });
        }
      }
    });

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    print(
        "--------_scrollController.position.maxScrollExtent----${_scrollController.position.maxScrollExtent}");
    final _ = ref.read(homectr);
    if (scrollPosition >= _scrollController.position.maxScrollExtent - 250 && _.isLoadingMore) {
      _.isLoadingMore = false;
      model.noOfRecords = model.noOfRecords! + 10;
      model.offset = 1;
      _.getStoryCategoryOccasion(context, true, model);
    }
  }

  bool isAllOccasionDataEmptyOrNull(OccasionDashboardModel? data) {
    if (data == null) return true;
    final allOccasions = [
      data.trendingOccasions,
      data.popularOccasions,
      data.recommendedOccasions,
      data.recentOccasions,
    ];
    // If all are null or empty
    return allOccasions.every((list) => list == null || list.isEmpty);
  }

// Check all data is empty
  bool isAllOccasionListsEmpty(OccasionDashboardModel? data) {
    return (data?.trendingOccasions?.isEmpty ?? true) &&
        (data?.popularOccasions?.isEmpty ?? true) &&
        (data?.recommendedOccasions?.isEmpty ?? true) &&
        (data?.recentOccasions?.isEmpty ?? true);
  }

  @override
  Widget build(BuildContext context) {
    final _ = ref.watch(homectr);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /*myProfileData != null
              ? CachedRectangularNetworkImageWidget(
                  errorWidget:
                      Image.asset(TImageName.homeBg, fit: BoxFit.cover),
                  image: myProfileData!.userBackgroundPictureUrl ?? '',
                  width: 1.sw,
                  height: 0.5.sh)
              : Image.asset(TImageName.homeBg, fit: BoxFit.cover),*/
          Container(
              height: MediaQuery.of(context).size.height,
              // height: 0.5.sh,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff003254),
                    Color(0xff002F50),
                  ],
                ),
              )),
          Container(
              height: MediaQuery.of(context).size.height,
              // height: 0.5.sh,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00ffffff),
                    Color(0xCCFFFFFF),
                  ],
                ),
              )),
          SmartRefresher(
            onRefresh: () async {
              setState(() {
                isLoading = true;
              });
              // await _.getTripData(context, isLoader: false);
              _refreshController.refreshCompleted();
              setState(() {
                isLoading = false;
              });
            },
            controller: _refreshController,
            scrollController: _scrollController,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: topSfarea > 0 ? topSfarea : 0.05.sh,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: _headerHeight),
                    homePageSearchField(),
                    SizedBox(height: 15.h),
                    _.authorsList == null
                        ? ShimmerBox(height: 110.h, width: double.infinity)
                        : HomePopularAuthors(
                            key: _popularAuthorsKey,
                            listOfAuthors: _.authorsList?.authors ?? [],
                            authorsname: TLabelStrings.explorePopular,
                            authorsColor: TAppColors.white,
                            isFollowShow: true,
                            onDataUpdated: () {
                              setState(() {});
                            },
                          ),
                    SizedBox(height: 15.h),
                    _.storyCategoryList?.modules == null
                        ? ShimmerBox(height: 100.h, width: double.infinity)
                        : HomePageStoryCollection(
                            key: _storyCollectionKey,
                            model: model,
                          ),
                    SizedBox(height: 15.h),
                    if (!headerCollection) const HomePageStoryType(),
                    Padding(
                      padding: const EdgeInsets.only(right: 7.5, left: 7.5),
                      child: _.occasionData == null
                          ? ShimmerBox(height: 220.h, width: double.infinity)
                          : isAllOccasionDataEmptyOrNull(_.occasionData)
                              ? const SizedBox() // Optional: your own widget
                              : HomePageStoryTypeCollection(model: model),
                    ),
                    // if (_.isLoadingMore)
                    //   SizedBox(
                    //     height: 40.h,
                    //     child: const Center(
                    //       child: CircularProgressIndicator(color: TAppColors.themeColor),
                    //     ),
                    //   ),
                    SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
          !isLoading
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 0.1.sh, // Adjust the height as needed
                          decoration: blurIntensity > 0
                              ? BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                      TAppColors.themeColor.withOpacity(0.4),
                                      TAppColors.white.withOpacity(0.1)
                                    ]))
                              : null,
                          child: homePageHeader(myProfileData),
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget homePageSearchField() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15),
      child: GestureDetector(
        key: _homeSearchKey,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeSearchPage(),
              )).then(
            (value) {
              final _ = ref.read(homectr);
              _.getPopolarsAuthors(context, false);
              _.getStoryCategoryOccasion(context, false, model);
            },
          );
        },
        child: TCard(
            height: 40.h,
            color: TAppColors.white.withOpacity(0.9),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.h),
              child: Row(
                children: [
                  Image.asset(
                    TImageName.search,
                    height: 20.h,
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: CTTextField(
                      isAutoFocus: false,
                      isEnabled: false,
                      maxLines: 1,
                      hint: 'Search Authors, Stories or Locations',
                      fontSize: 14,
                    ),
                  )),
                ],
              ),
            )),
      ),
    );
  }

  String getGreeting() {
    final currentTime = DateTime.now().hour;
    if (currentTime >= 5 && currentTime < 12) {
      return 'Good Morning';
    } else if (currentTime >= 12 && currentTime < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  Widget homePageHeader(UserModel? userProfileData) {
    final _ = ref.watch(homectr);
    if (!isHeaderHeightSet) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _getHeaderHeight();
      });
    }
    return CustomSafeArea(
      key: _headerKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Platform.isIOS) topPadding(topPadding: topSfarea + 4.h, offset: 30.h),
          Padding(
            padding: const EdgeInsets.only(right: 19, top: 5, left: 15),
            child: Row(
              children: [
                Image.asset(
                  TImageName.logoSmall,
                  width: 32.w,
                  height: 32.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: TText(
                        userProfileData != null
                            ? userProfileData.firstName != ''
                                ? '${getGreeting()}, ${userProfileData.firstName ?? ''}!'
                                : getGreeting()
                            : '',
                        color: headerTextColor,
                        fontSize: MyFonts.size18,
                        fontWeight: FontWeightManager.bold),
                  ),
                ),
                SizedBox(
                  width: 5.h,
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final _ = ref.read(homectr);
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 2,
                          ),
                          child: iconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotificationScreen(
                                              notifications: _.notifications,
                                            ))).then((value) {
                                  _.getNotifications(context);
                                });
                              },
                              radius: 33,
                              iconPath: TImageName.notificationBell,
                              bgColor: TAppColors.white),
                        ),
                        if (counter > 0)
                          Positioned(
                            right: -1,
                            top: -4,
                            child: TCard(
                                shape: BoxShape.circle,
                                border: true,
                                borderWidth: 1.5,
                                borderColor: TAppColors.buttonRed,
                                color: TAppColors.white,
                                radius: 50,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                                  child: TText((counter.toString()),
                                      color: TAppColors.buttonRed,
                                      fontSize: MyFonts.size13,
                                      fontWeight: FontWeight.w900),
                                )),
                          )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 7.h,
          ),
          if (_.storyCategoryList != null && headerCollection)
            Padding(
                padding: const EdgeInsets.only(right: 19, top: 0, left: 15),
                child: TText(
                    "${_.storyCategoryList?.modules?[_.selectedStoryCollection].moduleName.toString()} Collection",
                    fontSize: MyFonts.size16,
                    color: TAppColors.text1Color,
                    fontWeight: FontWeightManager.bold)),
          if (_.storyCategoryList != null && headerCollection)
            SizedBox(
              height: 9.h,
            ),
          if (headerCollection) const HomePageStoryType(),
        ],
      ),
    );
  }
}
