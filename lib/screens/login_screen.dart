import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'password_login_screen.dart';
import 'create_account_screen.dart';
import 'dart:io';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final String? redirectTo; // 👈 adicionado

  const LoginScreen({super.key, this.redirectTo});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _continueWithEmail(AuthController auth) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite seu email')),
      );
      return;
    }

    // Validação básica de email
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite um email válido')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      // Chama método que verificará se email existe via endpoint
      final userExists = await auth.checkUserByEmail(email);

      setState(() {
        _loading = false;
      });

      if (userExists) {
        // Email existe → vai para tela de senha
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PasswordLoginScreen(
              email: email,
              redirectTo: widget.redirectTo,
            ),
          ),
        ).then((result) {
          if (result != null) Navigator.of(context).pop(result);
        });
      } else {
        // Email não existe → vai para tela de criação de conta
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAccountScreen(
              email: email,
              redirectTo: widget.redirectTo, // 👈 repassa
            ),
          ),
        ).then((result) {
          if (result != null) Navigator.of(context).pop(result);
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao verificar email: $e')),
      );
    }
  }

  Future<void> _loginWithGoogle(AuthController auth) async {
    setState(() {
      _loading = true;
    });

    try {
      final token = await auth.signInWithGoogle();
      setState(() {
        _loading = false;
      });

      if (token != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login com Google realizado com sucesso!')),
        );
        debugPrint('Firebase ID Token: $token');

        // ✅ Após login bem sucedido, retorna redirectTo
        Navigator.of(context).pop(widget.redirectTo);
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login com Google: $e')),
      );
    }
  }

  // Verifica se deve mostrar botão Google (apenas Android e Web)
  bool get _shouldShowGoogleButton {
    if (kIsWeb) return true; // Web: sempre mostrar
    return !Platform.isIOS; // Mobile: mostrar apenas se NÃO for iOS
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    String continueWithGoogle = AppLocalizations.of(context)?.continue_with_google ?? 'Continue with Google';
    String or = AppLocalizations.of(context)?.or ?? 'or';
    String emailString = AppLocalizations.of(context)?.email ?? 'Email';
    String continueString = AppLocalizations.of(context)?.continue_string ?? 'Continue';
    String welcome = AppLocalizations.of(context)?.welcome ?? 'Welcome to Clixpot!';

    return Scaffold(
      backgroundColor: const Color(0xFF020202),
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
              Center(
                child: Image.asset(
                  'assets/logo_FE1F80.png',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                welcome,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9FAFB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Botão Google - só aparece no Android e Web
              if (_shouldShowGoogleButton) ...[
                ElevatedButton.icon(
                  onPressed: _loading ? null : () => _loginWithGoogle(auth),
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/2048px-Google_%22G%22_logo.svg.png',
                    height: 24,
                    width: 24,
                  ),
                  label: Text(continueWithGoogle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    foregroundColor: const Color(0xFF1E293B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                const SizedBox(height: 32),

                // Divisor "ou" - só aparece quando tem botão Google
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFF27272A)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        or,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFF27272A)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: emailString,
                  labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFF18181B),
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
                    borderSide: const BorderSide(
                      color: Color(0xFFFE1F80),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loading ? null : () => _continueWithEmail(auth),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFE1F80),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(continueString),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
