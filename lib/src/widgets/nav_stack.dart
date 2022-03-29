import 'package:flutter/material.dart';

class NavStack extends StatelessWidget {
  const NavStack({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: AlignmentDirectional.bottomCenter,
      children: children,
    );
  }
}
