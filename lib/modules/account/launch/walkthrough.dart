import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/login/provider/login_view_model.dart';
import 'package:Happinest/utility/Validations.dart';
import 'package:Happinest/utility/constants/strings/error_message.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../location/location_client.dart';
import 'package:provider/src/provider.dart';

class TWalkthrough extends StatefulWidget {
  const TWalkthrough({super.key});

  @override
  State<TWalkthrough> createState() => _TWalkthroughState();
}

// class GetLocationData {
//   static const platform = MethodChannel('com.css.Happinest/IOS');
//   static Future<String> getcurrentLocation() async {
//     try {
//       final result = await platform.invokeMethod('getcurrentLocation');
//       return result;
//     } catch (e) {
//       return '';
//     }
//   }
// }

class _TWalkthroughState extends State<TWalkthrough> {
  final _locationClient = LocationClient();
  bool _isServiceRunning = false;
  LoginViewModel? userViewModel;
  String version = '';
  String code = '';

  @override
  void initState() {
    super.initState();
    _locationClient.init(context);
    getPackageInfo();
    // _listenLocation();
    // _getLocationData();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print("packageInfo.version ********** ${packageInfo.version}");
    print("packageInfo.buildNumber ********** ${packageInfo.buildNumber}");
    setState(() {
      version = packageInfo.version;
      code = packageInfo.buildNumber;
    });
  }

  void _listenLocation() async {
    if (!_isServiceRunning && await _locationClient.isServiceEnabled(context)) {
      _isServiceRunning = true;
      _locationClient.locationStream.listen((event) {});
    } else {
      _isServiceRunning = false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  double? latitude;
  double? longitude;
  void locationHereIs() async {
    await locationServicesStatus();
    await checkLocationPermissions();
    try {
      Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkLocationPermissions() async {
    LocationPermission permission = await locationDialogue(context);
    print('Current Location Permission Status = $permission');
  }

  Future<void> locationServicesStatus() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    print(
        'Currently, the emulator\'s Location Services Status = $isLocationServiceEnabled');
  }

  Widget signUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TLabelStrings.notAMember,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: MyFonts.size16,
              color: TAppColors.white,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                  fontSize: MyFonts.size18, color: TAppColors.appColor),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Routes.singupRoute);
            },
            child: const Text(
              TLabelStrings.signUp,
              style: TextStyle(
                color: TAppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }


  bool isShowError = false;
  bool isAlreadyLogin = false;
  late String errorMesage = '';


  errorMessageFuction() async {
    mounted
        ? setState(() {
            isShowError = true;
          })
        : null;
    await Future.delayed(const Duration(seconds: 3), () {
      mounted
          ? setState(() {
              isShowError = false;
            })
          : null;
    });
  }

  Future<void> _signIn(
      BuildContext context, LoginViewModel userViewModel) async {
    String username ="kkgaurav1983@gmail.com";
    String password = "Gaurav@2005";
    userViewModel.email = username;
    userViewModel.password = password;
    FocusManager.instance.primaryFocus?.unfocus();
    var deviceID = await Utility.getDeveiceDetails();
    PreferenceUtils.setString(
      PreferenceKey.deviceID,
      deviceID,
    );
    if (username.isNotEmpty &&
        password.isNotEmpty &&
        validateEmail(username) == null) {
      Map<String, dynamic> params = {
        TPParameters.email: username,
        TPParameters.password: password,
        TPParameters.deviceId: deviceID,
        TPParameters.appleUserId: "",
        TPParameters.authenticationSource: TPParameters.appsinUpType,
        TPParameters.overWriteExistingSession: isAlreadyLogin
      };
      Loader.showLoader();
      try {
        await Provider.of<LoginViewModel>(context, listen: false).login(params);
        Loader.hideLoader();
        if (userViewModel.userResponse != null) {
          if (userViewModel.userResponse?.token != null) {
            Utility.saveData(userViewModel.userResponse!, context);
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.homeRoute, (routes) => false);
          } else {
            errorMesage = userViewModel.userResponse?.validationMessage ?? '';

            if (errorMesage == TPErrorStrings.loginError) {
              // showAlertMessage(userViewModel);
              setState(() {});
            } else if (errorMesage ==
                'You are not yet signed up. Please sign up to start enjoying travelory.') {
              // mounted
              //     ? Navigator.pushReplacementNamed(context, Routes.singupRoute,
              //         arguments: AlreadyAccountArgs(
              //             isRedirected: true, email: usernameController.text))
              //     : null;
            } else {
              if (mounted) {
                errorMessageFuction();
              }
            }
          }
        }
      } catch (e) {}
    } else {
      if (mounted) {
        validateEmail(username) != null
            ? errorMesage = validateEmail(username)!
            : errorMesage = TMessageStrings.emptyFiled;
        errorMessageFuction();
      }
    }
  }

// Build context --
  @override
  Widget build(BuildContext context) {
  
    final screenSize = MediaQuery.of(context).size;
      final loginViewModel = Provider.of<LoginViewModel>(context);
      
   
    return Scaffold(
      body: Stack(
        children: [
          const TBackgroundImage(imageName: TImageName.appBackground),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.h),
              child: Column(
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  const Center(
                    child: TAppTopImage(),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    // height: screenSize.height * 0.44,
                    child: ImageSlider(),
                  ),
                  SizedBox(
                    height: 55.h,
                  ),
                  TButton(
                    fontSize: MyFonts.size16,
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.loginRoute);
                    },
                    title: TButtonLabelStrings.login,
                    buttonBackground: TAppColors.selectionColor,
                  ),
                  /*SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () async {
                     _signIn(context, loginViewModel);
                      // Navigator.pushNamed(
                      //   context,
                      //   Routes.homeRoute,
                      // );
                    },
                    child: Container(
                      height: screenSize.height *
                          TDimension
                              .buttonHeight, // Adjust the height as needed
                      decoration: BoxDecoration(
                        color: Colors.white, // Set the background color
                        borderRadius: BorderRadius.circular(TDimension
                            .buttonCornerRadius), // Set border radius for rounded corners
                      ),
                      child: Center(
                        child: TText(TButtonLabelStrings.exploreAsGuest,
                            latterSpacing: 0,
                            color: Colors.blue, // Text color
                            fontSize: MyFonts.size16,
                            fontWeight: FontWeight.w600 // Font size
                            ),
                      ),
                    ),
                  ),*/
                  signUpButton(context),
                  SizedBox(height: 24.h),
                  TText('Version $version ($code)',
                      color: TAppColors.black, fontWeight: FontWeight.normal)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Image Slider For Top
class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer timer;
  final List<String> images = [
    // TImageName.walkthrough1,
    TImageName.walkthrough3,
    TImageName.walkthrough2,
  ];

  final List<String> titles = [
    // TLabelStrings.walkthrough1Title,
    TLabelStrings.walkthrough2Title,
    TLabelStrings.walkthrough3Title,
  ];

  final List<String> subtitles = [
    // TLabelStrings.walkthrough1Subtitle,
    TLabelStrings.walkthrough2Subtitle,
    TLabelStrings.walkthrough3Subtitle,
  ];

// Build initState --
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentPage = _controller.page?.round() ?? 0;
      });
    });

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        _controller.animateToPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.linearToEaseOut,
            _controller.page?.round() != 0
                ? _controller.page?.round() != 1
                    ? 0
                    : 0
                : 1);
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

// Bottom DOT function --
  Widget buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: images.asMap().entries.map((entry) {
        final int index = entry.key;
        return Container(
          width: 10.h,
          height: 10.h,
          margin: const EdgeInsets.symmetric(
            horizontal: 4.0,
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage != index ? Colors.white : TAppColors.login,
          ),
        );
      }).toList(),
    );
  }

// Build context --
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      height: 0.46.sh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: PageView.builder(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: TText(
                          titles[index],
                          fontSize: MyFonts.size20,
                          color: TAppColors.white,
                          fontWeight: FontWeight.w700,
                          textAlign: TextAlign.center
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
//height: screenSize.height * 0.25,
// height: screenSize.width * 0.5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Image.asset(
                            images[index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: screenSize.width * 0.8,
                        child: TText(
                          subtitles[index],
                          textAlign: TextAlign.center,
                          fontSize: MyFonts.size16,
                          color: TAppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          buildDotsIndicator(),
        ],
      ),
    );
  }
}
