// Packages
import 'package:get/get.dart';

// Models
import '../../data/models/list_item_model.dart';

// Controllers
import '../../presentation/controllers/auth_controller.dart';

// Repositories
import '../../data/repositories/list_item_repository.dart';

class ListItemController extends GetxController {
  final ListItemRepository _repository = ListItemRepository();
  var items = <ListItemModel>[].obs;
  var isLoading = false.obs;

  void fetchItems(String listId) {
    isLoading.value = true;
    try {
      _repository.getItems(listId).listen((itemList) {
        items.assignAll(itemList);
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch items: $e');
    }
  }

  Future<void> addItem(String listId, String name, int quantity) async {
    isLoading.value = true;
    try {
      final userId =
          Get.find<AuthController>().authService.auth.currentUser?.uid ?? '';
      final item = ListItemModel(
        id: '',
        name: name,
        quantity: quantity,
        isBought: false,
        addedBy: userId,
      );
      await _repository.addItem(listId, item);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to add item: $e');
    }
  }

  Future<void> updateItem(String listId, ListItemModel item) async {
    isLoading.value = true;
    try {
      await _repository.updateItem(listId, item);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to update item: $e');
    }
  }

  Future<void> deleteItem(String listId, String itemId) async {
    isLoading.value = true;
    try {
      await _repository.deleteItem(listId, itemId);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to delete item: $e');
    }
  }
}
