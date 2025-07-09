// Packages
import 'package:flutter/material.dart';

// Models
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskTile({super.key, required this.task, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(task.title),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
