// Services
import '../../core/services/auth_service.dart';

// Models
import '../models/user_model.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<UserModel?> login(String email, String password) async {
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel?> register(
    String email,
    String password,
    String username,
  ) async {
    try {
      final user = await _authService.signUp(email, password, username);
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          username: user.displayName ?? '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
