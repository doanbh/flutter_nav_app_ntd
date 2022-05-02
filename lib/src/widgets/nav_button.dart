import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../nav_button_border.dart';

class NavButton extends StatelessWidget {
  final Path navPath;
  final Size navSize;
  final double position;
  final int length;
  final int index;
  final double offsetY;
  final ValueChanged<int> onTap;
  final NavItemSplashType splashType;
  final double? splashRadius;
  final Widget child;

  NavButton({
    required this.onTap,
    required this.navPath,
    required this.navSize,
    required this.position,
    required this.length,
    required this.index,
    required this.offsetY,
    required this.splashType,
    required this.splashRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final desiredPosition = 1.0 / length * index;
    final difference = (position - desiredPosition).abs();
    final verticalAlignment = 1 - length * difference;
    final opacity = length * difference;

    late final NavButtonBorder shape;

    if (splashType != NavItemSplashType.none)
      shape = NavButtonBorder(
        fullPath: navPath,
        startingLocX: desiredPosition,
        navSize: navSize,
        itemsLength: length,
      );

    final span = 1.0 / length;

    Widget current = Transform.translate(
      offset: Offset(0, difference < span ? verticalAlignment * offsetY : 0),
      child: Opacity(
        opacity: difference < span * 0.99 ? opacity : 1.0,
        child: child,
      ),
    );

    final Key buttonKey = ValueKey(splashType);

    switch (splashType) {
      case NavItemSplashType.none:
        current = GestureDetector(
          key: buttonKey,
          behavior: HitTestBehavior.translucent,
          onTap: () => onTap(index),
          child: current,
        );
        break;
      case NavItemSplashType.rectangle:
        current = InkWell(
          key: buttonKey,
          onTap: () => onTap(index),
          radius: splashRadius,
          customBorder: shape,
          child: current,
        );
        break;
      case NavItemSplashType.circle:
        current = Center(
          key: buttonKey,
          child: InkResponse(
            onTap: () => onTap(index),
            containedInkWell: true,
            radius: splashRadius,
            customBorder: shape,
            child: current,
          ),
        );
        break;
    }

    return current;
    // for test custom border
    // return Material(
    //   type: MaterialType.transparency,
    //   shape: shape,
    //   // color: Colors.transparent,
    //   child: current,
    // );
  }
}
