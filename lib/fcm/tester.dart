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
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBKemskAao8jtZiI1FmYJG3J-ZFS9EObBw',
    appId: '1:910516599381:web:1e849d6f34aad5d13c72dc',
    messagingSenderId: '791585851981',
    projectId: 'wecloppe-df76f',
    authDomain: 'udemy-ac28e.firebaseapp.com',
    storageBucket: 'wecloppe-df76f.appspot.com',
    measurementId: 'G-Z2CQWBK39Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKemskAao8jtZiI1FmYJG3J-ZFS9EObBw',
    appId: '1:791585851981:android:e5db9cf7ff1a11dbc12a04',
    messagingSenderId: '791585851981',
    projectId: 'wecloppe-df76f',
    storageBucket: 'wecloppe-df76f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBKemskAao8jtZiI1FmYJG3J-ZFS9EObBw',
    appId: '1:910516599381:ios:95dbeaa76045105a3c72dc',
    messagingSenderId: '791585851981',
    projectId: 'wecloppe-df76f',
    storageBucket: 'wecloppe-df76f.appspot.com',
    iosClientId:
        '910516599381-t765u6d36k1ejen9lt5gogckmcnpeuav.apps.googleusercontent.com',
    iosBundleId: 'com.mashaheerism.poolApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBKemskAao8jtZiI1FmYJG3J-ZFS9EObBw',
    appId: '1:910516599381:ios:95dbeaa76045105a3c72dc',
    messagingSenderId: '791585851981',
    projectId: 'wecloppe-df76f',
    storageBucket: 'wecloppe-df76f.appspot.com',
    iosClientId:
        '910516599381-t765u6d36k1ejen9lt5gogckmcnpeuav.apps.googleusercontent.com',
    iosBundleId: 'com.mashaheerism.poolApp',
  );
}
