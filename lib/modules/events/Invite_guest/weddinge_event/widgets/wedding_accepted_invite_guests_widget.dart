import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/make_cohost_wedding_post_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingAcceptedInvitesGuestsWidget extends StatelessWidget {
  const WeddingAcceptedInvitesGuestsWidget({
    super.key,
    required this.guestName,
    required this.inviteId,
    required this.isCohost,
    this.imageUrl,
    this.phNumber,
  });
  final String guestName;
  final int inviteId;
  final bool isCohost;
  final String? imageUrl;
  final String? phNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedCircularNetworkImageWidget(
          image: imageUrl ?? "",
          size: 36,
          name: guestName,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guestName,
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
        isCohost
            ? Row(
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
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final inviteCtr = ref.watch(weddingEventGuestInviteController);
                      final weddingCtr = ref.watch(weddingEventHomeController);
                      return PopupMenuButton<String>(
                        onSelected: (String value) {
                          print(value);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        elevation: 2,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'remove_guest',
                            height: 30.h,
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: GestureDetector(
                              onTap: () async {
                                ActionOnWeddingInvitePostModel model =
                                    ActionOnWeddingInvitePostModel(
                                  weddingHeaderId:
                                      weddingCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                                  weddingInviteId: inviteId,
                                  acceptedRejectedOn: DateTime.now(),
                                  isAccepted: false,
                                  isCancelRequest: true,
                                );
                                await inviteCtr.actionOnWeddingInvite(
                                    actionOnWeddingInvitePostModel: model,
                                    ref: ref,
                                    context: context);
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(TImageName.deleteOutlineIcon,
                                      width: 18.w, height: 18.h),
                                  SizedBox(width: 8.w),
                                  Text(
                                    TButtonLabelStrings.removeGuest,
                                    style: getRegularStyle(
                                        color: TAppColors.black, fontSize: MyFonts.size14),
                                  ),
                                ],
                              ),
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
                      );
                    },
                  ),
                ],
              )
            : Row(
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
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final inviteCtr = ref.watch(weddingEventGuestInviteController);
                      final weddingCtr = ref.watch(weddingEventHomeController);
                      return PopupMenuButton<String>(
                        onSelected: (String value) {
                          print(value);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        elevation: 2,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'assign_co_host',
                            height: 30.h,
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: GestureDetector(
                              onTap: () async {
                                MakeCoHostWeddingPostModel model = MakeCoHostWeddingPostModel(
                                    weddingHeaderId:
                                        weddingCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                                    weddingInviteId: inviteId,
                                    isCoHost: true);
                                await inviteCtr.makeWeddingCohost(
                                    makeCoHostPostModel: model, ref: ref, context: context);
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(TImageName.inviteOutlineIcon,
                                      width: 18.w, height: 18.h),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Assign as a Co-Host',
                                    style: getRegularStyle(
                                        color: TAppColors.black, fontSize: MyFonts.size14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'remove_guest',
                            height: 30.h,
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: GestureDetector(
                              onTap: () async {
                                ActionOnWeddingInvitePostModel model =
                                    ActionOnWeddingInvitePostModel(
                                  weddingHeaderId:
                                      weddingCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                                  weddingInviteId: inviteId,
                                  acceptedRejectedOn: DateTime.now(),
                                  isAccepted: false,
                                  isCancelRequest: true,
                                );
                                await inviteCtr.actionOnWeddingInvite(
                                    actionOnWeddingInvitePostModel: model,
                                    ref: ref,
                                    context: context);
                                Navigator.pop(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(TImageName.deleteOutlineIcon,
                                      width: 18.w, height: 18.h),
                                  SizedBox(width: 8.w),
                                  Text(
                                    TButtonLabelStrings.removeGuest,
                                    style: getRegularStyle(
                                        color: TAppColors.black, fontSize: MyFonts.size14),
                                  ),
                                ],
                              ),
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
                      );
                    },
                  ),
                ],
              ),
      ],
    );
  }
}
