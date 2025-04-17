import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/modules/profile/model/follow_user_model.dart';
import 'package:intl/intl.dart';

class FollowersUserListWidget extends StatelessWidget {
  final FollowUserModel userData;
  final int index;
  final VoidCallback onTap;
  final VoidCallback? onAcceptTap;
  final VoidCallback? onRejectTap;
  final VoidCallback? onFollowTap;
  final VoidCallback? onFollowingTap;
  final bool isMyProfile;

  const FollowersUserListWidget({
    super.key,
    required this.userData,
    required this.index,
    required this.onTap,
    this.onAcceptTap,
    this.onRejectTap,
    this.onFollowTap,
    this.onFollowingTap,
    this.isMyProfile = false,
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
                  overflow: TextOverflow.ellipsis,
                  // maxLines: 1,
                  fontSize: MyFonts.size16,
                ),
                if (userData.userDetail?.requestedDate != null) const SizedBox(width: 10),
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
          const SizedBox(width: 10),
          if (isMyProfile &&
              userData.userDetail?.followerStatus == 2 &&
              userData.userDetail?.followingStatus == 2)
            GestureDetector(
              onTap: onFollowingTap,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: TCard(
                  radius: 6,
                  border: true,
                  borderColor: TAppColors.transparent,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    child: TText(TLabelStrings.following,
                        color: TAppColors.greyText,
                        fontSize: MyFonts.size14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          else if (isMyProfile && userData.userDetail?.followerStatus == 1)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: GestureDetector(
                onTap: onAcceptTap,
                child: TCard(
                  radius: 6,
                  border: true,
                  shadow: true,
                  shadowColor: TAppColors.selectionColor,
                  borderColor: TAppColors.selectionColor,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    child: TText(TLabelStrings.accept,
                        color: TAppColors.selectionColor,
                        fontSize: MyFonts.size12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          else if (isMyProfile &&
              (userData.userDetail?.followerStatus == 2 ||
                  userData.userDetail?.followingStatus == 0 ||
                  userData.userDetail?.followingStatus == 3 ||
                  userData.userDetail?.followingStatus == 4))
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              child: GestureDetector(
                onTap: onFollowTap,
                child: TCard(
                  radius: 6,
                  border: true,
                  borderWidth: 1.0,
                  shadow: true,
                  shadowColor: TAppColors.greyText,
                  borderColor: TAppColors.greyText,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    child: TText(
                      TLabelStrings.follow,
                      color: TAppColors.greyText,
                      fontSize: MyFonts.size14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          if (isMyProfile)
            GestureDetector(
              onTap: onRejectTap,
              child: Image.asset(
                userData.userDetail?.followerStatus == 1
                    ? TImageName.deleteRequestOrange
                    : TImageName.deleteRequest,
                height: userData.userDetail?.followerStatus == 4 ? 28.h : 32.h,
                width: userData.userDetail?.followerStatus == 1 ? 32.h : 28.h,
              ),
            )
        ],
      ),
    );
  }
}
