import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import 'package:travelapp_frontend/widgets/custom_app_bar.dart';
import 'package:travelapp_frontend/widgets/custom_bottom_bar.dart';
import 'package:travelapp_frontend/controllers/locale_controller.dart';
import 'package:travelapp_frontend/generated/app_localizations.dart';
import 'package:travelapp_frontend/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _isEditing = false;
  bool _isLoading = true;

  // Para restaurar valores originais se cancelar
  String _originalName = "";
  String _originalUsername = "";

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthController>(context, listen: false);

    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await auth.fetchAndSetUserData();
      setState(() {
        _nameController.text = auth.backendName ?? "";
        _usernameController.text = auth.backendUsername ?? "";
        _emailController.text = auth.currentUser?.email ?? "";
        _originalName = _nameController.text;
        _originalUsername = _usernameController.text;
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _nameController.text = _originalName;
      _usernameController.text = _originalUsername;
    });
  }

  void _saveEditing() async {
    final auth = Provider.of<AuthController>(context, listen: false);

    final newName = _nameController.text.trim();
    final newUsername = _usernameController.text.trim();

    setState(() {
      _isEditing = false;
      _originalName = newName;
      _originalUsername = newUsername;
      _isLoading = true;
    });

    try {
      await ApiService.updateUserProfile(
        firebaseUid: auth.currentUser!.uid,
        name: newName,
        username: newUsername,
      );

      // Atualiza localmente os dados no AuthController
      auth.backendName = newName;
      auth.backendUsername = newUsername;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao atualizar perfil: $e")),
      );

      // Restaura valores originais em caso de erro
      setState(() {
        _nameController.text = _originalName;
        _usernameController.text = _originalUsername;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);
    final locale = Provider.of<LocaleController>(context).locale;

    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    String profileString = AppLocalizations.of(context)?.profile ?? 'Profile';
    String userInfoString = AppLocalizations.of(context)?.user_info ?? 'User info';
    String nameString = AppLocalizations.of(context)?.name ?? 'Name';
    String usernameString = AppLocalizations.of(context)?.username ?? 'Username';
    String emailString = AppLocalizations.of(context)?.email ?? 'Email';
    String logoutString = AppLocalizations.of(context)?.logout ?? 'Logout';
    String saveString = AppLocalizations.of(context)?.save ?? 'Save';
    String cancelString = AppLocalizations.of(context)?.cancel ?? 'Cancel';

    return Scaffold(
      appBar: CustomAppBar(
        city: null,
        locale: locale,
        title: profileString,
      ),
      bottomNavigationBar: const CustomBottomBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userInfoString,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!_isEditing)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isEditing = true;
                                        });
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _nameController,
                                enabled: _isEditing,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: nameString,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: usernameString,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                controller: _emailController,
                                enabled: false,
                                style: TextStyle(color: Colors.white70),
                                decoration: InputDecoration(
                                  labelText: emailString,
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  labelStyle: const TextStyle(color: Colors.white70),
                                  filled: true,
                                  fillColor: Colors.grey[850],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 60), // espaço reservado para os botões
                            ],
                          ),
                        ),
                        // Botões fixos na parte inferior do card
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Visibility(
                            visible: _isEditing,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: _cancelEditing,
                                  child: Text(
                                    cancelString,
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _saveEditing,
                                  child: Text(
                                    saveString,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                    child: Text(
                      logoutString,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
