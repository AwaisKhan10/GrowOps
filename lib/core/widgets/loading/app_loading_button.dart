import 'package:flutter/material.dart';

import 'app_loader.dart';

/// Filled button that shows a loader while [loading] is true.
class AppLoadingButton extends StatelessWidget {
  const AppLoadingButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 6),
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const AppLoader.small(color: Colors.white)
          : Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}
