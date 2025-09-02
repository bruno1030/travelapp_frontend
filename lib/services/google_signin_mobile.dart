import 'package:firebase_auth/firebase_auth.dart';

Future<String?> signInWithGoogle(FirebaseAuth auth) async {
  try {
    // Cria o provedor Google
    final googleProvider = GoogleAuthProvider();

    // Para Android/iOS, a forma moderna é usar signInWithProvider
    final userCredential = await auth.signInWithProvider(googleProvider);

    // Retorna o token de ID do Firebase
    return await userCredential.user?.getIdToken();
  } catch (e) {
    // Lança exceção para o controller lidar
    rethrow;
  }
}

Future<void> signOut() async {
  try {
    // Desloga do Firebase
    await FirebaseAuth.instance.signOut();
  } catch (_) {
    // Ignora falha no signOut
  }
}
