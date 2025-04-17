import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../location/location_client.dart';
import '../../../../../models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';

class PersonalEventPendingSearchResultWidget extends StatefulWidget {
  const PersonalEventPendingSearchResultWidget(
      {super.key,
      required this.coHostName,
      this.imageUrl,
      this.email,
      this.isInvited = false,
      required this.invitedGuestModel,
      this.followingStatus,
      this.invitestatus,
      this.personalEventInviteId,
      required this.searchtext});
  final String coHostName;
  final PersonalEventInvitedGuest invitedGuestModel;
  final String? imageUrl;
  final String? email;
  final int? followingStatus;
  final int? invitestatus;
  final int? personalEventInviteId;
  final bool isInvited;
  final String searchtext;

  @override
  State<PersonalEventPendingSearchResultWidget> createState() =>
      _PersonalEventPendingSearchResultWidgetState();
}

class _PersonalEventPendingSearchResultWidgetState
    extends State<PersonalEventPendingSearchResultWidget> {
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
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await inviteCtr.getAllSearchedPersonalEventInviteUsers(
            personalEventHeaderId: ref
                    .read(personalEventHomeController)
                    .homePersonalEventDetailsModel
                    ?.personalEventHeaderId
                    .toString() ??
                '',
            searchWord: widget.searchtext,
            offset: 0,
            noOfRecords: 1000,
            ref: ref);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherUserprofilescreen(
                            userID: widget.invitedGuestModel.userEntity?.userId.toString(),
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
                    style:
                        getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
                  ),
                if (widget.email != null)
                  Text(
                    widget.email!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: getRobotoMediumStyle(fontSize: MyFonts.size12, color: TAppColors.black),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          if (widget.invitestatus == 2)
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return GestureDetector(
                  onTap: () async {
                    final inviteCtr = ref.watch(personalEventGuestInviteController);
                    final personalEventCtr = ref.watch(personalEventHomeController);
                    print('tapped');
                    ActionOnPersonalEventInvitePostModel model =
                        ActionOnPersonalEventInvitePostModel(
                      personalEventHeaderId:
                          personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId,
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
                          eventHeaderId: personalEventCtr
                                  .homePersonalEventDetailsModel?.personalEventHeaderId
                                  .toString() ??
                              "",
                          isLoaderShow: true,
                          ref: ref,
                          context: context);
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                        await inviteCtr.getAllSearchedPersonalEventInviteUsers(
                            personalEventHeaderId: ref
                                    .read(personalEventHomeController)
                                    .homePersonalEventDetailsModel
                                    ?.personalEventHeaderId
                                    .toString() ??
                                '',
                            searchWord: widget.searchtext,
                            offset: 0,
                            noOfRecords: 1000,
                            ref: ref);
                      });
                    });
                  },
                  child: TCard(
                      border: true,
                      borderColor: TAppColors.selectionColor,
                      color: Colors.transparent,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          child: Text(TLabelStrings.invited,
                              style: getRobotoMediumStyle(
                                fontSize: MyFonts.size12,
                                color: TAppColors.selectionColor,
                              )))),
                );
              },
            ),
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
      ),
    );
  }
}
