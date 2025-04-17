import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import '../../../../../models/create_event_models/create_personal_event_models/post_models/make_co_host_personal_event_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/action_on_wedding_invite_post_model.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/make_cohost_wedding_post_model.dart';
import '../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../../personal_event/controller/personal_event_invite_guests_controller.dart';
import '../controller/wedding_invite_guests_controller.dart';


class WeddingEventAcceptedInvitesCoHostWidget extends StatelessWidget {
  const WeddingEventAcceptedInvitesCoHostWidget({
    super.key,
    required this.guestName,
    required this.inviteId,
    required this.isCohost,
    this.imageUrl,
    this.phNumber,
  });
  final String guestName;
  final int inviteId;
  final bool isCohost;
  final String? imageUrl;
  final String? phNumber;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
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
                style: getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.black),
              ),
              SizedBox(
                height: 5.h,
              ),
              if (phNumber != null)
                Text(
                  phNumber!,
                  style: getRobotoMediumStyle(fontSize: MyFonts.size10, color: TAppColors.black),
                ),
            ],
          ),
          const Spacer(),
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
              Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final personalEventCtr = ref.watch(personalEventHomeController);
                  final inviteCtr = ref.watch(personalEventGuestInviteController);
                  return PopupMenuButton<String>(
                    onSelected: (String value) {
                      print(value);
                    },
                    offset: const Offset(-10, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 2,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'remove_guest',
                        height: 30.h,
                        padding: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                            MakeCoHostPersonalEventPostModel model =
                                MakeCoHostPersonalEventPostModel(
                                    personalEventInviteId: inviteId,
                                    personalEventHeaderId: personalEventCtr
                                            .homePersonalEventDetailsModel?.personalEventHeaderId ??
                                        0,
                                    isCoHost: false);
                            await inviteCtr.makePersonalEventCoHost(
                                makeCoHostPersonalEventPostModel: model,
                                ref: ref,
                                context: context);
                          },
                          child: Row(
                            children: [
                              Image.asset(TImageName.deleteOutlineIcon, width: 18.w, height: 18.h),
                              SizedBox(width: 8.w),
                              Text(
                                TButtonLabelStrings.removeGuest,
                                style: getRegularStyle(
                                    color: TAppColors.black, fontSize: MyFonts.size14),
                              ),
                            ],
                          ),
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
                  );
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}
