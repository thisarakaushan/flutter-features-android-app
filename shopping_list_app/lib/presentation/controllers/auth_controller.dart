// Packages
import 'package:get/get.dart';

// Repositories
import '../../data/repositories/auth_repository.dart';

// Services
import '../../core/services/auth_service.dart';

// Routes
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final AuthService authService = AuthService(); // Added authService
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authRepository.login(email, password);
      isLoading.value = false;
      if (user != null) {
        if (authService.auth.currentUser?.emailVerified ?? false) {
          Get.offAllNamed(AppRoutes.DASHBOARD);
        } else {
          Get.toNamed(AppRoutes.VERIFY_EMAIL);
        }
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register(String email, String password, String username) async {
    isLoading.value = true;
    try {
      final user = await _authRepository.register(email, password, username);
      isLoading.value = false;
      if (user != null) {
        Get.toNamed(AppRoutes.VERIFY_EMAIL);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await _authRepository.resetPassword(email);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authRepository.logout();
      isLoading.value = false;
      Get.offAllNamed(AppRoutes.LOGIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString());
    }
  }
}
