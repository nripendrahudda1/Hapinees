import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_panding_search_result_widget.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_searched_result_widget.dart';
import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/reminder_dialog.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../widgets/personal_event_accepted_invite_cohost_widget.dart';
import '../widgets/personal_event_accepted_invite_guests_widget.dart';

class PersonalEventInviteGuestBySearchScreen extends ConsumerStatefulWidget {
  const PersonalEventInviteGuestBySearchScreen({super.key});

  @override
  ConsumerState<PersonalEventInviteGuestBySearchScreen> createState() =>
      _EventInviteGuestBySearchScreenState();
}

class _EventInviteGuestBySearchScreenState
    extends ConsumerState<PersonalEventInviteGuestBySearchScreen> {
  bool reminderToAll = false;
  bool isGuestExpanded = false;
  bool isAuthorExpanded = false; // Default: expanded
  bool isdeclineExpanded = false;
  bool ispendingExpanded = false;
  bool issearcResultExpanded = true;

  final msgCtr = TextEditingController();
  final remCtr = TextEditingController();

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

  // @override
  // void initState() {
  //   super.initState();
  //   initialize();
  // }
  //
  // initialize(){
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     ref.watch(personalEventGuestInviteController).setSearchedPersonalEventInvitesModel(null);
  //     // ref.read(personalEventGuestInviteController).getAllSearchedPersonalEventInviteUsers(
  //     //     personalEventHeaderId: ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventHeaderId.toString() ?? '',
  //     //     searchWord: '',
  //     //     offset: 0,
  //     //     noOfRecords: 10000,
  //     //     ref: ref,
  //     //     context: context
  //     // );
  //   });
  // }
  //
  //
  // onSearch({required String val}){
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
  //     await ref.read(personalEventGuestInviteController).getAllSearchedPersonalEventInviteUsers(
  //         personalEventHeaderId: ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventHeaderId.toString() ?? '',
  //         searchWord: val,
  //         offset: 0,
  //         noOfRecords: 10000,
  //         ref: ref,
  //         context: context
  //     );
  //   });
  // }
  //
  //
  // @override
  // void dispose() {
  //   searchCtr.dispose();
  //   super.dispose();
  // }

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

  Widget showALlSataus(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min, // Ensures the row takes only necessary space
          children: [
            Text(
              "${TNavigationTitleStrings.acceptedGuests} (${0})",
              style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
              textAlign: TextAlign.left,
            ),
            SizedBox(width: 2.h), // Adds space between text and icon
            const Icon(
              Icons.keyboard_arrow_right_rounded, // Arrow icon
              color: TAppColors.greyText, // Adjust color if needed
            ),
          ],
        ),
        SizedBox(height: 10.w),
        Row(
          mainAxisSize: MainAxisSize.min, // Ensures the row takes only necessary space
          children: [
            Text(
              "${TNavigationTitleStrings.inviteDelined} (${0})",
              style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 2.h), // Adds space between text and icon
            const Icon(
              Icons.keyboard_arrow_right_rounded, // Arrow icon
              color: TAppColors.greyText, // Adjust color if needed
            ),
          ],
        ),
        SizedBox(height: 10.w),
        Row(
          mainAxisSize: MainAxisSize.min, // Ensures the row takes only necessary space
          children: [
            Text(
              "${TNavigationTitleStrings.pendingGuests} (${0})",
              style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.greyText),
              textAlign: TextAlign.center,
            ),
            SizedBox(width: 2.h), // Adds space between text and icon
            const Icon(
              Icons.keyboard_arrow_right_rounded, // Arrow icon
              color: TAppColors.greyText, // Adjust color if needed
            ),
          ],
        ),
        SizedBox(height: 10.w),
      ],
    );
  }

  Widget reminderButton(BuildContext context, int totalCount, bool reminderStatus) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "${TNavigationTitleStrings.inviteGuests} (${totalCount})",
              style:
                  getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.inputPlaceHolderColor),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!reminderStatus)
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
                        style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.appColor),
                      ),
                    ],
                  ),
                ),
              ),
            if (reminderStatus)
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
                        style:
                            getSemiBoldStyle(fontSize: MyFonts.size12, color: TAppColors.appColor),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final personalEventCtr = ref.watch(personalEventHomeController);
          final dataStatus =
              compareDate(personalEventCtr.homePersonalEventDetailsModel?.startDateTime);
          List<HappinestAuthor> searchedAuthors = (ref
                      .watch(personalEventGuestInviteController)
                      .searchedPersonalEventInvitesModel
                      ?.happinestAuthors ??
                  []) // Ensure it's not null
              .where((author) => author.userId != loginUserId)
              .toList();

          List<PersonalEventInvitedGuest> searchedInvitedGuests = ref
                  .watch(personalEventGuestInviteController)
                  .searchedPersonalEventInvitesModel
                  ?.personalEventInvitedGuests ??
              [];
          List<PersonalEventInvitedGuest> acceptedGuests = searchedInvitedGuests
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 2)
              .toList();

          List<PersonalEventInvitedGuest> pendingGuests = searchedInvitedGuests
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 1)
              .toList();
          List<PersonalEventInvitedGuest> declineGuests = searchedInvitedGuests
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 3)
              .toList();
          int totalGuests = searchedInvitedGuests.length + searchedAuthors.length;

          return searchedInvitedGuests.isEmpty && searchedAuthors.isEmpty
              ? const SizedBox.shrink()
              : searchedInvitedGuests.isNotEmpty || searchedAuthors.isNotEmpty
                  ? Container(
                      color: Colors.white,
                      // Seach New User List with Author
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            //Invited and accesped it

                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: reminderButton(context, totalGuests, dataStatus),
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isGuestExpanded =
                                      !isGuestExpanded; // Only toggles Co-Host section
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${TNavigationTitleStrings.acceptedGuests} (${acceptedGuests.length})",
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size12, color: TAppColors.greyText),
                                    ),
                                    Icon(
                                      isGuestExpanded
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_right_rounded,
                                      color: TAppColors.greyText,
                                    ),
                                    // const Spacer(),
                                    // Image.asset(TImageName.notificationBell,
                                    //     color: TAppColors.selectionColor,
                                    //     width: 14.w,
                                    //     height: 14.h),
                                  ],
                                ),
                              ),
                            ),
                            if (isGuestExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = acceptedGuests[index];
                                      final userName = [
                                        model.userEntity?.firstName,
                                        model.userEntity?.lastName
                                      ]
                                          .where((name) =>
                                              name != null &&
                                              name
                                                  .trim()
                                                  .isNotEmpty) // Remove null and empty values
                                          .join(" ");
                                      return PersonalEventAcceptedInvitesGuestsWidget(
                                        guestName: userName,
                                        inviteId: model.personalEventInviteId ?? 0,
                                        email: model.userEntity?.email,
                                        imageUrl: model.userEntity?.profileImageUrl,
                                        isCohost: model.isCoHost ?? false,
                                        userID: model.userEntity?.userId ?? 0,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: acceptedGuests.length),
                              ),

                            SizedBox(height: 10.h),

                            /// declineUser List User Lsit
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isdeclineExpanded =
                                      !isdeclineExpanded; // Only toggles Co-Host section
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${TNavigationTitleStrings.inviteDelined} (${declineGuests.length})",
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size12, color: TAppColors.greyText),
                                    ),
                                    Icon(
                                      isdeclineExpanded
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_right_rounded,
                                      color: TAppColors.greyText,
                                    ),
                                    // const Spacer(),
                                    // Image.asset(TImageName.notificationBell,
                                    //     color: TAppColors.selectionColor,
                                    //     width: 14.w,
                                    //     height: 14.h),
                                  ],
                                ),
                              ),
                            ),
                            //  Decline Guest Lst
                            if (isdeclineExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = declineGuests[index];
                                      final userName = [
                                        model.userEntity?.firstName,
                                        model.userEntity?.lastName
                                      ]
                                          .where((name) =>
                                              name != null &&
                                              name
                                                  .trim()
                                                  .isNotEmpty) // Remove null and empty values
                                          .join(" ");
                                      return PersonalEventPendingSearchResultWidget(
                                        invitedGuestModel: model,
                                        email: model.userEntity?.email ?? '',
                                        searchtext: ref
                                            .watch(personalEventGuestInviteController)
                                            .searchCtr
                                            .text,
                                        followingStatus: model.userEntity!.followingStatus,
                                        invitestatus: 3,
                                        personalEventInviteId: model.personalEventInviteId,
                                        imageUrl: model.userEntity?.profileImageUrl ?? '',
                                        coHostName: userName,
                                        isInvited: true,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: declineGuests.length),
                              ),
                            SizedBox(height: 10.h),

                            /// Pending  User Lsit
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  ispendingExpanded =
                                      !ispendingExpanded; // Only toggles Co-Host section
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${TNavigationTitleStrings.pendingGuests} (${pendingGuests.length})",
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size12, color: TAppColors.greyText),
                                    ),
                                    Icon(
                                      ispendingExpanded
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_right_rounded,
                                      color: TAppColors.greyText,
                                    ),
                                    // const Spacer(),
                                    // Image.asset(TImageName.notificationBell,
                                    //     color: TAppColors.selectionColor,
                                    //     width: 14.w,
                                    //     height: 14.h),
                                  ],
                                ),
                              ),
                            ),
                            //  Pending User List
                            if (ispendingExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = pendingGuests[index];
                                      final userName = [
                                        model.userEntity?.firstName,
                                        model.userEntity?.lastName
                                      ]
                                          .where((name) =>
                                              name != null &&
                                              name
                                                  .trim()
                                                  .isNotEmpty) // Remove null and empty values
                                          .join(" ");
                                      return PersonalEventPendingSearchResultWidget(
                                        invitedGuestModel: model,
                                        email: model.userEntity?.email ?? "",
                                        searchtext: ref
                                            .watch(personalEventGuestInviteController)
                                            .searchCtr
                                            .text,
                                        followingStatus: model.userEntity!.followingStatus,
                                        invitestatus: model.inviteStatus,
                                        personalEventInviteId: model.personalEventInviteId,
                                        imageUrl: model.userEntity?.profileImageUrl ?? '',
                                        coHostName: userName,
                                        isInvited: false,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: pendingGuests.length),
                              ),

                            /// Seach Result =====
                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  issearcResultExpanded =
                                      !issearcResultExpanded; // Only toggles Co-Host section
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${TNavigationTitleStrings.searcResult} (${searchedAuthors.length})",
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size12, color: TAppColors.greyText),
                                    ),
                                    Icon(
                                      issearcResultExpanded
                                          ? Icons.keyboard_arrow_down_rounded
                                          : Icons.keyboard_arrow_right_rounded,
                                      color: const Color.fromARGB(255, 179, 179, 179),
                                    ),
                                    // const Spacer(),
                                    // Image.asset(TImageName.notificationBell,
                                    //     color: TAppColors.selectionColor,
                                    //     width: 14.w,
                                    //     height: 14.h),
                                  ],
                                ),
                              ),
                            ),
                            if (issearcResultExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      HappinestAuthor model = searchedAuthors[index];
                                      final userName = [model.firstName, model.lastName]
                                          .where((name) =>
                                              name != null &&
                                              name
                                                  .trim()
                                                  .isNotEmpty) // Remove null and empty values
                                          .join(" ");
                                      return PersonalEventSearchResultWidget(
                                        authorModel: model,
                                        searchtext: ref
                                            .watch(personalEventGuestInviteController)
                                            .searchCtr
                                            .text,
                                        imageUrl: model.profileImageUrl ?? '',
                                        email: model.email ?? "",
                                        coHostName: userName,
                                        isInvited: model.followingStatus == 1 ? true : false,
                                        folllwingstatus: model.followingStatus,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: searchedAuthors.length),
                              ),
                          ],
                        ),
                      ),
                    )
                  : acceptedGuests.isEmpty && pendingGuests.isEmpty
                      ? Container(
                          height: 1.sh,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            // Seach New User List without Author
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: reminderButton(context, totalGuests, dataStatus),
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15), // ✅ Add right padding for centering
                                  child: Container(
                                    width: double.infinity, // ✅ Makes sure content can be centered
                                    alignment: Alignment.topLeft, // ✅ Aligns content to center
                                    child: showALlSataus(context),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      issearcResultExpanded =
                                          !issearcResultExpanded; // Only toggles Co-Host section
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${TNavigationTitleStrings.searcResult} (${searchedAuthors.length})",
                                          style: getBoldStyle(
                                              fontSize: MyFonts.size12, color: TAppColors.greyText),
                                        ),
                                        Icon(
                                          issearcResultExpanded
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right_rounded,
                                          color: const Color.fromARGB(255, 179, 179, 179),
                                        ),
                                        // const Spacer(),
                                        // Image.asset(TImageName.notificationBell,
                                        //     color: TAppColors.selectionColor,
                                        //     width: 14.w,
                                        //     height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),

                                /// New User case
                                if (issearcResultExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          HappinestAuthor model = searchedAuthors[index];
                                          return PersonalEventSearchResultWidget(
                                            authorModel: model,
                                            searchtext: ref
                                                .watch(personalEventGuestInviteController)
                                                .searchCtr
                                                .text,
                                            imageUrl: model.profileImageUrl ?? '',
                                            coHostName: model.displayName ?? '',
                                            isInvited: model.followingStatus == 1 ? true : false,
                                            folllwingstatus: model.followingStatus,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 20.h,
                                          );
                                        },
                                        itemCount: searchedAuthors.length),
                                  ),
                                SizedBox(
                                  height: 15.h,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          /// IF only One user staus is  Pending
                          color: Colors.white,
                          // Seach New User List with Author
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                //Invited and accesped it
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: reminderButton(context, totalGuests, dataStatus),
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isGuestExpanded =
                                          !isGuestExpanded; // Only toggles Co-Host section
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${TNavigationTitleStrings.acceptedGuests} (${acceptedGuests.length})",
                                          style: getBoldStyle(
                                              fontSize: MyFonts.size12, color: TAppColors.greyText),
                                        ),
                                        Icon(
                                          isGuestExpanded
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right_rounded,
                                          color: TAppColors.greyText,
                                        ),
                                        // const Spacer(),
                                        // Image.asset(TImageName.notificationBell,
                                        //     color: TAppColors.selectionColor,
                                        //     width: 14.w,
                                        //     height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),
                                if (isGuestExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          PersonalEventInvitedGuest model = acceptedGuests[index];
                                          return PersonalEventAcceptedInvitesGuestsWidget(
                                            guestName: model.userEntity?.displayName ??
                                                model.userEntity?.email ??
                                                "Co-host",
                                            inviteId: model.personalEventInviteId ?? 0,
                                            email: model.userEntity?.contactNumber,
                                            imageUrl: model.userEntity?.profileImageUrl,
                                            isCohost: model.isCoHost ?? false,
                                            userID: model.userEntity?.userId ?? 0,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 15.h,
                                          );
                                        },
                                        itemCount: acceptedGuests.length),
                                  ),

                                SizedBox(height: 10.h),

                                /// declineUser List User Lsit
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isdeclineExpanded =
                                          !isdeclineExpanded; // Only toggles Co-Host section
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${TNavigationTitleStrings.inviteDelined} (${declineGuests.length})",
                                          style: getBoldStyle(
                                              fontSize: MyFonts.size12, color: TAppColors.greyText),
                                        ),
                                        Icon(
                                          isdeclineExpanded
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right_rounded,
                                          color: TAppColors.greyText,
                                        ),
                                        // const Spacer(),
                                        // Image.asset(TImageName.notificationBell,
                                        //     color: TAppColors.selectionColor,
                                        //     width: 14.w,
                                        //     height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),
                                //  Decline Guest Lst
                                if (isdeclineExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          PersonalEventInvitedGuest model = declineGuests[index];
                                          return PersonalEventPendingSearchResultWidget(
                                            invitedGuestModel: model,
                                            searchtext: ref
                                                .watch(personalEventGuestInviteController)
                                                .searchCtr
                                                .text,
                                            followingStatus: model.userEntity!.followingStatus,
                                            invitestatus: 3,
                                            personalEventInviteId: model.personalEventInviteId,
                                            imageUrl: model.userEntity?.profileImageUrl ?? '',
                                            coHostName: model.userEntity?.displayName ?? '',
                                            isInvited: true,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 15.h,
                                          );
                                        },
                                        itemCount: declineGuests.length),
                                  ),
                                SizedBox(height: 10.h),

                                /// Pending  User Lsit
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ispendingExpanded =
                                          !ispendingExpanded; // Only toggles Co-Host section
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${TNavigationTitleStrings.pendingGuests} (${pendingGuests.length})",
                                          style: getBoldStyle(
                                              fontSize: MyFonts.size12, color: TAppColors.greyText),
                                        ),
                                        Icon(
                                          ispendingExpanded
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right_rounded,
                                          color: TAppColors.greyText,
                                        ),
                                        // const Spacer(),
                                        // Image.asset(TImageName.notificationBell,
                                        //     color: TAppColors.selectionColor,
                                        //     width: 14.w,
                                        //     height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),
                                //  Pending User List
                                if (ispendingExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          PersonalEventInvitedGuest model = pendingGuests[index];
                                          return PersonalEventPendingSearchResultWidget(
                                            invitedGuestModel: model,
                                            searchtext: ref
                                                .watch(personalEventGuestInviteController)
                                                .searchCtr
                                                .text,
                                            followingStatus: model.userEntity!.followingStatus,
                                            invitestatus: model.inviteStatus,
                                            personalEventInviteId: model.personalEventInviteId,
                                            imageUrl: model.userEntity?.profileImageUrl ?? '',
                                            coHostName: model.userEntity?.displayName ?? '',
                                            isInvited: false,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 15.h,
                                          );
                                        },
                                        itemCount: pendingGuests.length),
                                  ),

                                /// Seach Result =====
                                SizedBox(height: 10.h),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      issearcResultExpanded =
                                          !issearcResultExpanded; // Only toggles Co-Host section
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${TNavigationTitleStrings.searcResult} (${searchedAuthors.length})",
                                          style: getBoldStyle(
                                              fontSize: MyFonts.size12, color: TAppColors.greyText),
                                        ),
                                        Icon(
                                          issearcResultExpanded
                                              ? Icons.keyboard_arrow_down_rounded
                                              : Icons.keyboard_arrow_right_rounded,
                                          color: const Color.fromARGB(255, 179, 179, 179),
                                        ),
                                        // const Spacer(),
                                        // Image.asset(TImageName.notificationBell,
                                        //     color: TAppColors.selectionColor,
                                        //     width: 14.w,
                                        //     height: 14.h),
                                      ],
                                    ),
                                  ),
                                ),
                                if (issearcResultExpanded)
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          HappinestAuthor model = searchedAuthors[index];
                                          return PersonalEventSearchResultWidget(
                                            authorModel: model,
                                            searchtext: ref
                                                .watch(personalEventGuestInviteController)
                                                .searchCtr
                                                .text,
                                            imageUrl: model.profileImageUrl ?? '',
                                            coHostName: model.displayName ?? '',
                                            isInvited: model.followingStatus == 1 ? true : false,
                                            folllwingstatus: model.followingStatus,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return SizedBox(
                                            height: 15.h,
                                          );
                                        },
                                        itemCount: searchedAuthors.length),
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
