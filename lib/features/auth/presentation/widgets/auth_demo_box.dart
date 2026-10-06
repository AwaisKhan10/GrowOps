import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';

class AuthDemoBox extends StatelessWidget {
  const AuthDemoBox({super.key, required this.onAutofill});

  final VoidCallback onAutofill;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.authDemoBox,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.line,
          style: BorderStyle.solid,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.forest.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Demo account', style: AppTextStyles.body(weight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.xs),
          Text('Email:  ${AppConstants.demoEmail}'),
          Text('Password:  ${AppConstants.demoPassword}'),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onAutofill,
            child: Text(
              l10n.loginAutofillDemo,
              style: AppTextStyles.body(
                color: AppColors.forest,
                weight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthBrandHeader extends StatelessWidget {
  const AuthBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                AppAssets.logoMark,
                width: 36,
                height: 36,
                errorBuilder: (_, __, ___) => Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.forest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.eco, color: Colors.white, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.appTitle,
              style: AppTextStyles.title(),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          l10n.loginTitle,
          style: AppTextStyles.body(color: AppColors.muted).copyWith(fontSize: 15),
        ),
      ],
    );
  }
}

/// Segmented Log in / Sign up control matching the prototype.
class AuthModeToggle extends StatelessWidget {
  const AuthModeToggle({
    super.key,
    required this.isSignup,
    required this.onChanged,
  });

  final bool isSignup;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.softButtonUnfilled,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(child: _tab(l10n.authLoginTab, selected: !isSignup, onTap: () => onChanged(false))),
          Expanded(child: _tab(l10n.authSignupTab, selected: isSignup, onTap: () => onChanged(true))),
        ],
      ),
    );
  }

  Widget _tab(String label, {required bool selected, required VoidCallback onTap}) {
    return Material(
      color: selected ? AppColors.card : Colors.transparent,
      elevation: selected ? 1 : 0,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: selected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.forest.withValues(alpha: 0.35)),
                )
              : null,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.forest : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
