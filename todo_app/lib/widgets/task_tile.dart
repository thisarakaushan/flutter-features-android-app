// Packages
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Models
import '../../models/task_model.dart';

// Controllers
import '../../controllers/task_controller.dart';

// Routes
import '../../routes/app_routes.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final TaskController controller = Get.find<TaskController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (value) {
            controller.toggleTaskStatus(task.id);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            color: task.isDone ? Colors.grey : null,
          ),
        ),
        subtitle: Text(
          task.description.isEmpty ? 'No description' : task.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: task.isDone ? Colors.grey : null),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Navigate to details screen with task ID
          Get.toNamed(AppRoutes.taskDetails, arguments: task.id);
        },
      ),
    );
  }
}
