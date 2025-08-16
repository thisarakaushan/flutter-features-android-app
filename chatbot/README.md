# Flutter AI Chatbot

A Flutter-based AI chatbot app integrating Gemini API for natural language processing. This demo app supports user authentication with Firebase and stores chat history in Firestore.

---

## Features

- Interactive chat interface with real-time messaging
- User authentication (sign up & login) with Firebase Authentication (anonymous + Firestore email/name storage)
- Chat history stored and retrieved from Firebase Firestore
- Gemini API integration for AI-powered chat responses
- Popup menu with options: New Chat, Logout, Chat History

---

## Getting Started

### Prerequisites

- Flutter SDK installed (version 3.0+ recommended)
- Firebase project setup with Firestore and Authentication enabled
- Gemini API key (from Google Cloud / Gemini platform)
- Android emulator or device for testing

### Setup

1. Clone the repo:
   ```bash
   git clone git@github.com:thisarakaushan/flutter-features-android-app.git
   cd chatbot
   ```

2. Install dependencies:
   ```bash
   Install dependencies:
   ```

3. Add your Firebase configuration:
- Download ```google-services.json (Android)``` or from Firebase Console.
- Place these files in the appropriate platform directories:
    - Android: ```android/app/google-services.json```

4. Configure Gemini API Key:
- Store your Gemini API key securely.
- In your Flutter app, add the Gemini API integration inside your service class.
- Use the API key to send requests and receive AI-generated responses.

Example snippet:
```
final geminiApiKey = 'YOUR_GEMINI_API_KEY';

Future<String> getGeminiResponse(String message) async {
  final response = await http.post(
    Uri.parse('https://gemini.googleapis.com/v1/chat:generate'),
    headers: {
      'Authorization': 'Bearer $geminiApiKey',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'prompt': message,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'];
  } else {
    throw Exception('Failed to get response from Gemini API');
  }
}
```

5. Run the app:
   ```bash
   flutter run
   ```

---

## Project Structure

```
lib/
├── main.dart          # Entry point
├── screens/           # UI screens (Chat, Auth, etc.)
├── services/          # API services (Firebase, Gemini, Auth)
├── widgets/           # Reusable widgets
assets/
├── icon.png           # App icon or images
pubspec.yaml           # Dependencies and assets config

```

## Dependencies
- ```firebase_core```
- ```firebase_auth```
- ```cloud_firestore```
- ```http```
- ```file_picker``` (if using file/image upload)

- Any Gemini or Google AI packages if available
