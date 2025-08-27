import 'hive_service.dart';
import 'firebase_service.dart';
import '../models/module.dart';
import '../utils/connectivity_util.dart';

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
      await init(); // Ensure initialized
    }
    return _hive.getModules();
  }

  Future<void> sync() async {
    if (!_isInitialized) {
      await init();
    }
    if (!await isConnected()) {
      print('No connection, skipping sync');
      return;
    }

    try {
      // Pull from Firebase
      final remoteModules = await _firebase.fetchModules();
      for (var remote in remoteModules) {
        final local = _hive.moduleBox?.get(remote.id);
        if (local == null || remote.lastUpdated.isAfter(local.lastUpdated)) {
          try {
            remote.localImagePath = await _hive.downloadImage(
              remote.imageUrl,
              remote.id,
            );
          } catch (e) {
            print('Failed to download image for module ${remote.id}: $e');
          }
          await _hive.addOrUpdateModule(remote);
        }
      }

      // Push pending quiz submissions
      if (_hive.moduleBox != null) {
        for (var local in _hive.getModules()) {
          if (local.pendingSync) {
            // For demo, assume quiz score is stored; in real app, use separate queue
            // await _firebase.uploadQuizResponse(local.id, local.score); // Add score field if needed
            local.pendingSync = false;
            await local.save();
          }
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
