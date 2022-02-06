import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_navigation_bar/src/nav_path.dart';

extension NavStyleExtension on NavStyle {
  NavPathBuilder get pathBuilder {
    switch (this) {
      case NavStyle.planetGravity:
        return NavPath.planetGravity;
      case NavStyle.globePedestal:
        return NavPath.globePedestal;
      // case NavStyle.mould:
      //   return NavPath.mould;
    }
  }
}
