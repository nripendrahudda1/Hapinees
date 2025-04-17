import 'package:Happinest/models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/send_wedding_invite_post_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingSearchResultWidget extends StatefulWidget {
  const WeddingSearchResultWidget(
      {super.key,
      required this.coHostName,
      this.imageUrl,
      this.phNumber,
      this.folllwingstatus,
      this.isInvited = false,
      required this.autherModel,
      required this.searchtext});
  final String coHostName;
  final String? imageUrl;
  final String? phNumber;
  final int? folllwingstatus;
  final HappinestAuthor /*AuthorYouFollow*/ autherModel;
  final bool isInvited;
  final String searchtext;

  @override
  State<WeddingSearchResultWidget> createState() => _WeddingSearchResultWidgetState();
}

class _WeddingSearchResultWidgetState extends State<WeddingSearchResultWidget> {
  bool isInvitedBool = false;
  @override
  void initState() {
    isInvitedBool = widget.isInvited;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('searchtext ***********${widget.searchtext}');
    return Container(
      color: TAppColors.white,
      child: Row(
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
          const Spacer(),
          // if (!isInvitedBool)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final personalInviteCtr = ref.watch(personalEventGuestInviteController);
              final inviteCtr = ref.watch(weddingEventGuestInviteController);
              final weddingCtr = ref.watch(weddingEventHomeController);
              return GestureDetector(
                onTap: () async {
                  print('tapped');
                  SendWeddingInvitePostModel model = SendWeddingInvitePostModel(
                    weddingHeaderId: weddingCtr.homeWeddingDetails?.weddingHeaderId,
                    weddingInvites: [
                      WeddingInvite(
                        email: widget.autherModel.email,
                        inviteTo: widget.autherModel.userId,
                        mobile: widget.autherModel.contactNumber ?? '',
                      )
                    ],
                    invitedOn: DateTime.now(),
                  );
                  await inviteCtr.sendWeddingInvite(
                      sendWeddingInvitePostModel: model, ref: ref, context: context);
                  setState(() {
                    isInvitedBool = !isInvitedBool;
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                      await personalInviteCtr.getAllSearchedPersonalEventInviteUsers(
                          personalEventHeaderId: ref
                                  .read(weddingEventHomeController)
                                  .homeWeddingDetails
                                  ?.weddingHeaderId
                                  .toString() ??
                              '',
                          searchWord: widget.searchtext,
                          offset: 0,
                          noOfRecords: 10000,
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
