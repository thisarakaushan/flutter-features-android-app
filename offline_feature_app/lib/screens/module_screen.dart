import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';
import '../services/repository.dart';
import '../models/module.dart';

class ModuleScreen extends StatefulWidget {
  final Module module;
  final Repository repo;

  const ModuleScreen({super.key, required this.module, required this.repo});

  @override
  _ModuleScreenState createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  int _selectedAnswer = -1;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.module.videoUrl == null &&
        widget.module.localVideoPath == null) {
      print('No video available for module ${widget.module.id}');
      return;
    }
    final videoSource = widget.module.localVideoPath ?? widget.module.videoUrl!;
    _videoController = videoSource.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(videoSource))
        : VideoPlayerController.file(File(videoSource));
    _videoController!
        .initialize()
        .then((_) {
          setState(() {
            _isVideoInitialized = true;
          });
        })
        .catchError((e) {
          print('Error initializing video: $e');
          setState(() {
            _isVideoInitialized = false;
          });
        });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _submitQuiz(int correctIndex) {
    setState(() {
      _isSubmitted = true;
      final score = _selectedAnswer == correctIndex ? 100 : 0;
      widget.repo.submitQuizResponse(widget.module.id, score);
    });
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.module.quizQuestions.isNotEmpty
        ? widget.module.quizQuestions[0]
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(widget.module.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (widget.module.localImagePath != null)
              Image.file(
                File(widget.module.localImagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else if (widget.module.imageUrl.isNotEmpty)
              Image.network(
                widget.module.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(widget.module.content),
            ),
            // PDF
            if (widget.module.localPdfPath != null)
              Container(
                height: 300,
                child: PDFView(
                  filePath: widget.module.localPdfPath!,
                  onError: (error) => print('PDF error: $error'),
                ),
              )
            else if (widget.module.pdfUrl != null &&
                widget.module.pdfUrl!.isNotEmpty)
              Text('PDF not downloaded yet. Sync to download.')
            else
              Text('No PDF available.'),
            // Video
            if (_isVideoInitialized && _videoController != null)
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    child: Text(
                      _videoController!.value.isPlaying ? 'Pause' : 'Play',
                    ),
                  ),
                ],
              )
            else
              Text('Video not available.'),
            // Quiz
            if (question != null) ...[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Quiz: ${question.question}'),
              ),
              ...question.options.asMap().entries.map((entry) {
                int idx = entry.key;
                String option = entry.value;
                return RadioListTile<int>(
                  title: Text(option),
                  value: idx,
                  groupValue: _selectedAnswer,
                  onChanged: _isSubmitted
                      ? null
                      : (value) => setState(() => _selectedAnswer = value!),
                );
              }).toList(),
              if (!_isSubmitted)
                ElevatedButton(
                  onPressed: _selectedAnswer >= 0
                      ? () => _submitQuiz(question.correctIndex)
                      : null,
                  child: Text('Submit'),
                ),
              if (_isSubmitted)
                Text(
                  _selectedAnswer == question.correctIndex
                      ? 'Correct!'
                      : 'Incorrect. Try again.',
                  style: TextStyle(
                    color: _selectedAnswer == question.correctIndex
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
