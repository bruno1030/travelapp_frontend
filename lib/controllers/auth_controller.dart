import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? currentUser;

  bool get isLoggedIn => currentUser != null;

  /// Inicializa listener de autenticação
  void init() {
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  // ---------------------------
  // LOGIN COM GOOGLE
  // ---------------------------
  Future<void> signInWithGoogle() async {
    try {
        if (kIsWeb) {
        // Web: Login via popup
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        await _auth.signInWithPopup(googleProvider);
        } else {
        // Mobile: Login via FirebaseAuth com Google provider
        final provider = GoogleAuthProvider();
        await _auth.signInWithProvider(provider);
        }
    } catch (e) {
        debugPrint('Erro ao fazer login com Google: $e');
        rethrow;
    }
    }

  // ---------------------------
  // LOGIN COM EMAIL + SENHA
  // ---------------------------
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

  // ---------------------------
  // CRIAR CONTA COM EMAIL + SENHA
  // ---------------------------
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential cred =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await cred.user?.updateDisplayName(username);
      await cred.user?.sendEmailVerification();

      await _auth.signOut();
      currentUser = null;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao criar conta.';
    }
  }

  // ---------------------------
  // LOGOUT
  // ---------------------------
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
