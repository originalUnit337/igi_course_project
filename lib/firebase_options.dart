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
    apiKey: 'AIzaSyCwyFi5H9IhNKDI5fIPIIaGHVP2qRr5-rg',
    appId: '1:741506622193:web:58b13921aa804e907d3f50',
    messagingSenderId: '741506622193',
    projectId: 'igi-course-project',
    authDomain: 'igi-course-project.firebaseapp.com',
    storageBucket: 'igi-course-project.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCEZHckNA6ZrCHS6HZdjlJxDwuaR5njo9E',
    appId: '1:741506622193:android:cc3aeed76285a7967d3f50',
    messagingSenderId: '741506622193',
    projectId: 'igi-course-project',
    storageBucket: 'igi-course-project.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZ6wDRSVaPs9eqpRPHdBX6bhoDfSchwqY',
    appId: '1:741506622193:ios:619ea28ec529896d7d3f50',
    messagingSenderId: '741506622193',
    projectId: 'igi-course-project',
    storageBucket: 'igi-course-project.firebasestorage.app',
    iosBundleId: 'com.example.igiCourseProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDZ6wDRSVaPs9eqpRPHdBX6bhoDfSchwqY',
    appId: '1:741506622193:ios:619ea28ec529896d7d3f50',
    messagingSenderId: '741506622193',
    projectId: 'igi-course-project',
    storageBucket: 'igi-course-project.firebasestorage.app',
    iosBundleId: 'com.example.igiCourseProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCwyFi5H9IhNKDI5fIPIIaGHVP2qRr5-rg',
    appId: '1:741506622193:web:b6329fe5ab456ef97d3f50',
    messagingSenderId: '741506622193',
    projectId: 'igi-course-project',
    authDomain: 'igi-course-project.firebaseapp.com',
    storageBucket: 'igi-course-project.firebasestorage.app',
  );

}