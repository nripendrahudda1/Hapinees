
import 'package:Happinest/models/create_event_models/create_personal_event_models/searched_personal_event_invites_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_controller.dart';
import '../../../../../models/create_event_models/create_wedding_models/searched_wedding_invites_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class WeddingPendingSearchResultWidget extends StatefulWidget {
  const WeddingPendingSearchResultWidget(
      {super.key,
      required this.coHostName,
      this.imageUrl,
      this.phNumber,
      this.isInvited = false,
      required this.invitedGuestModel,
      this.followingStatus,
      // required this.autherModel,
      this.invitestatus,
      this.weddingInviteId,
      required this.searchtext});
  final String coHostName;
  final PersonalEventInvitedGuest/*InvitedGuests*/ invitedGuestModel;
  final String? imageUrl;
  final String? phNumber;
  final int? followingStatus;
  final int? invitestatus;
  final int? weddingInviteId;
  final bool isInvited;
  final String searchtext;
  // final HappinestAuthor/*AuthorYouFollow*/ autherModel;

  @override
  State<WeddingPendingSearchResultWidget> createState() =>
      _WeddingPendingSearchResultWidgetState();
}

class _WeddingPendingSearchResultWidgetState extends State<WeddingPendingSearchResultWidget> {
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
              style: getRobotoSemiBoldStyle(
                  fontSize: MyFonts.size14, color: TAppColors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (widget.phNumber != null)
              Text(
                widget.phNumber!,
                style: getRobotoMediumStyle(
                    fontSize: MyFonts.size10, color: TAppColors.black),
              ),
          ],
        ),
        const Spacer(),
        if (widget.invitestatus == 2)
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              return GestureDetector(
                onTap: () async {
                  final personalInviteCtr = ref.watch(personalEventGuestInviteController);
                  final inviteCtr = ref.watch(weddingEventGuestInviteController);
                  final weddingCtr = ref.watch(weddingEventHomeController);
                  print('tapped');
                  ActionOnWeddingInvitePostModel model =
                      ActionOnWeddingInvitePostModel(
                    weddingHeaderId:
                        weddingCtr.homeWeddingDetails?.weddingHeaderId,
                    isCancelRequest: true,
                    weddingInviteId: widget.weddingInviteId,
                    isAccepted: false,
                    acceptedRejectedOn: DateTime.now(),
                  );
                  await inviteCtr.actionOnWeddingInvite(
                      actionOnWeddingInvitePostModel: model,
                      ref: ref,
                      context: context);
                  setState(() {
                    isInvitedBool = !isInvitedBool;
                    inviteCtr.getWeddingInvites(
                        weddingHeaderId: weddingCtr
                                .homeWeddingDetails?.weddingHeaderId
                                .toString() ??
                            "",
                        ref: ref,
                        context: context);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
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
                  final personalInviteCtr = ref.watch(personalEventGuestInviteController);
                  final inviteCtr = ref.watch(weddingEventGuestInviteController);
                  final weddingCtr = ref.watch(weddingEventHomeController);
                  print('tapped');
                  ActionOnWeddingInvitePostModel model =
                      ActionOnWeddingInvitePostModel(
                    weddingHeaderId:
                        weddingCtr.homeWeddingDetails?.weddingHeaderId,
                    isCancelRequest: true,
                    weddingInviteId: widget.weddingInviteId,
                    isAccepted: false,
                    acceptedRejectedOn: DateTime.now(),
                  );
                  await inviteCtr.actionOnWeddingInviteHome(
                      actionOnWeddingInvitePostModel: model,
                      ref: ref,
                      context: context);
                  setState(() {
                    isInvitedBool = !isInvitedBool;
                    inviteCtr.getWeddingInvites(
                        weddingHeaderId: weddingCtr
                                .homeWeddingDetails?.weddingHeaderId
                                .toString() ??
                            "",
                        ref: ref,
                        context: context);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
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
                    borderColor: TAppColors.text4Color,
                    color: Colors.transparent,
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        child: Text(TLabelStrings.cancelRequest,
                            style: getRobotoMediumStyle(
                              fontSize: MyFonts.size12,
                              color: TAppColors.text4Color,
                            )))),
              );
            },
          ),
        // if (widget.followingStatus == 3)
        //   Consumer(
        //     builder: (context, ref, child) {
        //       final inviteCtr = ref.watch(eventGuestInviteController);
        //       final weddingCtr = ref.watch(weddingCreateEventController);
        //       return GestureDetector(
        //         onTap: () async {
        //           print('tapped');
        //           SendWeddingInvitePostModel model = SendWeddingInvitePostModel(
        //             weddingHeaderId:
        //                 weddingCtr.homeWeddingDetails?.weddingHeaderId,
        //             weddingInvites: [
        //               WeddingInvite(
        //                 email: widget.autherModel.email,
        //                 inviteTo: widget.autherModel.userId,
        //                 mobile: widget.autherModel.contactNumber,
        //               )
        //             ],
        //             invitedOn: DateTime.now(),
        //           );
        //           await inviteCtr.sendWeddingInvite(
        //               sendWeddingInvitePostModel: model,
        //               ref: ref,
        //               context: context);
        //           setState(() {
        //             isInvitedBool = !isInvitedBool;
        //             inviteCtr.getAllSearchedWeddingInviteUsers(
        //                 weddingHeaderId: ref
        //                         .read(weddingCreateEventController)
        //                         .homeWeddingDetails
        //                         ?.weddingHeaderId
        //                         .toString() ??
        //                     '',
        //                 searchWord: widget.searchtext,
        //                 offset: 0,
        //                 noOfRecords: 10000,
        //                 ref: ref,
        //                 context: context);
        //           });
        //         },
        //         child: TCard(
        //             border: true,
        //             borderColor: TAppColors.text4Color,
        //             color: Colors.transparent,
        //             child: Padding(
        //                 padding: EdgeInsets.symmetric(
        //                     horizontal: 8.w, vertical: 4.h),
        //                 child: Text(TLabelStrings.cancelRequest,
        //                     style: getRobotoMediumStyle(
        //                       fontSize: MyFonts.size12,
        //                       color: TAppColors.text4Color,
        //                     )))),
        //       );
        //     },
        //   )
      ],
    );
  }
}
