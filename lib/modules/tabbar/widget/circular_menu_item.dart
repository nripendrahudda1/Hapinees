import 'package:flutter/material.dart';

class CircularMenuItem extends StatelessWidget {
  final IconData? icon;
  final Widget? customImage;
  final Color? color;
  final Color? iconColor;
  final VoidCallback onTap;
  final double iconSize;
  final double padding;
  final double margin;
  final List<BoxShadow>? boxShadow;
  final bool enableBadge;
  final double? badgeRightOffet;
  final double? badgeLeftOffet;
  final double? badgeTopOffet;
  final double? badgeBottomOffet;
  final double? badgeRadius;
  final TextStyle? badgeTextStyle;
  final String? badgeLabel;
  final Color? badgeTextColor;
  final Color? badgeColor;
  final AnimatedIcon? animatedIcon;

  const CircularMenuItem({
    super.key,
    required this.onTap,
    this.customImage,
    this.icon,
    this.color,
    this.iconSize = 30,
    this.boxShadow,
    this.iconColor,
    this.animatedIcon,
    this.padding = 10,
    this.margin = 10,
    this.enableBadge = false,
    this.badgeBottomOffet,
    this.badgeLeftOffet,
    this.badgeRightOffet,
    this.badgeTopOffet,
    this.badgeRadius,
    this.badgeTextStyle,
    this.badgeLabel,
    this.badgeTextColor,
    this.badgeColor,
  })  : assert(padding >= 0.0),
        assert(margin >= 0.0);

  Widget _buildCircularMenuItem(BuildContext context) {
    return customImage == null
        ? Container(
            margin: EdgeInsets.all(margin),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: boxShadow ??
                  [
                    BoxShadow(
                      color: color ?? Theme.of(context).primaryColor,
                      blurRadius: 10,
                    ),
                  ],
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Material(
                color: color ?? Theme.of(context).primaryColor,
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: animatedIcon ??
                        Icon(
                          icon,
                          size: iconSize,
                          color: iconColor ?? Colors.white,
                        ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: customImage!,
          );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCircularMenuItem(context);
  }
}
