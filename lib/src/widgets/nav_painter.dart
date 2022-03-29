import 'package:flutter/material.dart';

class NavPainter extends CustomPainter {
  final Color color;
  final Path path;

  const NavPainter(this.path, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
