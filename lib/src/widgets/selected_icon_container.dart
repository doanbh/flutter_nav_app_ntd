import 'package:flutter/material.dart';

class SelectedIconContainer extends StatelessWidget {
  const SelectedIconContainer({
    Key? key,
    required this.bottom,
    required this.horizontalDistance,
    required this.width,
    required this.yOffset,
    required this.icon,
  }) : super(key: key);

  final double bottom;
  final double horizontalDistance;
  final double width;
  final double yOffset;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: Directionality.of(context) == TextDirection.rtl
          ? null
          : horizontalDistance,
      right: Directionality.of(context) == TextDirection.rtl
          ? horizontalDistance
          : null,
      width: width,
      child: Transform.translate(
        offset: Offset(0, yOffset),
        child: icon,
      ),
    );
  }
}
