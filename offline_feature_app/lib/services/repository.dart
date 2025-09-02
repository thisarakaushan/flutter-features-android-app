// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import '../utils/connectivity_util.dart';
import 'hive_service.dart';
import 'firebase_service.dart';
import '../models/module.dart';
import '../models/quiz_question.dart';

class Repository {
  final HiveService _hive = HiveService();
  final FirebaseService _firebase = FirebaseService();
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      await _hive.init();
      _isInitialized = true;
      print('Repository initialized successfully');
    } catch (e, stackTrace) {
      print('Error initializing repository: $e\n$stackTrace');
      throw Exception('Failed to initialize repository: $e');
    }
  }

  Future<List<Module>> getModules() async {
    if (!_isInitialized) {
      await init();
    }
    final modules = _hive.getModules();
    if (modules.isEmpty) {
      print('No modules in Hive, creating dummy module');
      final dummyModule = Module(
        id: 'dummy_1',
        title: 'Offline Sample Module',
        content: 'This is a sample module for offline use.',
        imageUrl: 'https://picsum.photos/200',
        pdfUrl:
            'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
        videoUrl: 'https://www.w3schools.com/html/mov_bbb.mp4',
        quizQuestions: [
          QuizQuestion(
            question: 'What is 2+2?',
            options: ['3', '4', '5'],
            correctIndex: 1,
          ),
        ],
        lastUpdated: DateTime.now(),
      );
      // Note: Not downloading assets automatically for dummy module
      // User will download PDF/video manually in ModuleScreen
      try {
        if (dummyModule.imageUrl.isNotEmpty &&
            dummyModule.localImagePath == null) {
          print('Downloading image for dummy module: ${dummyModule.imageUrl}');
          final path = await _hive.downloadImage(
            dummyModule.imageUrl,
            dummyModule.id,
          );
          if (await File(path).exists()) {
            dummyModule.localImagePath = path;
            print('Image downloaded to: $path');
          } else {
            print('Image file does not exist at: $path');
          }
        }
      } catch (e, stackTrace) {
        print('Failed to download dummy module image: $e\n$stackTrace');
      }
      await _hive.addOrUpdateModule(dummyModule);
      print('Dummy module saved to Hive');
      return [dummyModule];
    }
    return modules;
  }

  Future<void> sync() async {
    if (!_isInitialized) {
      await init();
    }
    if (!await isConnected()) {
      print('No connection, skipping sync');
      return;
    }
    if (_hive.moduleBox == null) {
      print('moduleBox not initialized, cannot sync');
      return;
    }

    try {
      print('Starting sync with Firestore');
      // Pull from Firebase
      final remoteModules = await _firebase.fetchModules();
      print('Fetched ${remoteModules.length} modules from Firestore');
      for (var remote in remoteModules) {
        final local = _hive.moduleBox!.get(remote.id);
        if (local == null || remote.lastUpdated.isAfter(local.lastUpdated)) {
          try {
            // if (remote.imageUrl.isNotEmpty) {
            //   remote.localImagePath = await _hive.downloadImage(
            //     remote.imageUrl,
            //     remote.id,
            //   );
            // }
            // Image
            if (remote.imageUrl.isNotEmpty && remote.localImagePath == null) {
              print(
                'Downloading image for module ${remote.id}: ${remote.imageUrl}',
              );
              final path = await _hive.downloadImage(
                remote.imageUrl,
                remote.id,
              );
              if (await File(path).exists()) {
                remote.localImagePath = path;
                print('Image downloaded to: $path');
              } else {
                print('Image file does not exist at: $path');
              }
            }
            // PDF and video downloads are handled manually in ModuleScreen
            // So, no need to download them automatically
            // if (remote.pdfUrl != null && remote.pdfUrl!.isNotEmpty) {
            //   remote.localPdfPath = await _hive.downloadPdf(
            //     remote.pdfUrl!,
            //     remote.id,
            //   );
            // }
            // if (remote.videoUrl != null && remote.videoUrl!.isNotEmpty) {
            //   remote.localVideoPath = await _hive.downloadVideo(
            //     remote.videoUrl!,
            //     remote.id,
            //   );
            // }
          } catch (e, stackTrace) {
            print(
              'Failed to download assets for module ${remote.id}: $e\n$stackTrace',
            );
          }
          await _hive.addOrUpdateModule(remote);
          print('Module ${remote.id} saved to Hive');
        }
      }

      // Push pending quiz submissions
      for (var local in _hive.getModules()) {
        if (local.pendingSync) {
          print('Uploading quiz response for module ${local.id}');
          await _firebase.uploadQuizResponse(local.id, 0); // Placeholder score
          local.pendingSync = false;
          await local.save();
          print('Quiz response for module ${local.id} synced');
        }
      }
    } catch (e, stackTrace) {
      print('Sync error: $e\n$stackTrace');
    }
  }

  Future<void> submitQuizResponse(String moduleId, int score) async {
    if (!_isInitialized) {
      await init();
    }
    final module = _hive.moduleBox?.get(moduleId);
    if (module != null) {
      print('Local score: $score for module $moduleId');
      module.pendingSync = true;
      module.lastUpdated = DateTime.now();
      await module.save();
    } else {
      print('Module $moduleId not found in Hive');
    }
    if (await isConnected()) await sync();
  }

  // Download pdf
  Future<String> downloadPdf(
    String url,
    String id, [
    Function(double)? onProgress,
  ]) async {
    print('Downloading PDF: $url for module $id');
    try {
      final path = await _hive.downloadPdf(url, id, onProgress);
      if (await File(path).exists()) {
        print('PDF downloaded successfully to: $path');
        return path;
      } else {
        print('PDF file does not exist at: $path');
        throw Exception('Downloaded PDF file not found');
      }
    } catch (e, stackTrace) {
      print('PDF download failed: $e\n$stackTrace');
      rethrow;
    }
  }

  // Video Download
  Future<String> downloadVideo(
    String url,
    String id, [
    Function(double)? onProgress,
  ]) async {
    print('Downloading video: $url for module $id');
    try {
      final path = await _hive.downloadVideo(url, id, onProgress);
      if (await File(path).exists()) {
        print('Video downloaded successfully to: $path');
        return path;
      } else {
        print('Video file does not exist at: $path');
        throw Exception('Downloaded video file not found');
      }
    } catch (e, stackTrace) {
      print('Video download failed: $e\n$stackTrace');
      rethrow;
    }
  }

  Future<void> updateModule(Module module) async {
    print('Updating module ${module.id} in Hive');
    await _hive.addOrUpdateModule(module);
  }
}
