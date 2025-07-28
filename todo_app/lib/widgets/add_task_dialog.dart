// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers
import '../../controllers/task_controller.dart';

class AddTaskDialog extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();

    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            minLines: 1,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isNotEmpty) {
              controller.addTask(
                titleController.text.trim(),
                descriptionController.text.trim(),
              );
              Get.back();
            } else {
              Get.snackbar(
                'Error',
                'Please enter a task title',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
