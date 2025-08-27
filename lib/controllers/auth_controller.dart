import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:io';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  bool get isLoggedIn => currentUser != null;

  void init() {
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        await _auth.signInWithPopup(googleProvider);
      } else {
        final provider = GoogleAuthProvider();
        await _auth.signInWithProvider(provider);
      }
    } catch (e) {
      debugPrint('Erro ao fazer login com Google: $e');
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    if (kIsWeb || !Platform.isIOS) return;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final authCredential = oAuthProvider.credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      await _auth.signInWithCredential(authCredential);
    } catch (e) {
      debugPrint('Erro ao fazer login com Apple: $e');
      rethrow;
    }
  }

  Future<String?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!(cred.user?.emailVerified ?? false)) {
        await _auth.signOut();
        return 'Por favor, confirme seu email antes de fazer login.';
      }

      currentUser = cred.user;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao fazer login com email.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
