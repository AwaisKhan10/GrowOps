import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class SyncedBadge extends StatelessWidget {
  const SyncedBadge({super.key, this.compact = false});

  /// Tighter padding for dense headers (detail screens).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final offline = AppScope.of(context).offline;
    final l10n = AppLocalizations.of(context);
    final dark = AppColors.isDark(context);

    final bg = offline
        ? (dark ? const Color(0xFF3A2E22) : AppColors.warning)
        : (dark ? const Color(0xFF243828) : AppColors.success);
    final fg = offline
        ? (dark ? const Color(0xFFE0B88A) : AppColors.warningInk)
        : (dark ? const Color(0xFFA8D4B0) : AppColors.forest);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: dark
            ? Border.all(color: fg.withValues(alpha: 0.35))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            offline ? Icons.cloud_off : Icons.wifi,
            size: compact ? 12 : 14,
            color: fg,
          ),
          SizedBox(width: compact ? 4 : 5),
          Text(
            offline ? l10n.syncedOffline : l10n.syncedOnline,
            style: AppTextStyles.label(color: fg).copyWith(
              fontSize: compact ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
