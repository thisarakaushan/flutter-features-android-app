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
  // Download pdf and video
  bool _isDownloadingPdf = false;
  bool _isDownloadingVideo = false;
  double _pdfDownloadProgress = 0.0;
  double _videoDownloadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    // if (widget.module.videoUrl == null &&
    //     widget.module.localVideoPath == null) {
    //   print('No video available for module ${widget.module.id}');
    //   return;
    // }
    // if (widget.module.localVideoPath == null) {
    //   print('No local video available for module ${widget.module.id}');
    //   return;
    // }
    // final videoSource = widget.module.localVideoPath ?? widget.module.videoUrl!;
    // Download
    // final videoSource = widget.module.localVideoPath!;
    // print('Initializing video from: $videoSource');

    // _videoController = videoSource.startsWith('http')
    //     ? VideoPlayerController.networkUrl(Uri.parse(videoSource))
    //     : VideoPlayerController.file(File(videoSource));
    // _videoController!
    //     .initialize()
    //     .then((_) {
    //       setState(() {
    //         _isVideoInitialized = true;
    //       });
    //     })
    //     .catchError((e) {
    //       print('Error initializing video: $e');
    //       setState(() {
    //         _isVideoInitialized = false;
    //       });
    //     });

    // _videoController = VideoPlayerController.file(File(videoSource));

    if (widget.module.localVideoPath != null) {
      final videoSource = widget.module.localVideoPath!;
      print('Initializing video from local: $videoSource');
      _videoController = VideoPlayerController.file(File(videoSource));
    } else if (widget.module.videoUrl != null &&
        widget.module.videoUrl!.isNotEmpty) {
      print('Initializing video from network: ${widget.module.videoUrl}');
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.module.videoUrl!),
      );
    } else {
      print('No video available for module ${widget.module.id}');
      return;
    }

    // Initialize the player
    _videoController!
        .initialize()
        .then((_) {
          setState(() {
            _isVideoInitialized = true;
            print(
              'Video initialized successfully for module ${widget.module.id}',
            );
          });
        })
        .catchError((e, stackTrace) {
          print(
            'Error initializing video for module ${widget.module.id}: $e\n$stackTrace',
          );
          setState(() {
            _isVideoInitialized = false;
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Failed to load video: $e')));
        });
  }

  // Download PDF
  Future<void> _downloadPdf() async {
    if (widget.module.pdfUrl == null || widget.module.pdfUrl!.isEmpty) {
      print('No PDF URL available for module ${widget.module.id}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No PDF available to download')));
      return;
    }
    // Pop up download indicator
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download PDF'),
        content: Text('This may use significant storage and data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Download'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    // download progress
    setState(() {
      _isDownloadingPdf = true;
      _pdfDownloadProgress = 0.0;
    });
    try {
      final path = await widget.repo.downloadPdf(
        widget.module.pdfUrl!,
        widget.module.id,
        // progess
        (progress) {
          setState(() {
            _pdfDownloadProgress = progress;
          });
        },
      );
      //
      final updatedModule = Module(
        id: widget.module.id,
        title: widget.module.title,
        content: widget.module.content,
        imageUrl: widget.module.imageUrl,
        localImagePath: widget.module.localImagePath,
        pdfUrl: widget.module.pdfUrl,
        localPdfPath: path,
        videoUrl: widget.module.videoUrl,
        localVideoPath: widget.module.localVideoPath,
        quizQuestions: widget.module.quizQuestions,
        lastUpdated: widget.module.lastUpdated,
        pendingSync: widget.module.pendingSync,
      );
      await widget.repo.updateModule(updatedModule);
      // setState(() {
      //   widget.module.localPdfPath = path;
      //   _isDownloadingPdf = false;
      // });
      setState(() {
        _isDownloadingPdf = false;
        _pdfDownloadProgress = 1.0;
      });
      // await widget.repo.updateModule(widget.module);
      print('PDF downloaded and module updated for ${widget.module.id}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('PDF downloaded successfully')));
    } catch (e, stackTrace) {
      print(
        'PDF download failed for module ${widget.module.id}: $e\n$stackTrace',
      );
      setState(() {
        _isDownloadingPdf = false;
        _pdfDownloadProgress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('SocketException') ||
                    e.toString().contains('HttpException')
                ? 'No internet connection. Please try again.'
                : 'Failed to download PDF: $e',
          ),
        ),
      );
    }
  }

  // Download Video
  Future<void> _downloadVideo() async {
    if (widget.module.videoUrl == null || widget.module.videoUrl!.isEmpty) {
      print('No video URL available for module ${widget.module.id}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('No video available to download')));
      return;
    }
    // Pop up download dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Download Video'),
        content: Text('This may use significant storage and data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Download'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    // progress
    setState(() {
      _isDownloadingVideo = true;
      _videoDownloadProgress = 0.0;
    });
    try {
      final path = await widget.repo.downloadVideo(
        widget.module.videoUrl!,
        widget.module.id,
        (progress) {
          setState(() {
            _videoDownloadProgress = progress;
          });
        },
      );
      //
      final updatedModule = Module(
        id: widget.module.id,
        title: widget.module.title,
        content: widget.module.content,
        imageUrl: widget.module.imageUrl,
        localImagePath: widget.module.localImagePath,
        pdfUrl: widget.module.pdfUrl,
        localPdfPath: widget.module.localPdfPath,
        videoUrl: widget.module.videoUrl,
        localVideoPath: path,
        quizQuestions: widget.module.quizQuestions,
        lastUpdated: widget.module.lastUpdated,
        pendingSync: widget.module.pendingSync,
      );
      await widget.repo.updateModule(updatedModule);
      // setState(() {
      //   widget.module.localVideoPath = path;
      //   _isDownloadingVideo = false;
      // });
      setState(() {
        _isDownloadingVideo = false;
        _videoDownloadProgress = 1.0;
      });
      // await widget.repo.updateModule(widget.module);
      _initializeVideo(); // Re-initialize video with new local path
      print('Video downloaded and module updated for ${widget.module.id}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Video downloaded successfully')));
    } catch (e, stackTrace) {
      print(
        'Video download failed for module ${widget.module.id}: $e\n$stackTrace',
      );
      setState(() {
        _isDownloadingVideo = false;
        _videoDownloadProgress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().contains('SocketException') ||
                    e.toString().contains('HttpException')
                ? 'No internet connection. Please try again.'
                : 'Failed to download video: $e',
          ),
        ),
      );
    }
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
      print('Quiz submitted for module ${widget.module.id}, score: $score');
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
                // Error
                errorBuilder: (context, error, stackTrace) {
                  print(
                    'Image file error for module ${widget.module.id}: $error',
                  );
                  return widget.module.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.module.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Network image error: $error');
                            return Icon(Icons.error);
                          },
                        )
                      : Icon(Icons.error);
                },
              )
            else if (widget.module.imageUrl.isNotEmpty)
              Image.network(
                widget.module.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                // Error
                errorBuilder: (context, error, stackTrace) {
                  print(
                    'Network image error for module ${widget.module.id}: $error',
                  );
                  return Icon(Icons.error);
                },
              ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(widget.module.content),
            ),
            // PDF
            if (widget.module.localPdfPath != null)
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: PDFView(
                      filePath: widget.module.localPdfPath!,
                      onError: (error) {
                        print(
                          'PDF error for module ${widget.module.id}: $error',
                        );
                      },
                    ),
                  ),
                ],
              )
            else if (widget.module.pdfUrl != null &&
                widget.module.pdfUrl!.isNotEmpty)
              Column(
                children: [
                  Container(
                    height: 300,
                    child: PDFView(
                      filePath: widget.module.pdfUrl!, // Network-based PDF
                      onError: (error) {
                        print(
                          'Network PDF error for module ${widget.module.id}: $error',
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to load PDF: $error')),
                        );
                      },
                    ),
                  ),
                  // Text('PDF not downloaded yet. Sync to download.')
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _isDownloadingPdf
                        ? Column(
                            children: [
                              CircularProgressIndicator(
                                value: _pdfDownloadProgress,
                              ),
                              SizedBox(height: 8),
                              Text(
                                '${(_pdfDownloadProgress * 100).toStringAsFixed(0)}%',
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: _downloadPdf,
                            child: Text('Download PDF for Offline'),
                          ),
                  ),
                ],
              )
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
                  if (widget.module.localVideoPath == null &&
                      widget.module.videoUrl != null &&
                      widget.module.videoUrl!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: _isDownloadingVideo
                          ? Column(
                              children: [
                                CircularProgressIndicator(
                                  value: _videoDownloadProgress,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${(_videoDownloadProgress * 100).toStringAsFixed(0)}%',
                                ),
                              ],
                            )
                          : ElevatedButton(
                              onPressed: _downloadVideo,
                              child: Text('Download Video for Offline'),
                            ),
                    ),
                ],
              )
            // Video download button
            else if (widget.module.videoUrl != null &&
                widget.module.videoUrl!.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: _isDownloadingVideo
                    ? Column(
                        children: [
                          CircularProgressIndicator(
                            value: _videoDownloadProgress,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${(_videoDownloadProgress * 100).toStringAsFixed(0)}%',
                          ),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: _downloadVideo,
                        child: Text('Download Video for Offline'),
                      ),
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
