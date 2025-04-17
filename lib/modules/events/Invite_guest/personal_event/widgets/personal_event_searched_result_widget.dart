import 'package:Happinest/models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';

class PersonalEventSearchResultWidget extends StatefulWidget {
  const PersonalEventSearchResultWidget(
      {super.key,
      required this.coHostName,
      this.imageUrl,
      this.email,
      this.folllwingstatus,
      this.isInvited = false,
      required this.authorModel,
      required this.searchtext});
  final String coHostName;
  final String? imageUrl;
  final String? email;
  final int? folllwingstatus;
  final HappinestAuthor authorModel;
  final bool isInvited;
  final String searchtext;

  @override
  State<PersonalEventSearchResultWidget> createState() => _PersonalEventSearchResultWidgetState();
}

class _PersonalEventSearchResultWidgetState extends State<PersonalEventSearchResultWidget> {
  bool isInvitedBool = false;
  @override
  void initState() {
    isInvitedBool = widget.isInvited;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            userID: widget.authorModel.userId.toString(),
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
          // if (!isInvitedBool)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final inviteCtr = ref.watch(personalEventGuestInviteController);
              final personalEventCtr = ref.watch(personalEventHomeController);
              return GestureDetector(
                onTap: () async {
                  print('tapped');
                  SendPersonalEventInvitePostModel model = SendPersonalEventInvitePostModel(
                    personalEventHeaderId:
                        personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId,
                    personalEventInvites: [
                      PersonalEventInvite(
                        email: "", // widget.authorModel.email,
                        inviteTo: widget.authorModel.userId,
                        mobile: "", // widget.authorModel.contactNumber ?? '',
                      )
                    ],
                    inviteStatus: 1,
                    invitedBy: getUserID(),
                    personalEventInviteId: 0,
                    invitedOn: DateTime.now(),
                  );
                  await inviteCtr.sendPersonalEventInvite(
                      sendPersonalEventInvitePostModel: model, ref: ref, context: context);
                  setState(() {
                    isInvitedBool = !isInvitedBool;
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
                        child: Text(TLabelStrings.invite,
                            style: getRobotoMediumStyle(
                              fontSize: MyFonts.size12,
                              color: TAppColors.selectionColor,
                            )))),
              );
            },
          ),
        ],
      ),
    );
  }
}
