// import 'package:cloud_firestore/cloud_firestore.dart';
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
    } catch (e) {
      print('Error initializing repository: $e');
    }
  }

  Future<List<Module>> getModules() async {
    if (!_isInitialized) {
      await init();
    }
    final modules = _hive.getModules();
    if (modules.isEmpty) {
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
      await _hive.addOrUpdateModule(dummyModule);
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
      // Pull from Firebase
      final remoteModules = await _firebase.fetchModules();
      for (var remote in remoteModules) {
        final local = _hive.moduleBox!.get(remote.id);
        if (local == null || remote.lastUpdated.isAfter(local.lastUpdated)) {
          try {
            if (remote.imageUrl.isNotEmpty) {
              remote.localImagePath = await _hive.downloadImage(
                remote.imageUrl,
                remote.id,
              );
            }
            if (remote.pdfUrl != null && remote.pdfUrl!.isNotEmpty) {
              remote.localPdfPath = await _hive.downloadPdf(
                remote.pdfUrl!,
                remote.id,
              );
            }
            if (remote.videoUrl != null && remote.videoUrl!.isNotEmpty) {
              remote.localVideoPath = await _hive.downloadVideo(
                remote.videoUrl!,
                remote.id,
              );
            }
          } catch (e) {
            print('Failed to download assets for module ${remote.id}: $e');
          }
          await _hive.addOrUpdateModule(remote);
        }
      }

      // Push pending quiz submissions
      for (var local in _hive.getModules()) {
        if (local.pendingSync) {
          await _firebase.uploadQuizResponse(local.id, 0); // Placeholder score
          local.pendingSync = false;
          await local.save();
        }
      }
    } catch (e) {
      print('Sync error: $e');
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
}
