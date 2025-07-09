// Packages
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// Models
import '../models/task_model.dart';

// Services
import '../services/task_service.dart';

// Widgets
import '../widgets/custom_button.dart';
import '../widgets/task_tile.dart';

class TodoAppScreen extends StatefulWidget {
  const TodoAppScreen({super.key});

  @override
  State<TodoAppScreen> createState() => _TodoAppScreenState();
}

class _TodoAppScreenState extends State<TodoAppScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                CustomButton(
                  text: 'Add',
                  onPressed: () async {
                    if (_taskController.text.isNotEmpty) {
                      await _taskService.addTask(
                        Task(
                          id: const Uuid().v4(), // Generate a unique id
                          title: _taskController.text,
                        ),
                      );
                      _taskController.clear();
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasks(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskTile(
                      task: task,
                      onDelete: () async {
                        await _taskService.deleteTask(task.id);
                        setState(() {});
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
