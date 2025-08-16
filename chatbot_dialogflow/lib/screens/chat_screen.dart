import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart' as df;
import '../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  df.DialogFlowtter? _dialogFlowtter;

  @override
  void initState() {
    super.initState();
    _initDialogflow();
  }

  Future<void> _initDialogflow() async {
    try {
      _dialogFlowtter = await df.DialogFlowtter.fromFile(
        path: 'assets/dialogflow_credentials.json',
      );
      print('Dialogflow initialized successfully');
    } catch (e, stackTrace) {
      print('Dialogflow initialization failed: $e\n$stackTrace');
      setState(() {
        _messages.add(
          Message(
            text: 'Error: Failed to initialize Dialogflow - $e',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _dialogFlowtter == null) {
      if (_dialogFlowtter == null) {
        setState(() {
          _messages.add(
            Message(
              text: 'Error: Dialogflow not initialized',
              isUser: false,
              timestamp: DateTime.now(),
            ),
          );
        });
      }
      return;
    }

    setState(() {
      _messages.add(
        Message(
          text: _controller.text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    try {
      // Send query to Dialogflow
      final response = await _dialogFlowtter!.detectIntent(
        queryInput: df.QueryInput(
          text: df.TextInput(text: _controller.text, languageCode: 'en'),
        ),
      );

      // Log the full response for debugging
      print('Dialogflow full response: ${response.toJson()}');

      // Safely access fulfillmentText
      final fulfillmentMessages = response.queryResult?.fulfillmentMessages;
      String fulfillmentText = 'Sorry, I didn’t understand.';

      if (fulfillmentMessages != null && fulfillmentMessages.isNotEmpty) {
        for (var message in fulfillmentMessages) {
          if (message.text?.text != null && message.text!.text!.isNotEmpty) {
            fulfillmentText = message.text!.text!.first;
            break;
          }
        }
      }

      print('Dialogflow response text: $fulfillmentText');

      setState(() {
        _messages.add(
          Message(
            text: fulfillmentText,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _controller.clear();
      });
    } catch (e, stackTrace) {
      print('Dialogflow query failed: $e\n$stackTrace');
      setState(() {
        _messages.add(
          Message(
            text: 'Error: Could not connect to Dialogflow - $e',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    }

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dialogflow ChatBot',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[800],
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[600]!, Colors.teal[800]!, Colors.indigo[900]!],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.tealAccent
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: message.isUser ? Colors.black87 : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              color: Colors.teal[900],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.teal[800]!.withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    backgroundColor: Colors.tealAccent,
                    mini: true,
                    child: const Icon(Icons.send, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _dialogFlowtter?.dispose();
    super.dispose();
  }
}
