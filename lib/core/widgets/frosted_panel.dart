import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedPanel extends StatelessWidget {
  const FrostedPanel({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.45),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0x3DFFFFFF), Color(0x1AFFFFFF)]
                  : const [Color(0xD9FFFFFF), Color(0x88FFFFFF)],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
