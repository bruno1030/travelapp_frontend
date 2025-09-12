import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthController>(context, listen: false);
    _usernameController = TextEditingController(
      text: auth.currentUser?.displayName ?? "",
    );
    _nameController = TextEditingController(
      text: auth.currentUser?.displayName ?? "",
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final locale = Provider.of<LocaleController>(context).locale;

    // Se o usuário não estiver logado, redireciona para a tela de login.
    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    final user = auth.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        city: null,
        locale: locale,
        title: "Profile",
      ),
      bottomNavigationBar: CustomBottomBar(),
      body: Container(
        color: const Color(0xFF262626),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "User Info",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isEditing ? Icons.close : Icons.edit,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Email: ${user?.email ?? "N/A"}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'UID: ${user?.uid ?? "N/A"}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      enabled: _isEditing,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _usernameController,
                      enabled: _isEditing,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Username",
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey[850],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_isEditing) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditing = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Changes saved (mock only)"),
                            ),
                          );
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await auth.signOut();
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
