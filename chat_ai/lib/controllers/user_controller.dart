import 'package:auth_state_manager/auth_state_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;
  static Future<User?> loginWithGoogle() async {
    final googleAccount = await GoogleSignIn().signIn();
    final googleAuth = await googleAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (googleAuth?.accessToken != null) {
      final isSuccesful = await AuthStateManager.instance
          .setToken(googleAuth?.accessToken ?? '');
      if (isSuccesful) {
        AuthStateManager.instance.login();
      }
    }
    return userCredential.user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }
}


