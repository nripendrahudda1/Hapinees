import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:Happinest/core/api_urls.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:Happinest/common/widgets/custom_checkbox.dart';
import 'package:Happinest/common/widgets/custom_dialog.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/account/login/provider/signup_viewmodel.dart';
import 'package:Happinest/modules/account/login/verify_email.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:Happinest/utility/Validations.dart';
import '../../../authmanager/apple_auth_manager.dart';
import '../../../authmanager/google_auth_manager.dart';
import '../../../utility/constants/strings/error_message.dart';
import '../../../utility/constants/strings/parameter.dart';
import '../update_profile/update_profile_screen.dart';
import '../usermodel/usermodel.dart';
import 'login_page.dart';
import 'provider/login_view_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isChecked = false;
  bool isShowError = false;
  LoginSourceType socialLoginType = LoginSourceType.google;
  bool isAlreadyLogin = false;
  late String errorMesage = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isOTPSended = false;
  @override
  void initState() {
    super.initState();
    errorMesage = TMessageStrings.emptyFiled;
    Future.microtask(() {
      final AlreadyAccountArgs? args =
          ModalRoute.of(context)?.settings.arguments as AlreadyAccountArgs?;
      if (args != null && args.isRedirected) {
        if (args.email != null && args.email!.isNotEmpty) {
          setState(() {
            errorMesage = TPErrorStrings.accountNotExitNormal;
            errorMessageFuction();
          });
          usernameController.text = args.email ?? '';
        } else {
          setState(() {
            errorMesage = TPErrorStrings.accountNotExitSocial;
            errorMessageFuction();
          });
        }
      }
    });
  }

  Future<String?> getDeveiceID() async {
    var deveiceID = await Utility.getDeveiceDetails();
    return deveiceID;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
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

  Future<void> getOtp() async {
    EasyLoading.show();
    String url = ApiUrl.getOtp;
    await ApiService.fetchApi(
      context: context,
      url: url,
      params: {TPParameters.email: usernameController.text.toString()},
      onSuccess: (response) async {
        EasyLoading.dismiss();
        if (response[TPParameters.statusCode].toString() == '0') {
          setState(() {
            isOTPSended = true;
          });
        } else if (response[TPParameters.statusCode].toString() == '5') {
          mounted
              ? Navigator.pushReplacementNamed(context, Routes.loginRoute,
                  arguments: AlreadyAccountArgs(isRedirected: true, email: usernameController.text))
              : null;
        } else {
          EasyLoading.showError(response['validationMessage'].toString());
        }
      },
    );
  }

// SignUP API Request ----
  Future<void> _signUP(BuildContext context, SignUPViewModel userViewModel, String otp) async {
    log('signUP api calling');
    String username = usernameController.text;
    String password = passwordController.text;
    userViewModel.email = username;
    userViewModel.password = password;
    FocusManager.instance.primaryFocus?.unfocus();
    var deviceID = await getDeveiceID();
    PreferenceUtils.setString(
      PreferenceKey.deviceID,
      deviceID ?? '',
    );
    // Perform authentication Signup here
    if (username.isNotEmpty && password.isNotEmpty && validateEmail(username) == null) {
      Map<String, dynamic> params = {
        TPParameters.email: username,
        TPParameters.password: password,
        TPParameters.signUpSource: TPParameters.appsinUpType,
        TPParameters.appleUserId: '',
        TPParameters.deviceId: deviceID,
        TPParameters.otp: otp,
      };
      Loader.showLoader();
      try {
        await Provider.of<SignUPViewModel>(context, listen: false).signup(params);
        Loader.hideLoader();
        log(userViewModel.userResponse!.userId.toString());
        log("userViewModel.userResponse!.token.toString() *****************");
        log(userViewModel.userResponse!.token.toString());
        if (userViewModel.userResponse != null) {
          if (userViewModel.userResponse?.token != null) {
            // ignore: use_build_context_synchronously
            Utility.saveData(userViewModel.userResponse!, context);
            if (mounted) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ),
                  (route) => false);
              // Navigator.pushNamedAndRemoveUntil(
              //     context, Routes.profileRoute, (route) => false);
            }
            // ignore: use_build_context_synchronously
          } else {
            errorMesage = userViewModel.userResponse?.validationMessage ?? '';

            if (errorMesage == TPErrorStrings.alreadyEditAccount) {
              // ignore: use_build_context_synchronously
              final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
              await signIn(context, loginViewModel);
            } else if (errorMesage == "Otp Expired") {
              EasyLoading.showError(TPErrorStrings.otpExpired,
                  duration: const Duration(seconds: 6));
            }
          }
        }
      } catch (e) {
        log('Signup Exeception:  $e');
      }
    } else {
      validateEmail(username) != null ? errorMesage = validateEmail(username)! : null;
      errorMessageFuction();
    }
  }

//- Social Login ----
  Future<void> socialSignup(
      BuildContext context, String email, String? displayName, LoginSourceType loginType) async {
    var deviceID = await Utility.getDeveiceDetails();
    // Perform authentication Signup here
    if (email.isNotEmpty) {
      Map<String, dynamic> params = {
        TPParameters.email: email,
        TPParameters.displayName: displayName,
        TPParameters.signUpSource: loginType.stringValue,
        TPParameters.password: "test123",
        TPParameters.deviceId: deviceID,
        TPParameters.appleUserId: "",
      };
      Loader.showLoader();
      try {
        UserModel? currUser =
            await Provider.of<SignUPViewModel>(context, listen: false).socialSignup(params);

        if (currUser != null) {
          if (currUser.token != null) {
            PreferenceUtils.setBool(
              PreferenceKey.loggedIn,
              true,
            );
            // ignore: use_build_context_synchronously
            Utility.saveData(currUser, context);
            Loader.hideLoader();
            if (mounted) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
            }
          } else {
            errorMesage = currUser.validationMessage ?? '';
            if (errorMesage == TPErrorStrings.alreadyEditAccount) {
              if (loginType == LoginSourceType.google) {
                // googleSignIN();
                mounted
                    ? Navigator.pushReplacementNamed(context, Routes.loginRoute,
                        arguments: AlreadyAccountArgs(isRedirected: true, isGoogle: true))
                    : null;
              } else if (loginType == LoginSourceType.facebook) {
                // facebookSignIN();
              } else {
                appleSignIN();
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

  Future<void> socialSignIn(
      BuildContext context, String email, String? displayName, LoginSourceType loginType) async {
    // Perform authentication Signup here
    var deviceID = await Utility.getDeveiceDetails();
    PreferenceUtils.setString(
      PreferenceKey.deviceID,
      deviceID,
    );
    if (email.isNotEmpty) {
      Map<String, dynamic> params = {
        TPParameters.email: email,
        TPParameters.password: 'jdssbjsbbfs',
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
            errorMesage = currUser.validationMessage ?? '';
            if (errorMesage == TPErrorStrings.loginError) {
              // ignore: use_build_context_synchronously
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
                signIn(context, userViewModel);
              },
              isBack: false,
              bodyText: userViewModel.userResponse?.validationMessage ?? '',
            ));
  }

  Future<void> signIn(BuildContext context, LoginViewModel userViewModel) async {
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
    if (username.isNotEmpty && password.isNotEmpty) {
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
            // ignore: use_build_context_synchronously
            Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (routes) => false);
          } else {
            errorMesage = userViewModel.userResponse?.validationMessage ?? '';

            if (errorMesage == TPErrorStrings.loginError) {
              showAlertMessage(userViewModel);
              setState(() {});
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
        errorMesage = TMessageStrings.emptyFiled;
        errorMessageFuction();
      }
    }
  }

  // SignInButton ----
  Widget signInButton() {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TLabelStrings.alreadyAMember,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: MyFonts.size16,
              color: TAppColors.white,
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: MyFonts.size16),
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.loginRoute);
            },
            child: const Text(
              TLabelStrings.signIN,
              style: TextStyle(
                color: TAppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signupViewModel = Provider.of<SignUPViewModel>(context);
    return PopScope(
      canPop: false,
      child: isOTPSended
          ? EmailVerifyPage(
              email: usernameController.text,
              onTap: (otp) {
                _signUP(context, signupViewModel, otp);
              },
            )
          : Scaffold(
              body: Stack(
                children: [
                  const TBackgroundImage(imageName: TImageName.appBackground),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 70.h, 16.w, 0),
                      child: Column(
                        children: [
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     SizedBox(
                          //       height: 28.h,
                          //       width: 28.w,
                          //       child: iconButton(
                          //           onPressed: () {
                          //             Navigator.pop(context);
                          //           },
                          //           iconPath: TImageName.back,
                          //           bgColor: Colors.white.withOpacity(0.2)),
                          //     ),
                          //     const TAppTopImage(
                          //       titleName: TLabelStrings.signupAndRoll,
                          //     ),
                          //     const SizedBox(
                          //       height: 28,
                          //       width: 28,
                          //     ),
                          //   ],
                          // ),
                          const TAppTopImage(
                            titleName: TLabelStrings.signupAndRoll,
                          ),
                          SizedBox(
                            height: 0.1.sh,
                          ),
                          if (isShowError) CustomErrorWidget(errorMessage: errorMesage),
                          TTextField(
                            inputboxBoder: TAppColors.white,
                            controller: usernameController,
                            maxLines: 1,
                            hintText: TPlaceholderStrings.email,
                            icon: TImageName.emailIcon,
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 20.h, 20.w, 20.h),
                            child: CustomCheckbox(
                              value: isChecked,
                              text: ' I accept the ',
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                          ),
                          TButton(
                            fontSize: MyFonts.size16,
                            onPressed: () {
                              String? emailError = validateEmail(usernameController.text);
                              String? passError = validateTextField(passwordController.text);
                              if (!isChecked) {
                                errorMesage = TPErrorStrings.termsandconditionsError;
                                errorMessageFuction();
                              } else if (emailError != null) {
                                errorMesage = emailError;
                                errorMessageFuction();
                              } else if (passError != null) {
                                errorMesage = passError;
                                errorMessageFuction();
                              } else {
                                errorMesage = TMessageStrings.emptyFiled;
                                getOtp();
                                // _signUP(context, signupViewModel);
                              }
                            },
                            title: TButtonLabelStrings.signup,
                            buttonBackground: TAppColors.selectionColor,
                          ),
                          SizedBox(
                            height: isShowError ? 0.1.sh : 0.15.sh,
                          ),
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
                                      TLabelStrings.signUpWithSocialMedia,
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
                            padding: EdgeInsets.all(10.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (!isChecked) {
                                      errorMesage = TPErrorStrings.termsandconditionsError;
                                      errorMessageFuction();
                                    } else {
                                      GoogleSignInAccount? user =
                                          await GoogleAuthService.signInWithGoogle();
                                      print("user ***************** $user");
                                      if (user != null) {
                                        // ignore: use_build_context_synchronously
                                        socialSignup(context, user.email, user.displayName,
                                            LoginSourceType.google);
                                      } else {
                                        if (mounted) {
                                          errorMesage = TPErrorStrings.loginFailed;
                                          errorMessageFuction();
                                        }
                                      }
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    TImageName.googleLogin,
                                    fit: BoxFit.fill, // Replace with your SVG asset path
                                  ),
                                ),
                                /*if (Platform.isIOS)
                                  const SizedBox(
                                    width: 20,
                                  ),
                                if (Platform.isIOS)
                                  InkWell(
                                    onTap: () async {
                                      if (!isChecked) {
                                        errorMesage = TPErrorStrings
                                            .termsandconditionsError;
                                        errorMessageFuction();
                                      } else {
                                        var appleEmail =
                                            PreferenceUtils.getString(
                                                PreferenceKey.appleEmail);
                                        var appleUserName =
                                            PreferenceUtils.getString(
                                                PreferenceKey.appleUserName);

                                        AuthorizationCredentialAppleID? appleID =
                                            await AppleAuthService
                                                .signInWithApple();
                                        if (appleID?.email != null) {
                                          socialSignup(
                                              context,
                                              appleID?.email ?? "",
                                              appleID?.givenName ?? "",
                                              LoginSourceType.apple);
                                        } else if (appleEmail != '') {
                                          socialSignup(
                                              context,
                                              appleEmail,
                                              appleUserName,
                                              LoginSourceType.apple);
                                        } else {
                                          errorMesage =
                                              TMessageStrings.emptyAppleEmail;
                                          errorMessageFuction();
                                        }
                                      }
                                    },
                                    child: SvgPicture.asset(
                                      TImageName.appleLogin,
                                      fit: BoxFit
                                          .fill, // Replace with your SVG asset path
                                    ),
                                  ),*/
                              ],
                            ),
                          ),
                          signInButton(),
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
