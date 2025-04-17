import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_accepted_invite_guests_widget.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../weddinge_event/widgets/reminder_dialog.dart';
import 'personal_event_accepted_invite_cohost_widget.dart';
import 'personal_event_decline_invite_guests_widget.dart';
import 'personal_event_pending_invite_guests_widget.dart';

class PersonalEventInvitedListWidget extends ConsumerStatefulWidget {
  const PersonalEventInvitedListWidget({
    super.key,
  });

  @override
  ConsumerState<PersonalEventInvitedListWidget> createState() =>
      _PersonalEventInvitedListWidgetState();
}

class _PersonalEventInvitedListWidgetState extends ConsumerState<PersonalEventInvitedListWidget> {
  bool isExpanded = false;
  bool reminderToAll = false;
  final msgCtr = TextEditingController();
  final remCtr = TextEditingController();
  bool isGuestExpanded = false; // Default: expanded
  // bool isCoHostExpanded = false; // Default: expanded
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
    return Builder(builder: (context) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w),
          child: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final personalEventCtr = ref.watch(personalEventHomeController);
            final dataStatus =
                compareDate(personalEventCtr.homePersonalEventDetailsModel?.startDateTime);
            final inviteCtr = ref.watch(personalEventGuestInviteController);
            List<PersonalEventInviteList> allGuests =
                inviteCtr.getAllInvitedUsers?.personalEventInviteList ?? []; // ALL Users
            // List<PersonalEventInviteList> accepted = allGuests
            //     .where((guest) =>
            //         guest.isCoHost != true && guest.inviteStatus == 2 || guest.isCoHost == true)
            //     .toList();
            int? loginUserId = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));

            List<PersonalEventInviteList> filterallGuests = allGuests
                .where((guest) => guest.inviteStatus == 2) // Only accepted guests
                .toList()
              ..sort((a, b) => b.isCoHost! ? 1 : -1); // Ensure co-hosts come first
            List<PersonalEventInviteList> accepted = filterallGuests.where((guest) {
              // Ensure guest.inviteStatus is accepted (2)
              bool isAccepted = guest.inviteStatus == 2;
              // Ensure inviteTo is not the current user
              bool isNotCurrentUser = guest.inviteTo?.userId != loginUserId;
              return isAccepted && isNotCurrentUser;
            }).toList();
            List<PersonalEventInviteList> pendingUser = allGuests
                .where((guest) => guest.isCoHost != true && guest.inviteStatus == 1)
                .toList();
            List<PersonalEventInviteList> declineUser = allGuests
                .where((guest) => guest.isCoHost != true && guest.inviteStatus == 3)
                .toList();
            final totalGuest = accepted.length + pendingUser.length + declineUser.length;
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
                          "${TNavigationTitleStrings.inviteGuests} ($totalGuest)",
                          style: getBoldStyle(
                              fontSize: MyFonts.size12, color: TAppColors.inputPlaceHolderColor),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!dataStatus)
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
                        if (dataStatus)
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

                // SizedBox(height: 15.h),
                // // Section for Accepted Co-Hosts with ExpansionTile
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       isCoHostExpanded = !isCoHostExpanded; // Only toggles Co-Host section
                //     });
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text(
                //         "${TNavigationTitleStrings.coHostGuests} (${acceptedHost.length})",
                //         style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                //       ),
                //       Icon(
                //         isCoHostExpanded
                //             ? Icons.keyboard_arrow_down_rounded
                //             : Icons.keyboard_arrow_right_rounded,
                //         color: TAppColors.greyText,
                //       ),
                //     ],
                //   ),
                // ),
                // if (isCoHostExpanded)
                //   Padding(
                //     padding: EdgeInsets.only(top: 10.h),
                //     child: ListView.separated(
                //       padding: EdgeInsets.zero,
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemBuilder: (context, index) {
                //         PersonalEventInviteList model = acceptedHost[index];
                //         return PersonalEventAcceptedInvitesCoHostWidget(
                //           guestName: model.inviteTo?.displayName ?? model.email ?? "Co-host",
                //           inviteId: model.personalEventInviteId ?? 0,
                //           phNumber: model.mobile ?? model.inviteTo?.contactNumber,
                //           imageUrl: model.inviteTo?.profileImageUrl,
                //           isCohost: model.isCoHost ?? false,
                //         );
                //       },
                //       separatorBuilder: (context, index) => SizedBox(height: 20.h),
                //       itemCount: acceptedHost.length,
                //     ),
                //   ),

                accepted.isNotEmpty ? SizedBox(height: 10.h) : SizedBox(height: 10.h),

                // Accepted Al  User ---
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
                            style:
                                getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
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
                    InkWell(
                      onTap: () {},
                      child: Container(
                          color: TAppColors.white,
                          child: Image.asset(
                            TImageName.notificationBell,
                            width: 16.w,
                            height: 16.h,
                          )),
                    )
                  ],
                ),
                accepted.isNotEmpty ? SizedBox(height: 10.h) : SizedBox(height: 10.h),
                if (isGuestExpanded)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, bottom: 15),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        PersonalEventInviteList model = accepted[index];
                        final userName = [model.inviteTo?.firstName, model.inviteTo?.lastName]
                            .where((name) =>
                                name != null &&
                                name.trim().isNotEmpty) // Remove null and empty values
                            .join(" ");
                        return PersonalEventAcceptedInvitesGuestsWidget(
                          userID: model.inviteTo?.userId ?? 0,
                          guestName: userName,
                          inviteId: model.personalEventInviteId ?? 0,
                          email: model.inviteTo?.email ?? "",
                          imageUrl: model.inviteTo?.profileImageUrl,
                          isCohost: model.isCoHost ?? false,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 20.h),
                      itemCount: accepted.length,
                    ),
                  ),

                // Decline All User ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isDeclineExpanded = !isDeclineExpanded; // Only toggles Co-Host section
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${TNavigationTitleStrings.inviteDelined} (${declineUser.length})",
                            style:
                                getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                          ),
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
                    padding: EdgeInsets.only(top: 10.h),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        PersonalEventInviteList model = declineUser[index];
                        final userName = [model.inviteTo?.firstName, model.inviteTo?.lastName]
                            .where((name) =>
                                name != null &&
                                name.trim().isNotEmpty) // Remove null and empty values
                            .join(" ");
                        return PersonalEventDeclineGuestsResultWidget(
                          invitedGuestModel: model,
                          followingStatus: model.inviteTo!.followingStatus,
                          invitestatus: model.inviteStatus,
                          email: model.inviteTo?.email ?? "",
                          personalEventInviteId: model.personalEventInviteId,
                          imageUrl: model.inviteTo?.profileImageUrl ?? '',
                          coHostName: userName,
                          isInvited: model.inviteTo == 1 ? true : false,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 20.h),
                      itemCount: declineUser.length,
                    ),
                  ),

                SizedBox(height: 10.h),

                /// Pending User List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPendingExpanded = !isPendingExpanded; // Only toggles Co-Host section
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${TNavigationTitleStrings.pendingGuests} (${pendingUser.length})",
                            style:
                                getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
                          ),
                          Icon(
                            isPendingExpanded
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_right_rounded,
                            color: TAppColors.greyText,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isPendingExpanded)
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        PersonalEventInviteList model = pendingUser[index];
                        final userName = [model.inviteTo?.firstName, model.inviteTo?.lastName]
                            .where((name) =>
                                name != null &&
                                name.trim().isNotEmpty) // Remove null and empty values
                            .join(" ");

                        return PersonalEventPendingGuestsResultWidget(
                          invitedGuestModel: model,
                          followingStatus: model.inviteTo?.followingStatus,
                          email: model.inviteTo?.email ?? "",
                          invitestatus: model.inviteStatus,
                          personalEventInviteId: model.personalEventInviteId,
                          imageUrl: model.inviteTo?.profileImageUrl ?? '',
                          coHostName: userName,
                          //  phNumber: model.inviteTo?.email ?? '',
                          isInvited: model.inviteTo == 1 ? true : false,
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 20.h),
                      itemCount: pendingUser.length,
                    ),
                  ),
              ],
            );
          }));
    });
  }
}
