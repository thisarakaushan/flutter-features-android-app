// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import 'counter_controller.dart';

class GetXCounterScreen extends StatelessWidget {
  const GetXCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller instance
    final CounterController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text('GetX Counter'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'GetX Pattern Flow:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('1. Controller extends GetxController'),
            Text('2. Variables marked with .obs'),
            Text('3. Obx() widget listens to changes'),
            Text('4. Get.find() for dependency injection'),
            SizedBox(height: 32),

            // Obx rebuilds only when observable changes
            Obx(
              () => Column(
                children: [
                  if (controller.isLoading.value)
                    CircularProgressIndicator()
                  else
                    Text(
                      '${controller.counter.value}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  SizedBox(height: 16),
                  Text('Obx rebuilds: ${DateTime.now().millisecond}'),
                ],
              ),
            ),

            SizedBox(height: 32),
            Text('This text never rebuilds'),

            SizedBox(height: 16),
            // GetX also provides easy navigation and snackbars
            ElevatedButton(
              onPressed: () {
                Get.snackbar(
                  'GetX Snackbar',
                  'Counter value: ${controller.counter.value}',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Text('Show GetX Snackbar'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "increment",
            onPressed: () => controller.increment(),
            backgroundColor: Colors.orange,
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "decrement",
            onPressed: () => controller.decrement(),
            backgroundColor: Colors.orange,
            child: Icon(Icons.remove),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "async",
            onPressed: () => controller.incrementAsync(),
            backgroundColor: Colors.orange,
            child: Icon(Icons.timer),
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "reset",
            onPressed: () => controller.reset(),
            backgroundColor: Colors.orange,
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
