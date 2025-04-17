import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_hostList_card_widget.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';

class PersonalEventHostListCard extends ConsumerStatefulWidget {
  const PersonalEventHostListCard({
    super.key,
    required this.inviteModel,
    this.indexNumber,
  });

  final PersonalEventInviteList inviteModel;
  final int? indexNumber;
  @override
  ConsumerState<PersonalEventHostListCard> createState() => _PersonalEventHostListCardState();
}

class _PersonalEventHostListCardState extends ConsumerState<PersonalEventHostListCard> {
  bool isFav = false;
  bool isShowReply = false;
  PersonalEventInviteList? commentData;

  switchIsShowReply() {
    setState(() {
      isShowReply = !isShowReply;
    });
  }

  @override
  void initState() {
    setState(() {
      // isFav = widget.commentModel.isLikedBySelf ?? false;
      commentData = widget.inviteModel;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TCard(
          color: TAppColors.transparent,
          border: true,
          borderColor: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedCircularNetworkImageWidget(
                      isWhiteBorder: true,
                      image: widget.inviteModel.inviteTo?.profileImageUrl ?? '',
                      size: 36),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        CommonHostListCard(
                          indexNumber: widget.indexNumber,
                          hostModel: widget.inviteModel,
                          userNumber: "",
                        ),
                      ],
                    ),
                  ),
                ]),
          )),
    );
  }
}
