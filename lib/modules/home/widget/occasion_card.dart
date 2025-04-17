import 'dart:ffi';

import 'package:Happinest/location/location_client.dart';
import 'package:Happinest/theme/styles_manager.dart';
import 'package:Happinest/utility/constants/strings/button_label_strings.dart';
import 'package:Happinest/utility/constants/strings/message_strings.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:Happinest/utility/preferenceutils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Happinest/modules/home/Models/occasion_home_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../common/common_functions/datetime_functions.dart';
import '../../../common/widgets/app_bounce.dart';
import '../../../common/widgets/app_card.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/cached_circular_network_image.dart';
import '../../../common/widgets/cached_retangular_network_image.dart';
import '../../../routes/app_router.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_manager.dart';
import '../../../utility/constants/images/image_name.dart';
import '../../../utility/utility.dart';
import '../../profile/User_profile/User_profile.dart';

class OccasionCard extends StatefulWidget {
  const OccasionCard(
      {super.key, required this.occasionData, required this.index, required this.onTab});
  final TrendingOccasions occasionData;
  final int index;
  final Function() onTab;
  @override
  State<OccasionCard> createState() => _OccasionCardState();
}

class _OccasionCardState extends State<OccasionCard> {
  int? loginUserID = getUserID();
  void showAlertMessage(BuildContext context, WidgetRef ref) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              bodyText: TMessageStrings.privateEventMessage,
              onActionPressed: () {
                // Navigator.pop(context);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Hero(
          tag: widget.occasionData.occasionId.toString(),
          child: TBounceAction(
            onPressed: () async {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (widget.occasionData.eventTypeMasterId.toString() == '1') {
                  Navigator.pushNamed(context, Routes.weddingEventHomePageScreen, arguments: {
                    'weddingId': widget.occasionData.occasionId.toString() ?? '',
                  }).then((value) {
                    widget.onTab.call();
                  });
                } else {
                  if (loginUserID != widget.occasionData.createdBy?.userId) {
                    if (widget.occasionData.isVisible == true &&
                        widget.occasionData.isVisible != null) {
                      Navigator.pushNamed(context, Routes.personalEventHomePageScreen, arguments: {
                        'personalEventId': widget.occasionData.occasionId.toString()
                      }).then((value) {
                        widget.onTab.call();
                      });
                    } else {
                      if (widget.occasionData.isVisible == null) {
                        Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                            arguments: {
                              'personalEventId': widget.occasionData.occasionId.toString()
                            }).then((value) {
                          widget.onTab.call();
                        });
                      } else {
                        showAlertMessage(context, ref);
                      }
                    }
                  } else {
                    Navigator.pushNamed(context, Routes.personalEventHomePageScreen, arguments: {
                      'personalEventId': widget.occasionData.occasionId.toString()
                    }).then((value) {
                      widget.onTab.call();
                    });
                  }
                }
              });
            },
            child: Stack(
              children: [
                TCard(
                  radius: 12,
                  child: CachedRectangularNetworkImageWidget(
                      radius: 12,
                      image: widget.occasionData.backgroundImageUrl ??
                          '', //widget.occasionData.eventTypeMasterId.toString() == '1' ? widget.occasionData.backgroundImageUrl ?? '' : widget.occasionData.backgroundImageUrl != null ? widget.occasionData.backgroundImageUrl.toString().replaceAll('WeddingDocuments', 'PersonalEventDocuments') : '',
                      width: double.maxFinite,
                      height: double.maxFinite),
                ),
                TCard(
                  radius: 12,
                  color: Colors.black45,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w, bottom: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          TextSpan(
                            children: <InlineSpan>[
                              TextSpan(
                                text: widget.occasionData.title ?? '',
                                style: GoogleFonts.workSans(
                                  color: TAppColors.white,
                                  fontSize: MyFonts.size20,
                                  fontWeight: FontWeightManager.bold,
                                ),
                              ),
                              WidgetSpan(
                                  child: SizedBox(
                                width: 3.w,
                              )),
                              WidgetSpan(
                                  child: Image.asset(
                                widget.occasionData.visibility == 2
                                    ? TImageName.privatePngIcon
                                    : widget.occasionData.visibility == 1
                                        ? TImageName.publicPngIcon
                                        : TImageName.guestPngIcon,
                                width: 12.w,
                                height: 12.w,
                                color: TAppColors.white,
                              )
                                  // Image.asset(

                                  //   // personalEventCtr.homePersonalEventDetailsModel?.visibility == 0
                                  //   //     ? TImageName.privatePngIcon
                                  //   //     : personalEventCtr.homePersonalEventDetailsModel?.visibility == 0
                                  //   //     ? TImageName.publicPngIcon
                                  //   //     :
                                  //   TImageName.guestPngIcon,
                                  //   width: 12.w,
                                  //   height: 14.h,
                                  // ),
                                  ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              TImageName.calenderPngIcon,
                              height: 15.h,
                              width: 15.w,
                              color: TAppColors.white,
                            ),
                            SizedBox(
                              width: 9.w,
                            ),
                            Flexible(
                              child: TText(
                                  getCommentTimeAgo(DateTime.parse(
                                              widget.occasionData.startDateTime.toString())) ==
                                          ''
                                      ? DateFormat('MMM d y').format(
                                          DateTime.parse(widget.occasionData.startDateTime ?? ''))
                                      : getCommentTimeAgo(DateTime.parse(
                                          widget.occasionData.startDateTime.toString())),
                                  color: TAppColors.white,
                                  latterSpacing: 0,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeightManager.medium),
                            )
                          ],
                        ),
                        // if (widget.occasionData.countryFlag != null)
                        //   SizedBox(
                        //       height: 16.h,
                        //       child: CachedRectangularNetworkImageWidget(
                        //           radius: 2,
                        //           image: widget.occasionData.countryFlag ?? '',
                        //           width: 16.w,
                        //           height: 16.h)),
                        const Spacer(),
                        SizedBox(
                          height: 30.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OtherUserprofilescreen(
                                                userID: widget.occasionData.createdBy?.userId
                                                    .toString(),
                                                author: null,
                                              )));
                                },
                                child: Row(
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none, // Allows the avatars to overlap
                                      children: [
                                        (widget.occasionData.createdBy?.profileImageUrl ?? '') ==
                                                    TPParameters.defaultUserProfile ||
                                                !(widget.occasionData.createdBy?.profileImageUrl
                                                        ?.isNotEmpty ??
                                                    false)
                                            ? CircleAvatar(
                                                radius: 17.r,
                                                backgroundColor: Colors.grey[400],
                                                child: Text(
                                                  getDisplayName(
                                                      0,
                                                      widget.occasionData.createdBy?.displayName ??
                                                          ""),
                                                  style: getMediumStyle(
                                                    fontSize: MyFonts.size12,
                                                    color: TAppColors.white,
                                                  ),
                                                ),
                                              )
                                            : CachedCircularNetworkImageWidget(
                                                image: widget
                                                        .occasionData.createdBy?.profileImageUrl ??
                                                    '',
                                                size: 34, // Adjust size as needed
                                              ),
                                        if ((widget.occasionData.guestCount ?? 0) > 0)
                                          Positioned(
                                            left:
                                                30, // Moves the co-host avatar slightly left to overlap
                                            child: CircleAvatar(
                                              radius: 15.r,
                                              backgroundColor: Colors.grey[400],
                                              child: TText(
                                                '+${widget.occasionData.guestCount}',
                                                color: TAppColors.white,
                                                fontSize:
                                                    MyFonts.size12, // Slightly smaller to fit well
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),

                                    // CachedCircularNetworkImageWidget(
                                    //     image: widget.occasionData.createdBy?.profileImageUrl ?? '',
                                    //     size: 30),
                                    // (widget.occasionData.coHosts ?? 0) > 0
                                    //     ? Padding(
                                    //         padding: const EdgeInsets.only(left: 20),
                                    //         child: CircleAvatar(
                                    //           backgroundColor: Colors.grey[400],
                                    //           child: TText('+${widget.occasionData.coHosts}',
                                    //               color: TAppColors.white,
                                    //               fontSize: MyFonts.size14,
                                    //               fontWeight: FontWeight.w600),
                                    //         ),
                                    //       )
                                    //     : const SizedBox.shrink()
                                  ],
                                ),
                              ),
                              SizedBox(width: (widget.occasionData.guestCount ?? 0) > 0 ? 30.w : 6.w),
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: TText(widget.occasionData.createdBy?.displayName ?? '',
                                          maxLines: 1,
                                          minFontSize: 12,
                                          fontSize: MyFonts.size14,
                                          overflow: TextOverflow.ellipsis,
                                          fontWeight: FontWeightManager.bold),
                                    ),
                                    // const SizedBox(height: 2),
                                    // TText(formatDateDDMMMyy(widget.occasionData.createdOn),
                                    //     fontSize: MyFonts.size10,
                                    //     fontWeight: FontWeightManager.semiBold)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Column(
                                children: [
                                  CachedRectangularNetworkImageWidget(
                                      image: widget.occasionData.eventTypeMasterIcon ?? '',
                                      width: 16.h,
                                      height: 16.h),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    child: TText(widget.occasionData.eventTypeName ?? '',
                                        maxLines: 1,
                                        fontSize: MyFonts.size12,
                                        fontWeight: FontWeightManager.semiBold),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                children: [
                                  Image.asset(
                                    (widget.occasionData.likedBySelf.toString().toLowerCase() ==
                                            'true')
                                        ? TImageName.likeFill
                                        : TImageName.like,
                                    height: 16.h,
                                    width: 16.h,
                                    // color: TAppColors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    child: TText(formatNumber(widget.occasionData.occasionLikes),
                                        fontSize: MyFonts.size12,
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
                                    height: 16.h,
                                    color: TAppColors.white,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    child: TText(formatNumber(widget.occasionData.occasionViews),
                                        fontSize: MyFonts.size12,
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
        );
      },
    );
  }
}
