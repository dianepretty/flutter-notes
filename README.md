# Flutter Notes App
This is a simple yet robust note-taking application built with Flutter, Firebase Authentication, and Firestore. It leverages the BLoC (Business Logic Component) pattern for state management, ensuring a clear separation of concerns, testability, and scalability.

## Feautures
- User Authentication: Secure sign-up and sign-in using Email and Password with Firebase Authentication.
- Persistent Notes: Create, read, update, and delete notes, with all data stored securely in Firebase Firestore.
- Real-time Updates: Notes are synchronized in real-time across devices thanks to Firestore's live data streams.
- User-Specific Data: Each user can only access and manage their own notes, enforced by Firestore Security Rules.
- Responsive UI: Designed to work well across different screen sizes.
- Password Visibility Toggle: Easily show/hide password during login for better usability.
- Delete Confirmation: A confirmation dialog before deleting notes to prevent accidental data loss.
- Input Validation: Client-side validation for login and sign-up forms

## Getting Started

### Prerequisites
- Flutter SDK: Install Flutter (version 3.x.x or higher recommended).
- Firebase CLI: Install Firebase CLI.
- Android Studio / VS Code: With Flutter and Dart plugins installed.
- Node.js and npm: Required for Firebase CLI.

1. Clone the Repository
git clone https://github.com/dianepretty/flutter-notes.git
2. Firebase Project Setup
This application relies heavily on Firebase. You'll need to set up a Firebase project and configure it for your Flutter app.
  a. Create a Firebase Project
     1. Go to the [Firebase Console](https://console.firebase.google.com/).
     2. Click "Add project" and follow the on-screen instructions to create a new project.
        b. Add Flutter App to Firebase Project
     1. In your Firebase project, click the Flutter icon (or "Add app" and choose Flutter).
     2. Follow the instructions to install the Firebase CLI and FlutterFire CLI.
     3. From your Flutter project's root directory
       ` flutterfire configure`
  c. Enable Authentication Methods
     1. In the Firebase Console, navigate to Authentication (under "Build"). 
     2. Go to the "Sign-in method" tab. 
     3. Enable "Email/Password" provider.
        d. Set up Firestore Database
     1. In the Firebase Console, navigate to Firestore Database (under "Build"). 
     2. Click "Create database". 
     3. Choose "Start in production mode" . Select a location for your database.
3. Install Dependencies
From your project's root directory, run:
   `flutter pub get`
4. Run the Application
Connect a device or start an emulator, then run the app:
`flutter run`



