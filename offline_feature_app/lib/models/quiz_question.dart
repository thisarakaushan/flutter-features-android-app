import 'package:hive_flutter/hive_flutter.dart';
part 'quiz_question.g.dart';

@HiveType(typeId: 1)
class QuizQuestion extends HiveObject {
  @HiveField(0)
  final String question;
  @HiveField(1)
  final List<String> options;
  @HiveField(2)
  final int correctIndex;


  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctIndex: map['correctIndex'],
    );
  }
}
