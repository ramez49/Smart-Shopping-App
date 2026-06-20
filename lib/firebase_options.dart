// Firebase configuration file
// For Android: Place your google-services.json in android/app/
// For iOS: Place your GoogleService-Info.plist in ios/Runner/
// For Web: Configure the options below or add to .env file

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ============================================
  // WEB CONFIGURATION
  // ============================================
  // You can get these values from Firebase Console:
  // Project Settings > Your apps > Web app > Config
  static FirebaseOptions get web => FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_API_KEY'] ?? 'YOUR_WEB_API_KEY',
    appId: dotenv.env['FIREBASE_APP_ID'] ?? 'YOUR_WEB_APP_ID',
    messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? 'YOUR_MESSAGING_SENDER_ID',
    projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? 'YOUR_PROJECT_ID',
    authDomain: '${dotenv.env['FIREBASE_PROJECT_ID'] ?? 'YOUR_PROJECT_ID'}.firebaseapp.com',
    storageBucket: '${dotenv.env['FIREBASE_PROJECT_ID'] ?? 'YOUR_PROJECT_ID'}.appspot.com',
  );

  // ============================================
  // ANDROID CONFIGURATION
  // ============================================
  // These values are automatically read from google-services.json
  // Place your google-services.json file in: android/app/google-services.json
  static const android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    appId: 'YOUR_ANDROID_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // ============================================
  // iOS CONFIGURATION
  // ============================================
  // These values are automatically read from GoogleService-Info.plist
  // Place your GoogleService-Info.plist file in: ios/Runner/GoogleService-Info.plist
  static const ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.example.projectMobileApp',
  );
}
