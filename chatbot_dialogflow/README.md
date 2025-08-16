# Chatbot with Dialogflow & Flutter

This project demonstrates a simple chatbot application built with **Dialogflow** for natural language understanding and **Flutter** for the mobile interface. The bot handles greetings, course selection, module navigation, home navigation, and exit flows.

---

## 🚀 Features
- **Welcome Flow**: Greets users and provides initial menu options.
- **Course Selection**: Users can select a course by entering its number.
- **Module Navigation**: Each course contains modules that users can explore.
- **Home Command**: Typing `h` or `home` returns to the main menu.
- **Exit Command**: Typing `x` or `exit` ends the conversation with a farewell message.

---

## ⚙️ Setup

### Step1: Dialogflow Agent Setup
1. Go to Dialogflow Console and create a Dialogflow agent.

    ```
    Click Create Agent → Give a name → Select default language and default time zone → Click Create.
    ```

2. Define the following intents:
   - **WelcomeIntent** → Handles `hi`, `hello`, etc. and shows course options.
   - **CourseSelectionIntent** → Maps numbers (1–5) to course details.  
     - Add `course_selection` as **output context**.
   - **ModuleSelectionIntent** → Handles module numbers and navigation.  
     - Add `module_selection` as **output context**.
   - **HomeIntent** → Training phrases: `h`, `home`.  
     - Response: same as WelcomeIntent.
   - **ExitIntent** → Training phrases: `x`, `exit`.  
     - Response: "Thank you for using this chatbot. Have a great day!"

3. Set contexts (`course_selection`, `module_selection`) with lifespan of 2 to maintain conversation state.

### Step 2: Google Cloud Console & Service Account
To allow your Flutter app to access Dialogflow:

1. Go to Google Cloud Console.
2. Select the project used by your Dialogflow agent.
3. Navigate to:
    ```
    IAM & Admin → Service Accounts → Click Create Service Account
    ```

4. Fill in:
- Name → e.g., ```dialogflow-client```
- Role → ```Dialogflow API Client```

5. Click Create Key → Select JSON → Download the key file.
- This JSON file contains credentials your Flutter app will use to authenticate with Dialogflow.

### Step3: Flutter Integration
1. Add ```dialog_flowtter``` dependency in ```pubspec.yaml```.
2. Place the downloaded JSON key in your Flutter project (e.g., ```assets/dialogflow_key.json```).
3. Load the credentials in Flutter when initializing Dialogflow:
```
DialogFlowtter dialogFlowtter = await DialogFlowtter.fromFile(path: 'assets/dialogflow_key.json');
```

4. Build your chat UI and send user messages to Dialogflow via ```dialogFlowtter.detectIntent(...)```.

### Flutter
1. Clone this project.
2. Run:
   ```
   flutter pub get
   flutter run
   ```
3. Connect the app with your Dialogflow agent using the client access key.
