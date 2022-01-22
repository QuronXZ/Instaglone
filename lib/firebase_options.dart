// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0Nu90eh4dgVyT3uJqziXzHS6YmRmRTnQ',
    appId: '1:403232190641:web:265242ef064e1dc7923290',
    messagingSenderId: '403232190641',
    projectId: 'instaglone',
    authDomain: 'instaglone.firebaseapp.com',
    storageBucket: 'instaglone.appspot.com',
    measurementId: 'G-PJ4H0930LV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBQdqmAoMcZm0Tvk7-G-LsNgI0_sBIFGR0',
    appId: '1:403232190641:android:315f67a367869500923290',
    messagingSenderId: '403232190641',
    projectId: 'instaglone',
    storageBucket: 'instaglone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBPDIjJdC9jIc1u3NZk--MZn6qN4tdqGy8',
    appId: '1:403232190641:ios:4aa1060a8ed2873b923290',
    messagingSenderId: '403232190641',
    projectId: 'instaglone',
    storageBucket: 'instaglone.appspot.com',
    iosClientId: '403232190641-sisuvii9umjpiq9um2166sj4tjsp70hp.apps.googleusercontent.com',
    iosBundleId: 'no',
  );
}