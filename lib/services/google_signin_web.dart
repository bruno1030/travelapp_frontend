import 'package:firebase_auth/firebase_auth.dart';

Future<String?> signInWithGoogle(FirebaseAuth auth) async {
  try {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.setCustomParameters({'prompt': 'select_account'});
    
    UserCredential userCredential = await auth.signInWithPopup(googleProvider);
    return await userCredential.user?.getIdToken();
  } catch (e) {
    rethrow;
  }
}

Future<void> signOut() async {
  // Não faz nada no web
}