import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Gemini secret key
import '../secrets.dart';

// Models
import 'package:chatbot/models/message_model.dart';

// Widgets
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  List<Message> messages = [];
  late GenerativeModel _model;
  String? currentSessionId;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: geminiApiKey);
    _loadLastSession();
  }

  Future<void> _loadLastSession() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final sessionsSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('sessions')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (sessionsSnapshot.docs.isNotEmpty) {
      setState(() {
        currentSessionId = sessionsSnapshot.docs.first.id;
      });
    } else {
      await _createNewSession();
    }
  }

  Future<void> _createNewSession() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final sessionRef = await FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('sessions')
        .add({
          'title': 'Chat ${DateFormat('MMM dd, HH:mm').format(DateTime.now())}',
          'createdAt': FieldValue.serverTimestamp(),
        });

    setState(() {
      currentSessionId = sessionRef.id;
      messages.clear();
    });
  }

  void sendMessage(String text, {List<Content>? additionalContent}) async {
    if (text.isEmpty && additionalContent == null) return;

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(userMessage);
      _isTyping = true;
    });
    _scrollToBottom();

    // Save user message to Firestore
    try {
      await _getSessionMessagesCollection(userId).add({
        'text': text,
        'isUser': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving user message: $e');
    }

    // Generate response
    try {
      final content = [
        Content.text('You are a helpful chatbot. Respond to: $text'),
      ];
      if (additionalContent != null) content.addAll(additionalContent);

      final response = await _model.generateContent(content);
      final botText = response.text ?? 'Sorry, couldn\'t generate a response.';

      final botMessage = Message(
        text: botText,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        messages.add(botMessage);
        _isTyping = false;
      });
      _scrollToBottom();

      // Save bot response to Firestore
      await _getSessionMessagesCollection(userId).add({
        'text': botText,
        'isUser': false,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      setState(() {
        messages.add(
          Message(
            text: 'Error: ${e.toString()}',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isTyping = false;
      });
    }

    _controller.clear();
  }

  CollectionReference _getSessionMessagesCollection(String userId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(userId)
        .collection('sessions')
        .doc(currentSessionId)
        .collection('messages');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _uploadImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final content = [
        Content.multi([
          TextPart('Describe this image or answer based on it.'),
          DataPart('image/jpeg', bytes),
        ]),
      ];
      sendMessage('📸 Analyzing image...', additionalContent: content);
    }
  }

  Future<void> _uploadPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      try {
        final file = File(result.files.single.path!);
        final pdfDocument = PdfDocument(inputBytes: await file.readAsBytes());
        final extractor = PdfTextExtractor(pdfDocument);
        String extractedText = '';

        for (int i = 0; i < pdfDocument.pages.count; i++) {
          extractedText += extractor.extractText(startPageIndex: i) + '\n';
        }
        pdfDocument.dispose();

        final userQuery = _controller.text.isEmpty
            ? 'Summarize this document.'
            : _controller.text;
        final prompt =
            'Answer based on this document content: $extractedText. Query: $userQuery';
        sendMessage(
          '📄 Processing PDF...',
          additionalContent: [Content.text(prompt)],
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error processing PDF: $e')));
      }
    }
  }

  Future<void> _showChatHistory() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.history, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Chat History',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _createNewSession();
                },
                icon: Icon(Icons.add),
                label: Text('New Chat'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 45),
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(userId)
                    .collection('sessions')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final sessions = snapshot.data!.docs;
                  if (sessions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'No chat history yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final data = session.data() as Map<String, dynamic>;
                      final isCurrentSession = session.id == currentSessionId;
                      final createdAt = data['createdAt'];
                      String timeText = 'Unknown time';

                      if (createdAt != null) {
                        try {
                          final timestamp = (createdAt as Timestamp).toDate();
                          timeText = DateFormat(
                            'MMM dd, HH:mm',
                          ).format(timestamp);
                        } catch (e) {
                          timeText = 'Unknown time';
                        }
                      }

                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrentSession ? Colors.blue[100] : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCurrentSession
                                ? Colors.blue[600]
                                : Colors.grey[400],
                            child: Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            data['title'] ?? 'Untitled Chat',
                            style: TextStyle(
                              fontWeight: isCurrentSession
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isCurrentSession ? Colors.blue[700] : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            timeText,
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: isCurrentSession
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.blue[600],
                                  size: 20,
                                )
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            _loadSession(session.id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSession(String sessionId) async {
    setState(() {
      currentSessionId = sessionId;
      messages.clear();
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    if (currentSessionId == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Scaffold(body: Center(child: Text('User not authenticated')));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Top App Bar
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 12),
                  Icon(Icons.smart_toy, color: Colors.blue[600], size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'AI Chatbot',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey[700],
                      size: 28,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'new_chat':
                          _createNewSession();
                          break;
                        case 'chat-history':
                          _showChatHistory();
                          break;
                        case 'logout':
                          _logout();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'new_chat',
                        child: Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.green[600],
                            ),
                            SizedBox(width: 8),
                            Text('New Chat'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'chat-history',
                        child: Row(
                          children: [
                            Icon(Icons.chat, color: Colors.blue[600]),
                            SizedBox(width: 8),
                            Text('Chat History'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red[600]),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Messages area
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getSessionMessagesCollection(
                userId,
              ).orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading chat: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                messages = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return Message(
                    text: data['text'] ?? '',
                    isUser: data['isUser'] ?? false,
                    timestamp: data['timestamp'] != null
                        ? (data['timestamp'] as Timestamp).toDate()
                        : DateTime.now(),
                  );
                }).toList();

                if (messages.isEmpty && !_isTyping) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Start a conversation!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Send a message, upload an image, or attach a PDF',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16),
                  itemCount: messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == messages.length) {
                      return TypingIndicator();
                    }

                    final msg = messages[index];
                    return Align(
                      alignment: msg.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: msg.isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!msg.isUser) ...[
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.blue[600],
                                child: Icon(
                                  Icons.smart_toy,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: msg.isUser
                                      ? Colors.blue[600]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: msg.isUser
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      msg.text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: msg.isUser
                                            ? Colors.white
                                            : Colors.grey[800],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      DateFormat('HH:mm').format(msg.timestamp),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: msg.isUser
                                            ? Colors.white70
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (msg.isUser) ...[
                              SizedBox(width: 8),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.green[600],
                                child: Icon(
                                  Icons.person,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  // Attachment menu
                  PopupMenuButton<String>(
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.attach_file,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'image':
                          _uploadImage();
                          break;
                        case 'pdf':
                          _uploadPdf();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'image',
                        child: Row(
                          children: [
                            Icon(Icons.image, color: Colors.blue[600]),
                            SizedBox(width: 8),
                            Text('Upload Image'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'pdf',
                        child: Row(
                          children: [
                            Icon(Icons.picture_as_pdf, color: Colors.red[600]),
                            SizedBox(width: 8),
                            Text('Upload PDF'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: (text) => sendMessage(text),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[400]!, Colors.blue[600]!],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => sendMessage(_controller.text),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
