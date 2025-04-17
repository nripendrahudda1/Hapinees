import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/modules/profile/model/follow_user_model.dart';
import 'package:intl/intl.dart';

class FollowingUserRowWidget extends StatelessWidget {
  final FollowUserModel userData;
  final VoidCallback onTap;
  final bool isMyProfile;

  final VoidCallback? onUnfollowTap;

  const FollowingUserRowWidget({
    super.key,
    required this.userData,
    required this.onTap,
    required this.isMyProfile,
    this.onUnfollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CachedCircularNetworkImageWidget(
            isWhiteBorder: false,
            image: userData.userDetail?.profileImageUrl ?? '',
            size: 50,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TText(
                  userData.userDetail?.displayName ?? "",
                  color: TAppColors.black,
                  fontWeight: FontWeight.bold,
                  // overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  fontSize: MyFonts.size16,
                ),
                if (userData.userDetail?.requestedDate != null &&
                    userData.userDetail!.requestedDate!.isNotEmpty)
                  const SizedBox(width: 10),
                TText(
                  DateFormat('MMM d, y').format(
                    DateTime.parse(userData.userDetail!.requestedDate!),
                  ),
                  color: TAppColors.black,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  fontSize: MyFonts.size12,
                ),
              ],
            ),
          ),
          if (isMyProfile)
            Builder(
              builder: (context) {
                final followingStatus = userData.userDetail?.followingStatus;
                if (followingStatus == 2) {
                  return GestureDetector(
                    onTap: onUnfollowTap,
                    child: TCard(
                      radius: 6,
                      height: 28.h,
                      border: true,
                      shadow: true,
                      shadowColor: TAppColors.greyText,
                      borderColor: TAppColors.greyText,
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: TText(
                            TLabelStrings.unFollow,
                            color: TAppColors.greyText,
                            fontSize: MyFonts.size12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                  // } else if (followingStatus == 1 && isMyProfile) {
                  //   return GestureDetector(
                  //     onTap: onUnfollowTap,
                  //     child: TCard(
                  //       radius: 6,
                  //       border: true,
                  //       borderColor: TAppColors.greyText,
                  //       color: Colors.white,
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //         child: TText(
                  //           TLabelStrings.unFollow,
                  //           color: TAppColors.greyText,
                  //           fontSize: MyFonts.size12,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }
                  //else if (followingStatus == 3) {
                  //   return GestureDetector(
                  //     onTap: onCancelRequestTap,
                  //     child: TCard(
                  //       radius: 6,
                  //       border: true,
                  //       borderColor: TAppColors.selectionColor,
                  //       color: Colors.white,
                  //       child: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  //         child: TText(
                  //           'Cancel Request',
                  //           color: TAppColors.selectionColor,
                  //           fontSize: MyFonts.size12,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //   );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
        ],
      ),
    );
  }
}
