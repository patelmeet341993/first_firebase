// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAK8OK4QFv5hsjQHsVxRQfnCYuZRXMiO9o',
    appId: '1:403008947046:web:7682c181a89249108cbea7',
    messagingSenderId: '403008947046',
    projectId: 'batch2023project-d5531',
    authDomain: 'batch2023project-d5531.firebaseapp.com',
    storageBucket: 'batch2023project-d5531.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCfCEvdRlUAVyR3-8jsy70qrPqZS5CEfNc',
    appId: '1:403008947046:android:0d05a9289b031d358cbea7',
    messagingSenderId: '403008947046',
    projectId: 'batch2023project-d5531',
    storageBucket: 'batch2023project-d5531.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxeGDI7EVsrqnXUrVPnG0dexfKvnad63c',
    appId: '1:403008947046:ios:32b03551a6f81d6d8cbea7',
    messagingSenderId: '403008947046',
    projectId: 'batch2023project-d5531',
    storageBucket: 'batch2023project-d5531.appspot.com',
    iosBundleId: 'com.friendlyitsolution.demo.firstFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxeGDI7EVsrqnXUrVPnG0dexfKvnad63c',
    appId: '1:403008947046:ios:51f84933b528b8fa8cbea7',
    messagingSenderId: '403008947046',
    projectId: 'batch2023project-d5531',
    storageBucket: 'batch2023project-d5531.appspot.com',
    iosBundleId: 'com.friendlyitsolution.demo.firstFirebase.RunnerTests',
  );
}