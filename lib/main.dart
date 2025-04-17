import 'dart:io';
import 'dart:async';
import 'package:Happinest/theme/theme_manager.dart' as AppThemes;
import 'package:Happinest/utility/database_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as Rp;
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:requests_inspector/requests_inspector.dart';
import 'package:system_date_time_format/system_date_time_format.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/Firebase/Firebase_services_.dart';
import 'package:Happinest/utility/Firebase/Notification_services_.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'modules/account/login/login_page.dart';
import 'modules/account/login/provider/forgot_password_view_model.dart';
import 'modules/account/login/provider/location_provider.dart';
import 'modules/account/login/provider/login_view_model.dart';
import 'modules/account/login/provider/profile_view_model.dart';
import 'modules/account/login/provider/signup_viewmodel.dart';
import 'modules/account/login/provider/verify_view_model.dart';
import 'package:hive/hive.dart';
import 'package:Happinest/theme/theme_provider.dart';
import 'package:Happinest/theme/apptheme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.init();
  _initialiseHive();
  // await FirebaseService.notificationInit();
  await PreferenceUtils.init();
  await FirebaseService.stupInteractedMessage();
  NotificationService().initilizenotification;
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: []);
  } else if (Platform.isIOS) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  EasyLoading.instance
    ..radius = 10
    ..maskColor = TAppColors.blackShadow
    ..textColor = TAppColors.black
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 48
    ..indicatorType = EasyLoadingIndicatorType.circle
    ..indicatorColor = TAppColors.black
    ..backgroundColor = TAppColors.white
    ..maskType = EasyLoadingMaskType.black;
  await dotenv.load(fileName: "assets/.env");
  datePattern = await SystemDateTimeFormat().getDatePattern();
  String token = PreferenceUtils.getString(PreferenceKey.accessToken);

  print("Bearer $token");
  token.isNotEmpty ? dio.options.headers["Authorization"] = "Bearer $token" : null;
  PhotoManager.clearFileCache();
  runApp(Rp.ProviderScope(child: MyApp()));
  // runApp(const RequestsInspector(
  //   enabled: true,
  //   showInspectorOn: ShowInspectorOn.Both,
  //   hideInspectorBanner: true,
  //   child: Rp.ProviderScope(child: MyApp()),
  // ));
}

void _initialiseHive() async {
  await getApplicationDocumentsDirectory().then((Directory value) {
    Hive.init(value.path);
    Hive.openBox(DBKeys.boxNAME);
  });
}

String navigationToScreen() {
  return PreferenceUtils.getBool(PreferenceKey.loggedIn) == false
      ? Routes.walkthrough
      : Routes.homeRoute;
}

Future<void> checkLocationPermissions() async {
  LocationPermission permission = await Geolocator.requestPermission();
}

Future<void> locationServicesStatus() async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    dheight = MediaQuery.of(context).size.height;
    dwidth = MediaQuery.of(context).size.width;
    topSfarea = MediaQuery.of(context).padding.top;
    bottomSfarea = MediaQuery.of(context).padding.bottom;

    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => LoginViewModel(),
              child: LoginPage(),
            ),
            ChangeNotifierProvider(create: (_) => ThemeNotifier()),
            ChangeNotifierProvider.value(value: SignUPViewModel()),
            ChangeNotifierProvider.value(value: SignUPViewModel()),
            ChangeNotifierProvider.value(value: ForgotPasswordViewModel()),
            ChangeNotifierProvider.value(value: VerifyViewModel()),
            ChangeNotifierProvider.value(value: ProfileViewModel()),
            ChangeNotifierProvider.value(value: LocationListener()),
            // Provider<ThemeStore>(create: (_) => Stores.themeStore),
            ChangeNotifierProvider(create: (_) => LoginViewModel()),
            // Add more providers for different pages as needed
          ],
          child: Consumer<ThemeNotifier>(builder: (context, themeNotifier, _) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              builder: (context, child) {
                child = EasyLoading.init()(context, child);
                final mediaQueryData = MediaQuery.of(context);
                final scale = Theme.of(context).platform == TargetPlatform.iOS
                    ? mediaQueryData.textScaleFactor.clamp(0.8, 0.95)
                    : mediaQueryData.textScaleFactor.clamp(0.9, 1.0);

                // print("--scale----$scale");
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                  child: child,
                );
              },
              // theme: ThemeData(
              //   textTheme: GoogleFonts.workSansTextTheme(),
              // ),
              debugShowCheckedModeBanner: false,
              title: 'Happinest',
              initialRoute: navigationToScreen(),
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: themeNotifier.themeMode,
              
              // darkTheme: ThemeData(
              //   textTheme: GoogleFonts.workSansTextTheme(),
              //   brightness: Brightness.dark,
              //   scaffoldBackgroundColor: TAppColors.eventScaffoldColor,
              //   // Apply your custom dark theme colors
              // ),

              //initialRoute: Routes.createEventScreen,
              onGenerateRoute: TRouter.generateRoute,
              // builder: EasyLoading.init(),
            );
          }),
        );
      },
    );
  }
}
