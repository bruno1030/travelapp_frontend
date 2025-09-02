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
  
  // URL base do seu backend - ajuste conforme necessário
  static const String _baseUrl = 'https://your-backend-url.com/api';

  bool get isLoggedIn => currentUser != null;

  void init() {
    _auth.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  // Método para verificar se email existe no backend
  Future<bool> checkUserByEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/check-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Email existe
        return true;
      } else if (response.statusCode == 404) {
        // Email não existe
        return false;
      } else {
        // Outro erro
        throw Exception('Erro ao verificar email: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao verificar email: $e');
      rethrow;
    }
  }

  // Login/Cadastro com Google - agora trata ambos os casos
  Future<String?> signInWithGoogle() async {
    try {
      final token = await GoogleSignInService.signInWithGoogle(_auth);
      
      if (token != null) {
        currentUser = _auth.currentUser;
        
        // Verifica se é um usuário novo (primeiro login)
        final isNewUser = await _checkIfUserIsNew();
        
        if (isNewUser) {
          // É cadastro: salva no backend
          await _handleNewGoogleUser();
          debugPrint('Novo usuário cadastrado via Google');
        } else {
          // É login normal
          debugPrint('Login existente via Google');
        }
        
        notifyListeners();
      }
      return token;
    } catch (e) {
      debugPrint('Erro ao fazer login/cadastro com Google: $e');
      rethrow;
    }
  }

  // Verifica se usuário é novo no seu backend
  Future<bool> _checkIfUserIsNew() async {
    if (currentUser?.email == null) return false;
    
    try {
      final userExists = await checkUserByEmail(currentUser!.email!);
      return !userExists; // Se não existe = é novo
    } catch (e) {
      debugPrint('Erro ao verificar se usuário é novo: $e');
      return false; // Em caso de erro, assume que já existe
    }
  }

  // Trata usuário novo que se cadastrou via Google
  Future<void> _handleNewGoogleUser() async {
    if (currentUser == null) return;
    
    try {
      await _saveUserDataToBackend(
        firebaseUid: currentUser!.uid,
        email: currentUser!.email!,
        name: currentUser!.displayName,
        // Username pode ser gerado automaticamente ou deixado null
        username: null,
      );
    } catch (e) {
      debugPrint('Erro ao salvar novo usuário Google no backend: $e');
      // Não falha o login se o backend falhar
    }
  }

  // Login com email e senha (para a tela PasswordLoginScreen)
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

  // Registro com email e dados adicionais (para a tela CreateAccountScreen)
  Future<String?> registerWithEmailAndData({
    required String email,
    required String password,
    String? username,
    String? name,
  }) async {
    try {
      // 1. Criar usuário no Firebase
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // 2. Atualizar displayName se fornecido
      if (name != null && name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }

      // 3. Enviar email de verificação
      await cred.user?.sendEmailVerification();
      
      // 4. Salvar dados adicionais no backend
      await _saveUserDataToBackend(
        firebaseUid: cred.user!.uid,
        email: email,
        username: username,
        name: name,
      );

      // 5. Fazer logout até verificar email
      await _auth.signOut();
      
      return 'Conta criada! Verifique seu email antes de fazer login.';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro ao criar conta: $e';
    }
  }

  // Método privado para salvar dados do usuário no backend
  Future<void> _saveUserDataToBackend({
    required String firebaseUid,
    required String email,
    String? username,
    String? name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/users/create'),
        headers: {
          'Content-Type': 'application/json',
        },
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
      // Por enquanto não vamos falhar o cadastro se o backend falhar
    }
  }

  // Método para recuperar senha
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

  Future<void> signOut() async {
    await GoogleSignInService.signOut();
    await _auth.signOut();
    currentUser = null;
    notifyListeners();
  }
}