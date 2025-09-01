import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:travelapp_frontend/services/google_sign_in_service.dart'; // <- factory do GoogleSignIn
import 'package:travelapp_frontend/config.dart';

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

  // Verifica se o email existe no backend
  Future<bool> checkUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/check-email?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) return true;
      if (response.statusCode == 404) return false;

      throw Exception('Erro ao verificar email: ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao verificar email: $e');
      rethrow;
    }
  }

  // Login com Google
  Future<String?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web: login direto pelo FirebaseAuth popup
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'prompt': 'select_account'});

        UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider);
        currentUser = userCredential.user;
        notifyListeners();
        return await currentUser?.getIdToken();
      } else {
        // Android / iOS: usa factory do GoogleSignInService
        final GoogleSignInBase googleSignIn = GoogleSignInService.create();
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null; // Usuário cancelou

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
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

  // Registro com email + dados adicionais
  Future<String?> registerWithEmailAndData({
    required String email,
    required String password,
    String? username,
    String? name,
  }) async {
    try {
      UserCredential cred =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      if (name != null && name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }

      await cred.user?.sendEmailVerification();

      await _saveUserDataToBackend(
        firebaseUid: cred.user!.uid,
        email: email,
        username: username,
        name: name,
      );

      await _auth.signOut();
      return 'Conta criada! Verifique seu email antes de fazer login.';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao criar conta: $e';
    }
  }

  // Salva dados do usuário no backend
  Future<void> _saveUserDataToBackend({
    required String firebaseUid,
    required String email,
    String? username,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firebase_uid': firebaseUid,
          'email': email,
          'username': username,
          'name': name,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Erro ao salvar usuário no backend: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao salvar usuário no backend: $e');
    }
  }

  // Reset de senha
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Email de recuperação enviado! Verifique sua caixa de entrada.';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao enviar email de recuperação.';
    }
  }

  // Logout
  Future<void> signOut() async {
    if (!kIsWeb) {
      final GoogleSignInBase googleSignIn = GoogleSignInService.create();
      await googleSignIn.signOut();
    }
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}
