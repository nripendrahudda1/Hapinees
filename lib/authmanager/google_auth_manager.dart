import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    print("googleUser ************ $googleUser");
    if (googleUser != null) {
      return googleUser;
    } else {}
    return null;
  }

  static Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }
}
