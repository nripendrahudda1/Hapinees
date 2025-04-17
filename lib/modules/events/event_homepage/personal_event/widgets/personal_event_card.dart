import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../utility/constants/images/image_url.dart';

class PersonalEventCard extends ConsumerStatefulWidget {
  final PersonalEventActivityList activityModel;
  final HomePersonalEventDetailsModel homePersonalEventDetailsModel;
  final int activityIndex;
  final Function() stopPlayer;
  final Function() favClick;
  final bool isFav;
  final int likesCount;

  const PersonalEventCard({
    required this.activityModel,
    super.key,
    required this.stopPlayer,
    required this.favClick,
    required this.isFav,
    required this.likesCount,
    required this.homePersonalEventDetailsModel, required this.activityIndex,
  });

  @override
  ConsumerState<PersonalEventCard> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<PersonalEventCard> {
  @override
  Widget build(BuildContext context) {
    final eventCtr = ref.watch(personalEventHomeController);
    return GestureDetector(
      onTap: () async {
        await widget.stopPlayer();
        Navigator.pushNamed(
            context,
            Routes.eventActivityScreen,
            arguments: {
              'homePersonalEventDetailsModel' : widget.homePersonalEventDetailsModel,
              'activityIndex' : widget.activityIndex,
              'activityModels' : widget.activityModel,
              'favClick': widget.favClick,
              'isFav': widget.isFav,
              'likesCount': widget.likesCount,
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
                        widget.activityModel.backgroundImageUrl ??
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
                            widget.activityModel.activityName ??
                                '',
                            style: getBoldStyle(
                                color: TAppColors.white,
                                fontSize: MyFonts.size16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          if(widget.activityModel.venueAddress != null && widget.activityModel.venueAddress.toString().isNotEmpty)
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
                                    widget.activityModel.venueAddress == null || widget.activityModel.venueAddress.toString().isEmpty? '' :widget.activityModel.venueAddress,
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
                                  formatDateTimeToCustomFormat2(widget.activityModel.scheduleDate),
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
              eventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type ?
              const SizedBox():
              Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: ETopEditButton(
                    //bgColor: TAppColors.blackShadow,
                    onTap: () async {
                      // EasyLoading.showError("Coming Soon");
                      await widget.stopPlayer();
                      Navigator.pushNamed(context, Routes.editActivityScreen,
                          arguments: {
                            'homePersonalEventDetailsModel': widget.homePersonalEventDetailsModel,
                            'activityIndex': widget.activityIndex,
                          });
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
