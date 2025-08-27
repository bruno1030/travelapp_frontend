import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    // Se o usuário não estiver logado, redireciona para a tela de login.
    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user?.email ?? "N/A"}'),
            const SizedBox(height: 8),
            Text('UID: ${user?.uid ?? "N/A"}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await auth.signOut();
                // Após o logout, não precisamos redirecionar explicitamente,
                // pois o ProfileScreen já irá chamar o LoginScreen
                // devido à lógica no início do método build.
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
