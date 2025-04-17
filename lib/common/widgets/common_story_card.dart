import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../modules/profile/User_profile/User_profile.dart';
import '../../modules/profile/model/stories_model.dart';
import '../common_functions/datetime_functions.dart';

class CommonStoryCard extends ConsumerStatefulWidget {
  const CommonStoryCard({
    super.key,
    required this.screenName,
    required this.data,
    required this.index,
    required this.titleFontSize,
    required this.titleTopPadding,
    required this.height,
    required this.isCurrant,
    required this.proFileHeight,
    required this.proFileNameSize,
    required this.proFileDateSize,
    required this.iconSize,
    required this.width,
    required this.onTab,
  });
  final String screenName;
  final Stories data;
  final int index;
  final bool isCurrant;
  final Function()? onTab;
  final double titleTopPadding;
  final double titleFontSize;
  final double height;
  final double iconSize;
  final double proFileHeight;
  final double proFileNameSize;
  final double proFileDateSize;
  final double width;

  @override
  ConsumerState<CommonStoryCard> createState() => StoryCardState();
}

class StoryCardState extends ConsumerState<CommonStoryCard> {
  // Display Name

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.data.storyId.toString(),
      child: SizedBox(
        // height: 0.3.sh,
        child: TBounceAction(
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (widget.data.eventTypeMasterId == 1) {
                Navigator.pushNamed(context, Routes.weddingEventHomePageScreen,
                    arguments: {'weddingId': widget.data.storyId.toString()}).then(
                  (value) {
                    widget.onTab?.call();
                  },
                );
              } else {
                Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                    arguments: {'personalEventId': widget.data.storyId.toString()}).then(
                  (value) {
                    widget.onTab?.call();
                  },
                );
              }
            });
          },
          child: Stack(
            children: [
              TCard(
                height: widget.height, //0.3.sh,
                width: widget.width, //0.42.sw,
                radius: 12,
                child: CachedRectangularNetworkImageWidget(
                  radius: 12,
                  image: widget.data.backgroundImageUrl ?? '',
                  width: 100,
                  height: 0.3.sh,
                ),
              ),
              TCard(
                height: widget.height, //0.3.sh,
                width: widget.width, //0.42.sw,
                radius: 12,
                color: Colors.black45,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: widget.titleTopPadding,
                      left: widget.titleTopPadding > 10 ? 10.w : 7.w,
                      right: widget.titleTopPadding > 10 ? 10.w : 7.w,
                      bottom: 3.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: widget.data.title ?? '',
                              style: GoogleFonts.workSans(
                                letterSpacing: -1,
                                color: TAppColors.white,
                                fontSize: widget.titleFontSize,
                                fontWeight: FontWeightManager.semiBold,
                              ),
                            ),
                            WidgetSpan(
                                child: SizedBox(
                              width: 3.w,
                            )),
                            WidgetSpan(
                              child: Image.asset(
                                // personalEventCtr.homePersonalEventDetailsModel?.visibility == 0
                                //     ? TImageName.privatePngIcon
                                //     : personalEventCtr.homePersonalEventDetailsModel?.visibility == 0
                                //     ? TImageName.publicPngIcon
                                //     :
                                TImageName.guestPngIcon,
                                width: 10.w,
                                height: 12.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            TImageName.icTravel,
                            height: 11.h,
                            width: 11.w,
                            color: widget.isCurrant ? TAppColors.orange : TAppColors.white,
                          ),
                          SizedBox(
                            width: 9.w,
                          ),
                          Flexible(
                            child: TText(
                                timeUntil(widget.data.startDate ?? '') == ''
                                    ? DateFormat('MMM d y')
                                        .format(DateTime.parse(widget.data.startDate ?? ''))
                                    : timeUntil(widget.data.startDate ?? ''),
                                color: widget.isCurrant ? TAppColors.orange : TAppColors.white,
                                latterSpacing: 0,
                                fontSize: 10.sp,
                                fontWeight: FontWeightManager.medium),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 10.h,
                      //   child: ListView.separated(
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemBuilder: (context, index) {
                      //         return CachedRectangularNetworkImageWidget(
                      //             radius: 2,
                      //             image:
                      //                 widget.data.visitiedCountryMasters?[index].countryFlagUrl ??
                      //                     '',
                      //             width: 16.w,
                      //             height: 16.h);
                      //       },
                      //       separatorBuilder: (context, index) {
                      //         return SizedBox(width: 6.w);
                      //       },
                      //       itemCount: widget.data.visitiedCountryMasters?.length ?? 0),
                      // ),
                      const Spacer(),
                      SizedBox(
                        height: widget.proFileHeight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtherUserprofilescreen(
                                              userID: widget.data.createdBy?.userId.toString(),
                                              author: null,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  CachedCircularNetworkImageWidget(
                                      image: widget.data.createdBy?.profileImageUrl ?? '',
                                      size: 30),
                                  (widget.data.guestCount ?? 0) > 0
                                      ? Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[400],
                                            child: TText('+${widget.data.guestCount}',
                                                color: TAppColors.white,
                                                fontSize: MyFonts.size10,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ],
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.data.createdBy?.displayName ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: GoogleFonts.workSans(
                                          color: TAppColors.white,
                                          fontSize: widget.proFileNameSize,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                  ),
                                  // const SizedBox(height: 2),
                                  // TText(formatDateDDMMMyy(widget.data.startDate!),
                                  //     maxLines: 1,
                                  //     fontSize: widget.proFileDateSize,
                                  //     fontWeight: FontWeightManager.semiBold)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            child: Column(
                              children: [
                                Image.asset(
                                  TImageName.calander,
                                  height: widget.iconSize,
                                  color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: TText(widget.data.storyDays.toString(),
                                      fontSize: widget.proFileDateSize,
                                      maxLines: 1,
                                      fontWeight: FontWeightManager.semiBold),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Column(
                              children: [
                                Image.asset(
                                  TImageName.icTravel,
                                  height: widget.iconSize,
                                  color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: TText(widget.data.storyTypeName ?? '',
                                      maxLines: 1,
                                      fontSize: widget.proFileDateSize,
                                      fontWeight: FontWeightManager.semiBold),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Image.asset(
                                  ((widget.data.likedBySelf ?? 'false').toString().toLowerCase() ==
                                          'true')
                                      ? TImageName.likeFill
                                      : TImageName.like,
                                  height: 16.h,
                                  width: 16.h,
                                  // color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: TText(formatNumber(widget.data.storyLikes),
                                      fontSize: widget.proFileDateSize,
                                      maxLines: 1,
                                      fontWeight: FontWeightManager.semiBold),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            child: Column(
                              children: [
                                Image.asset(
                                  TImageName.eye,
                                  height: widget.iconSize,
                                  color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.h),
                                  child: TText(formatNumber(widget.data.storyViews),
                                      fontSize: widget.proFileDateSize,
                                      maxLines: 1,
                                      fontWeight: FontWeightManager.semiBold),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
