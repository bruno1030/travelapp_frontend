import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class CreateAccountScreen extends StatefulWidget {
  final String email;
  
  const CreateAccountScreen({super.key, required this.email});

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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result ?? 'Conta criada com sucesso!')),
      );

      // Se a conta foi criada com sucesso, voltar para login
      if (result != null && result.contains('Conta criada')) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

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
              const Text(
                'Criar conta',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF9FAFB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Campo email (bloqueado)
              TextField(
                controller: TextEditingController(text: widget.email),
                enabled: false,
                style: const TextStyle(color: Color(0xFF9CA3AF)),
                decoration: InputDecoration(
                  labelText: 'Email',
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
              
              // Campo senha
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: 'Senha *',
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
              
              // Campo confirmar senha
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha *',
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
              
              // Campo nome (opcional)
              TextField(
                controller: nameController,
                style: const TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: 'Nome (opcional)',
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
              
              // Campo username (opcional)
              TextField(
                controller: usernameController,
                style: const TextStyle(color: Color(0xFFF9FAFB)),
                decoration: InputDecoration(
                  labelText: 'Nome de usuário (opcional)',
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
              
              // Texto de campos obrigatórios - MOVIDO PARA ANTES DO BOTÃO
              const Text(
                '* Campos obrigatórios',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              
              // Botão criar conta
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
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Criar conta'),
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