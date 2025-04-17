
import 'package:Happinest/core/api_urls.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import '../../common/widgets/appbar.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ChangePasswordScreen> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future changePassword() async {
    var url = ApiUrl.changePassword;
    await ApiService.fetchApi(
        context: context,
        url: url,
        params: {
          "currentPassword": oldPassword.text,
          "newPassword": newPassword.text
        },
        onSuccess: (res) {
          res['responseStatus'].toString().trim().toLowerCase() == 'false'
              ? EasyLoading.showError(res['validationMessage'].toString(),duration: const Duration(seconds: 6))
              : Navigator.pop(context);
          res['responseStatus'].toString().trim().toLowerCase() == 'false'
              ? null
              : EasyLoading.showSuccess('Password Changed Successfully');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Change Password',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TCard(
                border: true,
                child: TTextField(
                    isSecure: true,
                    controller: oldPassword,
                    hintText: 'Current Password',
                    onTapOutside: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                )),
            const SizedBox(height: 12),
            TCard(
                border: true,
                child: TTextField(
                    isSecure: true,
                    controller: newPassword,
                    hintText: 'New Password',
                    onTapOutside: (p0) {
                      FocusScope.of(context).unfocus();
                    },
                )),
            const SizedBox(height: 18),
            TButton(
                onPressed: () {
                  if (newPassword.text.isNotEmpty &&
                      oldPassword.text.isNotEmpty) {
                    primaryFocus?.unfocus();
                    changePassword();
                  } else {
                    EasyLoading.showInfo('Please Enter Valid Details');
                  }
                },
                title: 'Change Password',
                buttonBackground: TAppColors.orange)
          ],
        ),
      ),
    );
  }
}
