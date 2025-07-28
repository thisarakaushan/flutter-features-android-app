// Packages
import 'package:get/get.dart';

// Controllers
import '../controllers/task_controller.dart';

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    // Lazy loading - controller created when first used
    Get.lazyPut<TaskController>(() => TaskController());
  }
}
