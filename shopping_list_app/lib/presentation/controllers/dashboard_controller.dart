// Packages
import 'package:get/get.dart';

// Models
import '../../data/models/shopping_list_model.dart';

// Repositories
import '../../data/repositories/shopping_list_repository.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

class DashboardController extends GetxController {
  final ShoppingListRepository _repository = ShoppingListRepository();
  var lists = <ShoppingListModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLists();
  }

  void fetchLists() {
    isLoading.value = true;
    try {
      final userId =
          Get.find<AuthController>().authService.auth.currentUser?.uid ?? '';
      _repository.getUserLists(userId).listen((list) {
        lists.assignAll(list);
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch lists: $e');
    }
  }

  Future<void> deleteList(String listId) async {
    isLoading.value = true;
    try {
      await _repository.deleteList(listId);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete list: $e');
    }
  }

  Future<void> logout() async {
    await Get.find<AuthController>().logout();
  }
}
