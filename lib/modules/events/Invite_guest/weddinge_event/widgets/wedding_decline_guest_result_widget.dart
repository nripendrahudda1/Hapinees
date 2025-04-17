import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingDeclineGuestResultWidget extends StatefulWidget {
  const WeddingDeclineGuestResultWidget(
      {super.key,
      required this.coHostName,
      this.imageUrl,
      this.phNumber,
      this.isInvited = false,
      required this.invitedGuestModel,
      this.invitestatus,
      this.weddingInviteId,
      required this.searchtext});
  final String coHostName;
  final WeddingInviteList invitedGuestModel;
  final String? imageUrl;
  final String? phNumber;
  final int? invitestatus;
  final int? weddingInviteId;
  final bool isInvited;
  final String searchtext;

  @override
  State<WeddingDeclineGuestResultWidget> createState() => _WeddingDeclineGuestResultWidgetState();
}

class _WeddingDeclineGuestResultWidgetState extends State<WeddingDeclineGuestResultWidget> {
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
        CachedCircularNetworkImageWidget(
          image: widget.imageUrl ?? "",
          size: 36,
          name: widget.coHostName,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.coHostName,
              style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (widget.phNumber != null)
              Text(
                widget.phNumber!,
                style: getRobotoMediumStyle(fontSize: MyFonts.size10, color: TAppColors.black),
              ),
          ],
        ),
      ],
    );
  }
}
