// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../models/task_model.dart';

class TaskService {
  final CollectionReference _tasks = FirebaseFirestore.instance.collection(
    'tasks',
  );

  Future<void> addTask(Task task) async {
    await _tasks.doc(task.id).set({'title': task.title});
  }

  Stream<List<Task>> getTasks() {
    return _tasks.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Task(id: doc.id, title: doc['title']))
          .toList(),
    );
  }

  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }
}
