// Packages
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

// Repository
import '../../data/repositories/shopping_list_repository.dart';

// Models
import '../../data/models/shopping_list_model.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

// Rouets
import '../../routes/app_routes.dart';

class ShoppingListController extends GetxController {
  final ShoppingListRepository _repository = ShoppingListRepository();
  var isLoading = false.obs;

  Future<void> createList(String title, String? description) async {
    isLoading.value = true;
    try {
      final userId =
          Get.find<AuthController>().authService.auth.currentUser?.uid ?? '';
      final list = ShoppingListModel(
        id: '',
        title: title,
        description: description,
        code: Uuid().v4().substring(0, 6),
        members: [userId],
      );
      await _repository.createList(list);
      isLoading.value = false;
      Get.back();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to create list: $e');
    }
  }

  Future<void> joinList(String code) async {
    isLoading.value = true;
    try {
      final list = await _repository.getListByCode(code);
      if (list != null) {
        final userId =
            Get.find<AuthController>().authService.auth.currentUser?.uid ?? '';
        await _repository.joinList(list.id, userId);
        Get.offNamed(AppRoutes.DASHBOARD);
      } else {
        Get.snackbar('Error', 'Invalid list code');
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to join list: $e');
    }
  }
}
