import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/datetime_functions.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../../utility/constants/images/image_url.dart';

class WeddingEventCard extends ConsumerStatefulWidget {
  final WeddingRitualList ritualModels;
  final HomeWeddingDetailsModel homeWeddingDetailsModel;
  final int ritualIndex;
  final Function() stopPlayer;

  const WeddingEventCard({
    required this.ritualModels,
    super.key,
    required this.stopPlayer,
    required this.homeWeddingDetailsModel, required this.ritualIndex,
  });

  @override
  ConsumerState<WeddingEventCard> createState() => _WeddingEventCardState();
}

class _WeddingEventCardState extends ConsumerState<WeddingEventCard> {
  @override
  Widget build(BuildContext context) {
    final weddingCtr = ref.watch(weddingEventHomeController);
    return GestureDetector(
      onTap: () async {
        await widget.stopPlayer();
        Navigator.pushNamed(
          context,
          Routes.eventRitualScreen,
          arguments: {
            'homeWeddingDetailsModel' : widget.homeWeddingDetailsModel,
            'ritualIndex' : widget.ritualIndex,
            'ritualModels' : widget.ritualModels,
          }
        );
      },
      child: Padding(
        padding: EdgeInsets.only(right: 8.0.w, top: 10.h, bottom: 10.h),
        child: AspectRatio(
          aspectRatio: 4/3,
          child: Stack(
            children: [
              Container(
                height: 135.h,
                width: 180.w,
                padding: EdgeInsets.all(0.w),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: NetworkImage(
                        widget.ritualModels.backgroundImageUrl ??
                            TImageUrl.eventCardImgUrl,
                      ),
                      fit: BoxFit.fill),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Container(
                      height: 135.h,
                      width: 180.w,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: TAppColors.blackShadow.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            widget.ritualModels.ritualName ?? 'Sagai',
                            style: getBoldStyle(
                                color: TAppColors.white,
                                fontSize: MyFonts.size18),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          if(widget.ritualModels.venueAddress != null && widget.ritualModels.venueAddress.toString().isNotEmpty)
                          Row(
                            children: [
                              ImageIcon(
                                const AssetImage(
                                  TImageName.locationPngIcon,
                                ),
                                color: TAppColors.white,
                                size: 16.h,
                              ),
                              SizedBox(width: 6.h),
                              Expanded(
                                child: Text(
                                  widget.ritualModels.venueAddress == null || widget.ritualModels.venueAddress.toString().isEmpty?'Lake Palace, Udaipur' :widget.ritualModels.venueAddress,
                                  style: getRegularStyle(
                                      color: TAppColors.white,
                                      fontSize: MyFonts.size14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              ImageIcon(
                                const AssetImage(TImageName.calenderPngIcon),
                                color: TAppColors.white,
                                size: 16.h,
                              ),
                              SizedBox(width: 6.h),
                              Expanded(
                                child: Text(
                                  formatDateTimeToCustomFormat2(widget.ritualModels.scheduleDate) ?? '12 Oct - 08:30 PM',
                                  style: getRegularStyle(
                                      color: TAppColors.white,
                                      fontSize: MyFonts.size14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              ),
              weddingCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type ?
              const SizedBox():
              Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: ETopEditButton(
                    //bgColor: TAppColors.blackShadow,
                    onTap: () async {
                      await widget.stopPlayer();
                      Navigator.pushNamed(
                        context,
                        Routes.editRitualScreen,
                        arguments: {
                          'homeWeddingDetailsModel': widget.homeWeddingDetailsModel,
                          'ritualIndex': widget.ritualIndex,
                        }
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
