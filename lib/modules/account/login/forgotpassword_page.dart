import 'package:Happinest/core/api_urls.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/modules/account/login/provider/forgot_password_view_model.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import '../../../utility/Validations.dart';
import '../../../utility/constants/strings/parameter.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool isShowError = false;
  late String errorMesage = '';
  TextEditingController usernameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    errorMesage = TMessageStrings.emptyEmail;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Error Message ---
  errorMessageFuction() async {
    setState(() {
      isShowError = true;
    });
    await Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isShowError = false;
      });
    });
  }

  // Pasword Change ---
  Future<void> passwordChange(
      BuildContext context, ForgotPasswordViewModel userViewModel) async {
    FocusManager.instance.primaryFocus?.unfocus();
    String url = ApiUrl.resetPassword;
    userViewModel.email = usernameController.text;
    if (userViewModel.email.isNotEmpty &&
        validateEmail(usernameController.text) == null) {
      try {
        ApiService.fetchApi(
          context: context,
          url: url,
          params: {TPParameters.emailAddress: usernameController.text},
          onSuccess: (res) {
            Navigator.pop(context);
            EasyLoading.showInfo(res['validationMessage']);
          },
          onError: (res) {
            errorMesage = "Something Went Wrong";
            errorMessageFuction();
          },
        );
      } catch (e) {
        errorMessageFuction();
      }
    } else {
      validateEmail(usernameController.text) != null
          ? errorMesage = validateEmail(usernameController.text)!
          : null;
      errorMessageFuction();
    }
  }

  @override
  Widget build(BuildContext context) {
    final forgotViewModel = Provider.of<ForgotPasswordViewModel>(context);
    return Scaffold(
      body: Stack(
        children: [
          const TBackgroundImage(imageName: TImageName.appBackground),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 70.h, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: iconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconPath: TImageName.back,
                            radius: 24.h,
                            bgColor: TAppColors.text4Color,
                            // bgColor: Colors.white.withOpacity(0.2)
                        ),
                      ),
                      const TAppTopImage(
                        titleName: TLabelStrings.forgotPassword,
                      ),
                      const SizedBox(
                        height: 28,
                        width: 28,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 0.1.sh,
                  ),
                  if (isShowError) CustomErrorWidget(errorMessage: errorMesage),
                  TTextField(
                    inputboxBoder: TAppColors.white,
                    controller: usernameController,
                    hintText: TPlaceholderStrings.email,
                    icon: TImageName.emailIcon,
                    onTapOutside: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TButton(
                    fontSize: MyFonts.size16,
                    onPressed: () {
                      // Navigator.pop(context);
                      passwordChange(context, forgotViewModel);
                    },
                    title: TButtonLabelStrings.send,
                    buttonBackground: TAppColors.selectionColor,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
