import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class EventTCard extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final Color? color;
  final Color? borderColor;
  final bool? border;
  final bool? shadowPadding;
  final bool? shadow;
  final double? borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final DecorationImage? image;
  final Gradient? gradient;
  final BoxShape? shape;
  final Color? shadowColor;
  final double? blurRadius;
  final double? radius;

  const EventTCard({
    super.key,
    this.child, this.height, this.width, this.color, this.borderColor, this.border, this.shadowPadding, this.shadow, this.borderWidth, this.borderRadius, this.image, this.gradient, this.shape, this.shadowColor, this.blurRadius, this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: shadowPadding == true
            ? const EdgeInsets.all(4)
            : const EdgeInsets.all(0),
        child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
                gradient: gradient,
                image: image,
                shape: shape ?? BoxShape.rectangle,
                border: border == true
                    ? Border.all(
                    color: borderColor ?? TAppColors.lightBorderColor,
                    width: borderWidth ?? 1)
                    : null,
                borderRadius: borderRadius ??
                    (shape != null ? null : BorderRadius.circular(radius ?? 10)),
                color: color ?? Colors.transparent,
                boxShadow: [
                  BoxShadow(
                    color: (shadow ?? false)
                        ? shadowColor ?? Colors.grey.withOpacity(0.3)
                        : Colors.transparent,
                    spreadRadius: 0.5,
                    blurRadius: blurRadius ?? 1,
                  )
                ]),
            child: child),
      ),
    );
  }

}
