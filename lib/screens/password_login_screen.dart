import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'profile_screen.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class PasswordLoginScreen extends StatefulWidget {
  final String email;
  final String? redirectTo; // 👈 novo parâmetro

  const PasswordLoginScreen({super.key, required this.email, this.redirectTo});

  @override
  State<PasswordLoginScreen> createState() => _PasswordLoginScreenState();
}

class _PasswordLoginScreenState extends State<PasswordLoginScreen> {
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(AuthController auth) async {
    final password = passwordController.text.trim();

    String enterPasswordPrompt = AppLocalizations.of(context)?.enter_password_prompt ?? 'Please enter your password';

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(enterPasswordPrompt)),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final result = await auth.signInWithEmail(widget.email, password);

    setState(() {
      _loading = false;
    });

    if (result != null && result.startsWith('ey')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );

      // Redirecionamento baseado em redirectTo
      if (widget.redirectTo == 'post_photo') {
        Navigator.of(context).pop('post_photo'); // retorna para CustomBottomBar
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Erro desconhecido')),
      );
    }
  }

  Future<void> _forgotPassword(AuthController auth) async {
    final result = await auth.resetPassword(widget.email);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Erro ao enviar email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    String enterPasswordLabel = AppLocalizations.of(context)?.enter_password_label ?? 'Please enter your password';
    String passwordLabel = AppLocalizations.of(context)?.password_label ?? 'Password';
    String forgotYourPasswordString = AppLocalizations.of(context)?.forgot_your_password ?? 'Forgot your password?';
    String loginButton = AppLocalizations.of(context)?.login_button ?? 'Sign in';

    return Scaffold(
      backgroundColor: const Color(0xFF020202),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF9FAFB)),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                enterPasswordLabel,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9FAFB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF9CA3AF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: passwordLabel,
                  labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFF18181B),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF9CA3AF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
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
                onPressed: _loading ? null : () => _signIn(auth),
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
                          Text(loginButton),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _loading ? null : () => _forgotPassword(auth),
                child: Text(
                  forgotYourPasswordString,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
