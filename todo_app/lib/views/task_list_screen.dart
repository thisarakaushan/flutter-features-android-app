// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../controllers/task_controller.dart';

// Widgets
import '../widgets/task_tile.dart';
import '../widgets/add_task_dialog.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Task statistics
          Container(
            padding: const EdgeInsets.all(16),
            // Widgets automatically rebuild when controller data changes
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    'Total Tasks',
                    controller.tasks.length.toString(),
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Completed',
                    controller.completedTasksCount.toString(),
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Pending',
                    controller.pendingTasksCount.toString(),
                    Colors.orange,
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          // Task list
          Expanded(
            child: Obx(() {
              if (controller.tasks.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No tasks yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap the + button to add a new task',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.tasks.length,
                itemBuilder: (context, index) {
                  final task = controller.tasks[index];
                  return TaskTile(task: task);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(AddTaskDialog());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Method creates statistic display cards
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
