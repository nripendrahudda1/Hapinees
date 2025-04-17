import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../../../Invite_guest/weddinge_event/controller/wedding_invite_guests_controller.dart';


class WeddingInviteTopBar extends ConsumerWidget {
  const WeddingInviteTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: TAppColors.white,
          borderRadius: BorderRadius.circular(6.r)
      ),
      child: Row(
        children: [
          CachedCircularNetworkImageWidget(
              image: ref.read(weddingEventHomeController).homeWeddingDetails?.createdBy?.profileImageUrl ?? '',
              size: 36
          ),
          SizedBox(width: 10.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ref.read(weddingEventHomeController).homeWeddingDetails?.createdBy?.displayName ?? '',
                style: getSemiBoldStyle(
                    fontSize: MyFonts.size14
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxWidth: 150.w
                ),
                child: FittedBox(
                  child: Text(
                    'Invited you to this wedding',
                    style: getRegularStyle(
                        fontSize: MyFonts.size12,
                        color: TAppColors.text2Color
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final wedCtr = ref.watch(weddingEventHomeController);
              final inviteCtr = ref.watch(weddingEventGuestInviteController);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      ActionOnWeddingInvitePostModel model = ActionOnWeddingInvitePostModel(
                        weddingHeaderId: wedCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                        weddingInviteId: inviteCtr.inviteId,
                        acceptedRejectedOn: DateTime.now(),
                        isAccepted: true,
                        isCancelRequest: false,

                      );
                      await inviteCtr.actionOnWeddingInviteHome(
                          actionOnWeddingInvitePostModel: model,
                          ref: ref,
                          context: context
                      );
                      inviteCtr.clear();
                    },
                    child: TCard(
                        radius: 6,
                        border: true,
                        borderColor:
                        TAppColors.selectionColor,
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets
                              .symmetric(
                              horizontal: 8.w,
                              vertical: 2.h),
                          child: TText('Accept',
                              color: TAppColors
                                  .selectionColor,
                              fontSize:
                              MyFonts.size12,
                              fontWeight:
                              FontWeight
                                  .w600),
                        )),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () async{
                      ActionOnWeddingInvitePostModel model = ActionOnWeddingInvitePostModel(
                        weddingHeaderId: wedCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                        weddingInviteId: inviteCtr.inviteId,
                        acceptedRejectedOn: DateTime.now(),
                        isAccepted: false,
                        isCancelRequest: true,

                      );
                      await inviteCtr.actionOnWeddingInviteHome(
                          actionOnWeddingInvitePostModel: model,
                          ref: ref,
                          context: context
                      );
                      inviteCtr.clear();
                    },
                    child: TText('Decline',
                        color:
                        TAppColors.selectionColor,
                        fontSize: MyFonts.size12,
                        fontWeight:
                        FontWeight.w600),
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
