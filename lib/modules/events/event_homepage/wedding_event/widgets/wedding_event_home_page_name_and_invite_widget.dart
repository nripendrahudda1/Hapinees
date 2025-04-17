import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/utility/constants/images/image_url.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../../profile/User_profile/User_profile.dart';
import '../controller/wedding_event_home_controller.dart';

class WeddingEventHomePageNameAndInviteWidget extends StatefulWidget {
  const WeddingEventHomePageNameAndInviteWidget({
    super.key,
    required this.title,
    required this.stopPlayer,
  });
  final String title;
  final Function() stopPlayer;

  @override
  State<WeddingEventHomePageNameAndInviteWidget> createState() =>
      _WeddingEventHomePageNameAndInviteWidgetState();
}

class _WeddingEventHomePageNameAndInviteWidgetState
    extends State<WeddingEventHomePageNameAndInviteWidget> {
  bool isFollowed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final weddingEventCtr = ref.watch(weddingEventHomeController);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUserprofilescreen(
                                      userID: weddingEventCtr.homeWeddingDetails?.createdBy?.userId
                                          .toString(),
                                      author: null,
                                    )));
                      },
                      child: CircleAvatar(
                        backgroundColor: TAppColors.white,
                        radius: 18.r,
                        child: CircleAvatar(
                          radius: 17.r,
                          child: CachedCircularNetworkImageWidget(
                            image: weddingEventCtr.homeWeddingDetails?.createdBy?.profileImageUrl ??
                                TImageUrl.personImgUrl,
                            size: 35,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      weddingEventCtr.homeWeddingDetails?.createdBy?.displayName ?? "",
                      style:
                          getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                    ),
                  ],
                ),
                weddingEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type && !isFollowed
                    ? GestureDetector(
                        onTap: () async {
                          print(
                              'Follower ID: ${weddingEventCtr.homeWeddingDetails?.createdBy?.userId.toString()}');
                          await weddingEventCtr.followUser(
                              followerId: weddingEventCtr.homeWeddingDetails?.createdBy?.userId
                                      .toString() ??
                                  '',
                              ref: ref,
                              context: context, followStatus: 1);
                          setState(() {
                            isFollowed = !isFollowed;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: TCard(
                              radius: 6,
                              border: true,
                              borderColor: TAppColors.selectionColor,
                              color: Colors.transparent,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                child: TText(TLabelStrings.follow,
                                    color: TAppColors.selectionColor,
                                    fontSize: MyFonts.size12,
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                      )
                    : const SizedBox(),
              ],
            );
          },
        ),
        SizedBox(
          height: 12.h,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final weddingCtr = ref.watch(weddingEventHomeController);
            List<WeddingInviteList> allGuests =
                (weddingCtr.homeWeddingDetails?.weddingInviteList ?? []); // ALL Users

            List<WeddingInviteList> accepted =
                allGuests.where((guest) => guest.inviteStatus == 2).toList();
            return weddingCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type
                ? const SizedBox()
                : Row(
                    children: [
                      Text(
                        "Guests",
                        style: getSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      accepted.length == null || accepted.length == 0
                          ? const SizedBox()
                          : Stack(
                              children: [
                                SizedBox(
                                  width: accepted.length == 1
                                      ? 30.w
                                      : accepted.length == 2
                                          ? 60.w
                                          : accepted.length == 3
                                              ? 90.w
                                              : 110.w,
                                  height: 36.h,
                                ),
                                CircleAvatar(
                                  backgroundColor: TAppColors.white,
                                  radius: 18.r,
                                  child: CircleAvatar(
                                    radius: 17.r,
                                    child: const CachedCircularNetworkImageWidget(
                                      image: TImageUrl.personImgUrl,
                                      size: 35,
                                    ),
                                  ),
                                ),
                                ...List.generate(
                                  accepted.length > 3
                                      ? 3
                                      : accepted.length ??
                                          0, // Replace numberOfAvatars with the actual number you want
                                  (index) => Positioned(
                                    left: index *
                                        25.5.w, // Adjust the spacing between avatars as needed
                                    child: CircleAvatar(
                                      backgroundColor: TAppColors.white,
                                      radius: 18.r,
                                      child: CircleAvatar(
                                        radius: 17.r,
                                        child: CachedCircularNetworkImageWidget(
                                          image: weddingCtr
                                                  .homeWeddingDetails
                                                  ?.weddingInviteList?[index]
                                                  .inviteTo
                                                  ?.profileImageUrl ??
                                              '', // You can replace this with your actual image source
                                          size: 35,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                accepted.length > 3
                                    ? Positioned(
                                        left: 76.w,
                                        child: GestureDetector(
                                          onTap: () async {
                                            print(
                                                'weddingEventInvitedGuestScreen ****************************');
                                            await widget.stopPlayer();
                                            Navigator.pushNamed(
                                                context, Routes.weddingEventInvitedGuestScreen,
                                                arguments: {"title": widget.title}).then(
                                              (value) {
                                                weddingCtr.getWedding(
                                                    weddingId: weddingCtr
                                                        .homeWeddingDetails!.weddingHeaderId
                                                        .toString(),
                                                    context: context,
                                                    ref: ref);
                                              },
                                            );
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: TAppColors.white,
                                            radius: 18.r,
                                            child: CircleAvatar(
                                              backgroundColor: TAppColors.blackShadow,
                                              radius: 17.r,
                                              child: Text(
                                                "+${weddingCtr.homeWeddingDetails!.weddingInviteList!.length}",
                                                style: getMediumStyle(
                                                    fontSize: MyFonts.size10,
                                                    color: TAppColors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await widget.stopPlayer();
                          Navigator.pushNamed(context, Routes.weddingEventInvitedGuestScreen,
                              arguments: {"title": widget.title});
                        },
                        child: CircleAvatar(
                          backgroundColor: TAppColors.white,
                          radius: 18.r,
                          child: CircleAvatar(
                              backgroundColor: TAppColors.davyGrey,
                              radius: 17.r,
                              child: Center(
                                child: Image.asset(
                                  TImageName.invitePngIcon,
                                  width: 20.w,
                                  height: 20.h,
                                ),
                              )),
                        ),
                      ),
                    ],
                  );
          },
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}
