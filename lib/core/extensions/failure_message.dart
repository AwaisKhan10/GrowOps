import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../errors/failures.dart';

/// Maps domain failures to localized user-facing messages.
extension FailureMessage on Failure {
  String toLocalizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      NetworkFailure() => l10n.errorNetwork,
      UnauthorizedFailure() || AuthSessionExpiredFailure() => l10n.errorUnauthorized,
      AuthCancelledFailure() => 'Google sign-in cancelled',
      ValidationFailure() || AuthInvalidCredentialsFailure() || AuthInvalidEmailFailure() =>
        l10n.errorValidation,
      ServerFailure() || CacheFailure() || ParsingFailure() || UnknownFailure() =>
        l10n.errorUnknown,
    };
  }
}
