// File konfigurasi manual untuk PawPing
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for ios.');
      case TargetPlatform.macOS:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for macos.');
      case TargetPlatform.windows:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for windows.');
      case TargetPlatform.linux:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for linux.');
      case TargetPlatform.fuchsia:
        throw UnsupportedError('DefaultFirebaseOptions have not been configured for fuchsia.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDHC9b4p6yNDtJgoYrf2Y_tIeF83kUFuKg',
    appId: '1:347011716292:web:5c0acd657e6552b364e591',
    messagingSenderId: '347011716292',
    projectId: 'pawping-97cb4',
    authDomain: 'pawping-97cb4.firebaseapp.com',
    databaseURL: 'https://pawping-97cb4-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'pawping-97cb4.firebasestorage.app',
  );

  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'ISI_DENGAN_ANDROID_API_KEY_KAMU',
  //   appId: 'ISI_DENGAN_ANDROID_APP_ID_KAMU',
  //   messagingSenderId: 'ISI_DENGAN_SENDER_ID_KAMU',
  //   projectId: 'pawping',
  //   databaseURL: 'ISI_DENGAN_DATABASE_URL_KAMU',
  //   storageBucket: 'pawping.appspot.com',
  // );
}