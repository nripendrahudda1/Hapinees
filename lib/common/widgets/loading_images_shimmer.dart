import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Happinest/theme/app_colors.dart';

class ShimmerWidget extends StatelessWidget {
  final Duration duration;
  final Color? baseColor;
  final double width;
  final double height;
  final Color? highlightColor;
  final double border;

  const ShimmerWidget({
    super.key,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.width = double.infinity,
    this.height = double.infinity,
    this.highlightColor,
    this.border = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? TAppColors.black.withOpacity(1),
      highlightColor: highlightColor ?? TAppColors.davyGrey.withOpacity(0.9),
      period: duration,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: TAppColors.davyGrey.withOpacity(0.8),
          borderRadius: BorderRadius.circular(border),
        ),
      ),
    );
  }
}
