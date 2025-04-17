// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/explore/explore_screen.dart';
import 'package:Happinest/modules/home/home_screen.dart';
import 'package:Happinest/modules/profile/profile_screen.dart';
import 'package:Happinest/modules/tabbar/widget/circular_menu.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'dart:math' as math;

import '../../utility/constants/strings/error_message.dart';
import '../near_by/near_by_screen.dart';

class BottomTabBarScreen extends ConsumerStatefulWidget {
  final int initialIndex;
  const BottomTabBarScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  ConsumerState<BottomTabBarScreen> createState() => _BottomTabBarScreenState();
}

class _BottomTabBarScreenState extends ConsumerState<BottomTabBarScreen> {
  int _currentIndex = 0;
  bool isCenterclicked = false;
  bool _isLoading = false;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();
  late AnimationController animationController;
  var liveTripId = PreferenceUtils.getString(PreferenceKey.liveTripId);
  bool isTripStarted = false;
  final List<NavItem> _navItems = [
    NavItem(icon: TImageName.btmHome, title: TButtonLabelStrings.home, page: const HomeScreen()),
    // NavItem(
    //     icon: TImageName.btmExplore,
    //     title: TButtonLabelStrings.explore,
    //     page: const ExploreScreen()),
    NavItem(
        icon: TImageName.btmExplore,
        title: "",
        page: const HomeScreen()), // ignore this widget its just for spacing
    // NavItem(
    //     icon: TImageName.btmNearBy,
    //     title: "Near By",
    //     page: const NearByScreen()),
    NavItem(icon: TImageName.btmProfile, title: "Profile", page: const ProfileScreen()),
  ];
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /*Future stopTrip() async {
    try {
      EasyLoading.show();
      await Geolocator.requestPermission();
      await locationServicesStatus();
      await checkLocationPermissions();
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      String url = dotenv.get("API_EndTrip");
      await ApiService.fetchApi(
        context: context,
        url: url,
        params: {
          "tripId": PreferenceUtils.getString(PreferenceKey.liveTripId),
          "tripName": PreferenceUtils.getString(PreferenceKey.liveTripName),
          "travelTypeId":
          PreferenceUtils.getString(PreferenceKey.liveTripTypeID),
          "endTime": nowutc(isLocal: true),
          "endLocationCoordinateLongitude": position.longitude.toString(),
          "endLocationCoordinateLatitude": position.latitude.toString(),
          "tripStepsCount": 100,
          "tripStairsCount": 150
        },
        onSuccess: (response) async {
          // Navigator.pop(context);
          log("validationMessage == ${response['validationMessage'].toString()}");
          if (response['validationMessage'].toString() == 'null') {
            PreferenceUtils.setString(PreferenceKey.minDistance, '');
            PreferenceUtils.setString(PreferenceKey.minDuration, '');
            PreferenceUtils.setString(PreferenceKey.liveTripName, '');
            PreferenceUtils.setString(PreferenceKey.liveTripTypeID, '');
            Navigator.pushNamed(context, Routes.memoriesRoute, arguments: [
              PreferenceUtils.getString(PreferenceKey.liveTripId).toString(),
              null
            ]);
            PreferenceUtils.setString(PreferenceKey.liveTripId, '');
            if (liveTripId != "") {
              clearTripData();
              liveTripId = "";
            }
            EasyLoading.showSuccess("Trip Stopped Successfully!");

            setState(() {});
          } else {
            EasyLoading.showError(response['validationMessage'].toString());
          }
        },
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
      Future.delayed(const Duration(seconds: 2), () {
        if (e.toString().contains(
            "User denied permissions to access the device's location")) {
          Geolocator.openAppSettings();
        }
      });
    }
  }*/

  Future<void> checkLocationPermissions() async {
    LocationPermission permission = await Geolocator.requestPermission();
    liveTripId = PreferenceUtils.getString(PreferenceKey.liveTripId);
    if (liveTripId != '') {
      if (Platform.isAndroid) {
        // Android-specific code
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }
      } else if (Platform.isIOS) {
        // iOS-specific code
        if (permission == LocationPermission.always) {
          setState(() => _isLoading = true);
        } else {
          setState(() => _isLoading = false);
        }
      }
    }
    print('--permission --$permission');
    print('_isLoading --$_isLoading');
  }

  Future<void> locationServicesStatus() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print('Currently, the emulator\'s Location Services Status = $isLocationServiceEnabled');
  }

  @override
  void initState() {
    super.initState();
    checkLocationPermissions();
    _currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('index')) {
        setState(() {
          _currentIndex = args['index']; // Assign the passed index
        });
      }
    });
  }

  Widget loadData(BuildContext context) {
    if (liveTripId != '') {
      return Container(
        color: TAppColors.buttonRed,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Text(
            TPErrorStrings.locationEnableError,
            style: TextStyle(
              fontSize: MyFonts.size16,
              fontWeight: FontWeight.bold,
              color: TAppColors.primary500,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageStorage(bucket: _pageStorageBucket, child: _navItems[_currentIndex].page),
        bottomNavigationBar: SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: Container(
            color: TAppColors.white,
            padding: Platform.isAndroid ? EdgeInsets.symmetric(vertical: 10.h) : EdgeInsets.only(top: 8.h,bottom: 22.h),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, Routes.createEventScreen);
                    },
                    child: Image.asset(
                      isCenterclicked
                          ? TImageName.selectedBtmCenter
                          : TImageName.btmCenter,
                      fit: BoxFit.cover,
                      height: bottomSfarea > 6.h ? 0.046.sh : 0.050.sh,
                      width: bottomSfarea > 6.h ? 0.046.sh : 0.050.sh,
                    ),
                  ),
                  _buildNavItem(2)
                ]
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    return GestureDetector(
      onTap: () {
        _onTabTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            _navItems[index].icon,
            width: 28.h,
            height: 28.h,
            fit: BoxFit.contain,
            color: _currentIndex == index ? TAppColors.orange : TAppColors.primary500,
          ),
            TText(
              _navItems[index].title,
              fontSize: 10.5.spMin,
              fontWeight: _currentIndex == index
                  ? FontWeight.w700
                  : FontWeight.w600,
              color: _currentIndex == index
                  ? TAppColors.orange
                  : TAppColors.primary500,
            )
          ],
        ),
      );
  }
}

class NavItem {
  String icon;
  String title;
  Widget page;
  NavItem({required this.icon, required this.title, required this.page});
}
