import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'profile_screen.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  final String? redirectTo; // 👈 novo parâmetro

  const CreateAccountScreen({
    super.key,
    required this.email,
    this.redirectTo,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite uma senha')),
      );
      return false;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter pelo menos 6 caracteres')),
      );
      return false;
    }

    if (confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, confirme sua senha')),
      );
      return false;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem')),
      );
      return false;
    }

    return true;
  }

  Future<void> _createAccount(AuthController auth) async {
    if (!_validateForm()) return;

    setState(() {
      _loading = true;
    });

    final result = await auth.registerWithEmailAndData(
      email: widget.email,
      password: passwordController.text.trim(),
      username: usernameController.text.trim().isEmpty 
          ? null 
          : usernameController.text.trim(),
      name: nameController.text.trim().isEmpty 
          ? null 
          : nameController.text.trim(),
    );

    setState(() {
      _loading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result ?? 'Conta criada com sucesso!')),
    );

    // Se a conta foi criada com sucesso, loga automaticamente
    if (result != null && result.contains('Conta criada')) {
      await auth.signInWithEmail(widget.email, passwordController.text.trim());

      // Redirecionamento baseado no parâmetro
      if (widget.redirectTo == 'post_photo') {
        Navigator.of(context).pop('post_photo'); // volta para CustomBottomBar
      } else {
        // Por padrão ou se redirectTo == 'profile'
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    String createAccount = AppLocalizations.of(context)?.create_account ?? 'Create account';
    String emailString = AppLocalizations.of(context)?.email ?? 'Email';
    String passString = AppLocalizations.of(context)?.password_as_required ?? 'Password *';
    String passConfirmationString = AppLocalizations.of(context)?.confirm_your_password_as_required ?? 'Confirm your password *';
    String nameOptionalString = AppLocalizations.of(context)?.name_optional ?? 'Name (optional)';
    String usernameOptionalString = AppLocalizations.of(context)?.username_optional ?? 'Username (optional)';
    String mandatoryFieldsString = AppLocalizations.of(context)?.mandatory_fields ?? '* Mandatory fields';

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
                createAccount,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9FAFB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: TextEditingController(text: widget.email),
                enabled: false,
                style: TextStyle(color: Color(0xFF9CA3AF)),
                decoration: InputDecoration(
                  labelText: emailString,
                  labelStyle: const TextStyle(color: Color(0xFF6B7280)),
                  filled: true,
                  fillColor: const Color(0xFF111114),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF374151),
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: passString,
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
              const SizedBox(height: 16),
              
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: passConfirmationString,
                  labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: const Color(0xFF18181B),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                      color: const Color(0xFF9CA3AF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
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
              const SizedBox(height: 16),
              
              TextField(
                controller: nameController,
                style: TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: nameOptionalString,
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
              const SizedBox(height: 16),
              
              TextField(
                controller: usernameController,
                style: TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: usernameOptionalString,
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
              const SizedBox(height: 16),
              
              Text(
                mandatoryFieldsString,
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              
              ElevatedButton(
                onPressed: _loading ? null : () => _createAccount(auth),
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
                          Text(createAccount),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
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
