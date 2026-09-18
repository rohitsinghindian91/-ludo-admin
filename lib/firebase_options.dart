import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAdpsbH2w8T-iMh6pfBIBmjrgybXtgS9zY',
    appId: '1:472725834005:web:cacf6803be22d6708e411c',
    messagingSenderId: '472725834005',
    projectId: 'ludo-premium-50-e427e',
    authDomain: 'ludo-premium-50-e427e.firebaseapp.com',
    storageBucket: 'ludo-premium-50-e427e.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdpsbH2w8T-iMh6pfBIBmjrgybXtgS9zY',
    appId: '1:472725834005:android:d6dde95567e0b44a8e411c',
    messagingSenderId: '472725834005',
    projectId: 'ludo-premium-50-e427e',
    storageBucket: 'ludo-premium-50-e427e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAdpsbH2w8T-iMh6pfBIBmjrgybXtgS9zY',
    appId: '1:472725834005:web:cacf6803be22d6708e411c',
    messagingSenderId: '472725834005',
    projectId: 'ludo-premium-50-e427e',
    authDomain: 'ludo-premium-50-e427e.firebaseapp.com',
    storageBucket: 'ludo-premium-50-e427e.firebasestorage.app',
  );
}