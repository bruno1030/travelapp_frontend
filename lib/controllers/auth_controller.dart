import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

// Importação condicional para funcionar no web e mobile
import 'package:google_sign_in/google_sign_in.dart'
    if (dart.library.html) 'package:travelapp_frontend/web_google_stub.dart';

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

  // Login com Google
  Future<String?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: usa popup do Firebase diretamente
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});
        
        UserCredential userCredential = await _auth.signInWithPopup(googleProvider);
        currentUser = userCredential.user;
        notifyListeners();
        return await currentUser?.getIdToken();
      } else {
        // Android / iOS: usa GoogleSignIn
        // Só importa e usa GoogleSignIn em mobile
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: ['email'],
        );
        
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null; // Usuário cancelou

        final googleAuth = await googleUser.authentication();

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        currentUser = userCredential.user;
        notifyListeners();
        return await currentUser?.getIdToken();
      }
    } catch (e) {
      debugPrint('Erro ao fazer login com Google: $e');
      rethrow;
    }
  }

  // Login com email e senha
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!(cred.user?.emailVerified ?? false)) {
        await _auth.signOut();
        return 'Por favor, confirme seu email antes de fazer login.';
      }

      currentUser = cred.user;
      notifyListeners();
      return await currentUser?.getIdToken();
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao fazer login com email.';
    }
  }

  // Registro com email e senha
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Enviar email de verificação
      await cred.user?.sendEmailVerification();
      
      // Fazer logout até verificar email
      await _auth.signOut();
      
      return 'Conta criada! Verifique seu email antes de fazer login.';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao criar conta.';
    }
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      // Só faz logout do GoogleSignIn em mobile
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
    }
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}