import 'package:flutter/foundation.dart' show kIsWeb;

// Import condicional: web usa stub, mobile usa google_sign_in real
import 'package:google_sign_in/google_sign_in.dart'
    if (dart.library.html) 'package:travelapp_frontend/web_google_stub.dart';

class GoogleSignInService {
  static GoogleSignInBase create() {
    if (kIsWeb) {
      return GoogleSignInStub(); // seu stub web
    } else {
      return GoogleSignInReal(); // implementa wrapper do GoogleSignIn oficial
    }
  }
}

abstract class GoogleSignInBase {
  Future<GoogleSignInAccount?> signIn();
  Future<void> signOut();
}

class GoogleSignInStub implements GoogleSignInBase {
  @override
  Future<GoogleSignInAccount?> signIn() async =>
      throw UnimplementedError('Use FirebaseAuth.signInWithPopup no web');
  @override
  Future<void> signOut() async {}
}

class GoogleSignInReal implements GoogleSignInBase {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  @override
  Future<void> signOut() => _googleSignIn.signOut();
}
