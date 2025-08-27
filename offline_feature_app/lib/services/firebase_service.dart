import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/module.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Module>> fetchModules() async {
    try {
      final query = await _firestore.collection('modules').get();
      return query.docs
          .map((doc) => Module.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching modules: $e');
      return []; // Return empty list on error
    }
  }

  Future<void> uploadQuizResponse(String moduleId, int score) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
      await _firestore.collection('quiz_responses').add({
        'userId': userId,
        'moduleId': moduleId,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error uploading quiz response: $e');
      // Handle offline case (already queued in Hive)
    }
  }
}
