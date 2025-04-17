import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/theme/theme_manager.dart';
import 'package:Happinest/utility/database_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/setting%20screen/settings_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/widgets/appbar.dart';
import '../../common/widgets/custom_dialog.dart';
import '../../common/widgets/iconButton.dart';
import '../../utility/API/fetch_api.dart';
import '../profile/change_password.dart';
import 'html_view_screen.dart';
import 'package:Happinest/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> with WidgetsBindingObserver {
  CompanySettings? data;
  TextEditingController noteController = TextEditingController();
  final dbManager = DatabaseManager();

  Future getCompanySettings() async {
    var url = '${ApiUrl.authentication}${ApiUrl.getCompanySetting}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      onSuccess: (res) {
        setState(() {
          data = CompanySettings.fromJson(res);
        });
      },
    );
  }

  Future logout() async {
    // Clear the entire database (for logout)
    await dbManager.clearDatabase();
    var url = ApiUrl.logout;
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      onSuccess: (res) {},
    );
  }

  Future deleteAccount(void Function() onSuccess) async {
    var url = ApiUrl.deleteAccount;
    EasyLoading.show();
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      onSuccess: (res) {
        onSuccess.call();
        EasyLoading.dismiss();
      },
    );
    EasyLoading.dismiss();
  }

  Future changeStorySetting() async {
    var url = '${ApiUrl.authentication}${ApiUrl.updateUserNotificationSetting}';
    await ApiService.fetchApi(
        context: context,
        url: url,
        isLoader: false,
        params: {
          "smartTripReminders": true,
          "newLikes": true,
          "newFollowers": true,
          "newUpdates": true,
          "newOffers": true,
          "publicTrips": storyVisibility,
          "isTouchEnabled": true
        },
        onSuccess: (res) {});
  }

  Future changeThemeSetting() async {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    themeNotifier.toggleTheme();
  }

  Future sendUserFeedback() async {
    var url = '${ApiUrl.authentication}${ApiUrl.updateUserNotificationSetting}';
    await ApiService.fetchApi(
        context: context,
        url: url,
        isLoader: true,
        params: {
          "feedbackId": 0,
          "createdDate": nowutc(isLocal: true),
          "adminComment": "",
          "feedBackDescription": noteController.text.toString()
        },
        onSuccess: (res) {
          EasyLoading.showSuccess('your feedback has been submitted successfully');
          noteController.clear();
        });
  }

  bool isGuestUser = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      data = ModalRoute.of(context)!.settings.arguments as CompanySettings?;
      data == null ? getCompanySettings() : null;
    });

    var userId = PreferenceUtils.getString(PreferenceKey.userId);
    print("user is =====================>$userId ➡️➡️➡️➡️➡️ ");
    if (userId == 10106.toString()) {
      setState(() {
        isGuestUser = true;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      isFocused = bottomInset > 0;
    });
  }

  FocusNode focusNode = FocusNode();
  bool isFocused = false;
  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        setState(() {
          isFocused = false;
        });
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBar(
          title: "Settings",
          hasSuffix: false,
          prefixWidget: iconButton(
            bgColor: TAppColors.text4Color,
            iconPath: TImageName.back,
            radius: 24.h,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (isGuestUser) {
                      Utility.showAlertMessageForGuestUser(context);
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ));
                    }
                  },
                  child: TCard(
                      height: 40,
                      radius: 40,
                      color: isGuestUser ? Colors.grey : TAppColors.buttonBlue,
                      child: Center(
                          child: Text(
                        'RESET PASSWORD',
                        style: GoogleFonts.roboto(
                            color: TAppColors.white,
                            fontSize: MyFonts.size14,
                            fontWeight: FontWeight.w700),
                      ))),
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    showDialog<String>(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => PopScope(
                              canPop: false,
                              child: TDialog(
                                actionButtonText: 'LOGOUT',
                                bodyText: TMessageStrings.logoout,
                                title: 'Log out?',
                                isBack: false,
                                onActionPressed: () async {
                                  EasyLoading.show();
                                  await logout();
                                  await PreferenceUtils.clear();
                                  await EasyLoading.dismiss();
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.walkthrough, (route) => false);
                                },
                              ),
                            ));
                  },
                  child: TCard(
                      height: 40,
                      radius: 40,
                      color: isGuestUser ? Colors.grey : TAppColors.selectionColor,
                      child: Center(
                        child: Text(
                          'LOGOUT',
                          style: GoogleFonts.roboto(
                              color: TAppColors.white,
                              fontSize: MyFonts.size14,
                              fontWeight: FontWeight.w700),
                        ),
                      )),
                ),
                SizedBox(height: 18.h),
                GestureDetector(
                  onTap: () {
                    if (isGuestUser) {
                      Utility.showAlertMessageForGuestUser(context);
                    } else {
                      showDialog<String>(
                          context: context,
                          builder: (context) => TDialog(
                                actionButtonText: 'DELETE',
                                bodyText:
                                    'Are you sure you want to delete your account? This action is irreversible, and all your data will be permanently lost',
                                title: 'Delete Account?',
                                isBack: false,
                                onActionPressed: () async {
                                  await deleteAccount(
                                    () async {
                                      await PreferenceUtils.clear();
                                      Navigator.pushNamedAndRemoveUntil(
                                          context, Routes.walkthrough, (route) => false);
                                    },
                                  );
                                },
                              ));
                    }
                  },
                  child: Center(
                    child: Text(
                      'DELETE ACCOUNT',
                      style: GoogleFonts.roboto(
                          color: isGuestUser ? Colors.grey : TAppColors.buttonRed,
                          fontSize: MyFonts.size16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Private Stories',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        Switch(
                          value: storyVisibility,
                          onChanged: (value) {
                            setState(() {
                              storyVisibility = value;
                            });
                            changeStorySetting();
                          },
                          activeTrackColor: TAppColors.selectionColor,
                          activeColor: TAppColors.white,
                          inactiveTrackColor: TAppColors.white,
                          inactiveThumbColor: TAppColors.selectionColor,
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Theme',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        Switch(
                          value: setTheme,
                          onChanged: (value) {
                            setState(() {
                              setTheme = value;
                            });
                            changeThemeSetting();
                          },
                          activeTrackColor: TAppColors.selectionColor,
                          activeColor: TAppColors.white,
                          inactiveTrackColor: TAppColors.white,
                          inactiveThumbColor: TAppColors.selectionColor,
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2), //0.05
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tips And FAQs',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        commonReadButton(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data!.tipsAndFaq.toString(),
                                    appbarTitle: 'Tips And FAQs'),
                              ));
                        }),
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'About Happinest',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        commonReadButton(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data!.aboutTravelory.toString(),
                                    appbarTitle: 'About Happinest'),
                              ));
                        })
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2), //005
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terms & Conditions',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        commonReadButton(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data!.termsAndCondition.toString(),
                                    appbarTitle: 'Terms & Conditions'),
                              ));
                        })
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.themeColor.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Privacy Policy',
                          style: getRobotoBoldStyle(
                            fontSize: MyFonts.size14,
                            color: customColors.label,
                          ),
                        ),
                        commonReadButton(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HtmlViewScreen(
                                    data: data!.privacyPolicy.toString(),
                                    appbarTitle: 'Privacy Policy'),
                              ));
                        })
                      ],
                    ),
                  )),
              const SizedBox(height: 12),
              TCard(
                  color: TAppColors.lightBorderColor,
                  height: 0.15.sh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                    child: Stack(
                      children: [
                        CTTextField(
                            maxLines: 10,
                            focusNode: focusNode,
                            hint: 'Feedback/Issues',
                            controller: noteController,
                            onTapOutside: (p0) {
                              focusNode.unfocus();
                              setState(() {
                                isFocused = false;
                              });
                            },
                            onTap: () {
                              setState(() {
                                isFocused = true;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                isFocused = false;
                              });
                            },
                            hintTextColor: TAppColors.black),
                        if (!isFocused)
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                if (isGuestUser) {
                                  Utility.showAlertMessageForGuestUser(context);
                                } else {
                                  if (noteController.text.isNotEmpty) {
                                    sendUserFeedback();
                                  }
                                }
                              },
                              child: TCard(
                                  radius: 50,
                                  color: TAppColors.buttonBlue,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    child: TText('SEND',
                                        color: Colors.white,
                                        fontSize: MyFonts.size12,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                          )
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonReadButton(void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: TCard(
          radius: 50,
          color: TAppColors.selectionColor,
          border: true,
          borderWidth: 1,
          borderColor: TAppColors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            child: Text(
              'Read',
              style: getRobotoBoldStyle(
                fontSize: MyFonts.size12,
                color: Colors.white,
              ),
            ),
          )),
    );
  }
}
