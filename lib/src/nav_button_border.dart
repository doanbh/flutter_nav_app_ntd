import 'dart:ui';

import 'package:curved_navigation_bar/src/nav_path.dart';
import 'package:flutter/material.dart';

class NavButtonBorder extends ShapeBorder {
  NavButtonBorder({
    required this.fullPath,
    required this.startingLocX,
    required this.navSize,
    required this.itemsLength,
  }) : super();

  final Path fullPath;
  final double startingLocX;
  final Size navSize;
  final int itemsLength;

  // static Map<String, Path> _cache = Map();

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Path path = _getShape(textDirection!);

    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.transparent;
    // for test
    // ..style = PaintingStyle.stroke
    // ..color = Colors.deepOrange;

    canvas.drawPath(path, paint);
  }

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _getShape(textDirection!);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      _getShape(textDirection!);

  @override
  ShapeBorder scale(double t) => NavButtonBorder(
        fullPath: this.fullPath,
        startingLocX: this.startingLocX,
        navSize: navSize,
        itemsLength: this.itemsLength,
      );

  // static Path _getButtonRect(String key, Path Function() f) =>
  //     _cache.putIfAbsent(key, () => f());

  Path _getShape(TextDirection textDirection) {
    final Path path = NavPath.buttonRect(
      startingLocX,
      navSize,
      itemsLength,
      textDirection,
    );

    // print("-----------------");

    // print("path");
    // print(path.getBounds());
    // print(path.computeMetrics().any((PathMetric metric) => metric.length > 0));

    // print("fullPath");
    // print(fullPath.getBounds());

    final Path intersection = Path.combine(
      PathOperation.intersect,
      fullPath,
      path,
      // _getButtonRect(
      //   "$startingLocX $navWidth $size $textDirection",
      //   () => NavPath.buttonRect(
      //     startingLocX,
      //     navWidth,
      //     size,
      //     itemsLength,
      //     textDirection,
      //   ),
      // ),
    );

    // print("intersection");
    // print(intersection.getBounds());
    // print(intersection
    //     .computeMetrics()
    //     .any((PathMetric metric) => metric.length > 0));

    return intersection;
  }
}
