
import 'package:intl/intl.dart';

import '../../../../common/common_imports/common_imports.dart';

class ScheduleWidget extends StatelessWidget {
  const ScheduleWidget({
    super.key, required this.eventName, required this.dateTime, required this.venue, this.isLast=false,
  });
  final String eventName;
  final DateTime dateTime;
  final String venue;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            ImageIcon(
              const AssetImage(
                TImageName.calenderOutlinePngIcon,
              ),
              size: 24.h,
            ),
            SizedBox(height: 3.h,),
            if(!isLast)
              Container(
                width: 1.w,
                height: 70.h,
                color: TAppColors.appColor,
              )
          ],
        ),
        SizedBox(width: 12.w,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventName,
                style: getRegularStyle(
                    color: TAppColors.selectionColor, fontSize: MyFonts.size16),
              ),
              SizedBox(height: 6.h,),
              Text(
                DateFormat('MMM d y - hh:mm a').format(dateTime),
                style: getRobotoMediumStyle(
                    color: TAppColors.venueCardTextColor, fontSize: MyFonts.size16),
              ),
              SizedBox(height: 6.h,),
              Text(
                venue,
                style: getRegularStyle(
                    color: TAppColors.venueCardTextColor, fontSize: MyFonts.size14),softWrap: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
