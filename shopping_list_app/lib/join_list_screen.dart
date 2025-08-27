import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinListScreen extends StatefulWidget {
  final String userEmail;
  const JoinListScreen({super.key, required this.userEmail});

  @override
  State<JoinListScreen> createState() => _JoinListScreenState();
}

class _JoinListScreenState extends State<JoinListScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;
  String? _message;

  Future<void> _joinList() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() {
      _isLoading = true;
      _message = null;
    });

    final docRef = FirebaseFirestore.instance
        .collection('shopping_lists')
        .doc(code);

    final doc = await docRef.get();
    if (doc.exists) {
      final data = doc.data()!;
      final collaborators = List<String>.from(data['collaborators'] ?? []);

      if (collaborators.contains(widget.userEmail)) {
        setState(() {
          _message = "You're already a collaborator on this list.";
          _isLoading = false;
        });
        return;
      }

      await docRef.update({
        'collaborators': FieldValue.arrayUnion([widget.userEmail]),
      });

      setState(() {
        _message = "Successfully joined the list!";
        _isLoading = false;
      });
    } else {
      setState(() {
        _message = "No list found with this code.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join a List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Enter List Code (ID)",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _joinList,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Join"),
            ),
            const SizedBox(height: 16),
            if (_message != null)
              Text(
                _message!,
                style: TextStyle(
                  color: _message!.contains("Success")
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
