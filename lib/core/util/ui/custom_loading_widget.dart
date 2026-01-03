import 'package:flutter/material.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      children: [
        ModalBarrier(
          dismissible: false,
          color: colorScheme.onSurface.withValues(alpha: isDark ? 0.5 : 0.2),
        ),
        Center(
          child: CircularProgressIndicator(
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

