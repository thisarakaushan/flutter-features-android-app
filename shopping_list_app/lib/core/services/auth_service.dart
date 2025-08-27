// Packages
import 'package:firebase_auth/firebase_auth.dart';

// Utils
import '../utils/helpers.dart';

// Services
import '../../core/services/firebase_service.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseService.auth;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      Helpers.showError(e.message ?? 'Authentication failed');
      return null;
    }
  }

  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await result.user?.updateDisplayName(username);
      await result.user?.sendEmailVerification();
      return result.user;
    } on FirebaseAuthException catch (e) {
      Helpers.showError(e.message ?? 'Registration failed');
      return null;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      Helpers.showSuccess('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      Helpers.showError(e.message ?? 'Failed to send reset email');
    }
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      Helpers.showError('Failed to sign out');
    }
  }
}
