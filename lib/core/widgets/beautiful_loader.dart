import 'dart:math' as math;

import 'package:flutter/material.dart';

class BeautifulLoader extends StatefulWidget {
  const BeautifulLoader({
    super.key,
    this.size = 34,
    this.strokeWidth = 3.2,
  });

  final double size;
  final double strokeWidth;

  @override
  State<BeautifulLoader> createState() => _BeautifulLoaderState();
}

class _BeautifulLoaderState extends State<BeautifulLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final glowScale = 0.88 + (math.sin(t * math.pi * 2) * 0.08);

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: glowScale,
                child: Container(
                  width: widget.size * 0.52,
                  height: widget.size * 0.52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.28),
                        colorScheme.primary.withValues(alpha: 0.02),
                      ],
                    ),
                  ),
                ),
              ),
              Transform.rotate(
                angle: t * 2 * math.pi,
                child: CustomPaint(
                  size: Size.square(widget.size),
                  painter: _OrbitDotsPainter(
                    progress: t,
                    startColor: colorScheme.primary,
                    endColor: colorScheme.secondary,
                    strokeWidth: widget.strokeWidth,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrbitDotsPainter extends CustomPainter {
  const _OrbitDotsPainter({
    required this.progress,
    required this.strokeWidth,
    required this.startColor,
    required this.endColor,
  });

  final double progress;
  final double strokeWidth;
  final Color startColor;
  final Color endColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - (strokeWidth * 2);
    final count = 3;

    for (var i = 0; i < count; i++) {
      final phase = ((progress + (i / count)) % 1.0);
      final angle = phase * 2 * math.pi;
      final dotRadius = (strokeWidth * 1.8) + (math.sin(phase * math.pi) * 1.6);
      final dotOffset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final color = Color.lerp(startColor, endColor, phase) ?? startColor;
      final paint = Paint()
        ..color = color.withValues(alpha: 0.95)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotOffset, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitDotsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.startColor != startColor ||
        oldDelegate.endColor != endColor;
  }
}
