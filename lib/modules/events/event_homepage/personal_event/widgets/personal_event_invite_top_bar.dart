import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/action_on_personal_invite_post_model.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';
import 'package:Happinest/modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';

class PersonalEventInviteTopBar extends ConsumerWidget {
  final Function() callBack;
  final bool eventStatus;
  const PersonalEventInviteTopBar({super.key, required this.callBack, required this.eventStatus});

  // apiCalltheUpdateInviteStatus(int inviteStatus, WidgetRef ref, BuildContext context) async {
  //   final result = ref.read(personalEventHomeController).homePersonalEventDetailsModel;

  //   await ref.read(personalEventHomeController).updatePersonalEventStatus(
  //       personalEventInviteId: result!.personalEventInviteId.toString(),
  //       inviteStatus: inviteStatus,
  //       context: context,
  //       ref: ref);
  //   if (ref.read(personalEventHomeController).genralModelResponse?.statusCode == 1) {
  //     callBack();
  //   }
  // }

  apiCalltheUpdateInviteStatus(int inviteStatus, WidgetRef ref, BuildContext context) async {
    final personalEventCtr = ref.read(personalEventHomeController).homePersonalEventDetailsModel;
    final inviteCtr = ref.watch(personalEventGuestInviteController);
    SendPersonalEventInvitePostModel model = SendPersonalEventInvitePostModel(
      personalEventHeaderId: personalEventCtr?.personalEventHeaderId ?? 0,
      personalEventInvites: [
        PersonalEventInvite(
          email: "", // widget.authorModel.email,
          inviteTo: getUserID(),
          mobile: "", // widget.authorModel.contactNumber ?? '',
        )
      ],
      inviteStatus: inviteStatus,
      invitedBy: personalEventCtr?.createdBy?.userId ?? 0,
      personalEventInviteId: personalEventCtr?.personalEventInviteId ?? 0,
      invitedOn: DateTime.now(),
    );
    await inviteCtr.sendPersonalEventInvite(
        sendPersonalEventInvitePostModel: model, ref: ref, context: context);
    callBack();
    if (ref.read(personalEventHomeController).genralModelResponse?.statusCode == 1) {
      callBack();
    }

    // await ref.read(personalEventHomeController).updatePersonalEventStatus(
    //     personalEventInviteId: result!.personalEventInviteId.toString(),
    //     inviteStatus: inviteStatus,
    //     context: context,
    //     ref: ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
      decoration: BoxDecoration(color: TAppColors.white, borderRadius: BorderRadius.circular(6.r)),
      child: Row(
        children: [
          CachedCircularNetworkImageWidget(
              image: ref
                      .read(personalEventHomeController)
                      .homePersonalEventDetailsModel
                      ?.createdBy
                      ?.profileImageUrl ??
                  '',
              size: 36),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref
                        .read(personalEventHomeController)
                        .homePersonalEventDetailsModel
                        ?.createdBy
                        ?.displayName ??
                    '',
                style: getSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.text2Color),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 150.w),
                child: FittedBox(
                  child: Text(
                    eventStatus
                        ? TMessageStrings.pastEventBanner
                        : TMessageStrings.futureEventBanner,
                    style: getRegularStyle(fontSize: MyFonts.size12, color: TAppColors.text2Color),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              // final personalEventCtr = ref.watch(personalEventHomeController);
              // final inviteCtr = ref.watch(personalEventGuestInviteController);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      apiCalltheUpdateInviteStatus(2, ref, context);

                      // ActionOnPersonalEventInvitePostModel model =
                      //     ActionOnPersonalEventInvitePostModel(
                      //   personalEventHeaderId:
                      //       personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId ??
                      //           0,
                      //   personalEventInviteId: inviteCtr.inviteId,
                      //   acceptedRejectedOn: DateTime.now(),
                      //   isAccepted: true,
                      //   isCancelRequest: false,
                      // );
                      // await inviteCtr.actionOnPersonalEventInviteHome(
                      //     actionOnPersonalEventInvitePostModel: model, ref: ref, context: context);
                      // inviteCtr.clear();
                    },
                    child: TCard(
                        radius: 6,
                        border: true,
                        borderColor: TAppColors.selectionColor,
                        color: Colors.black,
                        child: Padding(
                          padding: eventStatus
                              ? EdgeInsets.symmetric(horizontal: 15.h, vertical: 3.h)
                              : EdgeInsets.symmetric(horizontal: 10.h, vertical: 3.h),
                          child: TText(
                              eventStatus
                                  ? TButtonLabelStrings.yesButton
                                  : TButtonLabelStrings.acceptButton,
                              color: TAppColors.selectionColor,
                              fontSize: MyFonts.size12,
                              fontWeight: FontWeight.w600),
                        )),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () async {
                      apiCalltheUpdateInviteStatus(3, ref, context);
                      // ActionOnPersonalEventInvitePostModel model =
                      //     ActionOnPersonalEventInvitePostModel(
                      //   personalEventHeaderId:
                      //       personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId ??
                      //           0,
                      //   personalEventInviteId: inviteCtr.inviteId,
                      //   acceptedRejectedOn: DateTime.now(),
                      //   isAccepted: false,
                      //   isCancelRequest: true,
                      // );
                      // await inviteCtr.actionOnPersonalEventInviteHome(
                      //     actionOnPersonalEventInvitePostModel: model, ref: ref, context: context);
                      // inviteCtr.clear();
                    },
                    child: Padding(
                      padding: eventStatus
                          ? EdgeInsets.symmetric(horizontal: 10.h, vertical: 3.h)
                          : EdgeInsets.symmetric(horizontal: 1.h, vertical: 3.h),
                      child: TText(eventStatus ? "No" : TButtonLabelStrings.declineButton,
                          color: TAppColors.selectionColor,
                          fontSize: MyFonts.size14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
