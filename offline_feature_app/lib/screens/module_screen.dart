import 'dart:io';
import 'package:flutter/material.dart';
import '../models/module.dart';
import '../services/repository.dart';

class ModuleScreen extends StatefulWidget {
  final Module module;
  final Repository repo;

  const ModuleScreen({super.key, required this.module, required this.repo});

  @override
  // ignore: library_private_types_in_public_api
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  int? _selectedAnswer;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.module.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(widget.module.content),
            ),
            if (widget.module.localImagePath != null)
              Image.file(File(widget.module.localImagePath!))
            else
              Image.network(
                widget.module.imageUrl,
                errorBuilder: (_, __, ___) => Text('Image offline'),
              ),
            if (widget.module.quizQuestions.isNotEmpty) ...[
              Text('Quiz: ${widget.module.quizQuestions[0].question}'),
              ...widget.module.quizQuestions[0].options.asMap().entries.map(
                (e) => RadioListTile<int>(
                  title: Text(e.value),
                  value: e.key,
                  groupValue: _selectedAnswer,
                  onChanged: (v) => setState(() => _selectedAnswer = v),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_selectedAnswer ==
                      widget.module.quizQuestions[0].correctIndex) {
                    _score = 1;
                  }
                  await widget.repo.submitQuizResponse(
                    widget.module.id,
                    _score,
                  );
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Score: $_score - Saved (syncs later)'),
                    ),
                  );
                },
                child: Text('Submit'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
