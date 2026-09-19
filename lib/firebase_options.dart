import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAdpsbH2w8T-iMh6pfBIBmjrgybXtgS9z2Y',
    appId: '1:472725834005:web:cacf6803be22d6708e411c',
    messagingSenderId: '472725834005',
    projectId: 'ludo-premium-50-e427e',
    authDomain: 'ludo-premium-50-e427e.firebaseapp.com',
    storageBucket: 'ludo-premium-50-e427e.firebasestorage.app',
  );
}
