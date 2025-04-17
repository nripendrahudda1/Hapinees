import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../controller/wedding_invite_guests_controller.dart';

class InvitedGuestWidget extends StatelessWidget {
  const InvitedGuestWidget({
    super.key,
      required this.guestName,
      required this.inviteId,
      this.imageUrl,
      this.phNumber,
      required this.isReminded});
  final String guestName;
  final int inviteId;
  final String? imageUrl;
  final String? phNumber;
  final bool isReminded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CachedCircularNetworkImageWidget(
          image: imageUrl ?? "",
          size: 36,
          name: guestName,
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              guestName,
              style: getRobotoSemiBoldStyle(
                  fontSize: MyFonts.size14, color: TAppColors.black),
            ),
            SizedBox(
              height: 5.h,
            ),
            if (phNumber != null)
              Text(
                phNumber!,
                style: getRobotoMediumStyle(
                    fontSize: MyFonts.size10, color: TAppColors.black),
              ),
          ],
        ),
        const Spacer(),
        if (!isReminded)
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                    color: TAppColors.white,
                    child: Image.asset(
                      TImageName.notificationBell,
                      width: 16.w,
                      height: 16.h,
                    )),
              ),
              SizedBox(
                width: 10.w,
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  print(value);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                elevation: 2,
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'remove_guest',
                    height: 30.h,
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Consumer(
                      builder: (BuildContext context, WidgetRef ref, Widget? child) {
                        final inviteCtr = ref.watch(weddingEventGuestInviteController);
                        final weddingCtr = ref.watch(weddingEventHomeController);
                        return GestureDetector(
                          onTap: ()async{
                            ActionOnWeddingInvitePostModel model = ActionOnWeddingInvitePostModel(
                              weddingHeaderId: weddingCtr.homeWeddingDetails?.weddingHeaderId ?? 0,
                              weddingInviteId: inviteId,
                              acceptedRejectedOn: DateTime.now(),
                              isAccepted: false,
                              isCancelRequest: true,

                            );
                            await inviteCtr.actionOnWeddingInvite(
                                actionOnWeddingInvitePostModel: model,
                                ref: ref,
                                context: context
                            );
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Image.asset(TImageName.deleteOutlineIcon,
                                  width: 18.w, height: 18.h),
                              SizedBox(width: 8.w),
                              Text(
                                'Remove Guest',
                                style: getRegularStyle(
                                    color: TAppColors.black,
                                    fontSize: MyFonts.size14),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                child: Container(
                    color: TAppColors.white,
                    child: Image.asset(
                      TImageName.moreVertIcon,
                      width: 22.w,
                      height: 22.h,
                    )),
              ),
            ],
          ),
        if (isReminded)
          Row(
            children: [
              Container(
                  color: TAppColors.white,
                  child: Image.asset(
                    TImageName.thankYouIcon,
                    width: 18.w,
                    height: 18.h,
                  )),
              SizedBox(
                width: 5.w,
              ),
            ],
          )
      ],
    );
  }
}
