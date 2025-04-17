
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:Happinest/modules/home/Models/dashoard_det_trip_data_model.dart';
import 'package:Happinest/theme/app_colors.dart';

class StoryCard extends ConsumerStatefulWidget {
  const StoryCard({
    super.key,
    required this.tripData,
    required this.index,
  });
  final TrendingTrips tripData;
  final int index;

  @override
  ConsumerState<StoryCard> createState() => StoryCardState();
}

class StoryCardState extends ConsumerState<StoryCard> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.tripData.tripId.toString(),
      child: Consumer(builder: (context, ref, child) {
        final _ = ref.watch(homectr);
        return TBounceAction(
          onPressed: () {
            // Navigator.pushNamed(context, Routes.memoriesRoute, arguments: [
            //   widget.tripData.tripId.toString(),
            //   widget.tripData
            // ]).then((value) {
            //   _.getTripData(context, isLoader: false);
            // });
          },
          child: Stack(
            children: [
              TCard(
                radius: 12,
                child: CachedRectangularNetworkImageWidget(
                    radius: 12,
                    image: widget.tripData.startLocationImage ?? '',
                    width: double.maxFinite,
                    height: double.maxFinite),
              ),
              TCard(
                radius: 12,
                color: Colors.black45,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 15.h, left: 10.w, right: 10.w, bottom: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TText(
                        widget.tripData.tripName ?? '',
                        maxLines: 2,
                        fontSize: MyFonts.size20,
                        minFontSize: MyFonts.size14,
                        fontWeight: FontWeightManager.bold,
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      SizedBox(
                        height: 16.h,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return CachedRectangularNetworkImageWidget(
                                  radius: 2,
                                  image: widget
                                          .tripData
                                          .visitiedCountries?[index]
                                          .countryFlagUrl ??
                                      '',
                                  width: 16.w,
                                  height: 16.h);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(width: 6.w);
                            },
                            itemCount:
                                widget.tripData.visitiedCountries?.length ?? 0),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 30.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                (widget.tripData.coAuthorsCount ?? 0) > 0
                                    ? Padding(
                                  padding:   const EdgeInsets.only(left: 20),
                                  child: TCard(
                                      shape: BoxShape.circle,
                                      height: 30.h,
                                      width: 30.h,
                                      border: true,
                                      borderColor: TAppColors.white,
                                      borderWidth: 1,
                                      color: TAppColors.greyText,
                                      child: Center(
                                        child: TText(
                                            '+${widget.tripData.coAuthorsCount}',
                                            color: TAppColors.white,
                                            fontSize: MyFonts.size14,
                                            fontWeight: FontWeight.w600),
                                      )
                                  ),
                                ) : const SizedBox.shrink(),
                                CachedCircularNetworkImageWidget(
                                    image:
                                    widget.tripData.userProfilePictureUrl ??
                                        '',
                                    size: 30),
                              ],
                            ),
                            SizedBox(width: 6.w),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: TText(
                                        widget.tripData.userFullName ??
                                            widget.tripData.userFirstName ??
                                            '',
                                        maxLines: 1,
                                        minFontSize: 12,
                                        fontSize: MyFonts.size14,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeightManager.bold),
                                  ),
                                  // const SizedBox(height: 2),
                                  TText(
                                      formatDateDDMMMyy(widget.tripData.createdDate!),
                                      fontSize: MyFonts.size10,
                                      fontWeight: FontWeightManager.semiBold)
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
                            child: Column(
                              children: [
                                Image.asset(
                                  TImageName.calander,
                                  height: 16.h,
                                  color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
                                  child: TText(
                                      widget.tripData.tripDaysCount.toString(),
                                      fontSize: MyFonts.size12,
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
                                  height: 16.h,
                                  color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
                                  child: TText(
                                      widget.tripData.travelTypeDesc ?? '',
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
                                  (widget.tripData.tripLikedBySelf ?? false)
                                      ? TImageName.likeFill
                                      : TImageName.like,
                                  height: 16.h,
                                  // color: TAppColors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
                                  child: TText(
                                      formatNumber(
                                          widget.tripData.tripLikeCount),
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
                                  child: TText(
                                      formatNumber(
                                          widget.tripData.tripViewCount),
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
        );
      }),
    );
  }
}
