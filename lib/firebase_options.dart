// File generated for GrowOpsGo Firebase project (growopsgo).
// Ignore: avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web is not configured for GrowOpsGo yet.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDHtN-k5MYFzRuDAuZdJd-AIx0-URsS44A',
    appId: '1:726480725003:android:08ecba3a41af92877e530e',
    messagingSenderId: '726480725003',
    projectId: 'growopsgo',
    storageBucket: 'growopsgo.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEeNYtfimOsU5Plnq8EL7Pnw3jNIkA0Dc',
    appId: '1:726480725003:ios:328bc52ee6b31f937e530e',
    messagingSenderId: '726480725003',
    projectId: 'growopsgo',
    storageBucket: 'growopsgo.firebasestorage.app',
    iosBundleId: 'com.growopsgo.app',
  );
}
