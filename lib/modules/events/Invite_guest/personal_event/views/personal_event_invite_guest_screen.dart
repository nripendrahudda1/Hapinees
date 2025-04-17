import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/views/personal_event_invite_guest_by_search_screen.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/event_invited_guest_list_widget.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../../../../../common/common_functions/topPadding.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../weddinge_event/widgets/reminder_dialog.dart';
import '../../../../../common/widgets/invite_guest_search_bar_widget.dart';

class PersonalEventInvitedGuestScreen extends ConsumerStatefulWidget {
  const PersonalEventInvitedGuestScreen({required this.title, super.key});
  final String title;

  @override
  ConsumerState<PersonalEventInvitedGuestScreen> createState() =>
      _PersonalEventInvitedGuestScreenState();
}

class _PersonalEventInvitedGuestScreenState extends ConsumerState<PersonalEventInvitedGuestScreen> {
  bool reminderToAll = false;
  final msgCtr = TextEditingController();
  final remCtr = TextEditingController();
  bool? isAnyInvites;

  @override
  void initState() {
    msgCtr.text = TMessageStrings.thanksMessage;
    remCtr.text = TMessageStrings.thanksinderRemMessage;
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final inviteCtr = ref.watch(personalEventGuestInviteController);
      final personalEventCtr = ref.watch(personalEventHomeController);
      print(
          'Wedding Header ID: ${ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventHeaderId.toString()}');
      inviteCtr.getPersonalEventInvites(
          eventHeaderId: ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventHeaderId
                  .toString() ??
              '',
          ref: ref,
          isLoaderShow: true,
          context: context);
      final dataStatus = compareDate(personalEventCtr.homePersonalEventDetailsModel?.startDateTime);

      inviteCtr.getEmailTemplateData(
          eventHeaderId: ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventHeaderId
                  .toString() ??
              '',
          templateType: !dataStatus
              ? EmailTemplateTypeEnum.eventReminder.type
              : EmailTemplateTypeEnum.eventThankYou.type,
          ref: ref,
          isLoaderShow: true,
          context: context);

      isAnyInvites = (inviteCtr.getAllInvitedUsers != null &&
          inviteCtr.getAllInvitedUsers!.personalEventInviteList != null &&
          inviteCtr.getAllInvitedUsers!.personalEventInviteList!.isNotEmpty);
    });
  }

  @override
  void dispose() {
    msgCtr.dispose();
    remCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !ref.read(personalEventGuestInviteController).isFindGuest,
      onPopInvoked: (didPop) {
        if (ref.read(personalEventGuestInviteController).isFindGuest) {
          ref.watch(personalEventGuestInviteController).setFindGuest(false);
        } else {}
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
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
              CommonInviteGuestSearchbarWidget(title: widget.title, isPersonal: true),
              SizedBox(
                height: 15.h,
              ),
              if (!ref.watch(personalEventGuestInviteController).isFindGuest)
                const Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        PersonalEventInvitedListWidget(),
                      ],
                    ),
                  ),
                ),
              if (ref.watch(personalEventGuestInviteController).isFindGuest)
                const Flexible(child: PersonalEventInviteGuestBySearchScreen()),
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
