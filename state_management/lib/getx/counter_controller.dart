// Packages
import 'package:get/get.dart';

class CounterController extends GetxController {
  // Reactive variable
  var counter = 0.obs;
  var isLoading = false.obs;

  void increment() => counter++;

  void decrement() => counter--;

  void reset() => counter.value = 0;

  Future<void> incrementAsync() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    counter++;
    isLoading.value = false;
  }

  // Called when controller is initialized
  @override
  void onInit() {
    super.onInit();
    print('CounterController initialized');
  }

  // Called when controller is disposed
  @override
  void onClose() {
    super.onClose();
    print('CounterController disposed');
  }
}
