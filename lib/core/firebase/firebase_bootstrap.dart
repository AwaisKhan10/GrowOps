import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../firebase_options.dart';

/// Boots Firebase + Google Sign-In once at app start.
abstract final class FirebaseBootstrap {
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Android reads client IDs from google-services.json after SHA + Google
    // provider are configured. iOS can pass clientId from GoogleService-Info.
    await GoogleSignIn.instance.initialize();

    _ready = true;
    debugPrint('Firebase + Google Sign-In initialized');
  }
}
