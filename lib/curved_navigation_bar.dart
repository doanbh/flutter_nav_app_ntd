import 'package:flutter/material.dart';

import 'src/nav_button.dart';
import 'src/nav_painter.dart';
import 'src/nav_style_extension.dart';

typedef _LetIndexPage = bool Function(int value);

typedef NavPathBuilder = Path Function(
  double startingLocX,
  Size size,
  int itemsLength,
  TextDirection textDirection,
);

enum NavStyle {
  planetGravity,
  mould,
}

enum NavItemSplashType {
  none,
  rectangle,
  circle,
}

const NavStyle _defaultNavStyle = NavStyle.planetGravity;

bool _defaultLetIndexChange(int index) => false;

class CurvedNavigationBar extends StatefulWidget {
  const CurvedNavigationBar({
    Key? key,
    this.customNavPathBuilder,
    this.navStyle,
    required this.items,
    this.index = 0,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.buttonPadding = const EdgeInsets.all(8.0),
    this.buttonOffsetY = 55,
    this.itemSplashType = NavItemSplashType.none,
    this.itemSplashRadius,
    this.backgroundColor = Colors.transparent,
    this.shaderCallback,
    this.blendMode = BlendMode.modulate,
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
  })  : letSameIndexChange = letIndexChange ?? _defaultLetIndexChange,
        assert(items.length >= 1),
        assert(0 <= index && index < items.length),
        super(key: key);

  /// Custom your own nav style
  final NavPathBuilder? customNavPathBuilder;

  /// Default: `NavStyle.planetGravity`
  final NavStyle? navStyle;

  /// List of Widgets
  final List<Widget> items;

  /// Index of NavigationBar, can be used to change current index or to set initial index
  final int index;

  /// Color of NavigationBar
  ///
  /// Default: `Colors.white`
  final Color color;

  /// Color of NavigationBar's background,
  ///
  /// Default: `Colors.transparent`
  final Color backgroundColor;

  /// Background color of floating button
  ///
  /// Default: `same as color attribute`
  final Color? buttonBackgroundColor;

  final double buttonOffsetY;

  final EdgeInsetsGeometry buttonPadding;

  final NavItemSplashType itemSplashType;

  /// Only apply to `NavItemSplashType.circle`
  final double? itemSplashRadius;

  /// Called to create the [dart:ui.Shader] that generates the mask.
  ///
  /// The shader callback is called with the current size of the child so that
  /// it can customize the shader to the size and location of the child.
  ///
  /// Typically this will use a [LinearGradient], [RadialGradient], or
  /// [SweepGradient] to create the [dart:ui.Shader], though the
  /// [dart:ui.ImageShader] class could also be used.
  final Shader Function(Rect)? shaderCallback;

  /// The [BlendMode] to use when applying the shader to the child.
  ///
  /// The default, [BlendMode.modulate], is useful for applying an alpha blend
  /// to the child. Other blend modes can be used to create other effects.
  final BlendMode blendMode;

  /// Function handling taps on items
  final ValueChanged<int>? onTap;

  /// Function which takes page index as argument and returns bool.
  /// If function returns false then current page is not changed on button tap.
  /// It returns false by default
  final _LetIndexPage letSameIndexChange;

  /// Curves interpolating button change animation
  ///
  /// Default `Curves.easeOut`
  final Curve animationCurve;

  /// Duration of button change animation
  ///
  /// Default: `Duration(milliseconds: 600)`
  final Duration animationDuration;

  /// Height of NavigationBar, min 0.0, max 75.0
  final double height;

  @override
  CurvedNavigationBarState createState() => CurvedNavigationBarState();
}

class CurvedNavigationBarState extends State<CurvedNavigationBar>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  int _endingIndex = 0;
  late double _pos;
  double _buttonHide = 0;
  late Widget _icon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _icon = widget.items[widget.index];
    _length = widget.items.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = widget.items[_endingIndex];
        }
        _buttonHide =
            (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Size navSize = Size(size.width, widget.height);
    final Path navPath = widget.customNavPathBuilder
            ?.call(_pos, navSize, _length, Directionality.of(context)) ??
        widget.navStyle
            ?.pathBuilder(_pos, navSize, _length, Directionality.of(context)) ??
        _defaultNavStyle.pathBuilder(
            _pos, navSize, _length, Directionality.of(context));

    final Widget navBar = CustomPaint(
      size: navSize,
      painter: NavPainter(navPath, widget.color),
    );

    final Widget icons = Row(
      children: widget.items
          .map(
            (item) => Expanded(
              child: NavButton(
                onTap: _buttonTap,
                navPath: navPath,
                navSize: navSize,
                position: _pos,
                length: _length,
                index: widget.items.indexOf(item),
                offsetY: widget.height * 2,
                splashType: widget.itemSplashType,
                splashRadius: widget.itemSplashRadius,
                child: Center(child: item),
              ),
            ),
          )
          .toList(),
    );

    final Widget current;

    if (widget.shaderCallback == null) {
      current = SizedBox.fromSize(
        size: navSize,
        child: _buildStack(
          [
            _buidSelectedIconContainer(MaterialType.circle, size),
            navBar,
            icons,
          ],
        ),
      );
    } else {
      current = SizedBox(
        width: navSize.width,
        height: navSize.height + widget.buttonPadding.vertical,
        child: _buildStack(
          [
            _buildShaderMask(
              _buildStack([
                _buidSelectedIconContainer(MaterialType.circle, size),
              ]),
            ),
            _buidSelectedIconContainer(MaterialType.transparency, size),
            _buildShaderMask(
              SizedBox(
                height: navSize.height,
                child: navBar,
              ),
            ),
            SizedBox(
              height: navSize.height,
              child: Material(
                type: MaterialType.transparency,
                child: icons,
              ),
            ),
          ],
        ),
      );
    }

    return ColoredBox(
      color: widget.backgroundColor,
      child: current,
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (index == _endingIndex && !widget.letSameIndexChange(index)) return;

    if (widget.onTap != null) widget.onTap!(index);

    final newPosition = index / _length;

    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }

  Widget _buildStack(List<Widget> children) => Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.bottomCenter,
        children: children,
      );

  Widget _buildShaderMask(Widget child) => ShaderMask(
        blendMode: widget.blendMode,
        shaderCallback: widget.shaderCallback!,
        child: child,
      );

  Widget _buildSelectedIcon(MaterialType type) {
    final icon = Padding(
      key: ValueKey(_pos),
      padding: widget.buttonPadding,
      child: _icon,
    );

    if (type == MaterialType.transparency) return icon;

    return Material(
      type: type,
      color: widget.buttonBackgroundColor ?? widget.color,
      child: icon,
    );
  }

  Widget _buidSelectedIconContainer(MaterialType type, Size parentSize) =>
      Positioned(
        bottom: -widget.buttonOffsetY * 1.4,
        left: Directionality.of(context) == TextDirection.rtl
            ? null
            : _pos * parentSize.width,
        right: Directionality.of(context) == TextDirection.rtl
            ? _pos * parentSize.width
            : null,
        width: parentSize.width / _length,
        child: Transform.translate(
          offset: Offset(
            0,
            -(1 - _buttonHide) * widget.buttonOffsetY * 2,
          ),
          child: _buildSelectedIcon(type),
        ),
      );
}
