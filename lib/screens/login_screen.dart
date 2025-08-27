import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../controllers/auth_controller.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Placeholder para o logo do app
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'Logo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Bem-vindo de volta 👋',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B), // Cor de texto principal
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Entre ou crie sua conta rapidamente',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B), // Cor de texto secundária
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Botão Google
              ElevatedButton.icon(
                onPressed: () async {
                  await auth.signInWithGoogle();
                },
                icon: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
                  height: 24,
                  width: 24,
                ),
                label: const Text('Continue com Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9), // Cor de fundo
                  foregroundColor: const Color(0xFF1E293B), // Cor do texto
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)), // Cor da borda
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (!kIsWeb && Platform.isIOS)
                const SizedBox(height: 16),
              if (!kIsWeb && Platform.isIOS)
                // Botão Apple
                SignInWithAppleButton(
                  onPressed: () async {
                    await auth.signInWithApple();
                  },
                  style: SignInWithAppleButtonStyle.black,
                ),
              const SizedBox(height: 32),
              // Divisor "ou"
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'ou',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Campo de email
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Color(0xFF64748B)),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF38BDF8), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Botão de continuar
              ElevatedButton(
                onPressed: () {
                  // Lógica para login/signup por email
                  // A tela seguinte precisará de uma verificação para saber se o usuário já existe
                  // para pedir senha ou criar nova conta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Função de email ainda não implementada.'),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continuar'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B), // Cor do botão principal
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),
              // Link para esquecer senha
              TextButton(
                onPressed: () {
                  // Lógica para resetar senha
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Função de recuperação de senha ainda não implementada.'),
                    ),
                  );
                },
                child: const Text(
                  'Esqueceu sua senha?',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
