
// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0U44NmVDI75l-U3iVynMHk_Jp_a7iezc',
    appId: '1:1034247307606:web:66a8b1e2244a992fe316f7',
    messagingSenderId: '1034247307606',
    projectId: 'auth-20866',
    authDomain: 'auth-20866.firebaseapp.com',
    storageBucket: 'auth-20866.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDfANULS8JyxexyDMA2ic29hKQN3krkCnQ',
    appId: '1:1034247307606:android:03ac33e502557b87e316f7',
    messagingSenderId: '1034247307606',
    projectId: 'auth-20866',
    storageBucket: 'auth-20866.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC7QT5OICJ4jrtrMYpw7vYU1Pyr1e4RJaM',
    appId: '1:1034247307606:ios:2bd18413b0f0c370e316f7',
    messagingSenderId: '1034247307606',
    projectId: 'auth-20866',
    storageBucket: 'auth-20866.firebasestorage.app',
    iosBundleId: 'com.example.aura',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC7QT5OICJ4jrtrMYpw7vYU1Pyr1e4RJaM',
    appId: '1:1034247307606:ios:2bd18413b0f0c370e316f7',
    messagingSenderId: '1034247307606',
    projectId: 'auth-20866',
    storageBucket: 'auth-20866.firebasestorage.app',
    iosBundleId: 'com.example.aura',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0U44NmVDI75l-U3iVynMHk_Jp_a7iezc',
    appId: '1:1034247307606:web:a7aa5549fdfa698be316f7',
    messagingSenderId: '1034247307606',
    projectId: 'auth-20866',
    authDomain: 'auth-20866.firebaseapp.com',
    storageBucket: 'auth-20866.firebasestorage.app',
  );

}