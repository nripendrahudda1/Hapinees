import 'package:shimmer/shimmer.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';

class EventShimmer extends StatelessWidget {
  final Duration duration;
  final Color? baseColor;
  final double width;
  final double height;
  final Color? highlightColor;

  const EventShimmer({super.key, 
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.width = double.infinity,
    this.height = double.infinity,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 420.w,
            height: 120.h,
            child: ListView(
              padding: EdgeInsets.only(bottom: 20.h),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20.w),
                  child: Shimmer.fromColors(
                    baseColor: baseColor ?? TAppColors.selectionColor.withOpacity(0.1),
                    highlightColor: highlightColor ?? TAppColors.textFieldColor.withOpacity(0.1),
                    period: duration,
                    child: Container(
                      height: 100.h,
                      width: 96.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20.w),
                  child: Shimmer.fromColors(
                    baseColor: baseColor ?? TAppColors.selectionColor.withOpacity(0.1),
                    highlightColor: highlightColor ?? TAppColors.textFieldColor.withOpacity(0.1),
                    period: duration,
                    child: Container(
                      height: 100.h,
                      width: 96.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20.w),
                  child: Shimmer.fromColors(
                    baseColor: baseColor ?? TAppColors.selectionColor.withOpacity(0.1),
                    highlightColor: highlightColor ?? TAppColors.textFieldColor.withOpacity(0.1),
                    period: duration,
                    child: Container(
                      height: 100.h,
                      width: 96.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
