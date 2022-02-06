import 'package:flutter/material.dart';

class GlobePedestalStylePainter extends CustomPainter {
  GlobePedestalStylePainter({
    required double startingLocX,
    required int itemsLength,
    required this.color,
    required TextDirection textDirection,
  }) : _maxLocX = (itemsLength - 1) / itemsLength {
    final span = 1.0 / itemsLength;
    double l = startingLocX + (span - _s) / 2;
    locX = textDirection == TextDirection.rtl ? 0.8 - l : l;
  }

  late final double locX;
  late final double _maxLocX;
  late final Color color;

  double get _notchWidth => 45;
  double get _halfNotchWidth => _notchWidth / 2;
  double get _s => 0.2;

  @override
  void paint(Canvas canvas, Size size) {
    bool isLocXEqualZero = locX == 0;
    bool isLocXEqualMax = locX == _maxLocX;

    bool isLocXCloseToZero =
        !isLocXEqualZero && double.parse(locX.toStringAsFixed(2)) <= 0.08;
    bool isLocXCloseToMax =
        !isLocXEqualMax && double.parse(locX.toStringAsFixed(1)) == _maxLocX;

    bool shouldChangeFirstCubic =
        (isLocXEqualZero || isLocXCloseToZero) && size.width < 458;
    bool shouldChangeLastCubic =
        (isLocXEqualMax || isLocXCloseToMax) && size.width < 458;

    // point no. 6
    double notchCenterX = size.width * (locX + 0.1000000);

    double pointNo5X = notchCenterX - _halfNotchWidth - 5.54100;
    double pointNo7X = notchCenterX + _halfNotchWidth + 5.54100;

    double pointNo4X = pointNo5X - 9.35100 + (isLocXEqualMax ? 0.649 : 0);
    double pointNo8X = pointNo7X + 9.35100 - (isLocXEqualMax ? 0.649 : 0);

    Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, size.height * 0.2500000)
      ..cubicTo(
        0,
        size.height * 0.1119333,
        shouldChangeFirstCubic
            ? isLocXCloseToZero
                ? size.width *
                    (0.01790933 - ((1 - locX - 0.01790933).abs() * 0.02))
                : 0
            : 6.716,
        shouldChangeFirstCubic
            ? size.height *
                (isLocXCloseToZero ? ((locX * 0.1) - 0.050000000) : 0.050000000)
            : 0,
        shouldChangeFirstCubic
            ? isLocXCloseToZero
                ? (() {
                    double x = pointNo4X - 15 - (1 / locX);

                    return x <= 0.0 ? 0.0 : x;
                  })()
                : 0
            : 15,
        0,
      )
      ..lineTo(pointNo4X, 0)
      ..cubicTo(
        pointNo4X + 5.54100,
        0,
        pointNo5X,
        size.height * 0.09931667,
        pointNo5X,
        size.height * 0.1916667,
      )
      ..cubicTo(
        pointNo5X,
        size.height * 0.4448000,
        notchCenterX - 15.18800,
        size.height * 0.6500000,
        notchCenterX,
        size.height * 0.6500000,
      )
      ..cubicTo(
        notchCenterX + 15.18800,
        size.height * 0.6500000,
        pointNo7X,
        size.height * 0.4448000,
        pointNo7X,
        size.height * 0.1916667,
      )
      ..cubicTo(
        pointNo7X,
        size.height * 0.09931667,
        pointNo8X - 5.54100,
        0,
        pointNo8X,
        0,
      )
      ..lineTo(
        shouldChangeLastCubic
            ? isLocXCloseToMax
                ? (() {
                    double x = pointNo8X + 15 - (1 / locX);

                    return x >= size.width ? size.width : x;
                  })()
                : size.width
            : size.width - 15,
        0,
      )
      ..cubicTo(
        shouldChangeLastCubic
            ? size.width *
                (isLocXCloseToMax
                    ? (0.9820907 + ((1 - locX - 0.9820907).abs() * 0.02))
                    : 1)
            : size.width - 6.716,
        shouldChangeLastCubic
            ? size.height *
                (isLocXCloseToMax ? ((locX * 0.1) - 0.050000000) : 0.050000000)
            : 0,
        size.width,
        size.height * 0.1119333,
        size.width,
        size.height * 0.2500000,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
