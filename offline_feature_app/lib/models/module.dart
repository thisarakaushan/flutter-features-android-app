// # Model with timestamp

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quiz_question.dart';
part 'module.g.dart'; // Generated

@HiveType(typeId: 0)
class Module extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String content;
  @HiveField(3)
  final String imageUrl;
  @HiveField(4)
  final List<QuizQuestion> quizQuestions;
  @HiveField(5)
  String? localImagePath;
  @HiveField(6)
  DateTime lastUpdated; // For sync
  @HiveField(7)
  bool pendingSync = false; // For queued writes

  Module({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.quizQuestions,
    this.localImagePath,
    required this.lastUpdated,
    this.pendingSync = false,
  });

  factory Module.fromMap(Map<String, dynamic> map, String docId) {
    return Module(
      id: docId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      quizQuestions: (map['quizQuestions'] as List? ?? [])
          .map((q) => QuizQuestion.fromMap(q))
          .toList(),
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
    );
  }
}
