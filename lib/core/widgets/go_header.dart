import 'package:flutter/material.dart';

import '../../app_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'synced_badge.dart';

/// App screen header matching GrowOps prototype screenshots.
///
/// Layout: [back] title(+subtitle) ··· [actions] [Synced] [menu]
/// Title is always a single line (ellipsis) so it never wraps under the back icon.
class GoHeader extends StatelessWidget {
  const GoHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.showNotifications = false,
    this.notificationCount = 0,
    this.trailing,
    this.showBorder = true,
    this.showSynced = true,
    this.showExportActions = false,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showNotifications;
  final int notificationCount;
  final Widget? trailing;
  final bool showBorder;
  final bool showSynced;
  final bool showExportActions;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final ink = AppColors.inkOf(context);
    final muted = AppColors.mutedOf(context);
    final line = AppColors.lineOf(context);
    // Keep title on one line — smaller when chrome is dense.
    final dense = showBack || showExportActions || trailing != null;
    final titleSize = showExportActions ? 18.0 : (dense ? 22.0 : 26.0);

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: showBorder
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: line, width: 1),
                ),
              )
            : null,
        padding: const EdgeInsets.fromLTRB(4, 4, 4, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBack)
              _HeaderIconButton(
                icon: Icons.arrow_back,
                onTap: app.back,
                iconSize: 22,
                color: ink,
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: showBack ? 2 : 12,
                  right: 8,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final fittedSize = _titleSizeThatFits(
                      title,
                      constraints.maxWidth,
                      titleSize,
                    );
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.display().copyWith(
                            fontSize: fittedSize,
                            height: 1.2,
                            color: ink,
                          ),
                        ),
                        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall(color: muted),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
            if (showNotifications)
              _HeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () => app.go('/tasks'),
                badge: notificationCount > 0,
                color: ink,
              ),
            if (trailing != null) trailing!,
            if (showExportActions) ...[
              _ExportAction(
                icon: Icons.download_outlined,
                label: 'CSV',
                color: ink,
              ),
              _ExportAction(
                icon: Icons.picture_as_pdf_outlined,
                label: 'PDF',
                color: ink,
              ),
            ],
            if (showSynced) ...[
              const SyncedBadge(compact: true),
              const SizedBox(width: 2),
            ],
            _HeaderIconButton(
              icon: Icons.menu,
              onTap: () => Scaffold.of(context).openEndDrawer(),
              color: ink,
            ),
          ],
        ),
      ),
    );
  }
}

/// Sticky [GoHeader] above a padded scrollable body.
class GoPageScaffold extends StatelessWidget {
  const GoPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.showBack = true,
    this.showSynced = true,
    this.showExportActions = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showSynced;
  final bool showExportActions;
  final Widget? trailing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GoHeader(
          title: title,
          subtitle: subtitle,
          showBack: showBack,
          showSynced: showSynced,
          showExportActions: showExportActions,
          trailing: trailing,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: children,
          ),
        ),
      ],
    );
  }
}

class _ExportAction extends StatelessWidget {
  const _ExportAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.inkOf(context);
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 2),
            Text(
              label,
              style: AppTextStyles.label(color: fg).copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shrinks long titles (for example "Compliance Dashboard") so the full
/// name stays on one line beside the back button and header actions.
double _titleSizeThatFits(String title, double maxWidth, double preferred) {
  if (maxWidth <= 0) return preferred;
  var size = preferred;
  final painter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );
  while (size > 15) {
    painter.text = TextSpan(
      text: title,
      style: AppTextStyles.display().copyWith(fontSize: size, height: 1.2),
    );
    painter.layout();
    if (painter.width <= maxWidth) return size;
    size -= 0.5;
  }
  return 15;
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.badge = false,
    this.iconSize = 24,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool badge;
  final double iconSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.inkOf(context);
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Icon(icon, size: iconSize, color: fg),
            if (badge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Circular green + button used in Batches header.
class HeaderAddButton extends StatelessWidget {
  const HeaderAddButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: AppColors.forest,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const SizedBox(
            width: 36,
            height: 36,
            child: Icon(Icons.add, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
