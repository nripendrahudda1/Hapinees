import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/account/usermodel/usermodel.dart';

import '../../../common/common_imports/apis_commons.dart';
import '../../../common/common_imports/common_imports.dart';
import '../../../common/widgets/cached_circular_network_image.dart';
import '../../account/update_profile/update_profile_screen.dart';
import '../followers_sreen.dart';
import '../following_screen.dart';
import '../controller/profile_controller.dart';

class ProfileHeaderView extends ConsumerStatefulWidget {
  const ProfileHeaderView({super.key, required this.userID, required this.isMapshowFullScreen});
  final String? userID;
  final bool isMapshowFullScreen;

  @override
  ConsumerState<ProfileHeaderView> createState() => _ProfileHeaderViewState();
}

class _ProfileHeaderViewState extends ConsumerState<ProfileHeaderView> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _ = ref.watch(profileCtr);
      return widget.isMapshowFullScreen
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: _.profileData?.aboutUser != "" ? 5 : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserProfileScreen(
                                  user: _.profileData,
                                ),
                              ),
                            ).then((value) {
                              setState(() {
                                _.getUserDetails(context, _.profileData!.userId.toString());
                              });
                            });
                            setState(() {});
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CachedCircularNetworkImageWidget(
                                  isWhiteBorder: true,
                                  image: _.profileData?.userProfilePictureUrl ?? '',
                                  size: 64),
                              const Positioned(
                                bottom: 0,
                                right: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.edit, size: 15, color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonDisplayNameView(_.profileData?.displayName ??
                                  ('${_.profileData?.firstName ?? ""} ${_.profileData?.lastName ?? ""}')),
                              Row(
                                children: [
                                  (_.profileData?.address ?? '').toString().isNotEmpty
                                      ? Expanded(
                                          child: TText(_.profileData?.address ?? '',
                                              color: TAppColors.black, fontSize: 12),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  commonFollowButtonView(
                                      TLabelStrings.followers,
                                      (_.profileData?.followersCount ?? '0').toString(),
                                      () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FollowersScreen(
                                                  userFollowType: FollowType.follower,
                                                  data: _.profileData!,
                                                  userID: widget.userID ?? ''))).then((value) {})),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  commonFollowButtonView(TLabelStrings.following,
                                      (_.profileData?.followingCount ?? '0').toString(), () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FollowersScreen(
                                                  userFollowType: FollowType.following,
                                                  userID: widget.userID ??
                                                      PreferenceUtils.getString(
                                                          PreferenceKey.userId),
                                                  data: _.profileData ?? UserModel(),
                                                ))).then((value) {
                                      setState(() {});
                                    });
                                  })
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 2, left: 12),
                          child: commonProfileButtons(Icons.settings, 13.5, 20.25, () {
                            Navigator.pushNamed(context, Routes.settingScreen, arguments: _.data);
                          }))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_.profileData?.aboutUser != "")
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          isExpanded && (_.profileData?.aboutUser ?? '').toString().length > 38
                              ? TText(
                                  '"${(_.profileData?.aboutUser ?? '').toString().substring(0, 38)}..',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  color: TAppColors.black,
                                  fontSize: 14)
                              : Flexible(
                                  child: TText(
                                      (_.profileData?.aboutUser ?? '').toString().isEmpty
                                          ? ''
                                          : '"${_.profileData?.aboutUser ?? ''.toString()}"',
                                      color: TAppColors.black,
                                      fontSize: 14),
                                ),
                          (_.profileData?.aboutUser ?? '').toString().length > 40
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        child: isExpanded
                                            ? const Icon(
                                                Icons.keyboard_arrow_up_rounded,
                                                size: 20,
                                              )
                                            : const Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                size: 20,
                                              ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: CachedCircularNetworkImageWidget(
                        isWhiteBorder: true,
                        image: _.profileData?.userProfilePictureUrl ?? '',
                        size: 38),
                  ),
                  Expanded(
                    child: commonDisplayNameView(
                      _.profileData?.displayName ??
                          ('${_.profileData?.firstName ?? ""} ${_.profileData?.lastName ?? ""}'),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  commonProfileButtons(Icons.edit, 12, 18, () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          user: _.profileData,
                        ),
                      ),
                    ).then((value) {
                      setState(() {
                        _.getUserDetails(context, _.profileData!.userId.toString());
                      });
                    });
                    setState(() {});
                  }),
                  SizedBox(
                    width: 10.w,
                  ),
                  commonProfileButtons(Icons.settings, 12, 20, () {
                    Navigator.pushNamed(context, Routes.settingScreen, arguments: _.data);
                  })
                ],
              ),
            );
    });
  }

  Widget commonProfileButtons(
      IconData? icon, double radius, double iconSize, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: radius,
        child: Icon(
          icon,
          color: TAppColors.orange,
          size: iconSize,
        ),
      ),
    );
  }

  Widget commonFollowButtonView(String text, String counts, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            color: Colors.white60,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Center(
              child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: TText(counts,
                    color: TAppColors.black, fontWeight: FontWeight.bold, fontSize: MyFonts.size12),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: TText(text,
                    color: Colors.black87,
                    overflow: TextOverflow.ellipsis,
                    fontSize: MyFonts.size12),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget commonDisplayNameView(String name) {
    return Row(
      children: [
        Flexible(
          child: TText(name,
              color: TAppColors.black,
              fontWeight: FontWeight.bold,
              maxLines: 1,
              minFontSize: 18,
              overflow: TextOverflow.ellipsis,
              fontSize: 18),
        ),
        const SizedBox(
          width: 6,
        ),
        Container(
          decoration: const BoxDecoration(
              color: TAppColors.orange, borderRadius: BorderRadius.all(Radius.circular(17))),
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Center(
              child: TText('Basic', fontSize: 10, fontWeight: FontWeightManager.medium),
            ),
          ),
        ),
      ],
    );
  }
}
