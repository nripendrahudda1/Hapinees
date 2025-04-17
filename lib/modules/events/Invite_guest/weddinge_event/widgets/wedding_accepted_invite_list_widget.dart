import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import '../controller/wedding_invite_guests_controller.dart';
import 'wedding_accepted_invite_guests_widget.dart';

class WeddingAcceptedInviteListWidget extends StatefulWidget {
  const WeddingAcceptedInviteListWidget({
    super.key,
  });

  @override
  State<WeddingAcceptedInviteListWidget> createState() =>
      _WeddingAcceptedInviteListWidgetState();
}

class _WeddingAcceptedInviteListWidgetState extends State<WeddingAcceptedInviteListWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final inviteCtr = ref.watch(weddingEventGuestInviteController);
          List<WeddingInviteList> accepted = [];
          if (inviteCtr.getAllInvitedUsers != null &&
              inviteCtr.getAllInvitedUsers!.weddingInviteList != null &&
              inviteCtr.getAllInvitedUsers!.weddingInviteList!.isNotEmpty) {
            inviteCtr.getAllInvitedUsers?.weddingInviteList?.forEach((guest) {
              if (guest.inviteStatus == 2) {
                accepted.add(guest);
              }
            });
          }
          return accepted.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Row(
                        children: [
                          Text(
                            'Yes (${accepted.length})  ',
                            style: getSemiBoldStyle(
                                fontSize: MyFonts.size12,
                                color: TAppColors.greyText),
                          ),
                        ],
                      ),
                    ),
                    Consumer(builder: (BuildContext context, WidgetRef ref,
                            Widget? child) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              WeddingInviteList model = accepted[index];
                              return WeddingAcceptedInvitesGuestsWidget(
                                guestName: model.inviteTo != null &&
                                        model.inviteTo?.displayName != null
                                    ? model.inviteTo!.displayName!
                                    : model.email != null
                                        ? model.email!
                                        : "Guest",
                                inviteId: model.weddingInviteId ?? 0,
                                phNumber: model.mobile != null
                                    ? model.mobile!
                                    : model.inviteTo != null &&
                                            model.inviteTo?.contactNumber !=
                                                null
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
                    }
                        )
                  ],
                )
              : const SizedBox();
        },
      ),
    );
  }
}
