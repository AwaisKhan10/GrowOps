import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Auth data source — demo email/password + real Firebase Google Sign-In.
class DemoAuthDataSource {
  DemoAuthDataSource({
    fb.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fb.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final fb.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!email.contains('@') || password.isEmpty) {
      throw const ValidationException('Invalid email or password');
    }

    _currentUser = UserModel.demo(
      email: email,
      name: email == AppConstants.demoEmail
          ? AppConstants.demoGrowerName
          : 'Demo Grower',
      workspace: AppConstants.demoWorkspace,
    );
    return _currentUser!;
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    _currentUser = UserModel.demo(
      email: email.isEmpty ? 'new@growops.app' : email,
      name: name.isEmpty ? 'New Grower' : name,
      workspace: AppConstants.demoWorkspace,
    );
    return _currentUser!;
  }

  Future<UserModel> loginWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const UnauthorizedException(
          'Google Sign-In did not return an ID token. '
          'Add SHA keys in Firebase and enable Google provider.',
        );
      }

      final credential = fb.GoogleAuthProvider.credential(idToken: idToken);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw const UnauthorizedException('Firebase Google sign-in failed');
      }

      _currentUser = UserModel(
        id: user.uid,
        email: user.email ?? googleUser.email,
        name: user.displayName ?? googleUser.displayName ?? 'Google User',
        workspace: AppConstants.demoWorkspace,
      );
      return _currentUser!;
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelledException();
      }
      throw UnauthorizedException(error.description ?? error.toString());
    } on fb.FirebaseAuthException catch (error) {
      throw UnauthorizedException(error.message ?? error.code);
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    if (!email.contains('@')) {
      throw const ValidationException('Invalid email');
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore Google sign-out failures during demo/local logout.
    }
    try {
      await _firebaseAuth.signOut();
    } catch (_) {
      // Ignore Firebase sign-out failures during demo/local logout.
    }
    _currentUser = null;
  }
}
