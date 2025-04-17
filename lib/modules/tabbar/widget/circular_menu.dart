import 'dart:math' as math;
import 'package:Happinest/common/common_imports/common_imports.dart';

class CircularMenu extends StatefulWidget {
  @override
  final GlobalKey<CircularMenuState>? key;
  final AlignmentGeometry alignment;
  final double radius;
  final Widget? backgroundWidget;
  final Duration animationDuration;
  final Curve curve;
  final Curve reverseCurve;
  final Function(AnimationController animationController)?
      toggleButtonOnPressed;
  final List<Widget> listOfItmes;
  final Color? toggleButtonColor;
  final double toggleButtonSize;
  final List<BoxShadow>? toggleButtonBoxShadow;
  final double toggleButtonPadding;
  final double toggleButtonMargin;
  final Color? toggleButtonIconColor;
  final AnimatedIconData toggleButtonAnimatedIconData;
  final double? startingAngleInRadian;
  final double? endingAngleInRadian;
  final Widget mainWidget;

  const CircularMenu(
      {this.alignment = Alignment.bottomCenter,
      this.radius = 100,
      this.backgroundWidget,
      this.animationDuration = const Duration(milliseconds: 500),
      this.curve = Curves.bounceOut,
      this.reverseCurve = Curves.fastOutSlowIn,
      this.toggleButtonOnPressed,
      required this.listOfItmes,
      this.toggleButtonColor,
      this.toggleButtonBoxShadow,
      this.toggleButtonMargin = 10,
      this.toggleButtonPadding = 10,
      this.toggleButtonSize = 40,
      this.toggleButtonIconColor,
      this.toggleButtonAnimatedIconData = AnimatedIcons.menu_close,
      this.key,
      this.startingAngleInRadian,
      this.endingAngleInRadian,
      required this.mainWidget})
      : super(key: key);

  @override
  CircularMenuState createState() => CircularMenuState();
}

class CircularMenuState extends State<CircularMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double? _completeAngle;
  late double _initialAngle;
  double? _endAngle;
  double? _startAngle;
  late Animation<double> _animation;

  /// forward animation
  void forwardAnimation() {
    _animationController.forward();
  }

  /// reverse animation
  void reverseAnimation() {
    _animationController.reverse();
  }

  @override
  void initState() {
    _configure();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(() {
        setState(() {});
      });
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController,
          curve: widget.curve,
          reverseCurve: widget.reverseCurve),
    );
    super.initState();
  }

  void _configure() {
    if (widget.startingAngleInRadian != null ||
        widget.endingAngleInRadian != null) {
      if (widget.startingAngleInRadian == null) {
        throw ('startingAngleInRadian can not be null');
      }
      if (widget.endingAngleInRadian == null) {
        throw ('endingAngleInRadian can not be null');
      }

      if (widget.startingAngleInRadian! < 0) {
        throw 'startingAngleInRadian has to be in clockwise radian';
      }
      if (widget.endingAngleInRadian! < 0) {
        throw 'endingAngleInRadian has to be in clockwise radian';
      }
      _startAngle = (widget.startingAngleInRadian! / math.pi) % 2;
      _endAngle = (widget.endingAngleInRadian! / math.pi) % 2;
      if (_endAngle! < _startAngle!) {
        throw 'startingAngleInRadian can not be greater than endingAngleInRadian';
      }
      _completeAngle = _startAngle == _endAngle
          ? 2 * math.pi
          : (_endAngle! - _startAngle!) * math.pi;
      _initialAngle = _startAngle! * math.pi;
    } else {
      switch (widget.alignment.toString()) {
        case 'Alignment.bottomCenter':
          _completeAngle = 1 * math.pi;
          _initialAngle = 1 * math.pi;
          break;
        case 'Alignment.topCenter':
          _completeAngle = 1 * math.pi;
          _initialAngle = 0 * math.pi;
          break;
        case 'Alignment.centerLeft':
          _completeAngle = 1 * math.pi;
          _initialAngle = 1.5 * math.pi;
          break;
        case 'Alignment.centerRight':
          _completeAngle = 1 * math.pi;
          _initialAngle = 0.5 * math.pi;
          break;
        case 'Alignment.center':
          _completeAngle = 2 * math.pi;
          _initialAngle = 0 * math.pi;
          break;
        case 'Alignment.bottomRight':
          _completeAngle = 0.5 * math.pi;
          _initialAngle = 1 * math.pi;
          break;
        case 'Alignment.bottomLeft':
          _completeAngle = 0.5 * math.pi;
          _initialAngle = 1.5 * math.pi;
          break;
        case 'Alignment.topLeft':
          _completeAngle = 0.5 * math.pi;
          _initialAngle = 0 * math.pi;
          break;
        case 'Alignment.topRight':
          _completeAngle = 0.5 * math.pi;
          _initialAngle = 0.5 * math.pi;
          break;
        default:
          throw 'startingAngleInRadian and endingAngleInRadian can not be null';
      }
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    _configure();
    super.didUpdateWidget(oldWidget);
  }

  List<Widget> _buildMenuItems() {
    List<Widget> items = [];
    widget.listOfItmes.asMap().forEach((index, item) {
      items.add(
        Positioned.fill(
          child: Align(
            alignment: widget.alignment,
            child: Transform.translate(
              offset: Offset.fromDirection(
                  _completeAngle == (2 * math.pi)
                      ? (_initialAngle +
                          (_completeAngle! / (widget.listOfItmes.length)) *
                              index)
                      : (_initialAngle +
                          (_completeAngle! / (widget.listOfItmes.length - 1)) *
                              index),
                  _animation.value * widget.radius),
              child: Transform.scale(
                scale: _animation.value,
                child: Transform.rotate(
                  angle: _animation.value * (math.pi * 2),
                  child: item,
                ),
              ),
            ),
          ),
        ),
      );
    });
    return items;
  }

  Widget _buildMenuButton(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: widget.alignment,
        child: InkWell(
          onTap: () {
            _animationController.status == AnimationStatus.dismissed
                ? (_animationController).forward()
                : (_animationController).reverse();
            if (widget.toggleButtonOnPressed != null) {
              widget.toggleButtonOnPressed!(_animationController);
            }
          },
          child: widget.mainWidget,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.backgroundWidget ?? Container(),
        ..._buildMenuItems(),
        _buildMenuButton(context),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
