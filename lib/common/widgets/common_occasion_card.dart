import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/location/location_client.dart';
import 'package:Happinest/theme/styles_manager.dart';
import 'package:Happinest/utility/constants/strings/button_label_strings.dart';
import 'package:Happinest/utility/constants/strings/message_strings.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:Happinest/utility/preferenceutils.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
import '../../modules/profile/User_profile/User_profile.dart';
import '../../modules/profile/model/stories_model.dart';

class CommonOccasionCard extends ConsumerStatefulWidget {
  const CommonOccasionCard(
      {super.key,
      required this.screenName,
      required this.isCurrant,
      required this.data,
      required this.index,
      required this.height,
      required this.width,
      required this.iconSize,
      required this.proFileHeight,
      required this.proFileNameSize,
      required this.proFileDateSize,
      required this.titleFontSize,
      required this.titleTopPadding,
      required this.onTab});
  final String screenName;
  final Stories data;
  final Function(int)? onTab;
  final bool isCurrant;
  final int index;
  final double height;
  final double width;
  final double iconSize;
  final double proFileHeight;
  final double proFileNameSize;
  final double proFileDateSize;
  final double titleTopPadding;
  final double titleFontSize;
  @override
  ConsumerState<CommonOccasionCard> createState() => _OccasionCardState();
}

class _OccasionCardState extends ConsumerState<CommonOccasionCard> {
  int? loginUserID = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));
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
    return Hero(
      tag: "${widget.data.storyId.toString()}_${widget.screenName}",
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return SizedBox(
            height: widget.height,
            width: widget.width,
            child: TBounceAction(
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  // if (widget.data.eventTypeMasterId == 1) {
                  //   Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                  //       arguments: {'personalEventId': widget.data.storyId.toString()}).then(
                  //     (value) {
                  //       if (value is int) {
                  //         widget.onTab?.call(value); // Ensure `onTab` is not null before calling
                  //       }
                  //     },
                  //   );
                  // } else {
                  if (loginUserID != widget.data.createdBy?.userId) {
                    if (widget.data.isVisible == true && widget.data.isVisible != null) {
                      Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                          arguments: {'personalEventId': widget.data.storyId.toString()}).then(
                        (value) {
                          if (value is int) {
                            widget.onTab?.call(value); // Ensure `onTab` is not null before calling
                          }
                        },
                      );
                    } else {
                      if (widget.data.isVisible == null) {
                        Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                            arguments: {'personalEventId': widget.data.storyId.toString()}).then(
                          (value) {
                            if (value is int) {
                              widget.onTab
                                  ?.call(value); // Ensure `onTab` is not null before calling
                            }
                          },
                        );
                      } else {
                        showAlertMessage(context, ref);
                      }
                    }
                  } else {
                    Navigator.pushNamed(context, Routes.personalEventHomePageScreen,
                        arguments: {'personalEventId': widget.data.storyId.toString()}).then(
                      (value) {
                        if (value is int) {
                          widget.onTab?.call(value); // Ensure `onTab` is not null before calling
                        }
                      },
                    );
                  }
                  // }
                });
              },
              child: Stack(
                children: [
                  TCard(
                    radius: 12,
                    child: CachedRectangularNetworkImageWidget(
                        fit: BoxFit.cover,
                        radius: 12,
                        image: widget.data.backgroundImageUrl ?? '',
                        width: 0.42.sw,
                        height: 0.25.sh),
                  ),
                  TCard(
                    height: widget.height,
                    width: widget.width,
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
                                    color: TAppColors.white,
                                    fontSize: widget.titleFontSize,
                                    fontWeight: FontWeightManager.bold,
                                  ),
                                ),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 2.w,
                                )),
                                WidgetSpan(
                                    child: Image.asset(
                                  widget.data.visibility == 2
                                      ? TImageName.privatePngIcon
                                      : widget.data.visibility == 1
                                          ? TImageName.publicPngIcon
                                          : TImageName.guestPngIcon,
                                  width: 12.w,
                                  height: 12.w,
                                  color: TAppColors.white,
                                )),
                              ],
                            ),
                          ),
                          // Text.rich(
                          //   TextSpan(
                          //     children: <InlineSpan>[
                          //       TextSpan(
                          //         text: widget.data.title ?? '',
                          //         style: GoogleFonts.workSans(
                          //           color: TAppColors.white,
                          //           fontSize: widget.titleFontSize,
                          //           fontWeight: FontWeightManager.bold,
                          //         ),
                          //       ),
                          //       WidgetSpan(
                          //         alignment: PlaceholderAlignment.baseline,
                          //         baseline: TextBaseline.alphabetic, // Align with text
                          //         child: SizedBox(width: 2.w), // Space between text and icon
                          //       ),
                          //       WidgetSpan(
                          //         alignment: PlaceholderAlignment.baseline,
                          //         baseline: TextBaseline.alphabetic, // Align with text
                          //         child: Image.asset(
                          //           widget.data.visibility == 2
                          //               ? TImageName.privatePngIcon
                          //               : widget.data.visibility == 1
                          //                   ? TImageName.publicPngIcon
                          //                   : TImageName.guestPngIcon,
                          //           width: 12.w,
                          //           height: 12.w,
                          //           color: TAppColors.white,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          Row(
                            children: [
                              Image.asset(
                                TImageName.calenderPngIcon,
                                height: 12.h,
                                width: 12.w,
                                color: widget.isCurrant ? TAppColors.orange : TAppColors.white,
                              ),
                              SizedBox(
                                width: 9.w,
                              ),
                              Flexible(
                                child: TText(
                                    getCommentTimeAgo(
                                                DateTime.parse(widget.data.startDate.toString())) ==
                                            ''
                                        ? DateFormat('MMM d y')
                                            .format(DateTime.parse(widget.data.startDate ?? ''))
                                        : getCommentTimeAgo(
                                            DateTime.parse(widget.data.startDate.toString())),
                                    color: widget.isCurrant ? TAppColors.orange : TAppColors.white,
                                    latterSpacing: 0,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeightManager.medium),
                              )
                            ],
                          ),
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
                                  child: Row(
                                    children: [
                                      Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          (widget.data.createdBy?.profileImageUrl ?? '') ==
                                                      TPParameters.defaultUserProfile ||
                                                  !(widget.data.createdBy?.profileImageUrl
                                                          ?.isNotEmpty ??
                                                      false)
                                              ? CircleAvatar(
                                                  radius: 17.r,
                                                  backgroundColor: Colors.grey[400],
                                                  child: Text(
                                                    getDisplayName(0,
                                                        widget.data.createdBy?.displayName ?? ""),
                                                    style: getMediumStyle(
                                                      fontSize: MyFonts.size12,
                                                      color: TAppColors.white,
                                                    ),
                                                  ),
                                                )
                                              : CachedCircularNetworkImageWidget(
                                                  image:
                                                      widget.data.createdBy?.profileImageUrl ?? '',
                                                  size: 30,
                                                ),
                                          if ((widget.data.guestCount ?? 0) > 0)
                                            Positioned(
                                              left: 30,
                                              child: CircleAvatar(
                                                radius: 15.r,
                                                backgroundColor: Colors.grey[400],
                                                child: TText(
                                                  '+${widget.data.guestCount}',
                                                  color: TAppColors.white,
                                                  fontSize: MyFonts.size14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      // CachedCircularNetworkImageWidget(

                                      //     image: ((widget.data.createdBy?.profileImageUrl ?? '') ==
                                      //                 TPParameters.defaultUserProfile ||
                                      //             (widget.data.createdBy?.profileImageUrl
                                      //                     ?.isNotEmpty ??
                                      //                 false))
                                      //         ? getDisplayName(
                                      //             0, widget.data.createdBy?.displayName ?? "")
                                      //         : widget.data.createdBy?.profileImageUrl ?? '',
                                      //     size: 30),
                                      // (widget.data.storyCoAuthor ?? 0) > 0
                                      //     ? Padding(
                                      //         padding: const EdgeInsets.only(left: 20),
                                      //         child: CircleAvatar(
                                      //           backgroundColor: Colors.grey[400],
                                      //           child: TText('+${widget.data.storyCoAuthor}',
                                      //               color: TAppColors.white,
                                      //               fontSize: MyFonts.size14,
                                      //               fontWeight: FontWeight.w600),
                                      //         ),
                                      //       )
                                      //     : const SizedBox.shrink()
                                    ],
                                  ),
                                ), //
                                SizedBox(width: (widget.data.guestCount ?? 0) > 0 ? 30.w : 6.w),
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
                                      // TText(formatDateDDMMMyy(widget.data.startDate),
                                      //     maxLines: 1,
                                      //     fontSize: widget.proFileDateSize,
                                      //     fontWeight: FontWeightManager.semiBold)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  children: [
                                    CachedRectangularNetworkImageWidget(
                                        image: widget.data.eventTypeMasterIcon ?? '',
                                        width: widget.iconSize,
                                        // fit: BoxFit.fill,
                                        height: widget.iconSize),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 3.h),
                                      child: TText(widget.data.eventTypeName ?? '',
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
                                      ((widget.data.likedBySelf ?? "false")
                                                  .toString()
                                                  .toLowerCase() ==
                                              'true')
                                          ? TImageName.likeFill
                                          : TImageName.like,
                                      height: 16.h,
                                      width: 16.h,
                                      // fit: BoxFit.fill,
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
                                      width: widget.iconSize,
                                      color: TAppColors.white,
                                      // fit: BoxFit.fill,
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
          );
        },
      ),
    );
  }
}
