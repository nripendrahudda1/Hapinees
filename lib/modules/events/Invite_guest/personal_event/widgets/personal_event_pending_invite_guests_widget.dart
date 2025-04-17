import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../location/location_client.dart';
import '../../../../../models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';

class PersonalEventPendingGuestsResultWidget extends StatefulWidget {
  const PersonalEventPendingGuestsResultWidget({
    super.key,
    required this.coHostName,
    this.imageUrl,
    this.email,
    this.isInvited = false,
    required this.invitedGuestModel,
    this.followingStatus,
    this.invitestatus,
    this.personalEventInviteId,
  });
  final String coHostName;
  final PersonalEventInviteList invitedGuestModel;
  final String? imageUrl;
  final String? email;
  final int? followingStatus;
  final int? invitestatus;
  final int? personalEventInviteId;
  final bool isInvited;

  @override
  State<PersonalEventPendingGuestsResultWidget> createState() =>
      _PersonalEventPendingGuestsResultWidgetState();
}

class _PersonalEventPendingGuestsResultWidgetState
    extends State<PersonalEventPendingGuestsResultWidget> {
  bool isInvitedBool = false;
  @override
  void initState() {
    isInvitedBool = widget.isInvited;
    super.initState();
  }

  void showAlertMessage(BuildContext context, bool hideYesButton, WidgetRef ref) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: TButtonLabelStrings.alertMessage,
              actionButtonText: TButtonLabelStrings.yesButton,
              showActionButton: hideYesButton,
              bodyText:
                  hideYesButton ? TMessageStrings.cancelRequest : TMessageStrings.cancelRequest,
              onActionPressed: () {
                apiRequestCall(ref);
              },
            ));
  }

  void apiRequestCall(WidgetRef ref) async {
    final inviteCtr = ref.watch(personalEventGuestInviteController);
    final personalEventCtr = ref.watch(personalEventHomeController);
    print('tapped');
    ActionOnPersonalEventInvitePostModel model = ActionOnPersonalEventInvitePostModel(
      personalEventHeaderId: personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId,
      isCancelRequest: true,
      personalEventInviteId: widget.personalEventInviteId,
      isAccepted: false,
      acceptedRejectedOn: DateTime.now(),
    );
    await inviteCtr.actionOnPersonalEventInvite(
        actionOnPersonalEventInvitePostModel: model, ref: ref, context: context);
    setState(() {
      isInvitedBool = !isInvitedBool;
      inviteCtr.getPersonalEventInvites(
          eventHeaderId:
              personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId.toString() ??
                  "",
          isLoaderShow: true,
          ref: ref,
          context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtherUserprofilescreen(
                          userID: widget.invitedGuestModel.inviteTo?.userId.toString(),
                          author: null,
                        )));
          },
          child: CachedCircularNetworkImageWidget(
            image: widget.imageUrl ?? "",
            size: 36,
            name: widget.coHostName,
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.coHostName.isNotEmpty)
                Text(
                  widget.coHostName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
                ),
              SizedBox(
                height: 5.h,
              ),
              if (widget.email != null)
                Text(
                  widget.email ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: getRobotoMediumStyle(fontSize: MyFonts.size12, color: TAppColors.black),
                ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        if (widget.invitestatus == 1)
          Consumer(
            builder: (context, ref, child) {
              return GestureDetector(
                onTap: () async {
                  print('tapped');
                  showAlertMessage(context, true, ref);
                },
                child: TCard(
                    border: true,
                    borderColor: TAppColors.text4Color,
                    color: Colors.transparent,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        child: Text(TLabelStrings.cancelRequest,
                            style: getRobotoMediumStyle(
                              fontSize: MyFonts.size12,
                              color: TAppColors.text4Color,
                            )))),
              );
            },
          ),
      ],
    );
  }
}
