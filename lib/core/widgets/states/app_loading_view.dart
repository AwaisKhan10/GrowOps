import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';
import '../loading/app_loader.dart';

/// Full-area or inline loading state.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppLoader.large(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: AppTextStyles.bodySmall()),
          ],
        ],
      ),
    );
  }
}
