import 'package:flutter/material.dart';

/// Slow-drifting gradient orbs used behind cinematic sections. Pure decor —
/// never intercepts pointer events and respects reduced-motion settings.
class AnimatedMeshBackground extends StatefulWidget {
  const AnimatedMeshBackground({
    super.key,
    this.colors = const [
      Color(0xFF0B2E25),
      Color(0xFF133B2E),
      Color(0xFF0A1F3D),
    ],
    this.opacity = 1,
  });

  final List<Color> colors;
  final double opacity;

  @override
  State<AnimatedMeshBackground> createState() =>
      _AnimatedMeshBackgroundState();
}

class _AnimatedMeshBackgroundState extends State<AnimatedMeshBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return IgnorePointer(
      child: Opacity(
        opacity: widget.opacity,
        child: ColoredBox(
          color: widget.colors.first,
          child: reduce
              ? CustomPaint(
                  painter: _MeshPainter(widget.colors, 0),
                  size: Size.infinite,
                )
              : AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) => CustomPaint(
                    painter: _MeshPainter(widget.colors, _c.value),
                    size: Size.infinite,
                  ),
                ),
        ),
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  _MeshPainter(this.colors, this.t);
  final List<Color> colors;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final cycle = t * 6.283185307;
    final blobs = <(Offset, double, Color)>[
      (
        Offset(
          size.width * (0.18 + 0.08 * math_cos(cycle)),
          size.height * (0.22 + 0.06 * math_sin(cycle)),
        ),
        size.width * 0.42,
        colors[1 % colors.length].withValues(alpha: 0.55),
      ),
      (
        Offset(
          size.width * (0.82 + 0.06 * math_sin(cycle * 0.8)),
          size.height * (0.30 + 0.08 * math_cos(cycle * 0.8)),
        ),
        size.width * 0.38,
        colors[2 % colors.length].withValues(alpha: 0.5),
      ),
      (
        Offset(
          size.width * (0.5 + 0.10 * math_sin(cycle * 0.5 + 1.4)),
          size.height * (0.85 + 0.05 * math_cos(cycle * 0.5)),
        ),
        size.width * 0.5,
        const Color(0xFFC99A3D).withValues(alpha: 0.16),
      ),
    ];
    for (final (center, radius, color) in blobs) {
      final paint = Paint()
        ..shader = RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MeshPainter oldDelegate) =>
      oldDelegate.t != t;
}

double math_cos(double x) => _cosTable(x);
double math_sin(double x) => _cosTable(x - 1.5707963267948966);

double _cosTable(double x) {
  // Lightweight cos without importing dart:math at call sites repeatedly.
  const twoPi = 6.283185307179586;
  var v = x % twoPi;
  if (v < 0) v += twoPi;
  return _cos(v);
}

double _cos(double x) {
  // Bhaskara I's approximation — smooth enough for decorative motion.
  final piMinusX = 3.141592653589793 - x;
  if (x <= 3.141592653589793) {
    return -(16 * x * piMinusX) /
        (49.34802200544679 - 4 * x * piMinusX);
  }
  final y = x - 3.141592653589793;
  final piMinusY = 3.141592653589793 - y;
  return (16 * y * piMinusY) / (49.34802200544679 - 4 * y * piMinusY);
}
