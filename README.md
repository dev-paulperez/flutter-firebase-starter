# Somnio's Flutter Boilerplate

This project was developed by Somnio Software as an app to be used as a boilerplate, making easy to start developing new apps or projects and as a repository to reuse generic widgets, services, models, etc. previously implemented on a working project.

### Supported sign-in methods

- [x] Anonymous
- [x] Email & Password
- [ ] Email link (passwordless)
- [x] Facebook
- [ ] GitHub
- [x] Google
- [x] Apple
- [ ] Phone
- [ ] Twitter

### Other authentication features

- [x] Email verification (for email & password sign-in)
- [x] Password reset
- [ ] Sign-in with custom token

## Application features

### Sign-in page

- [x] Email and password sign-in
- [x] Apple sign-in
- [x] Google sign-in
- [x] Facebook sign-in
- [ ] Anonymous sing-in
- [x] Custom submit button with loading state
- [x] Disable all input widgets while authentication is in progress
- [x] Email regex validation
- [x] Error hints
- [ ] Focus order (email -> password -> submit by pressing "next" on keyboard)
- [x] Password of at least 6 characters, with at least 1 number, 1 capital letter and 1 lowercase letter
- [x] Show/hide password
- [x] Password reset flow

### Create account page

- [x] First name and last name fields
- [x] Email regex validation
- [x] Password and Confirm Password validation
- [x] Show/hide password

### Email link page

- [ ] Email input field, backed by secure storage

### Services

#### Authentication

- [x] Abstract `AuthService` class, modeled after the `firebase_auth` API
- [x] `FirebaseAuthService` implementation
- [ ] `MockAuthService` for testing
- [x] Firebase project configuration for iOS & Android
- [ ] Toggle `FirebaseAuthService` and `MockAuthService` at runtime via developer menu

#### Storage

- [x] Abstract `StorageService` class, modeled after `firebase_storage` API
- [x] `FirebaseStorageService` implementation

#### Persistence

- [x] Abstract `PersistenceService` class, modeled after `cloud_firestore` API
- [x] `FirebasePersistenceService` implementation

### Architecture

- [x] Logic inside models for better separation of concerns (using [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html))
- [x] Use [Provider package](https://pub.dev/packages/provider) for dependency injection

### User models

- [x] On app custom User and Admin models
- [x] Admin and User roles defined
- [x] Admin with different capabilities from user

### Other

- [x] Use [`Shared Preferences`](https://pub.dev/packages/shared_preferences), a providing persistent storage for simple data
- [x] Use [`Image Picker`](https://pub.dev/packages/image_picker) for picking images from the library and taking photos
- [x] [`OnBoarding Screen`](https://pub.dev/packages/introduction_screen) with introduction text of the app and custom images
- [x] Custom `Splash Screen`
- [x] Custom App light and dark theme
- [x] Abstracted general widgets as buttons, text fields, lists, etc.

## Running the project with Firebase

To use this project with Firebase authentication, some configuration steps are required.

- Create a new project with the Firebase console.
- Add iOS and Android apps in the Firebase project settings.
- On iOS, you must set a bundle ID. As a recommendation, if your thinking of releasing the app on iOS, you should have an [Apple Developer Program Account](https://developer.apple.com/account/) and [create an app](https://developer.apple.com/account/resources/identifiers/list/bundleId) on your profile. Here you will setup your bundle ID validated by Apple, that you should also use on the Firebase Configuration.
- then, [download and copy](https://firebase.google.com/docs/flutter/setup#configure_an_ios_app) `GoogleService-Info.plist` into `iOS/Runner`, and add it to the Runner target in Xcode.
- On Android, define the package name as your preference, a good practice is to use as name the bundle ID defined on iOS (a SHA-1 certificate fingerprint is also needed for Google sign-in).
- then, [download and copy](https://firebase.google.com/docs/flutter/setup#configure_an_android_app) `google-services.json` into `android/app`.

See this document for full instructions:

- [https://firebase.google.com/docs/flutter/setup](https://firebase.google.com/docs/flutter/setup)

Additional setup instructions for Google, Apple and Facebook sign-in:

- Google Sign-In on iOS: [https://firebase.google.com/docs/auth/ios/google-signin](https://firebase.google.com/docs/auth/ios/google-signin)
- Google Sign-In on Android: [https://firebase.google.com/docs/auth/android/google-signin](https://firebase.google.com/docs/auth/android/google-signin)
- Facebook Login for Android: [https://developers.facebook.com/docs/facebook-login/android](https://developers.facebook.com/docs/facebook-login/android)
- Facebook Login for iOS: [https://developers.facebook.com/docs/facebook-login/ios](https://developers.facebook.com/docs/facebook-login/ios)
- Apple Sign-in: [https://pub.dev/packages/sign_in_with_apple](https://pub.dev/packages/sign_in_with_apple)