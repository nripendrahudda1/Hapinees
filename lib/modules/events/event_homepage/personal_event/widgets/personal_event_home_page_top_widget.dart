import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_invite_top_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../common/widgets/e_top_editbutton.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../create_event/controllers/event_dates_controller.dart';
import '../../../create_event/controllers/event_more_info_controller/info_venue_controller.dart';
import '../../../create_event/controllers/personal_event_controller/baby_shower_themes_controller.dart';
import '../../../create_event/controllers/personal_event_controller/baby_shower_visibility_controller.dart';
import '../../../create_event/controllers/personal_event_controller/personal_event_activity_controller.dart';
import '../../../create_event/controllers/title_controller.dart';
import '../../../create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../../create_event/controllers/wedding_controllers/wedding_couple_controller.dart';
import '../../../create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import '../../../event_details_moments/controller/moment_and_detail_provider.dart';
import '../../../event_details_moments/views/event_details_and_moments_screen.dart';
import '../controller/personal_event_home_controller.dart';

class PersonalEventHomePageTopWidget extends StatelessWidget {
  const PersonalEventHomePageTopWidget({
    super.key,
    required this.stopPlayer,
    this.inviteCallback,
  });
  final Function() stopPlayer;
  final Function()? inviteCallback;

  setForUpdate(WidgetRef ref) {
    // final manageStylesCtr = ref.read(updateWeddingStylesCtr);
    // final coupleCtr = ref.read(updateWeddingCoupleCtr);
    // coupleCtr.setCouple1Name("Jane Doe");
    // coupleCtr.setCouple2Name("John Doe");
    //
    // final coupleTitleCtr = ref.read(updateEventTitleCtr);
    // coupleTitleCtr.setTitleName("Jane weds John");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final personalEventCtr = ref.watch(personalEventHomeController);
          final followStatus =
              personalEventCtr.homePersonalEventDetailsModel?.createdBy?.followingStatus;

          final inviteCtr = ref.watch(personalEventGuestInviteController);
          final loginUserID = getUserID();
          final dataStatus =
              compareDate(personalEventCtr.homePersonalEventDetailsModel?.startDateTime);
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 1.3.sh * (inviteCtr.isInvited ? 0.02 : 0.05), 16, 0),
            // padding: EdgeInsets.fromLTRB(16, 1.sh * 0.07, 16, 0),,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (personalEventCtr.homePersonalEventDetailsModel?.inviteStatus == 1 &&
                        loginUserID !=
                            personalEventCtr.homePersonalEventDetailsModel?.createdBy?.userId &&
                        personalEventCtr.homePersonalEventDetailsModel?.selfRegistration == false)
                    ? Column(
                        children: [
                          PersonalEventInviteTopBar(
                            eventStatus: dataStatus,
                            callBack: () {
                              inviteCallback!();
                            },
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ETopBackButton(
                      onTap: () async {
                        await stopPlayer();
                        ref.read(weddingStylesCtr).clearStyles();
                        ref.read(weddingActivityCtr).clearRitualss();
                        ref.read(weddingCoupleCtr).clearCoupleNames();
                        ref.read(eventTitleCtr).clearTitle();
                        ref.read(eventDatesCtr).clearDates();
                        ref.read(personalEventVisibilityCtr).resetSelection();
                        ref.read(personalEventThemesCtr).clearThemes();
                        ref.read(personalEventActivityCtr).clearActivity();
                        ref.watch(personalEventHomeController).clearData();
                        ref.watch(infoVenueController).resetData();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context, followStatus);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.homeRoute, (route) => false,
                            arguments: {'index': 2}, // Send index 2 (or any tab index)
                          );
                        }
                      },
                    ),
                    Container(
                      width: 250.w, // Adjust width as needed
                      height: 36.h,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1.w),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: personalEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Consumer(builder: (context, ref, child) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          stopPlayer();
                                          final tabProvider = ref.read(momentAndDetailProvider);
                                          tabProvider.setInitialIndex(initialndex: 0);
                                          final memoriesCtr =
                                              ref.watch(personalEventMemoriesController);
                                          memoriesCtr.personalEventPosts.clear();
                                          Navigator.pushNamed(
                                              context, Routes.eventDetailsAndMomentsScreen,
                                              arguments: {'isPersonalEvent': true});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 36.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            TButtonLabelStrings.momentsButton,
                                            textAlign: TextAlign.center,
                                            style: getRegularStyle(
                                                fontSize: MyFonts.size14, color: TAppColors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Row(
                                children: [
                                  Consumer(builder: (context, ref, child) {
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          stopPlayer();
                                          final tabProvider = ref.read(momentAndDetailProvider);
                                          tabProvider.setInitialIndex(initialndex: 0);

                                          Navigator.pushNamed(
                                              context, Routes.eventDetailsAndMomentsScreen,
                                              arguments: {'isPersonalEvent': true});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 36.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            TButtonLabelStrings.momentsButton,
                                            textAlign: TextAlign.center,
                                            style: getRegularStyle(
                                                fontSize: MyFonts.size14, color: TAppColors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),

                                  Container(
                                    width: dataStatus == false
                                        ? 2.w
                                        : 0.0, // Adjust the width of the divider
                                    height: 40.h, // Adjust the height of the divider
                                    color: Colors.grey,
                                  ),
                                  dataStatus == false
                                      ? Consumer(builder: (context, ref, child) {
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                stopPlayer();
                                                final tabProvider =
                                                    ref.read(momentAndDetailProvider);
                                                tabProvider.setInitialIndex(initialndex: 1);
                                                Navigator.pushNamed(
                                                    context, Routes.eventDetailsAndMomentsScreen,
                                                    arguments: {'isPersonalEvent': true});
                                              },
                                              child: Container(
                                                color: Colors.transparent,
                                                height: 36.h,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  TButtonLabelStrings.eventDetail,
                                                  textAlign: TextAlign.center,
                                                  style: getRegularStyle(
                                                      fontSize: MyFonts.size14,
                                                      color: TAppColors.white),
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                      : Container(),

                                  // }
                                ],
                              ),
                            ),
                    ),
                    personalEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                        ? SizedBox(
                            width: 21.w,
                          )
                        : Consumer(builder: (context, ref, child) {
                            return ETopEditButton(
                              onTap: () async {
                                await stopPlayer();
                                setForUpdate(ref);
                                Navigator.pushNamed(context, Routes.updatePersonalEventScreen,
                                    arguments: {
                                      'homeModel': personalEventCtr.homePersonalEventDetailsModel,
                                    });
                              },
                            );
                          }),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                if (personalEventCtr.homePersonalEventDetailsModel?.title != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.75.sw),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            personalEventCtr.homePersonalEventDetailsModel?.title ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: getBoldStyle(fontSize: MyFonts.size34, color: TAppColors.white),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      Image.asset(
                        personalEventCtr.homePersonalEventDetailsModel?.visibility == 2
                            ? TImageName.privatePngIcon
                            : personalEventCtr.homePersonalEventDetailsModel?.visibility == 1
                                ? TImageName.publicPngIcon
                                : TImageName.guestPngIcon,
                        width: 12.w,
                        height: 14.h,
                      )
                    ],
                  ),
                SizedBox(
                  height: 10.h,
                ),
                personalEventCtr.homePersonalEventDetailsModel?.venueAddress == null ||
                        personalEventCtr.homePersonalEventDetailsModel?.venueAddress == ''
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(maxWidth: 0.85.sw),
                            child: Text(
                              personalEventCtr.homePersonalEventDetailsModel?.venueAddress ??
                                  "Lake Palace, Udaipur",
                              textAlign: TextAlign.center,
                              style:
                                  getBoldStyle(fontSize: MyFonts.size16, color: TAppColors.white),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                if (personalEventCtr.homePersonalEventDetailsModel?.startDateTime != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedRectangularNetworkImageWidget(
                          image: personalEventCtr.homePersonalEventDetailsModel?.eventIcon ?? '',
                          width: 18.w,
                          height: 18.h,
                          errorWidget: Image.asset(
                            TImageName.dateIcon,
                            width: 18.w,
                            height: 18.h,
                          )),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        formatDateTimeToCustomFormat(
                            personalEventCtr.homePersonalEventDetailsModel?.startDateTime,
                            personalEventCtr.homePersonalEventDetailsModel?.endDateTime),
                        style: getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 5.h,
                ),
                Image.asset(
                  TImageName.logoPngIcon,
                  width: 22.w,
                  height: 28.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
