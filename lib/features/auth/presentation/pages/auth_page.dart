import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app_state.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/failure_message.dart';
import '../../../../core/feedback/app_snackbar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/loading/app_loading_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_demo_box.dart';

/// Unified Login / Sign up screen matching the Lovable prototype screenshots.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.initialSignup = false});

  final bool initialSignup;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _isSignup;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _obscurePassword = true;
  String? _banner;
  bool _bannerIsError = true;

  @override
  void initState() {
    super.initState();
    _isSignup = widget.initialSignup;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofill() {
    setState(() {
      _emailController.text = AppConstants.demoEmail;
      _passwordController.text = AppConstants.demoPassword;
      if (_isSignup) {
        _nameController.text = AppConstants.demoGrowerName;
      }
    });
  }

  void _submit() {
    final bloc = context.read<AuthBloc>();
    if (_isSignup) {
      bloc.add(
        SignUpSubmitted(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      bloc.add(
        LoginSubmitted(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final app = AppScope.of(context);
    final loading = context.watch<AuthBloc>().state is AuthLoading;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => c is AuthFailureState,
      listener: (context, state) {
        if (state is AuthFailureState) {
          setState(() {
            _banner = state.failure.toLocalizedMessage(context);
            _bannerIsError = true;
          });
          context.read<AuthBloc>().add(const AuthFailureAcknowledged());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F4),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  children: [
                    const AuthBrandHeader(),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AuthDemoBox(onAutofill: _autofill),
                          const SizedBox(height: 14),
                          AuthModeToggle(
                            isSignup: _isSignup,
                            onChanged: (v) {
                              setState(() {
                                _isSignup = v;
                                _banner = null;
                              });
                              app.go(v ? '/signup' : '/auth');
                            },
                          ),
                          if (_banner != null) ...[
                            const SizedBox(height: 14),
                            AppMessageBanner(
                              message: _banner!,
                              isError: _bannerIsError,
                            ),
                          ],
                          const SizedBox(height: 18),
                          if (_isSignup) ...[
                            Text('Display name', style: AppTextStyles.body(weight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _nameController,
                              enabled: !loading,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: l10n.authFullNameHint,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text(l10n.authEmailLabel, style: AppTextStyles.body(weight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            enabled: !loading,
                            decoration: InputDecoration(
                              hintText: l10n.authEmailHint,
                              
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(l10n.authPasswordLabel, style: AppTextStyles.body(weight: FontWeight.w600)),
                              const Spacer(),
                              if (!_isSignup)
                                TextButton(
                                  onPressed: () => app.go('/forgot-password'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.muted,
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(l10n.authForgotPassword),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            enabled: !loading,
                            onSubmitted: (_) => _submit(),
                            decoration: InputDecoration(
                              hintText: l10n.authPasswordHint,
                              suffixIcon: IconButton(
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                                onPressed: () {
                                  setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  );
                                },
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                          ),
                          if (_isSignup) ...[
                            const SizedBox(height: 6),
                            Text(
                              'At least 8 characters.',
                              style: AppTextStyles.bodySmall(),
                            ),
                          ],
                          const SizedBox(height: 18),
                          AppLoadingButton(
                            label: _isSignup ? 'Create account' : l10n.authLoginTab,
                            loading: loading,
                            onPressed: _submit,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(l10n.authOrDivider, style: AppTextStyles.bodySmall()),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 14),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.line),
                              foregroundColor: AppColors.ink,
                            ),
                            onPressed: loading
                                ? null
                                : () => context.read<AuthBloc>().add(const GoogleLoginRequested()),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppAssets.google,
                                  width: 20,
                                  height: 20,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(l10n.authContinueWithGoogle),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Legacy aliases used by routing / barrel exports.
typedef LoginPage = AuthPage;
typedef SignupPage = AuthPage;
