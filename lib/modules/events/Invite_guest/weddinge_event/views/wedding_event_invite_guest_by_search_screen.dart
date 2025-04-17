import 'dart:developer';

import 'package:Happinest/modules/events/Invite_guest/weddinge_event/widgets/reminder_dialog.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/searched_wedding_invites_model.dart';
import '../../personal_event/controller/personal_event_invite_guests_controller.dart';
import '../controller/wedding_invite_guests_controller.dart';
import '../widgets/wedding_pending_search_result_widget.dart';
import '../widgets/wedding_searched_result_widget.dart';

class WeddingEventInviteGuestBySearchScreen extends ConsumerStatefulWidget {
  final String searchCtr;
  const WeddingEventInviteGuestBySearchScreen({super.key, required this.searchCtr});

  @override
  ConsumerState<WeddingEventInviteGuestBySearchScreen> createState() =>
      _EventInviteGuestBySearchScreenState();
}

class _EventInviteGuestBySearchScreenState
    extends ConsumerState<WeddingEventInviteGuestBySearchScreen> {
  // final searchCtr = TextEditingController();
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
  // @override
  // void initState() {
  //   super.initState();
  //   initiallize();
  // }

  // initiallize(){
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     ref.read(weddingEventGuestInviteController).getAllSearchedWeddingInviteUsers(
  //         weddingHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString() ?? '',
  //         searchWord: '',
  //         offset: 0,
  //         noOfRecords: 10000,
  //         ref: ref,
  //         context: context
  //     );
  //   });
  // }

  // onSearch({required String val}){
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
  //     await ref.read(weddingEventGuestInviteController).getAllSearchedWeddingInviteUsers(
  //         weddingHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString() ?? '',
  //         searchWord: val,
  //         offset: 0,
  //         noOfRecords: 10000,
  //         ref: ref,
  //         context: context
  //     );
  //   });
  // }

  Widget reminderButton(BuildContext context, int totalCount) {
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
                        style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.appColor),
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
                        style: getBoldStyle(fontSize: MyFonts.size12, color: TAppColors.appColor),
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

  @override
  Widget build(BuildContext context) {
    print('searchtext *********** 1 ${widget.searchCtr}');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          print(ref
              .watch(weddingEventGuestInviteController)
              .searchedWeddingInvtesModel
              ?.validationMessage);
          // List<HappinestAuthor> searchedAuthets = ref
          //         .watch(personalEventGuestInviteController)
          //         .searchedPersonalEventInvitesModel
          //         ?.happinestAuthors ??
          //     [];
          List<HappinestAuthor> searchedAuthors = (ref
                      .watch(personalEventGuestInviteController)
                      .searchedPersonalEventInvitesModel
                      ?.happinestAuthors ??
                  []) // Ensure it's not null
              .where((author) => author.userId != loginUserId)
              .toList();

          List<PersonalEventInvitedGuest> searchedInvitedGuestes = ref
                  .watch(personalEventGuestInviteController)
                  .searchedPersonalEventInvitesModel
                  ?.personalEventInvitedGuests ??
              [];
          print("---searchedInvitedGuestes---${searchedInvitedGuestes}");
          List<PersonalEventInvitedGuest> acceptedGuests = searchedInvitedGuestes
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 2)
              .toList();
          List<PersonalEventInvitedGuest> pendingUsers = searchedInvitedGuestes
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 1)
              .toList();
          List<PersonalEventInvitedGuest> declineGuests = searchedInvitedGuestes
              .where((guest) =>
                  guest.inviteStatus != null && guest.isCoHost != true && guest.inviteStatus == 3)
              .toList();

          int totalGuests = searchedInvitedGuestes.length + searchedAuthors.length;

          return searchedInvitedGuestes.isEmpty && searchedAuthors.isEmpty
              ? SizedBox.fromSize()
              : searchedInvitedGuestes.isNotEmpty && searchedAuthors.isNotEmpty
                  ? Container(
                      color: TAppColors.white,
                      // Seach New User List with Author
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              child: reminderButton(context, totalGuests),
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
                                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = acceptedGuests[index];
                                      print('Invited Status: ${model.userEntity?.followingStatus}');
                                      return WeddingPendingSearchResultWidget(
                                        invitedGuestModel: model,
                                        searchtext: widget.searchCtr,
                                        followingStatus: model.userEntity!.followingStatus,
                                        invitestatus: model.inviteStatus,
                                        weddingInviteId: model.personalEventInviteId,
                                        imageUrl: model.userEntity?.profileImageUrl ?? '',
                                        coHostName: model.userEntity?.displayName ?? '',
                                        isInvited: model.inviteStatus == 1 ? true : false,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: acceptedGuests.length),
                              ),

                            /// isNoExpanded User Lsit
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
                            if (isdeclineExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = declineGuests[index];
                                      print('Invited Status: ${model.userEntity?.followingStatus}');
                                      return WeddingPendingSearchResultWidget(
                                        invitedGuestModel: model,
                                        searchtext: widget.searchCtr,
                                        followingStatus: model.userEntity!.followingStatus,
                                        invitestatus: model.inviteStatus,
                                        weddingInviteId: model.personalEventInviteId,
                                        imageUrl: model.userEntity?.profileImageUrl ?? '',
                                        coHostName: model.userEntity?.displayName ?? '',
                                        isInvited: model.inviteStatus == 1 ? true : false,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 20.h,
                                      );
                                    },
                                    itemCount: declineGuests.length),
                              ),

                            SizedBox(height: 10.h),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  //isPendingExpanded
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
                                      "${TNavigationTitleStrings.pendingGuests} (${pendingUsers.length})",
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size12, color: TAppColors.greyText),
                                    ),
                                    Icon(
                                      ispendingExpanded
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
                            if (ispendingExpanded)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      PersonalEventInvitedGuest model = pendingUsers[index];
                                      return WeddingPendingSearchResultWidget(
                                        invitedGuestModel: model,
                                        searchtext: widget.searchCtr,
                                        followingStatus: model.userEntity!.followingStatus,
                                        invitestatus: model.inviteStatus,
                                        weddingInviteId: model.personalEventInviteId,
                                        imageUrl: model.userEntity?.profileImageUrl ?? '',
                                        coHostName: model.userEntity?.displayName ?? '',
                                        isInvited: model.inviteStatus == 1 ? true : false,
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 15.h,
                                      );
                                    },
                                    itemCount: pendingUsers.length),

                                //   print('Following Status: ${model.followingStatus}');
                                //   return WeddingSearchResultWidget(
                                //     autherModel: model,
                                //     imageUrl: model.profileImageUrl ?? '',
                                //     coHostName: model.displayName ?? '',
                                //     searchtext: widget.searchCtr,
                                //     folllwingstatus: model.followStatus,
                                //     isInvited: model.followingStatus == 3 ? true : false,
                                //   );
                                // },
                                // separatorBuilder: (context, index) {
                                //   return SizedBox(
                                //     height: 15.h,
                                //   );
                                // },
                                // itemCount: searchedAuthors.length),
                              ),
                          ],
                        ),
                      ),
                    )
                  : acceptedGuests.isEmpty && pendingUsers.isEmpty
                      ? Container(
                          height: 1.sh,
                          color: TAppColors.white,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: reminderButton(context, totalGuests),
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
                                          return WeddingSearchResultWidget(
                                            autherModel: model,
                                            searchtext: widget.searchCtr,
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
                      : const SizedBox();
        },
      ),
      /*Scaffold(
        backgroundColor: TAppColors.white,
        body:  Column(
          children: [
            topPadding(topPadding: 0,offset: 30),

            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: TNavigationTitleStrings.inviteGuests,
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 5.h),
              child: Expanded(
                child: TCard(
                    height: 44.h,
                    border: true,
                    borderColor: TAppColors.textFieldColor,
                    color: TAppColors.textFieldColor.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            TImageName.search,
                            height: 20,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: CTTextField(
                                  controller: searchCtr,
                                  hint: 'Find Guest',
                                  fontSize: 14.sp,
                                  onEditingComplete: (){
                                    onSearch(val: searchCtr.text);
                                  }
                              )),
                        ],
                      ),
                    )),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            const Divider(
              color: TAppColors.textFieldColor,
            ),
            SizedBox(
              height: 15.h,
            ),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                print(ref.watch(weddingEventGuestInviteController).searchedWeddingInvtesModel?.validationMessage);
                List<AuthorYouFollow> searchedAuthets =  ref.watch(weddingEventGuestInviteController).searchedWeddingInvtesModel?.traveloryAuthors ?? [];
                List<InvitedGuests> searchedInvitedGuestes = ref.watch(weddingEventGuestInviteController).searchedWeddingInvtesModel?.invitedGuests ?? [];
                return
                searchedInvitedGuestes.isEmpty && searchedAuthets.isEmpty ?
                const SizedBox(
                  child: Text("Nothing found!"),
                ):
                searchedInvitedGuestes.isNotEmpty && searchedAuthets.isNotEmpty ?
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 15.w),
                          child:  ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  for (var _ in searchedInvitedGuestes) {
                                    log("searched invited guestes == ${_.userEntity!.displayName} && ${_.inviteStatus}");
                                  }
                                  AuthorYouFollow authmodel = searchedAuthets[index];
                                  InvitedGuests model = searchedInvitedGuestes[index];
                                  print('Invited Status: ${model.userEntity?.followingStatus}');
                                  return WeddingPendingSearchResultWidget(
                                    autherModel: authmodel,
                                    invitedGuestModel: model,
                                    searchtext: searchCtr.text,
                                    followingStatus: model.userEntity!.followingStatus,
                                    invitestatus: model.inviteStatus,
                                    weddingInviteId: model.weddingInviteId,
                                    imageUrl: model.userEntity?.profileImageUrl ?? '',
                                    coHostName: model.userEntity?.displayName ?? '',
                                    isInvited:  model.inviteStatus == 1? true:false ,
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 15.h,
                                  );
                                },
                                itemCount: searchedInvitedGuestes.length),
                          
                        ),
                        // SizedBox(
                        //   height: 15.h,
                        // ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.h, horizontal: 15.w),
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                AuthorYouFollow model = searchedAuthets[index];
                                print('Following Status: ${model.followingStatus}');
                                return WeddingSearchResultWidget(
                                  autherModel: model,
                                  imageUrl: model.profileImageUrl ?? '',
                                  coHostName: model.displayName ?? '',
                                  searchtext: searchCtr.text,
                                  folllwingstatus: model.followStatus,
                                  isInvited:  model.followingStatus == 3? true:false ,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 20.h,
                                );
                              },
                              itemCount: searchedAuthets.length),
                        ),
                      ],
                    ),
                  ),
                ):
                searchedInvitedGuestes.isEmpty && searchedAuthets.isNotEmpty ?
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12.h, horizontal: 15.w),
                          child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                AuthorYouFollow model = searchedAuthets[index];
                                return WeddingSearchResultWidget(
                                  autherModel: model,
                                  searchtext: searchCtr.text,
                                  imageUrl: model.profileImageUrl ?? '',
                                  coHostName: model.displayName ?? '',
                                  isInvited:  model.followingStatus == 1? true:false ,
                                  folllwingstatus: model.followingStatus,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 20.h,
                                );
                              },
                              itemCount: searchedAuthets.length),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ):
                const SizedBox();
              },
            ),
          ],
        ),
      ),*/
    );
  }
}
