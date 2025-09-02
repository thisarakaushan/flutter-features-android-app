import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/module.dart';
import '../models/quiz_question.dart';

class HiveService {
  Box<Module>? moduleBox;

  Future<void> init() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      Hive.initFlutter(dir.path);
      if (!Hive.isAdapterRegistered(ModuleAdapter().typeId)) {
        Hive.registerAdapter(ModuleAdapter());
      }
      if (!Hive.isAdapterRegistered(QuizQuestionAdapter().typeId)) {
        Hive.registerAdapter(QuizQuestionAdapter());
      }
      try {
        moduleBox = await Hive.openBox<Module>('modules');
      } catch (e) {
        print('Error opening Hive box: $e');
        // Clear box if deserialization fails
        await Hive.deleteBoxFromDisk('modules');
        moduleBox = await Hive.openBox<Module>('modules');
      }
    } catch (e) {
      print('Error initializing Hive: $e');
      rethrow;
    }
  }

  Future<void> addOrUpdateModule(Module module) async {
    if (moduleBox == null) {
      throw Exception('Hive moduleBox not initialized');
    }
    await moduleBox!.put(module.id, module);
  }

  List<Module> getModules() {
    if (moduleBox == null) {
      print('Warning: moduleBox not initialized, returning empty list');
      return [];
    }
    return moduleBox!.values.toList();
  }

  Future<String> downloadFile(String url, String id, String extension) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/$id.$extension';
        await File(path).writeAsBytes(response.bodyBytes);
        return path;
      }
      throw Exception('Download failed for $extension');
    } catch (e) {
      print('Error downloading $extension: $e');
      rethrow;
    }
  }

  Future<String> downloadImage(String url, String id) async {
    return downloadFile(url, id, 'jpg');
  }

  Future<String> downloadPdf(String url, String id) async {
    return downloadFile(url, id, 'pdf');
  }

  Future<String> downloadVideo(String url, String id) async {
    return downloadFile(url, id, 'mp4');
  }
}
