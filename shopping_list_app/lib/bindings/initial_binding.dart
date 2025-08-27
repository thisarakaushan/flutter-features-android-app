import 'package:get/get.dart';
import '../../presentation/controllers/auth_controller.dart';
import '../../presentation/controllers/dashboard_controller.dart';
import '../../presentation/controllers/shopping_list_controller.dart';
import '../../presentation/controllers/list_item_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => ShoppingListController());
    Get.lazyPut(() => ListItemController());
  }
}
