// Stub para GoogleSignIn no Web - evita erros de compilação
class GoogleSignIn {
  GoogleSignIn({List<String>? scopes});
  
  Future<GoogleSignInAccount?> signIn() async {
    throw UnimplementedError('Use Firebase Auth popup para web');
  }
  
  Future<void> signOut() async {
    // Não faz nada no web
  }
}

class GoogleSignInAccount {
  Future<GoogleSignInAuthentication> authentication() async {
    throw UnimplementedError();
  }
}

class GoogleSignInAuthentication {
  String? get idToken => null;
  String? get accessToken => null;
}