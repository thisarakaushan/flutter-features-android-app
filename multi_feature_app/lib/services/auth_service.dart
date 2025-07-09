// Packages
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// Models
import '../models/user_model.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  Future<User> signIn(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return User(id: user.uid, email: user.email!);
  }

  Future<User> signUp(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return User(id: user.uid, email: user.email!);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
