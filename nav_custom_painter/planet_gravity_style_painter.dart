import 'package:flutter/material.dart';

class PlanetGravityStylePainter extends CustomPainter {
  PlanetGravityStylePainter({
    required double startingLocX,
    required int itemsLength,
    required this.color,
    required TextDirection textDirection,
  }) {
    final span = 1.0 / itemsLength;
    double l = startingLocX + (span - _s) / 2;
    locX = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }

  late final double locX;
  late final Color color;

  double get _s => 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo((locX - 0.1) * size.width, 0)
      ..cubicTo(
        (locX + _s * 0.20) * size.width,
        size.height * 0.05,
        locX * size.width,
        size.height * 0.60,
        (locX + _s * 0.50) * size.width,
        size.height * 0.60,
      )
      ..cubicTo(
        (locX + _s) * size.width,
        size.height * 0.60,
        (locX + _s - _s * 0.20) * size.width,
        size.height * 0.05,
        (locX + _s + 0.1) * size.width,
        0,
      )
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
