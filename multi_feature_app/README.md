# 📱 Multi Feature Flutter Android App

A mobile application built using Flutter that includes multiple mini projects in a single app, with login/register authentication and Firebase integration. The app is designed for Android devices.

---

## ✨ Features

- 🚀 Splash Screen
- 🔐 User Registration & Login (Firebase Auth)
- 🏠 Home Dashboard with Navigation Buttons
- ✅ To-Do List App (Add, View, Delete tasks)
- ⚖️ BMI Calculator
- 🔢 Counter App with Light/Dark Theme Toggle
- 📇 Contacts Manager (Add, View, Navigate)

---

## 🧰 Tools & Technologies

| Tool           | Purpose                          |
|----------------|----------------------------------|
| **Flutter**    | Cross-platform UI framework      |
| **Firebase**   | Auth & future data integrations  |
| **Dart**       | Programming language for Flutter |
| **Android SDK**| Android build & emulator         |
| **NDK 27**     | Native dependency support (Firebase) |
| **VS Code**    | Development environment          |

---

## 📁 Folder Structure

```
/lib
├── main.dart
├── app.dart
├── routes.dart
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
|   |   ├── login_screen.dart
│   |   └── register_screen.dart
│   ├── home_screen.dart        # Dashboard with 4 feature buttons
│   ├── todo_screen.dart
│   ├── bmi_calculator_screen.dart
│   ├── counter_theme_switcher_screen.dart
│   └── contacts_manager_screen.dart
├── widgets/
│   ├── contact_card.dart
|   ├── custom_button.dart
|   ├── theme_switcher.dart
│   ├── custom_input_field.dart
│   └── task_tile.dart
├── models/
│   ├── contact_manager_model.dart
|   ├── user_model.dart
│   └── task_model.dart
├── services/
|   ├── auth_service.dart
|   ├── contact_manager_service.dart
│   └── task_service.dart
├── themes/
│   └── app_theme.dart
├── utils/
|   ├── constants.dart
│   └── validators.dart

``

---

## 🧑‍💻 How to Run

1. **Clone the repo**:
   ```bash
   git clone https://github.com/thisarakaushan/multi-features-android-app.git
   cd multi-features-android-app
   cd multi-feature-app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Set up Firebase for Android**:
   - Add your ```google-services.json``` inside ```android/app/```

4. **Make sure the correct NDK version is installed (see below).**

5. **Run the app**:
   ```bash
   flutter run
   ```

---

## ⚠️ Common Issues & Fixes

### ❗ NDK Version Mismatch

> `cloud_firestore`, `firebase_auth`, etc. require NDK 27+

✅ **Fix**:

- Open **Android Studio** → **SDK Manager** → **SDK Tools**
- Enable **NDK (Side by side)** → Click the ⚙️ (gear icon) → **Show Package Details**
- ✅ Install version **27.0.12077973**

Or install manually via command line:

```bash
sdkmanager "ndk;27.0.12077973"
```

### ❗ minSdkVersion Too Low

> Firebase requires `minSdkVersion` 23+

✅ **Fix**: In `android/app/build.gradle.kts`, update the configuration:

```kotlin
defaultConfig {
    minSdk = 23
    ndkVersion = "27.0.12077973"
    // other configs
}
```

### ❗ use_build_context_synchronously Warning

> **Problem**: Using `BuildContext` after an `await` can cause runtime errors if the widget is disposed before the context is used.

✅ **Fix**: Add a `mounted` check before using `context`:

```dart
await someAsyncCall();
if (!mounted) return;
Navigator.pushReplacementNamed(context, '/home');
```

### ❗ Route Not Found

> **Error**: Could not find a generator for route `/login`

✅ **Fix**: Ensure your route is registered in the `MaterialApp` like this:

```dart
MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (_) => SplashScreen(),
    '/login': (_) => LoginScreen(),
    // Add other routes here
  },
);
```