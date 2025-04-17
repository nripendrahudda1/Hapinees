import '../../../../common/common_imports/common_imports.dart';

class VenueCard extends StatelessWidget {
  final String venue;

  const VenueCard({
    required this.venue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.h),
      child: Center(
        child: Container(
            height: 100.h,
            width: 330.w,
            padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: TAppColors.venueCardColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ImageIcon(
                  const AssetImage(
                    TImageName.venueLocationIcon,
                  ),
                  color: TAppColors.venueCardTextColor,
                  size: 24.h,
                ),
                SizedBox(width: 10.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Venue',
                      style: getRegularStyle(
                          color: TAppColors.venueCardTextColor,
                          fontSize: MyFonts.size14),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    SizedBox(
                      width: 260.w,
                      child: Text(
                        venue,
                        overflow: TextOverflow.ellipsis,
                        style: getBoldStyle(
                            color: TAppColors.venueCardTextColor,
                            fontSize: MyFonts.size14),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
