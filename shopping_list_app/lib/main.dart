// // Packages
// import 'package:flutter/material.dart';

// // App
// import './app.dart';

// // Services
// import '../../core/services/firebase_service.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await FirebaseService.initialize();
//     runApp(App());
//   } catch (e) {
//     print('Failed to initialize Firebase: $e');
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './join_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List App',
      debugShowCheckedModeBanner: false,
      home: AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late String _userEmail;
  final TextEditingController _listNameController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmail();
  }

  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('user_email');

    if (savedEmail != null && savedEmail.isNotEmpty) {
      setState(() {
        _userEmail = savedEmail;
        _isLoading = false;
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _promptForEmail(prefs);
      });
    }
  }

  void _promptForEmail(SharedPreferences prefs) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Enter your email'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                prefs.setString('user_email', email);
                setState(() {
                  _userEmail = email;
                  _isLoading = false;
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _createList(String name) async {
    if (name.isEmpty) return;
    final listRef = FirebaseFirestore.instance
        .collection('shopping_lists')
        .doc();
    await listRef.set({
      'id': listRef.id,
      'name': name,
      'createdBy': _userEmail,
      'collaborators': [_userEmail],
      'createdAt': FieldValue.serverTimestamp(),
    });
    _listNameController.clear();
  }

  Stream<QuerySnapshot> _getUserLists() {
    return FirebaseFirestore.instance
        .collection('shopping_lists')
        .where('collaborators', arrayContains: _userEmail)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Lists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add),
            tooltip: "Join a List",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JoinListScreen(userEmail: _userEmail),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('user_email');
              setState(() {
                _isLoading = true;
              });
              _loadEmail(); // trigger email prompt again
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _listNameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter list name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _createList(_listNameController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getUserLists(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                if (docs.isEmpty)
                  return const Center(child: Text("No lists yet"));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(data['name']),
                      subtitle: Text("Created by: ${data['createdBy']}"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
