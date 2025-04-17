import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';

class InvitedCoHostWidget extends StatelessWidget {
  const InvitedCoHostWidget({super.key, required this.coHostName, this.imageUrl, this.phNumber});
  final String coHostName;
  final String? imageUrl;
  final String? phNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedCircularNetworkImageWidget(
          image: imageUrl ?? "",
          size: 36,
          name: coHostName,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coHostName,
              style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (phNumber != null)
              Text(
                phNumber!,
                style: getRobotoMediumStyle(fontSize: MyFonts.size10, color: TAppColors.black),
              ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                  color: TAppColors.white,
                  child: Image.asset(
                    TImageName.notificationBell,
                    width: 16.w,
                    height: 16.h,
                  )),
            ),
            SizedBox(
              width: 10.w,
            ),
            PopupMenuButton<String>(
              onSelected: (String value) {
                print(value);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              elevation: 2,
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'remove_co_host',
                  height: 30.h,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Row(
                    children: [
                      Image.asset(TImageName.deleteOutlineIcon, width: 18.w, height: 18.h),
                      SizedBox(width: 8.w),
                      Text(
                        TButtonLabelStrings.removeCoHostGuest,
                        style: getRegularStyle(color: TAppColors.black, fontSize: MyFonts.size14),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'remove_guest',
                  height: 30.h,
                  padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  child: Row(
                    children: [
                      Image.asset(TImageName.deleteOutlineIcon, width: 18.w, height: 18.h),
                      SizedBox(width: 8.w),
                      Text(
                        TButtonLabelStrings.removeGuest,
                        style: getRegularStyle(color: TAppColors.black, fontSize: MyFonts.size14),
                      ),
                    ],
                  ),
                ),
              ],
              child: Container(
                  color: TAppColors.white,
                  child: Image.asset(
                    TImageName.moreVertIcon,
                    width: 22.w,
                    height: 22.h,
                  )),
            ),
          ],
        )
      ],
    );
  }
}
