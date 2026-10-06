import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class GoFabAction {
  const GoFabAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

/// Circular FAB that expands upward into pill quick-actions (prototype style).
class GoFabMenu extends StatefulWidget {
  const GoFabMenu({
    super.key,
    required this.actions,
    this.enabled = true,
  });

  final List<GoFabAction> actions;
  final bool enabled;

  @override
  State<GoFabMenu> createState() => _GoFabMenuState();
}

class _GoFabMenuState extends State<GoFabMenu>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _scale = Tween<double>(begin: 0.85, end: 1).animate(_fade);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!widget.enabled) return;
    setState(() => _open = !_open);
    if (_open) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _close() {
    if (!_open) return;
    setState(() => _open = false);
    _controller.reverse();
  }

  void _run(GoFabAction action) {
    _close();
    action.onTap();
  }

  @override
  Widget build(BuildContext context) {
    // Sit above custom bottom nav (62) + home indicator.
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final fabBottom = 16 + 62 + bottomPad;

    return Stack(
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: FadeTransition(
                opacity: _fade,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                  child: Container(color: Colors.black.withValues(alpha: 0.18)),
                ),
              ),
            ),
          ),
        Positioned(
          right: 16,
          bottom: fabBottom,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  alignment: Alignment.bottomRight,
                  child: IgnorePointer(
                    ignoring: !_open,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final action in widget.actions) ...[
                          _FabPill(
                            label: action.label,
                            icon: action.icon,
                            onTap: () => _run(action),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              _MainFab(
                open: _open,
                enabled: widget.enabled,
                onTap: _toggle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainFab extends StatelessWidget {
  const _MainFab({
    required this.open,
    required this.enabled,
    required this.onTap,
  });

  final bool open;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.forest : AppColors.muted,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 2.5),
      ),
      elevation: 4,
      shadowColor: Colors.black26,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: enabled ? onTap : null,
        child: SizedBox(
          width: 60,
          height: 60,
          child: AnimatedRotation(
            turns: open ? 0.125 : 0, // + becomes ×
            duration: const Duration(milliseconds: 220),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}

class _FabPill extends StatelessWidget {
  const _FabPill({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.softButtonUnfilled,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: AppColors.forest),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTextStyles.body(weight: FontWeight.w600).copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
