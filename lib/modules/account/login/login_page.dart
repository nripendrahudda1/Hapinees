// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:Happinest/authmanager/apple_auth_manager.dart';
import 'package:Happinest/modules/account/login/provider/login_view_model.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../authmanager/google_auth_manager.dart';
import '../../../common/widgets/custom_dialog.dart';
import '../../../utility/Validations.dart';
import '../../../utility/constants/strings/error_message.dart';
import '../../../utility/constants/strings/parameter.dart';

class LoginPage extends StatefulWidget {
  String? emailText;
  LoginPage({super.key, this.emailText});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isShowError = false;
  bool isAlreadyLogin = false;
  late String errorMesage = '';
  late String socialEmail = '';
  late String personName = '';
  LoginSourceType socialLoginType = LoginSourceType.google;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    errorMesage = TMessageStrings.emptyFiled;
    // usernameController.text = "rvtest@yopmail.com";
    // passwordController.text = "123456";
    Future.microtask(() {
      final AlreadyAccountArgs? args =
          ModalRoute.of(context)?.settings.arguments as AlreadyAccountArgs?;
      if (args != null && args.isRedirected) {
        if (args.isGoogle != null) {
          setState(() {
            errorMesage = TPErrorStrings.alreadyEditAccount;
            errorMessageFuction();
          });
          usernameController.text = '';
        } else if (args.isGoogle == null) {
          if (args.email != null && args.email!.isNotEmpty) {
            setState(() {
              errorMesage = TPErrorStrings.signupAccountFailed;
              errorMessageFuction();
            });
            usernameController.text = args.email ?? '';
          }
        } else {
          setState(() {
            errorMesage = TPErrorStrings.alreadyEditAccount;
            errorMessageFuction();
          });
        }
      }
    });
    setState(() {
      if (widget.emailText != null) {
        usernameController.text = widget.emailText!;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showAlertMessage(
    LoginViewModel userViewModel,
  ) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              actionButtonText: 'CONTINUE',
              title: 'Logout?',
              onActionPressed: () {
                isAlreadyLogin = true;
                _signIn(context, userViewModel);
              },
              isBack: false,
              bodyText: userViewModel.userResponse?.validationMessage ?? '',
            ));
  }

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

  Future<void> _signIn(BuildContext context, LoginViewModel userViewModel) async {
    String username = usernameController.text;
    String password = passwordController.text;
    userViewModel.email = username;
    userViewModel.password = password;
    FocusManager.instance.primaryFocus?.unfocus();
    var deviceID = await Utility.getDeveiceDetails();
    PreferenceUtils.setString(
      PreferenceKey.deviceID,
      deviceID,
    );
    if (username.isNotEmpty && password.isNotEmpty && validateEmail(username) == null) {
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
            Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (routes) => false);
          } else {
            errorMesage = userViewModel.userResponse?.validationMessage ?? '';

            if (errorMesage == TPErrorStrings.loginError) {
              showAlertMessage(userViewModel);
              setState(() {});
            } else if (errorMesage ==
                'You are not yet signed up. Please sign up to start enjoying travelory.') {
              mounted
                  ? Navigator.pushReplacementNamed(context, Routes.singupRoute,
                      arguments:
                          AlreadyAccountArgs(isRedirected: true, email: usernameController.text))
                  : null;
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

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  Future<void> socialSignIn(
      BuildContext context, String email, String? displayName, LoginSourceType loginType) async {
    var deviceID = await Utility.getDeveiceDetails();
    PreferenceUtils.setString(
      PreferenceKey.deviceID,
      deviceID,
    );
    if (email.isNotEmpty) {
      Map<String, dynamic> params = {
        TPParameters.email: email,
        TPParameters.password: "test123",
        TPParameters.displayName: displayName,
        TPParameters.deviceId: deviceID,
        TPParameters.appleUserId: "",
        TPParameters.authenticationSource: loginType.toString(),
        TPParameters.overWriteExistingSession: isAlreadyLogin
      };
      Loader.showLoader();
      try {
        UserModel? currUser =
            await Provider.of<LoginViewModel>(context, listen: false).socialLogin(params);
        Loader.hideLoader();
        if (currUser != null) {
          if (currUser.token != null) {
            Utility.saveData(currUser, context);
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
            }
          } else {
            print('Login Failed');
            errorMesage = currUser.validationMessage ?? '';
            if (errorMesage == TPErrorStrings.loginError) {
              showDialog<String>(
                  context: context,
                  builder: (context) => TDialog(
                        actionButtonText: 'CONTINUE',
                        title: 'Logout?',
                        onActionPressed: () {
                          isAlreadyLogin = true;
                          socialSignIn(context, email, displayName, socialLoginType);
                        },
                        isBack: false,
                        bodyText: currUser.validationMessage ?? '',
                      ));
            } else if (errorMesage == TPErrorStrings.notSignIn) {
              Navigator.pushReplacementNamed(context, Routes.singupRoute,
                  arguments: loginType.stringValue == LoginSourceType.google
                      ? AlreadyAccountArgs(isGoogle: true, isRedirected: true)
                      : loginType.stringValue == LoginSourceType.facebook
                          ? AlreadyAccountArgs(isFacebbook: true, isRedirected: true)
                          : AlreadyAccountArgs(isApple: true, isRedirected: true));
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
        errorMesage = TPErrorStrings.loginFailed;
        errorMessageFuction();
      }
    }
  }

  // SignIn Button ----
  Widget signUpButton() {
    return Padding(
      padding: const EdgeInsets.all(6),
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
              textStyle: TextStyle(fontSize: MyFonts.size18, color: TAppColors.appColor),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.singupRoute);
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

  googleSignIN() async {
    GoogleSignInAccount? user = await GoogleAuthService.signInWithGoogle();
    if (user != null) {
      socialSignIn(context, user.email, user.displayName, LoginSourceType.google);
    } else {
      if (mounted) {
        errorMesage = TPErrorStrings.loginFailed;
        errorMessageFuction();
      }
    }
  }

  // facebookSignIN() async {
  //   await FaceBookAuthService().onPressedLogInButton();
  //   if (FaceBookAuthService().token != null) {
  //     socialSignIn(context, FaceBookAuthService().email!,
  //         FaceBookAuthService().profile!.name, LoginSourceType.facebook);
  //   } else {
  //     if (mounted) {
  //       errorMesage = TPErrorStrings.loginFailed;
  //       errorMessageFuction();
  //     }
  //   }
  // }

  appleSignIN() async {
    var appleEmail = PreferenceUtils.getString(PreferenceKey.appleEmail);
    var appleUserName = PreferenceUtils.getString(PreferenceKey.appleUserName);
    AuthorizationCredentialAppleID? appleID = await AppleAuthService.signInWithApple();
    socialEmail = appleEmail;
    personName = appleUserName;
    // ignore: unnecessary_null_comparison
    if (appleID?.email != null) {
      socialSignIn(context, appleID?.email ?? "", appleID?.givenName ?? "", LoginSourceType.apple);
    } else if (appleEmail != '') {
      socialSignIn(context, appleEmail, appleUserName, LoginSourceType.apple);
    } else {
      if (mounted) {
        errorMesage = TMessageStrings.emptyAppleEmail;
        errorMessageFuction();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const TBackgroundImage(imageName: TImageName.appBackground),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 70.h, 16, 0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Navigator.canPop(context)
                        //     ? SizedBox(
                        //         height: 24,
                        //         width: 24,
                        //         child: iconButton(
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //             iconPath: TImageName.back,
                        //             bgColor: Colors.white.withOpacity(0.2)),
                        //       )
                        //     : const SizedBox(),
                        TAppTopImage(
                          titleName: TLabelStrings.loginAndGo,
                        ),
                        SizedBox(
                          height: 24,
                          width: 24,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 0.1.sh,
                    ),
                    if (isShowError) CustomErrorWidget(errorMessage: errorMesage),
                    TTextField(
                      controller: usernameController,
                      maxLines: 1,
                      textInputType: TextInputType.emailAddress,
                      hintText: TPlaceholderStrings.email,
                      icon: TImageName.emailIcon,
                      inputboxBoder: TAppColors.white,
                      onTapOutside: (p0) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TTextField(
                      inputboxBoder: TAppColors.white,
                      isSecure: true,
                      maxLines: 1,
                      controller: passwordController,
                      hintText: TPlaceholderStrings.password,
                      icon: TImageName.lockClosedIcon,
                      onTapOutside: (p0) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                    SizedBox(height: 20.h),
                    TButton(
                      fontSize: MyFonts.size16,
                      onPressed: () {
                        _signIn(context, loginViewModel);
                      },
                      title: TButtonLabelStrings.login,
                      buttonBackground: TAppColors.selectionColor,
                    ),
                    const SizedBox(height: 10.0),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.forgotPasswordRoute),
                          child: TText(
                            TButtonLabelStrings.forgotPassword,
                            fontSize: 14.w,
                            color: TAppColors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isShowError ? 0.1.sh : 0.16.sh),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Row(
                          children: [
                            Flexible(
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                TLabelStrings.loginWithSocialMedia,
                                style: TextStyle(
                                  fontSize: TDimension.socialTitleFont,
                                  color: TAppColors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: googleSignIN,
                            child: SvgPicture.asset(
                              TImageName.googleLogin,
                              fit: BoxFit.fill, // Replace with your SVG asset path
                            ),
                          ),
                          // const SizedBox(
                          //   width: 20,
                          // ),
                          // InkWell(
                          //   onTap: facebookSignIN,
                          //   child: SvgPicture.asset(
                          //     TImageName.fbLogin,
                          //     fit: BoxFit.fill,
                          //   ),
                          // ),
                          // if (Platform.isIOS)
                          //   const SizedBox(
                          //     width: 20,
                          //   ),
                          // if (Platform.isIOS)
                          //   InkWell(
                          //     onTap: appleSignIN,
                          //     child: SvgPicture.asset(
                          //       TImageName.appleLogin,
                          //       fit: BoxFit
                          //           .fill, // Replace with your SVG asset path
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                    // SignUpButton Widget
                    signUpButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AlreadyAccountArgs {
  String? email;
  bool? isGoogle;
  bool? isFacebbook;
  bool? isApple;
  bool isRedirected;
  AlreadyAccountArgs(
      {this.email, this.isGoogle, this.isApple, this.isFacebbook, required this.isRedirected});
}
