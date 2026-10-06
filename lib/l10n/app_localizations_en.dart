// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GrowOpsGo';

  @override
  String get loginTitle => 'Sign in to manage your batches';

  @override
  String get loginAutofillDemo => 'Autofill demo credentials';

  @override
  String get authLoginTab => 'Log in';

  @override
  String get authSignupTab => 'Sign up';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authForgotPassword => 'Forgot password?';

  @override
  String get authOrDivider => 'OR';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authSignupTitle => 'Create account';

  @override
  String get authFullNameHint => 'Enter display name';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authPasswordHint => 'Enter password';

  @override
  String get authResetTitle => 'Reset password';

  @override
  String get authResetDescription => 'We\'ll send a reset link to your email.';

  @override
  String get authSendResetLink => 'Send reset link';

  @override
  String get authResetLinkSent => 'Reset link sent (demo)';

  @override
  String get syncedOnline => 'Synced';

  @override
  String get syncedOffline => 'Offline';

  @override
  String get navHome => 'Home';

  @override
  String get navBatches => 'Batches';

  @override
  String get navTasks => 'Tasks';

  @override
  String get navStock => 'Stock';

  @override
  String get navMore => 'More';

  @override
  String get quickActionsTitle => 'Quick actions';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'Unable to connect. Check your network and try again.';

  @override
  String get errorUnauthorized =>
      'Your session has expired. Please sign in again.';

  @override
  String get errorValidation => 'Please check your input and try again.';
}
