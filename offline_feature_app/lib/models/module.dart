import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'quiz_question.dart';
part 'module.g.dart';

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
  DateTime lastUpdated;
  @HiveField(7)
  bool pendingSync = false;
  @HiveField(8)
  final String? pdfUrl;
  @HiveField(9)
  String? localPdfPath;
  @HiveField(10)
  final String? videoUrl;
  @HiveField(11)
  String? localVideoPath;

  Module({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.quizQuestions,
    this.localImagePath,
    required this.lastUpdated,
    this.pendingSync = false,
    this.pdfUrl,
    this.localPdfPath,
    this.videoUrl,
    this.localVideoPath,
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
      lastUpdated: map['lastUpdated'] != null
          ? (map['lastUpdated'] as Timestamp).toDate()
          : DateTime.now(),
      pdfUrl: map['pdfUrl'] as String?,
      videoUrl: map['videoUrl'] as String?,
    );
  }
}
