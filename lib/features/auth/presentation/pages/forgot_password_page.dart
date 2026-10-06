import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_state.dart';
import '../../../../core/extensions/failure_message.dart';
import '../../../../core/feedback/app_snackbar.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailController;
  String? _banner;
  bool _bannerIsError = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<AuthBloc>().add(
          PasswordResetRequested(email: _emailController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final app = AppScope.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPasswordResetSent) {
          setState(() {
            _banner = l10n.authResetLinkSent;
            _bannerIsError = false;
          });
          context.read<AuthBloc>().add(const PasswordResetAcknowledged());
          Future<void>.delayed(const Duration(milliseconds: 1600), () {
            if (!mounted) return;
            app.go('/auth');
          });
        } else if (state is AuthFailureState) {
          setState(() {
            _banner = state.failure.toLocalizedMessage(context);
            _bannerIsError = true;
          });
          context.read<AuthBloc>().add(const AuthFailureAcknowledged());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.authResetTitle),
          leading: IconButton(
            onPressed: () => app.go('/auth'),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Text(l10n.authResetDescription),
              if (_banner != null) ...[
                const SizedBox(height: AppSpacing.lg),
                AppMessageBanner(
                  message: _banner!,
                  isError: _bannerIsError,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: l10n.authEmailHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    current is AuthLoading || previous is AuthLoading,
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return FilledButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.authSendResetLink),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
