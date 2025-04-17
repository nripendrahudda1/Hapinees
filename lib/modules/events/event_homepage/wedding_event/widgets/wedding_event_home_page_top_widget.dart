import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/wedding_event/update_wedding_style_controller.dart';

import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/e_top_backbutton.dart';
import '../../../../../common/widgets/e_top_editbutton.dart';
import '../../../Invite_guest/weddinge_event/controller/wedding_invite_guests_controller.dart';
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
import '../../../update_wedding_event/controllers/common_update_event_title_controller.dart';
import '../../../update_wedding_event/controllers/wedding_event/update_wedding_couple_controller.dart';
import 'wedding_invite_top_bar.dart';

class WeddingEventHomePageTopWidget extends StatelessWidget {
  const WeddingEventHomePageTopWidget({
    super.key,
    required this.stopPlayer,
  });
  final Function() stopPlayer;

  setForUpdate(WidgetRef ref) {
    final manageStylesCtr = ref.read(updateWeddingStylesCtr);
    final coupleCtr = ref.read(updateWeddingCoupleCtr);
    coupleCtr.setCouple1Name("Jane Doe");
    coupleCtr.setCouple2Name("John Doe");

    final coupleTitleCtr = ref.read(updateEventTitleCtr);
    coupleTitleCtr.setTitleName("Jane weds John");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final weddingCtr = ref.watch(weddingEventHomeController);
          final inviteCtr = ref.watch(weddingEventGuestInviteController);
          final dataStatus = compareDate(weddingCtr.homeWeddingDetails?.startDateTime);
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 1.3.sh * (inviteCtr.isInvited ? 0.02 : 0.05), 16, 0),
            // padding: EdgeInsets.fromLTRB(16, 1.sh * 0.07, 16, 0),,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                inviteCtr.isInvited
                    ? Column(
                        children: [
                          const WeddingInviteTopBar(),
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
                        ref.read(createEventController).resetAllData();
                        ref.read(weddingEventHomeController).clearData();
                        ref.read(personalEventVisibilityCtr).resetSelection();
                        ref.read(personalEventThemesCtr).clearThemes();
                        ref.read(personalEventActivityCtr).clearActivity();
                        ref.watch(infoVenueController).resetData();
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                              context, Routes.homeRoute, (route) => false);
                        }
                      },
                    ),
                    Container(
                      width: 250.w, // Adjust width as needed
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.grey, width: 1.w),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: weddingCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16.r),
                              child: Consumer(builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: () {
                                    stopPlayer();
                                    final tabProvider = ref.read(momentAndDetailProvider);
                                    tabProvider.setInitialIndex(initialndex: 0);
                                    Navigator.pushNamed(
                                        context, Routes.eventDetailsAndMomentsScreen,
                                        arguments: {'isPersonalEvent': false});
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
                                              arguments: {'isPersonalEvent': false});
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 36.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Moments',
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
                                                    arguments: {'isPersonalEvent': false});
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
                                ],
                              ),
                            ),
                    ),
                    weddingCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                        ? SizedBox(
                            width: 21.w,
                          )
                        : Consumer(builder: (context, ref, child) {
                            return ETopEditButton(
                              onTap: () async {
                                await stopPlayer();
                                setForUpdate(ref);
                                // print(weddingCtr.homeWeddingDetails?.weddingHeaderId);
                                Navigator.pushNamed(context, Routes.updateWeddingEventScreen,
                                    arguments: {
                                      'homeModel': weddingCtr.homeWeddingDetails,
                                    });
                              },
                            );
                          }),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                if (weddingCtr.homeWeddingDetails?.title != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.75.sw),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            weddingCtr.homeWeddingDetails?.title ?? "",
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
                        weddingCtr.homeWeddingDetails?.visibility == 0
                            ? TImageName.privatePngIcon
                            : weddingCtr.homeWeddingDetails?.visibility == 0
                                ? TImageName.publicPngIcon
                                : TImageName.guestPngIcon,
                        width: 12.w,
                        height: 14.h,
                      )
                    ],
                  ),
                SizedBox(
                  height: 8.h,
                ),
                weddingCtr.homeWeddingDetails?.venueAddress == null ||
                        weddingCtr.homeWeddingDetails?.venueAddress == ''
                    ? const SizedBox()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(maxWidth: 0.85.sw),
                            child: Text(
                              weddingCtr.homeWeddingDetails?.venueAddress ?? "",
                              textAlign: TextAlign.center,
                              style:
                                  getBoldStyle(fontSize: MyFonts.size16, color: TAppColors.white),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                if (weddingCtr.homeWeddingDetails?.startDateTime != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        TImageName.dateIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        formatDateTimeToCustomFormat(weddingCtr.homeWeddingDetails?.startDateTime,
                            weddingCtr.homeWeddingDetails?.endDateTime),
                        style: getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 5.h,
                ),
                Image.asset(
                  TImageName.logoPngIcon,
                  width: 18.w,
                  height: 24.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
