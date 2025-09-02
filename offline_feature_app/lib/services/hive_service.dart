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
        print('Hive box "modules" opened successfully');
      } catch (e, stackTrace) {
        print('Error opening Hive box: $e\n$stackTrace');
        await Hive.deleteBoxFromDisk('modules');
        moduleBox = await Hive.openBox<Module>('modules');
        print('Hive box "modules" recreated after error');
      }
    } catch (e, stackTrace) {
      print('Error initializing Hive: $e\n$stackTrace');
      rethrow;
    }
  }

  Future<void> addOrUpdateModule(Module module) async {
    if (moduleBox == null) {
      throw Exception('Hive moduleBox not initialized');
    }
    await moduleBox!.put(module.id, module);
    print('Module ${module.id} added or updated in Hive');
  }

  List<Module> getModules() {
    if (moduleBox == null) {
      print('Warning: moduleBox not initialized, returning empty list');
      return [];
    }
    return moduleBox!.values.toList();
  }

  Future<String> downloadFile(
    String url,
    String id,
    String extension, [
    Function(double)? onProgress,
  ]) async {
    print('Starting download: $url for module $id (extension: $extension)');
    // try {
    //   final response = await http.get(Uri.parse(url));
    //   if (response.statusCode == 200) {
    //     final dir = await getApplicationDocumentsDirectory();
    //     final path = '${dir.path}/$id.$extension';
    //     await File(path).writeAsBytes(response.bodyBytes);
    //     return path;
    //   }
    //   throw Exception('Download failed for $extension');
    // } catch (e) {
    //   print('Error downloading $extension: $e');
    //   rethrow;
    // }
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await http.Client().send(request);
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/$id.$extension';
        final file = File(path);
        final sink = file.openWrite();
        final totalBytes = response.contentLength ?? 0;
        int receivedBytes = 0;

        await for (var chunk in response.stream) {
          receivedBytes += chunk.length;
          if (totalBytes > 0 && onProgress != null) {
            onProgress(receivedBytes / totalBytes);
          }
          sink.add(chunk);
        }
        await sink.close();
        if (await file.exists()) {
          print('File downloaded successfully to: $path');
          return path;
        } else {
          print('File does not exist after download at: $path');
          throw Exception('Downloaded file not found');
        }
      } else {
        print('Download failed with status code: ${response.statusCode}');
        throw Exception('Download failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error downloading $extension for module $id: $e\n$stackTrace');
      rethrow;
    }
  }

  Future<String> downloadImage(String url, String id) async {
    return downloadFile(url, id, 'jpg');
  }

  Future<String> downloadPdf(
    String url,
    String id, [
    Function(double)? onProgress,
  ]) async {
    return downloadFile(url, id, 'pdf', onProgress);
  }

  Future<String> downloadVideo(
    String url,
    String id, [
    Function(double)? onProgress,
  ]) async {
    return downloadFile(url, id, 'mp4', onProgress);
  }
}
