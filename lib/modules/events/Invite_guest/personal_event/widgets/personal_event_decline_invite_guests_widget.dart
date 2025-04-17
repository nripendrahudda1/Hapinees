import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';

class PersonalEventDeclineGuestsResultWidget extends StatefulWidget {
  const PersonalEventDeclineGuestsResultWidget({
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
  State<PersonalEventDeclineGuestsResultWidget> createState() =>
      _PersonalEventDeclineGuestsResultWidgetState();
}

class _PersonalEventDeclineGuestsResultWidgetState
    extends State<PersonalEventDeclineGuestsResultWidget> {
  bool isInvitedBool = false;
  @override
  void initState() {
    isInvitedBool = widget.isInvited;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.coHostName.isNotEmpty)
              Text(
                widget.coHostName,
                overflow: TextOverflow.ellipsis,
              maxLines: 1,
                style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
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
      ],
    );
  }
}
