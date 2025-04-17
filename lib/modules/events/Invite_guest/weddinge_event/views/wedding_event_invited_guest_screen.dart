import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/Invite_guest/weddinge_event/views/wedding_event_invite_guest_by_search_screen.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../controller/wedding_invite_guests_controller.dart';
import '../widgets/wedding_accepted_invite_list_widget.dart';
import '../widgets/not_accepted_invites.dart';
import '../widgets/wedding_guest_list_widget.dart';
import '../widgets/reminder_dialog.dart';
import '../../../../../common/widgets/invite_guest_search_bar_widget.dart';

class WeddingEventInvitedGuestScreen extends ConsumerStatefulWidget {
  const WeddingEventInvitedGuestScreen({required this.title, super.key});
  final String title;

  @override
  ConsumerState<WeddingEventInvitedGuestScreen> createState() =>
      _WeddingEventInvitedGuestScreenState();
}

class _WeddingEventInvitedGuestScreenState extends ConsumerState<WeddingEventInvitedGuestScreen> {
  bool reminderToAll = false;
  final msgCtr = TextEditingController();
  final remCtr = TextEditingController();
  bool? isAnyInvites;

  @override
  void initState() {
    msgCtr.text =
        "Dear [Guest's Name],\n\nThank you again for being a part of our big day, as well as for the wonderful wedding gift. It means so much that you traveled so far to celebrate with us. ";
    remCtr.text =
        "Dear [Guest's Name],\n\nThank you again for being a part of our big day, as well as for the wonderful wedding gift. It means so much that you traveled so far to celebrate with us. ";
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final inviteCtr = ref.watch(weddingEventGuestInviteController);
      print(
          'Wedding Header ID: ${ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString()}');
      inviteCtr.getWeddingInvites(
          weddingHeaderId:
              ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId.toString() ??
                  '',
          ref: ref,
          context: context);
      isAnyInvites = (inviteCtr.getAllInvitedUsers != null &&
          inviteCtr.getAllInvitedUsers!.weddingInviteList != null &&
          inviteCtr.getAllInvitedUsers!.weddingInviteList!.isNotEmpty);
    });
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: PopScope(
        canPop: !ref.read(personalEventGuestInviteController).isFindGuest,
        onPopInvoked: (didPop) {
          if (ref.read(personalEventGuestInviteController).isFindGuest) {
            ref.watch(personalEventGuestInviteController).setFindGuest(false);
          } else {}
        },
        child: Scaffold(
          backgroundColor: TAppColors.white,
          body: Column(
            children: [
              topPadding(topPadding: 0, offset: 30),
              CustomAppBar(
                onTap: () {
                  if (ref.read(personalEventGuestInviteController).isFindGuest) {
                    ref.watch(personalEventGuestInviteController).setFindGuest(false);
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                  }
                },
                title: TNavigationTitleStrings.inviteGuests,
                hasSubTitle: true,
                subtitle: widget.title,
              ),
              CommonInviteGuestSearchbarWidget(title: widget.title, isPersonal: false),
              SizedBox(
                height: 15.h,
              ),
              if (!ref.watch(personalEventGuestInviteController).isFindGuest)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Invited Guest',
                        //         style: getBoldStyle(
                        //             fontSize: MyFonts.size12, color: TAppColors.greyText),
                        //       ),
                        //       if (!reminderToAll)
                        //         InkWell(
                        //           onTap: () async {
                        //             await showRemDialog(context);
                        //             setState(() {
                        //               reminderToAll = true;
                        //             });
                        //           },
                        //           child: Container(
                        //             color: TAppColors.white,
                        //             child: Row(
                        //               children: [
                        //                 Image.asset(TImageName.notificationBell,
                        //                     color: TAppColors.selectionColor,
                        //                     width: 14.w,
                        //                     height: 14.h),
                        //                 SizedBox(
                        //                   width: 6.w,
                        //                 ),
                        //                 Text(
                        //                   'Reminder to All',
                        //                   style: getSemiBoldStyle(
                        //                       fontSize: MyFonts.size12, color: TAppColors.appColor),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       if (reminderToAll)
                        //         InkWell(
                        //           onTap: () async {
                        //             await showMsgDialog(context);
                        //           },
                        //           child: Container(
                        //             color: TAppColors.white,
                        //             child: Row(
                        //               children: [
                        //                 Image.asset(TImageName.thankYouIcon,
                        //                     color: TAppColors.greyText, width: 14.w, height: 14.h),
                        //                 SizedBox(
                        //                   width: 6.w,
                        //                 ),
                        //                 Text(
                        //                   'Thank You Message',
                        //                   style: getSemiBoldStyle(
                        //                       fontSize: MyFonts.size12, color: TAppColors.appColor),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 15.h,
                        // ),
                        // const WeddingAcceptedInviteListWidget(),
                        WeddingGuestListWidget(
                          isAllReminded: reminderToAll,
                          onTap: () async {
                            await showMsgDialog(context);
                          },
                          onReminder: () async {
                            await showRemDialog(context);
                            setState(() {
                              reminderToAll = true;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        // const NotAcceptedGesutsWidget(),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ),
              if (ref.watch(personalEventGuestInviteController).isFindGuest)
                Flexible(
                    child: WeddingEventInviteGuestBySearchScreen(
                  searchCtr: ref.watch(personalEventGuestInviteController).searchCtr.text,
                )),
              SizedBox(
                height: 3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
