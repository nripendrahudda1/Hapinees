import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/make_co_host_personal_event_post_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';

class PersonalEventAcceptedInvitesGuestsWidget extends StatelessWidget {
  const PersonalEventAcceptedInvitesGuestsWidget({
    super.key,
    required this.guestName,
    required this.inviteId,
    required this.isCohost,
    this.imageUrl,
    this.email,
    required this.userID,
  });
  final String guestName;
  final int inviteId;
  final bool isCohost;
  final String? imageUrl;
  final String? email;
  final int userID;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherUserprofilescreen(
                          userID: userID.toString(),
                          author: null,
                        )));
          },
          child: CachedCircularNetworkImageWidget(
            image: imageUrl ?? "",
            size: 36,
            name: guestName,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (guestName.isNotEmpty)
                Text(
                  guestName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
                ),
              // SizedBox(
              //   height: 3.h,
              // ),
              if (email != null)
                Text(
                  email!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getRobotoMediumStyle(fontSize: MyFonts.size12, color: TAppColors.black),
                ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        // if (!isReminded)
        isCohost
            ? Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final personalEventCtr = ref.watch(personalEventHomeController);
                      final inviteCtr = ref.watch(personalEventGuestInviteController);
                      return GestureDetector(
                        onTap: () async {
                          MakeCoHostPersonalEventPostModel model = MakeCoHostPersonalEventPostModel(
                              personalEventInviteId: inviteId,
                              personalEventHeaderId: personalEventCtr
                                      .homePersonalEventDetailsModel?.personalEventHeaderId ??
                                  0,
                              isCoHost: false);
                          await inviteCtr.makePersonalEventCoHost(
                              makeCoHostPersonalEventPostModel: model, ref: ref, context: context);
                        },
                        child: TCard(
                            radius: 6,
                            border: true,
                            borderColor: Colors.black45,
                            color: Colors.transparent,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              child: TText('Co-Host',
                                  color: TAppColors.black,
                                  fontSize: MyFonts.size12,
                                  fontWeight: FontWeight.w400),
                            )),
                      );
                    },
                  )
                  // return PopupMenuButton<String>(
                  //   onSelected: (String value) {
                  //     print(value);
                  //   },
                  //   offset: const Offset(-10, 20),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.r),
                  //   ),
                  //   elevation: 2,
                  //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  //     PopupMenuItem<String>(
                  //       value: 'remove_guest',
                  //       height: 30.h,
                  //       padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  //       child: GestureDetector(
                  //         onTap: () async {
                  //           Navigator.pop(context);
                  //           MakeCoHostPersonalEventPostModel model =
                  //               MakeCoHostPersonalEventPostModel(
                  //                   personalEventInviteId: inviteId,
                  //                   personalEventHeaderId: personalEventCtr
                  //                           .homePersonalEventDetailsModel
                  //                           ?.personalEventHeaderId ??
                  //                       0,
                  //                   isCoHost: false);
                  //           await inviteCtr.makePersonalEventCoHost(
                  //               makeCoHostPersonalEventPostModel: model,
                  //               ref: ref,
                  //               context: context);
                  //         },
                  //         child: Row(
                  //           children: [
                  //             Image.asset(TImageName.deleteOutlineIcon,
                  //                 width: 18.w, height: 18.h),
                  //             SizedBox(width: 8.w),
                  //             Text(
                  //               TButtonLabelStrings.removeCoHostGuest,
                  //               style: getRegularStyle(
                  //                   color: TAppColors.black, fontSize: MyFonts.size14),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  //   child: Container(
                  //       color: TAppColors.white,
                  //       child: Image.asset(
                  //         TImageName.moreVertIcon,
                  //         width: 22.w,
                  //         height: 22.h,
                  //       )),
                  // );
                  // },
                  // ),
                ],
              )

            // return GestureDetector(
            //   onTap: () async {
            //     MakeCoHostPersonalEventPostModel model = MakeCoHostPersonalEventPostModel(
            //         personalEventInviteId: personalEventCtr
            //                 .homePersonalEventDetailsModel?.personalEventHeaderId ??
            //             0,
            //         personalEventHeaderId: inviteId,
            //         isCoHost: false);
            //     await inviteCtr.makePersonalEventCoHost(
            //         makeCoHostPersonalEventPostModel: model, ref: ref, context: context);
            //     // Navigator.pop(context);
            //   },
            //   child: TCard(
            //       radius: 6,
            //       border: true,
            //       borderColor: TAppColors.selectionColor,
            //       color: Colors.transparent,
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            //         child: TText('Remove Co-Host',
            //             color: TAppColors.selectionColor,
            //             fontSize: MyFonts.size12,
            //             fontWeight: FontWeight.w600),
            //       )),
            // );
            //   },
            // )
            : Row(
                children: [
                  // InkWell(
                  //   onTap: () {},
                  //   child: Container(
                  //       color: TAppColors.white,
                  //       child: Image.asset(
                  //         TImageName.notificationBell,
                  //         width: 16.w,
                  //         height: 16.h,
                  //       )),
                  // ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final inviteCtr = ref.watch(personalEventGuestInviteController);
                      final personalEventCtr = ref.watch(personalEventHomeController);
                      return PopupMenuButton<String>(
                        onSelected: (String value) {
                          print(value);
                        },
                        offset: const Offset(-5, 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 2,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'assign_co_host',
                            height: 30.h,
                            padding: EdgeInsets.only(left: 15.w, right: 15.w),
                            child: GestureDetector(
                              onTap: () async {
                                Navigator.pop(context);
                                MakeCoHostPersonalEventPostModel model =
                                    MakeCoHostPersonalEventPostModel(
                                        personalEventHeaderId: personalEventCtr
                                                .homePersonalEventDetailsModel
                                                ?.personalEventHeaderId ??
                                            0,
                                        personalEventInviteId: inviteId,
                                        isCoHost: true);
                                await inviteCtr.makePersonalEventCoHost(
                                    makeCoHostPersonalEventPostModel: model,
                                    ref: ref,
                                    context: context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(TImageName.inviteOutlineIcon,
                                      width: 18.w, height: 18.h),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Assign Co-Host',
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
                                ActionOnPersonalEventInvitePostModel model =
                                    ActionOnPersonalEventInvitePostModel(
                                  personalEventHeaderId: personalEventCtr
                                          .homePersonalEventDetailsModel?.personalEventHeaderId ??
                                      0,
                                  personalEventInviteId: inviteId,
                                  acceptedRejectedOn: DateTime.now(),
                                  isAccepted: false,
                                  isCancelRequest: true,
                                );
                                await inviteCtr.actionOnPersonalEventInvite(
                                    actionOnPersonalEventInvitePostModel: model,
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
                  )

                  //GestureDetector(
                  //   onTap: () async {
                  //     MakeCoHostPersonalEventPostModel model = MakeCoHostPersonalEventPostModel(
                  //         personalEventHeaderId: personalEventCtr
                  //                 .homePersonalEventDetailsModel?.personalEventHeaderId ??
                  //             0,
                  //         personalEventInviteId: inviteId,
                  //         isCoHost: true);
                  //     await inviteCtr.makePersonalEventCoHost(
                  //         makeCoHostPersonalEventPostModel: model, ref: ref, context: context);
                  //     // Navigator.pop(context);
                  //   },
                  //   child: TCard(
                  //       radius: 6,
                  //       border: true,
                  //       borderColor: Colors.black45,
                  //       color: Colors.transparent,
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  //         child: TText('Assign Co-Host',
                  //             color: TAppColors.black,
                  //             fontSize: MyFonts.size12,
                  //             fontWeight: FontWeight.w400),
                  //       )),
                  // );
                  //    },
                  // )
                  // return PopupMenuButton<String>(
                  //   onSelected: (String value) {
                  //     print(value);
                  //   },
                  //   offset: const Offset(-5, 25),
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.r),
                  //   ),
                  //   elevation: 2,
                  //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  //     PopupMenuItem<String>(
                  //       value: 'assign_co_host',
                  //       height: 30.h,
                  //       padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  //       child: GestureDetector(
                  //         onTap: () async {
                  //           Navigator.pop(context);
                  //           MakeCoHostPersonalEventPostModel model =
                  //               MakeCoHostPersonalEventPostModel(
                  //                   personalEventHeaderId: personalEventCtr
                  //                           .homePersonalEventDetailsModel
                  //                           ?.personalEventHeaderId ??
                  //                       0,
                  //                   personalEventInviteId: inviteId,
                  //                   isCoHost: true);
                  //           await inviteCtr.makePersonalEventCoHost(
                  //               makeCoHostPersonalEventPostModel: model,
                  //               ref: ref,
                  //               context: context);
                  //         },
                  //         child: Row(
                  //           children: [
                  //             Image.asset(TImageName.inviteOutlineIcon,
                  //                 width: 18.w, height: 18.h),
                  //             SizedBox(width: 8.w),
                  //             Text(
                  //               'Assign as a Co-Host',
                  //               style: getRegularStyle(
                  //                   color: TAppColors.black, fontSize: MyFonts.size14),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //     PopupMenuItem<String>(
                  //       value: 'remove_guest',
                  //       height: 30.h,
                  //       padding: EdgeInsets.only(left: 15.w, right: 15.w),
                  //       child: GestureDetector(
                  //         onTap: () async {
                  //           ActionOnPersonalEventInvitePostModel model =
                  //               ActionOnPersonalEventInvitePostModel(
                  //             personalEventHeaderId: personalEventCtr
                  //                     .homePersonalEventDetailsModel?.personalEventHeaderId ??
                  //                 0,
                  //             personalEventInviteId: inviteId,
                  //             acceptedRejectedOn: DateTime.now(),
                  //             isAccepted: false,
                  //             isCancelRequest: true,
                  //           );
                  //           await inviteCtr.actionOnPersonalEventInvite(
                  //               actionOnPersonalEventInvitePostModel: model,
                  //               ref: ref,
                  //               context: context);
                  //           Navigator.pop(context);
                  //         },
                  //         child: Row(
                  //           children: [
                  //             Image.asset(TImageName.deleteOutlineIcon,
                  //                 width: 18.w, height: 18.h),
                  //             SizedBox(width: 8.w),
                  //             Text(
                  //               TButtonLabelStrings.removeGuest,
                  //               style: getRegularStyle(
                  //                   color: TAppColors.black, fontSize: MyFonts.size14),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  //   child: Container(
                  //       color: TAppColors.white,
                  //       child: Image.asset(
                  //         TImageName.moreVertIcon,
                  //         width: 22.w,
                  //         height: 22.h,
                  //       )),
                  // );
                  //  },
                  // ),
                ],
              ),
      ],
    );
  }
}
