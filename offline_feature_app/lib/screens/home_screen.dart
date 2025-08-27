import 'package:flutter/material.dart';
import '../services/repository.dart';
import 'module_screen.dart';
import '../models/module.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Repository _repo = Repository();
  List<Module> _modules = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _isLoading = true);
    try {
      await _repo.sync(); // Try to sync with Firebase
      _modules = await _repo.getModules(); // Load from Hive
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to sync: $e. Using local data.';
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline LMS Sample'),
        actions: [IconButton(icon: Icon(Icons.sync), onPressed: _loadModules)],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _modules.isEmpty
          ? Center(child: Text('No modules available.'))
          : ListView.builder(
              itemCount: _modules.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_modules[index].title),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ModuleScreen(module: _modules[index], repo: _repo),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
