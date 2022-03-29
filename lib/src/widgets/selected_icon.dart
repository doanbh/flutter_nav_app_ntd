import 'package:flutter/material.dart';

class SelectedIcon extends StatelessWidget {
  const SelectedIcon({
    Key? key,
    this.iconKey,
    required this.iconPadding,
    required this.icon,
    required this.type,
    this.color,
  }) : super(key: key);

  final dynamic iconKey;
  final EdgeInsetsGeometry iconPadding;
  final Widget icon;
  final MaterialType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    // wrap w/ Center because case input icon is CustomPainter
    final effectiveIcon = Center(
      key: ValueKey(iconKey),
      child: Padding(
        padding: iconPadding,
        child: icon,
      ),
    );

    if (type == MaterialType.transparency) {
      return effectiveIcon;
    }

    return Material(
      type: type,
      color: color,
      child: effectiveIcon,
    );
  }
}
