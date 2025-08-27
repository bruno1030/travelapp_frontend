import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final message = await auth.signInWithEmail(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                if (message != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(message)));
                }
              },
              child: const Text('Login with Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await auth.signInWithGoogle();
              },
              child: const Text('Continue with Google'),
            ),
            if (!kIsWeb && Platform.isIOS)
              const SizedBox(height: 10),
            if (!kIsWeb && Platform.isIOS)
              SignInWithAppleButton(
                onPressed: () async {
                  await auth.signInWithApple();
                },
              ),
          ],
        ),
      ),
    );
  }
}
