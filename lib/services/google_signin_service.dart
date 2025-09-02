import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

// Imports condicionais separados
import 'google_signin_mobile.dart' if (dart.library.html) 'google_signin_web.dart' as platform_signin;

class GoogleSignInService {
  static Future<String?> signInWithGoogle(FirebaseAuth auth) async {
    return await platform_signin.signInWithGoogle(auth);
  }

  static Future<void> signOut() async {
    await platform_signin.signOut();
  }
}