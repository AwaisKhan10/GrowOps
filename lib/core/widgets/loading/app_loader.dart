import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Brand-aligned loading indicator.
class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
  });

  const AppLoader.small({super.key, this.color})
      : size = 20,
        strokeWidth = 2;

  const AppLoader.large({super.key, this.color})
      : size = 36,
        strokeWidth = 3;

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? AppColors.forest,
      ),
    );
  }
}
