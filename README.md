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

## Architecture Overview (BLoC with Firebase)
The application follows a clean architecture pattern, primarily using the BLoC library for state management and Firebase for backend services.
- UI Layer (Screens/Widgets):
  - LoginScreen, SignUpScreen, Notes (main notes display).
  - These widgets dispatch Events to the BLoCs and rebuild themselves based on States emitted by the BLoCs. They do not contain direct business logic or data fetching.

- Business Logic Layer (BLoCs):

