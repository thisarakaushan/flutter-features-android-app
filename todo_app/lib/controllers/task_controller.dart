// Packages
import 'package:get/get.dart';

// Models
import '../models/task_model.dart';

class TaskController extends GetxController {
  // Observable list of tasks - automatically triggers UI updates
  final RxList<Task> tasks = <Task>[].obs;

  // Add a new task
  void addTask(String title, String description) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
    );
    tasks.add(task);
  }

  // Delete a task by ID
  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
  }

  // Toggle task completion status
  void toggleTaskStatus(String id) {
    final taskIndex = tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      tasks[taskIndex].isDone = !tasks[taskIndex].isDone;
      tasks
          .refresh(); // Manually trigger UI update since we modified object property
    }
  }

  // Get task by ID
  Task? getTaskById(String id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get completed tasks count
  int get completedTasksCount => tasks.where((task) => task.isDone).length;

  // Get pending tasks count
  int get pendingTasksCount => tasks.where((task) => !task.isDone).length;
}
