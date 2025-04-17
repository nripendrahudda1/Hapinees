// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
//
// class FaceBookAuthService {
//   final plugin = FacebookLogin();
//   FacebookAccessToken? token;
//   FacebookUserProfile? profile;
//   String? email;
//   String? imageUrl;
//
//   Future<void> onPressedLogInButton() async {
//     await plugin.logIn(permissions: [
//       FacebookPermission.publicProfile,
//       FacebookPermission.email,
//     ]);
//     await updateLoginInfo();
//   }
//
//   Future<void> onPressedExpressLogInButton() async {
//     final res = await plugin.expressLogin();
//     if (res.status == FacebookLoginStatus.success) {
//       await updateLoginInfo();
//     } else {
//       // await showDialog<Object>(
//       //   context: context,
//       //   builder: (context) => const AlertDialog(
//       //     content: Text("Can't make express log in. Try regular log in."),
//       //   ),
//       // );
//     }
//   }
//
//   Future<void> onPressedLogOutButton() async {
//     await plugin.logOut();
//     await updateLoginInfo();
//   }
//
//   Future<void> updateLoginInfo() async {
//     // final plugin = .plugin;
//     token = await plugin.accessToken;
//
//     if (token != null) {
//       profile = await plugin.getUserProfile();
//       if (token!.permissions.contains(FacebookPermission.email.name)) {
//         email = await plugin.getUserEmail();
//       }
//       imageUrl = await plugin.getProfileImageUrl(width: 100);
//     }
//   }
// }
