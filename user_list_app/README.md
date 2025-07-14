# 👥 User List App (Flutter)

A Flutter application that fetches and displays a list of users from a public API with profile pictures, names, and emails.

---

## 📱 Features

- Fetch users from the ReqRes API (`https://reqres.in/api/users`)
- Scrollable `ListView` showing:
  - Avatar (profile picture)
  - Full name
  - Email address
- Loading indicator while fetching data
- Error handling with message display
- Organized using a clean folder structure

### 💡 Bonus Features (Optional)
- Pagination support (load more on scroll)
- Pull-to-refresh
- Tap on a user to view detailed info

---

## 🏗️ Folder Structure

```
lib/
├── main.dart                   # App entry point, sets up MaterialApp
├── models/                    # Data models for API responses
│   └── user_model.dart        # User class with JSON serialization
├── services/                  # Network request logic
│   └── api_service.dart       # API service for fetching users
├── screens/                   # UI screens
│   ├── user_list_screen.dart  # Main screen with user ListView
│   └── user_detail_screen.dart # (Bonus) Screen for user details
├── widgets/                   # Reusable UI components
│   ├── user_list_item.dart    # Widget for a single user item
│   ├── loading_indicator.dart # Widget for loading spinner
│   └── error_message.dart     # Widget for error messages
├── utils/                     # Utility files and constants
│   └── constants.dart         # API base URL, headers, and other constants

```

## 🚀 Getting Started

### ✅ Prerequisites
- Flutter SDK installed
- An IDE (VS Code, Android Studio)
- Internet connection (for API call)

### 🛠️ Run the App

```bash
git clone https://github.com/thisarakaushan/user_list_app.git
cd user_list_app
flutter pub get
flutter run
```

### 🌐 API Used

```
https://reqres.in/api/users
```

### 🧾 Required Headers

```
x-api-key: reqres-free-v1
```

This API returns paginated dummy users. The x-api-key header is required for authentication with the free endpoint.