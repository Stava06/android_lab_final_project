import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnE30nstXcfD9k4B38QZQFNG15inoLWnU',
    appId: '1:939159106937:android:a7d0da5ff3b3a0e81e6ba8',
    messagingSenderId: '939159106937',
    projectId: 'androidfinalproject-3e903',
    databaseURL:
        'https://androidfinalproject-3e903-default-rtdb.firebaseio.com',
    storageBucket: 'androidfinalproject-3e903.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDXqlS460a7wxLo7isPgM2ihEhVyQtlzrI',
    appId: '1:939159106937:web:3adb471264ebc45d1e6ba8',
    messagingSenderId: '939159106937',
    projectId: 'androidfinalproject-3e903',
    authDomain: 'androidfinalproject-3e903.firebaseapp.com',
    databaseURL:
        'https://androidfinalproject-3e903-default-rtdb.firebaseio.com',
    storageBucket: 'androidfinalproject-3e903.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDmQ1ffZUmLEc78Qgnz6pFMqYMWVELkv_I',
    appId: '1:939159106937:ios:049dd4bade33da231e6ba8',
    messagingSenderId: '939159106937',
    projectId: 'androidfinalproject-3e903',
    databaseURL:
        'https://androidfinalproject-3e903-default-rtdb.firebaseio.com',
    storageBucket: 'androidfinalproject-3e903.firebasestorage.app',
    iosClientId:
        '939159106937-2nufthf8tn8rb08c0blfipatpte707mn.apps.googleusercontent.com',
    iosBundleId: 'com.example.androidLabFinalProject',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDmQ1ffZUmLEc78Qgnz6pFMqYMWVELkv_I',
    appId: '1:939159106937:ios:049dd4bade33da231e6ba8',
    messagingSenderId: '939159106937',
    projectId: 'androidfinalproject-3e903',
    databaseURL:
        'https://androidfinalproject-3e903-default-rtdb.firebaseio.com',
    storageBucket: 'androidfinalproject-3e903.firebasestorage.app',
    iosClientId:
        '939159106937-2nufthf8tn8rb08c0blfipatpte707mn.apps.googleusercontent.com',
    iosBundleId: 'com.example.androidLabFinalProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDXqlS460a7wxLo7isPgM2ihEhVyQtlzrI',
    appId: '1:939159106937:web:9783f21796783cdf1e6ba8',
    messagingSenderId: '939159106937',
    projectId: 'androidfinalproject-3e903',
    authDomain: 'androidfinalproject-3e903.firebaseapp.com',
    databaseURL:
        'https://androidfinalproject-3e903-default-rtdb.firebaseio.com',
    storageBucket: 'androidfinalproject-3e903.firebasestorage.app',
  );
}
