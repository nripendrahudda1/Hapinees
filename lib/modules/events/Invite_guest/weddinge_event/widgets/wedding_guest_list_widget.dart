import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/reminder_dialog.dart';
import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/wedding_accepted_invite_guests_widget.dart';
import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/wedding_decline_guest_result_widget.dart';
import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/wedding_pending_guest_result_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import '../controller/wedding_invite_guests_controller.dart';
import 'invited_guest_widget.dart';
import 'wedding_event_accepted_invite_cohost_widget.dart';

class WeddingGuestListWidget extends StatefulWidget {
  const WeddingGuestListWidget({
    super.key,
    required this.isAllReminded,
    required this.onTap,
    required this.onReminder,
  });
  final bool isAllReminded;
  final Function() onTap;
  final Function() onReminder;

  @override
  State<WeddingGuestListWidget> createState() => _WeddingGuestListWidgetState();
}

class _WeddingGuestListWidgetState extends State<WeddingGuestListWidget> {
  // bool isExpanded = false;
  bool reminderToAll = false;
  final msgCtr = TextEditingController();
  final remCtr = TextEditingController();
  bool isGuestExpanded = false; // Default: expanded
  bool isCoHostExpanded = false; // Default: expanded
  bool isDeclineExpanded = false; // Default: expanded
  bool isPendingExpanded = false; // Default: expanded

  bool? isAnyInvites;

  Future<void> showRemDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonReminderDialog(
          onTap: () {},
          title: 'Reminder november',
          textEditingCtr: remCtr,
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    msgCtr.text = TMessageStrings.thanksMessage;
    remCtr.text = TMessageStrings.thanksinderRemMessage;
    super.initState();
  }

  @override
  void dispose() {
    msgCtr.dispose();
    remCtr.dispose();
    super.dispose();
  }

  Future<void> showMsgDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonReminderDialog(
          onTap: () {},
          title: 'Thank You!',
          textEditingCtr: msgCtr,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('inviteCtr.getAllInvitedUsers?.weddingInviteList 1 **********');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Consumer(builder: (context, ref, child) {
        final inviteCtr = ref.watch(weddingEventGuestInviteController);
        print('inviteCtr.getAllInvitedUsers?.weddingInviteList 2 **********');
        print(inviteCtr.getAllInvitedUsers != null);
        print(inviteCtr.getAllInvitedUsers?.weddingInviteList != null);
        print(inviteCtr.getAllInvitedUsers?.weddingInviteList?.isNotEmpty);
        print(inviteCtr.getAllInvitedUsers != null &&
            inviteCtr.getAllInvitedUsers!.weddingInviteList != null &&
            inviteCtr.getAllInvitedUsers!.weddingInviteList!.isNotEmpty);

        List<WeddingInviteList> allGuests = []; // ALL Users
        List<WeddingInviteList> accepted = [];
        // List<WeddingInviteList> acceptedHost = [];
        List<WeddingInviteList> declineUser = [];
        List<WeddingInviteList> pendingUser = [];

        if (inviteCtr.getAllInvitedUsers != null &&
            inviteCtr.getAllInvitedUsers!.weddingInviteList != null &&
            inviteCtr.getAllInvitedUsers!.weddingInviteList!.isNotEmpty) {
          allGuests = inviteCtr.getAllInvitedUsers!.weddingInviteList!;
          accepted = allGuests
              .where((guest) =>
                  guest.isCoHost != true && guest.inviteStatus == 2 || guest.isCoHost == true)
              .toList();
          // acceptedHost = allGuests.where((guest) => guest.isCoHost == true).toList();
          pendingUser = allGuests
              .where((guest) => guest.isCoHost != true && guest.inviteStatus == 1)
              .toList();
          declineUser = allGuests
              .where((guest) => guest.isCoHost != true && guest.inviteStatus == 3)
              .toList();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "${TNavigationTitleStrings.inviteGuests} (${allGuests.length})",
                      style: getBoldStyle(
                          fontSize: MyFonts.size12, color: TAppColors.inputPlaceHolderColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!reminderToAll)
                      InkWell(
                        onTap: () async {
                          await showRemDialog(context);
                          setState(() {
                            reminderToAll = true;
                          });
                        },
                        child: Container(
                          color: TAppColors.white,
                          child: Row(
                            children: [
                              Image.asset(TImageName.notificationBell,
                                  color: TAppColors.selectionColor, width: 14.w, height: 14.h),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                TMessageStrings.remimderToAll,
                                style: getBoldStyle(
                                    fontSize: MyFonts.size12, color: TAppColors.appColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (reminderToAll)
                      InkWell(
                        onTap: () async {
                          await showMsgDialog(context);
                        },
                        child: Container(
                          color: TAppColors.white,
                          child: Row(
                            children: [
                              Image.asset(TImageName.thankYouIcon,
                                  color: TAppColors.greyText, width: 14.w, height: 14.h),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                TLabelStrings.thankYou,
                                style: getSemiBoldStyle(
                                    fontSize: MyFonts.size12, color: TAppColors.appColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
            // SizedBox(
            //   height: 10.w,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           isCoHostExpanded = !isCoHostExpanded; // Only toggles Guest section
            //         });
            //       },
            //       child: Row(
            //         children: [
            //           Text(
            //             "${TNavigationTitleStrings.coHostGuests} (${acceptedHost.length})",
            //             style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
            //           ),
            //           SizedBox(width: 8.w),
            //           Icon(
            //             isCoHostExpanded
            //                 ? Icons.keyboard_arrow_down_rounded
            //                 : Icons.keyboard_arrow_right_rounded,
            //             color: TAppColors.greyText,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // if (isCoHostExpanded)
            //   Padding(
            //     padding: EdgeInsets.only(top: 10.h),
            //     child: ListView.separated(
            //       padding: EdgeInsets.zero,
            //       shrinkWrap: true,
            //       physics: const NeverScrollableScrollPhysics(),
            //       itemBuilder: (context, index) {
            //         WeddingInviteList model = acceptedHost[index];
            //         return WeddingEventAcceptedInvitesCoHostWidget(
            //           guestName: model.inviteTo?.displayName ?? model.email ?? "Co-host",
            //           inviteId: model.weddingInviteId ?? 0,
            //           phNumber: model.mobile ?? model.inviteTo?.contactNumber,
            //           imageUrl: model.inviteTo?.profileImageUrl,
            //           isCohost: model.isCoHost ?? false,
            //         );
            //       },
            //       separatorBuilder: (context, index) => SizedBox(height: 20.h),
            //       itemCount: acceptedHost.length,
            //     ),
            //   ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isGuestExpanded = !isGuestExpanded; // Only toggles Guest section
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "${TNavigationTitleStrings.acceptedGuests} (${accepted.length})",
                        style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        isGuestExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: TAppColors.greyText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isGuestExpanded)
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 15),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    WeddingInviteList model = accepted[index];
                    return WeddingAcceptedInvitesGuestsWidget(
                      guestName: model.inviteTo?.displayName ?? model.email ?? "Guest",
                      inviteId: model.weddingInviteId ?? 0,
                      phNumber: model.mobile ?? model.inviteTo?.contactNumber,
                      imageUrl: model.inviteTo?.profileImageUrl,
                      isCohost: model.isCoHost ?? false,
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemCount: accepted.length,
                ),
              ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDeclineExpanded = !isDeclineExpanded; // Only toggles Guest section
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        "${TNavigationTitleStrings.inviteDelined} (${declineUser.length})",
                        style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        isDeclineExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_right_rounded,
                        color: TAppColors.greyText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isDeclineExpanded)
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 15),
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    WeddingInviteList model = declineUser[index];
                    return WeddingDeclineGuestResultWidget(
                      invitedGuestModel: model,
                      invitestatus: model.inviteStatus,
                      weddingInviteId: model.weddingInviteId,
                      imageUrl: model.inviteTo?.profileImageUrl ?? '',
                      coHostName: model.inviteTo?.displayName ?? '',
                      //  phNumber: model.inviteTo?.email ?? '',
                      isInvited: model.inviteTo == 1 ? true : false, searchtext: '',
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20.h),
                  itemCount: declineUser.length,
                ),
              ),
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  isPendingExpanded = !isPendingExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${TNavigationTitleStrings.pendingGuests} (${pendingUser.length})",
                    style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    isPendingExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    color: TAppColors.greyText,
                  ),
                ],
              ),
            ),
            if (isPendingExpanded)
              Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        WeddingInviteList model = pendingUser[index];

                        return WeddingPendingGuestResultWidget(
                          invitedGuestModel: model,
                          invitestatus: model.inviteStatus,
                          weddingInviteId: model.weddingInviteId,
                          imageUrl: model.inviteTo?.profileImageUrl ?? '',
                          coHostName: model.inviteTo?.displayName ?? '',
                          //  phNumber: model.inviteTo?.email ?? '',
                          isInvited: model.inviteTo == 1 ? true : false, searchtext: '',
                        );
                      },
                      //   return InvitedGuestWidget(
                      //     guestName: model.inviteTo != null && model.inviteTo?.displayName != null
                      //         ? model.inviteTo!.displayName!
                      //         : model.email != null
                      //             ? model.email!
                      //             : "Guest",
                      //     inviteId: model.weddingInviteId ?? 0,
                      //     phNumber: model.mobile != null
                      //         ? model.mobile!
                      //         : model.inviteTo != null && model.inviteTo?.contactNumber != null
                      //             ? model.inviteTo!.contactNumber!
                      //             : null,
                      //     imageUrl: model.inviteTo?.profileImageUrl,
                      //     isReminded: widget.isAllReminded,
                      //   );
                      // },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 20.h,
                        );
                      },
                      itemCount: pendingUser.length),
                );
              })
          ],
        );
      }),
    );
  }
}
