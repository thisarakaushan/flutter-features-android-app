# 🔔 Notify Me

Notify Me is a Flutter-based mobile app that integrates **local** and **push notifications** using Firebase Cloud Messaging (FCM). It demonstrates managing notification preferences, viewing details, and simulating email alerts—all wrapped in a clean UI.

---

## 📦 Features

- 🔔 Local notifications with custom icons & channels  
- ☁️ Push notifications via Firebase (FCM)  
- ⚙️ Notification toggle with persistent state (SharedPreferences)  
- 📬 Simulated email notifications  
- 🧹 Reset / Clear all notifications  
- 🧭 Custom splash screen and navigation  
- ✅ Background notification handling

---

## 🚀 Getting Started

### ✅ Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Android Studio / VS Code
- Firebase project setup (Cloud Messaging enabled)
- Emulator or real device with internet access

---

## 🛠️ Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/notify_me.git
cd notify_me

```

### 2. Install Flutter Packages

```bash
flutter pub get

```

### 3. Firebase Setup

 - Go to Firebase Console
 - Create a project and enable Cloud Messaging
 - Download ```google-services.json``` and place it in:
    ```
    android/app/src/main/google-services.json
    ```

### 4. Android SDK Version Fix

Update the SDK version to 35 to satisfy plugin requirements.

📁 ```android/app/build.gradle.kts```

```
android {
    compileSdk = 35

    defaultConfig {
        minSdk = 21
        targetSdk = 35
        // ...
    }

    compileOptions {
        coreLibraryDesugaringEnabled = true
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```
✅ This ensures compatibility with:

    - ```flutter_local_notifications```
    - ```shared_preferences_android```
    - ```permission_handler_android``

### 5. Run the App

Once setup is complete, launch your app using:

```
flutter run
```

You should see the app start in your connected device or emulator.


## 🗂️ Folder Structure

```
notify_me/
├── android/                         # Android-specific files
│   └── app/
│       └── src/
│           └── main/
│               ├── res/             # Icons, drawables
│               ├── AndroidManifest.xml
│               └── google-services.json  # Firebase config
│
├── lib/
│   ├── models/                      # Notification model
│   │   └── notification_model.dart
│
│   ├── screens/                     # UI Screens
│   │   ├── home_screen.dart
│   │   ├── notification_details_screen.dart
│   │   ├── settings_screen.dart
│   │   └── splash_screen.dart
│
│   ├── services/                    # Business logic
│   │   ├── notification_service.dart
│   │   ├── email_service.dart
│   │   └── preference_service.dart
│
│   ├── widgets/                     # Custom widgets
│   │   ├── notification_button.dart
│   │   └── toggle_switch.dart
│
│   ├── utils/
│   │   ├── constants.dart
│   │   └── routes.dart
│
│   └── main.dart                    # App entry
│
├── assets/
│   └── images/
│       ├── icon.png
│       └── splash_screen.png
│
├── pubspec.yaml
└── README.md

```

## 🧪 Firebase Cloud Messaging Testing

### 🔘 1. Get Device Token

Launch the app. In logs (VS Code or terminal), you’ll see:

```
FCM Token: <your-token>

```

Try following code after FCM initialized.

```
String? token = await FirebaseMessaging.instance.getToken();
print('FCM Token: $token');

```

### 📤 2. Send Test Message

    1. Go to Firebase Console → Cloud Messaging
    2. Click "Send Message"
    3. Choose "Test on device" and paste the token
    4. Click Test

### ✅ 3. Confirm Behavior

    - Foreground: Message handled via ```onMessage```
    - Background/Killed: Message shows as notification (handled by OS)

### 🔁 Cancel All Notifications

In the app:

    - Go to Settings
    - Tap Reset / Clear Notifications
    - This triggers:
    ```
    flutterLocalNotificationsPlugin.cancelAll();
    ```
    This clears all active notifications from system tray.