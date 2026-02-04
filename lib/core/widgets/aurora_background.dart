import 'dart:ui';

import 'package:flutter/material.dart';

class AuroraBackground extends StatelessWidget {
  const AuroraBackground({
    required this.child,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      fit: StackFit.expand,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? const [Color(0xFF0A1324), Color(0xFF101E3C), Color(0xFF0E1730)]
                  : const [Color(0xFFE7F0FF), Color(0xFFF8FBFF), Color(0xFFEAF6F7)],
            ),
          ),
        ),
        const _GlowOrb(
          alignment: Alignment(-0.95, -0.85),
          diameter: 220,
          color: Color(0x66437BFF),
        ),
        const _GlowOrb(
          alignment: Alignment(1.0, -0.5),
          diameter: 260,
          color: Color(0x6653D1BD),
        ),
        const _GlowOrb(
          alignment: Alignment(0.15, 1.05),
          diameter: 300,
          color: Color(0x66F6A623),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(color: Colors.transparent),
        ),
        if (padding != null)
          Padding(padding: padding!, child: child)
        else
          child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.alignment,
    required this.diameter,
    required this.color,
  });

  final Alignment alignment;
  final double diameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0.06), Colors.transparent],
            stops: const [0.2, 0.65, 1],
          ),
        ),
      ),
    );
  }
}
