import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.init();
  await configureDependencies();
  runApp(const GrowOpsGoApp());
}
