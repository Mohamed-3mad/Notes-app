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
    apiKey: 'AIzaSyC-fNpRKi-lqtFOo4oD5HAzXgVY9U3ye_8',
    appId: '1:894068168613:web:fc2c586ea438e678fafa4c',
    messagingSenderId: '894068168613',
    projectId: 'register-62a37',
    authDomain: 'register-62a37.firebaseapp.com',
    storageBucket: 'register-62a37.appspot.com',
    measurementId: 'G-VP65LC5MHE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDVmqSNMzfQ3pEbbvvjkEaWn4AgPYGFB30',
    appId: '1:894068168613:android:a5df2e7e5c2f7902fafa4c',
    messagingSenderId: '894068168613',
    projectId: 'register-62a37',
    storageBucket: 'register-62a37.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCKqBhPZftFjhFbWYarTwFQtLzd1M5g7uI',
    appId: '1:894068168613:ios:93591a7b0ced1593fafa4c',
    messagingSenderId: '894068168613',
    projectId: 'register-62a37',
    storageBucket: 'register-62a37.appspot.com',
    iosClientId: '894068168613-bq7ba9utbd41qel8u85ci825qo7kfrhe.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCKqBhPZftFjhFbWYarTwFQtLzd1M5g7uI',
    appId: '1:894068168613:ios:93591a7b0ced1593fafa4c',
    messagingSenderId: '894068168613',
    projectId: 'register-62a37',
    storageBucket: 'register-62a37.appspot.com',
    iosClientId: '894068168613-bq7ba9utbd41qel8u85ci825qo7kfrhe.apps.googleusercontent.com',
    iosBundleId: 'com.example.notes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC-fNpRKi-lqtFOo4oD5HAzXgVY9U3ye_8',
    appId: '1:894068168613:web:0e7c57badbfc48dffafa4c',
    messagingSenderId: '894068168613',
    projectId: 'register-62a37',
    authDomain: 'register-62a37.firebaseapp.com',
    storageBucket: 'register-62a37.appspot.com',
    measurementId: 'G-VNXZH2HY95',
  );

}