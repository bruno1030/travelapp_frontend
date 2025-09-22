import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:travelapp_frontend/config.dart';
import 'package:travelapp_frontend/services/google_signin_service.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  String? backendName;
  String? backendUsername;
  int? backendUserId; // 👈 novo campo

  bool get isLoggedIn => currentUser != null;

  void init() {
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      debugPrint('Auth state changed. Current user: ${user?.uid}');
      notifyListeners();
    });
  }

  Future<bool> checkUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/check-email?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );

      debugPrint('checkUserByEmail response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) return true;
      if (response.statusCode == 404) return false;
      throw Exception('Erro ao verificar email: ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao verificar email: $e');
      rethrow;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final token = await GoogleSignInService.signInWithGoogle(_auth);

      if (token != null) {
        currentUser = _auth.currentUser;
        debugPrint('Google sign-in successful. UID: ${currentUser?.uid}, ID Token: $token');

        final isNewUser = await _checkIfUserIsNew();
        debugPrint('Is new user in backend? $isNewUser');

        if (isNewUser) await _handleNewGoogleUser();

        notifyListeners();
      }

      return token;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      if (e.code == 'account-exists-with-different-credential') {
        return 'Essa conta já foi criada com outro método de login. Use esse método para entrar.';
      }
      rethrow;
    } catch (e) {
      debugPrint('Erro ao fazer login/cadastro com Google: $e');
      rethrow;
    }
  }

  Future<bool> _checkIfUserIsNew() async {
    if (currentUser?.email == null) return false;

    try {
      final userExists = await checkUserByEmail(currentUser!.email!);
      debugPrint('checkIfUserIsNew result: $userExists');
      return !userExists;
    } catch (e) {
      debugPrint('Erro ao verificar se usuário é novo: $e');
      return false;
    }
  }

  Future<void> _handleNewGoogleUser() async {
    if (currentUser == null) return;

    try {
      debugPrint('Saving new Google user to backend. UID: ${currentUser!.uid}');
      await _saveUserDataToBackend(
        email: currentUser!.email!,
        name: currentUser!.displayName,
        username: null,
        provider: "google",
      );
    } catch (e) {
      debugPrint('Erro ao salvar novo usuário Google no backend: $e');
    }
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      UserCredential cred =
          await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (!(cred.user?.emailVerified ?? false)) {
        await _auth.signOut();
        return 'Por favor, confirme seu email antes de fazer login.';
      }

      currentUser = cred.user;
      debugPrint('Email sign-in successful. UID: ${currentUser?.uid}');

      final idToken = await currentUser?.getIdToken();
      debugPrint('ID Token for email login: $idToken');

      notifyListeners();
      return idToken;
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      return e.message;
    } catch (e) {
      debugPrint('Erro ao fazer login com email: $e');
      return 'Erro ao fazer login com email.';
    }
  }

  Future<String?> registerWithEmailAndData({
    required String email,
    required String password,
    String? username,
    String? name,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (name != null && name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }

      await cred.user?.sendEmailVerification();

      debugPrint('New user registered with email. UID: ${cred.user?.uid}');

      await _saveUserDataToBackend(
        email: email,
        username: username,
        name: name,
        provider: "email",
      );

      await _auth.signOut();
      return 'Conta criada! Verifique seu email antes de fazer login.';
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during registration: ${e.code} - ${e.message}');
      return e.message;
    } catch (e) {
      debugPrint('Erro ao criar conta: $e');
      return 'Erro ao criar conta: $e';
    }
  }

  Future<void> _saveUserDataToBackend({
    required String email,
    required String provider,
    String? username,
    String? name,
  }) async {
    try {
      final idToken = await _auth.currentUser?.getIdToken();

      debugPrint('Saving user data to backend. UID: ${currentUser?.uid}, ID Token: $idToken');

      final Map<String, dynamic> body = {
        'email': email,
        'provider': provider,
        if (username != null) 'username': username,
        if (name != null) 'name': name,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/users/create-from-firebase'),
        headers: {
          'Content-Type': 'application/json',
          if (idToken != null) 'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(body),
      );

      debugPrint('Backend response: ${response.statusCode} ${response.body}');

      if (response.statusCode != 201) {
        throw Exception('Erro ao salvar usuário no backend: ${response.body}');
      }
    } catch (e) {
      debugPrint('Erro ao salvar usuário no backend: $e');
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Email de recuperação enviado! Verifique sua caixa de entrada.';
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException during password reset: ${e.code} - ${e.message}');
      return e.message;
    } catch (e) {
      debugPrint('Erro ao enviar email de recuperação: $e');
      return 'Erro ao enviar email de recuperação.';
    }
  }

  Future<void> signOut() async {
    await GoogleSignInService.signOut();
    await _auth.signOut();
    debugPrint('User signed out. UID before clearing: ${currentUser?.uid}');
    currentUser = null;
    backendUserId = null; // 👈 limpa id
    backendName = null;
    backendUsername = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getCurrentUserFromBackend() async {
    try {
      final idToken = await _auth.currentUser?.getIdToken();

      if (idToken == null) return null;

      final response = await http.get(
        Uri.parse('$baseUrl/users/current'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        debugPrint('Failed to fetch current user. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Erro ao obter usuário atual do backend: $e');
      return null;
    }
  }

  Future<void> fetchAndSetUserData() async {
    final data = await getCurrentUserFromBackend();
    if (data != null) {
      backendName = data['name'] as String?;
      backendUsername = data['username'] as String?;
      backendUserId = data['id'] as int?; // 👈 salva o id do backend
      debugPrint('Fetched user data: id=$backendUserId, name=$backendName, username=$backendUsername');
      notifyListeners();
    }
  }
}
