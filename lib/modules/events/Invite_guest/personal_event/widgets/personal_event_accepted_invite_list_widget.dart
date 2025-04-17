import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/widgets/personal_event_accepted_invite_guests_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';

class PersonalEventAcceptedInviteListWidget extends StatefulWidget {
  const PersonalEventAcceptedInviteListWidget({
    super.key,
  });

  @override
  State<PersonalEventAcceptedInviteListWidget> createState() =>
      _PersonalEventAcceptedInviteListWidgetState();
}

class _PersonalEventAcceptedInviteListWidgetState
    extends State<PersonalEventAcceptedInviteListWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final inviteCtr = ref.watch(personalEventGuestInviteController);
          List<PersonalEventInviteList> accepted = [];
          if (inviteCtr.getAllInvitedUsers != null &&
              inviteCtr.getAllInvitedUsers!.personalEventInviteList != null &&
              inviteCtr.getAllInvitedUsers!.personalEventInviteList!.isNotEmpty) {
            inviteCtr.getAllInvitedUsers?.personalEventInviteList?.forEach((guest) {
              if (guest.inviteStatus == 2) {
                accepted.add(guest);
              }
            });
          }
          return accepted.isNotEmpty
              ? Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          PersonalEventInviteList model = accepted[index];
                          return PersonalEventAcceptedInvitesGuestsWidget(
                            userID: model.inviteTo?.userId ?? 0,
                            guestName: model.inviteTo != null && model.inviteTo?.displayName != null
                                ? model.inviteTo!.displayName!
                                : model.email != null
                                    ? model.email!
                                    : "Guest",
                            inviteId: model.personalEventInviteId ?? 0,
                            email: model.mobile != null
                                ? model.mobile!
                                : model.inviteTo != null && model.inviteTo?.contactNumber != null
                                    ? model.inviteTo!.contactNumber!
                                    : null,
                            imageUrl: model.inviteTo?.profileImageUrl,
                            isCohost: model.isCoHost ?? false,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20.h,
                          );
                        },
                        itemCount: accepted.length),
                  );
                })
              : const SizedBox();
        },
      ),
    );
  }
}
