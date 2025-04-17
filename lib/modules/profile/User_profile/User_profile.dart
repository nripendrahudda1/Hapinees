import 'dart:developer';
import 'dart:ffi';
import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/home/widget/follow_button_widget.dart';
import 'package:Happinest/modules/profile/model/setProfile_user_model.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_circular_network_image.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/models/popular_authors_model.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_photo_.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile_controller.dart';
import 'package:Happinest/modules/profile/followers_sreen.dart';
import 'package:Happinest/modules/profile/following_screen.dart';
import 'package:Happinest/modules/profile/controller/profile_controller.dart';
import 'package:Happinest/modules/profile/widgets/profile_google_map.dart';
import 'package:Happinest/common/widgets/common_occasion_card.dart';
import 'package:Happinest/common/widgets/common_story_card.dart';
import 'package:Happinest/utility/API/fetch_api.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';

class OtherUserprofilescreen extends ConsumerStatefulWidget {
  const OtherUserprofilescreen({
    super.key,
    this.userID,
    this.author,
  });
  final String? userID;
  final Authors? author;
  @override
  ConsumerState<OtherUserprofilescreen> createState() => _OtherUserprofilescreenState();
}

class _OtherUserprofilescreenState extends ConsumerState<OtherUserprofilescreen> {
  bool isExpanded = false;
  int? selectedVisibility;
  int currIndex = 0;
  GlobalKey<MapScreenState> map = GlobalKey<MapScreenState>();
  bool isMapshowFullScreen = true;
  bool isHostedSelected = true;
  SetProfileModel profileModel = SetProfileModel();
  var userID;
  @override
  void initState() {
    final _ = ref.read(userprofileCtr);
    userID = widget.userID ??
        (PreferenceUtils.getString(PreferenceKey.userId) == ''
            ? PreferenceUtils.getString(PreferenceKey.serveruserId)
            : getUserID());
    profileModel = SetProfileModel(
      userId: userID,
      deviceTime: DateTime.now().toIso8601String(),
      guestType: 1,
      isFavourite: false,
    );
    _.profileData = null;
    _.stories?.clear();
      _.getMyStory(profileModel, context, isLoader: true);
    _.getUserDetails(context, userID);
    final ctr = ref.read(profileCtr);
    ctr.userProCurrPage = 0;
    _.getCompanySettings(context, false);
    ctr.scrollController.addListener(onScroll);
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    final _ = ref.read(profileCtr);

    // Remove listeners to prevent calling setState after dispose
    _.scrollController.removeListener(onScroll);
    super.dispose();
  }

  onScroll() {
    final _ = ref.read(profileCtr);
    final userCtr = ref.read(userprofileCtr);
    if (_.isEventScrollingFromPinCLick == false) {
      double offset = _.scrollController.offset;
      double itemWidth = 0.34.sw;
      double separatorWidth = 20.w;
      double totalItemWidth = itemWidth + separatorWidth;
      double centerPosition = offset + ((dwidth != null ? (dwidth!) : 0) / (2.5));
      int index = (centerPosition / totalItemWidth).round();
      if (offset <= totalItemWidth * 0.15) {
        index = 0;
      }
      index = index.clamp(0, (userCtr.stories?.length ?? 1) - 1);
      // Update the index if it has changed
      if (_.userProCurrPage != index) {
        setState(() {
          _.userProCurrPage = index;
        });
      }
    } else {
      _.updateMapScrollingAction(false);
    }
  }

  Future<bool> doFollow(BuildContext context,
      {required String userId, required num followRequestStatus}) async {
    final loginUserID = getUserID();
    var status = false;
    EasyLoading.show();
    var url =
        '${ApiUrl.authentication}$loginUserID/$userId/${ApiUrl.followUser}?${TPParameters.followRequestStatus}=$followRequestStatus';
    print({"---followUser url----${url}"});
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (res) {
        print("----FollowResponse -----${res}");
        status = true;
        EasyLoading.dismiss();
        return status;
      },
      onError: (res) {
        status = false;
        EasyLoading.dismiss();
        return status;
      },
    );
    return status;
  }

  Future deleteRequest(BuildContext context, {required String userId}) async {
    var url = '${ApiUrl.authentication}$userId/${ApiUrl.deleteFollowerUser}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      isLoader: false,
      get: true,
      onSuccess: (res) {},
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final _ = ref.watch(homectr);
    return Scaffold(body: Consumer(
      builder: (context, ref, child) {
        final _ = ref.watch(userprofileCtr);
        return Container(
          width: dwidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade300,
                Colors.blue.shade50,
              ],
              stops: const [0, 0.2],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: topSfarea > 0 ? topSfarea : 0.03.sh,
              // bottom: bottomSfarea > 0
              //     ? _.isOtherProfile
              //         ? bottomSfarea
              //         : 0
              //     : 0.02.sh
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      bottom: 8,
                      right: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconButton(
                          bgColor: TAppColors.text4Color,
                          iconPath: TImageName.back,
                          radius: 24.h,
                          onPressed: () {
                            _.profileData = null;
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  isMapshowFullScreen == true
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: InkWell(
                                        onTap: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UserphotoDetailsScreen(
                                                tag: 'userPhoto',
                                                userProfilePictureUrl:
                                                    _.profileData?.userProfilePictureUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: 'userPhoto',
                                          child: Stack(
                                            alignment:
                                                Alignment.center, // Ensures positioning works well
                                            clipBehavior: Clip.none,
                                            //mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CachedCircularNetworkImageWidget(
                                                isWhiteBorder: true,
                                                image: _.profileData?.userProfilePictureUrl ?? '',
                                                size: 85,
                                              ),
                                              // Space between the image and button
                                              if (_.profileData?.userId?.toInt() !=
                                                  int.parse(myProfileData?.userId.toString() ??
                                                      PreferenceUtils.getString(
                                                          PreferenceKey.userId)))
                                                Positioned(
                                                  bottom: -10,
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: buildFollowActionButton(
                                                      context: context,
                                                      followingStatus:
                                                          widget.author?.userEntity != null
                                                              ? widget.author?.userEntity!
                                                                      .followingStatus ??
                                                                  0
                                                              : 0,
                                                      onFollow: () async {
                                                        var loginUserID = getUserID();
                                                        if (loginUserID.toString() == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await doFollow(
                                                            context,
                                                            userId: widget.userID ?? '',
                                                            followRequestStatus: 1,
                                                          );
                                                          if (response == true) {
                                                            widget.author!.userEntity!
                                                                .followingStatus = 1;
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      onUnfollow: () async {
                                                        var loginUserID = getUserID();
                                                        if (loginUserID.toString() == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await doFollow(
                                                            context,
                                                            userId: widget.userID ?? '',
                                                            followRequestStatus: 3,
                                                          );
                                                          if (response == true) {
                                                            widget.author!.userEntity!
                                                                .followingStatus = 3;
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                      onRemove: () async {
                                                        var loginUserID = getUserID();
                                                        if (loginUserID.toString() == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await doFollow(
                                                            context,
                                                            userId: widget.userID ?? '',
                                                            followRequestStatus: 4,
                                                          );
                                                          if (response == true) {
                                                            widget.author!.userEntity!
                                                                .followingStatus = 4;
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),

                                                  // Align(
                                                  //   alignment: Alignment.center,
                                                  //   child: widget.author?.userEntity != null
                                                  //       ? widget.author?.userEntity!
                                                  //                       .followingStatus ==
                                                  //                   0 ||
                                                  //               widget.author?.userEntity!
                                                  //                       .followingStatus ==
                                                  //                   3 ||
                                                  //               widget.author?.userEntity!
                                                  //                       .followingStatus ==
                                                  //                   4
                                                  //           ? GestureDetector(
                                                  //               onTap: () async {
                                                  //                 var userId =
                                                  //                     PreferenceUtils.getString(
                                                  //                         PreferenceKey.userId);

                                                  //                 if (userId == 10106.toString()) {
                                                  //                   Utility
                                                  //                       .showAlertMessageForGuestUser(
                                                  //                           context);
                                                  //                 } else {
                                                  //                   widget.author?.userEntity!
                                                  //                       .followingStatus = 1;
                                                  //                   // Call the follow function here

                                                  //                   doFollow(context,
                                                  //                       userId: userID,
                                                  //                       followRequestStatus: 1);
                                                  //                   setState(() {});
                                                  //                 }
                                                  //               },
                                                  //               child: TCard(
                                                  //                 radius: 6,
                                                  //                 border: true,
                                                  //                 borderColor:
                                                  //                     TAppColors.selectionColor,
                                                  //                 color: Colors.black,
                                                  //                 child: Padding(
                                                  //                   padding: EdgeInsets.symmetric(
                                                  //                       horizontal: 8.w,
                                                  //                       vertical: 2.h),
                                                  //                   child: TText(
                                                  //                     TLabelStrings.follow,
                                                  //                     color:
                                                  //                         TAppColors.selectionColor,
                                                  //                     fontSize: MyFonts.size12,
                                                  //                     fontWeight: FontWeight.w600,
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //             )
                                                  //           : widget.author!.userEntity!
                                                  //                       .followingStatus ==
                                                  //                   1
                                                  //               ? GestureDetector(
                                                  //                   onTap: () async {
                                                  //                     var userId =
                                                  //                         PreferenceUtils.getString(
                                                  //                             PreferenceKey.userId);

                                                  //                     if (userId ==
                                                  //                         10106.toString()) {
                                                  //                       Utility
                                                  //                           .showAlertMessageForGuestUser(
                                                  //                               context);
                                                  //                     } else {
                                                  //                       widget.author!.userEntity!
                                                  //                           .followingStatus = 4;
                                                  //                       // Call the unfollow function here

                                                  //                       doFollow(context,
                                                  //                           userId: userID,
                                                  //                           followRequestStatus: 4);
                                                  //                       setState(() {});
                                                  //                     }
                                                  //                   },
                                                  //                   child: TCard(
                                                  //                     radius: 6,
                                                  //                     border: true,
                                                  //                     borderColor:
                                                  //                         TAppColors.selectionColor,
                                                  //                     color: Colors.black,
                                                  //                     child: Padding(
                                                  //                       padding:
                                                  //                           EdgeInsets.symmetric(
                                                  //                               horizontal: 8.w,
                                                  //                               vertical: 2.h),
                                                  //                       child: TText(
                                                  //                         TLabelStrings.remove,
                                                  //                         color: TAppColors
                                                  //                             .selectionColor,
                                                  //                         fontSize: MyFonts.size12,
                                                  //                         fontWeight:
                                                  //                             FontWeight.w600,
                                                  //                       ),
                                                  //                     ),
                                                  //                   ),
                                                  //                 )
                                                  //               : widget.author!.userEntity!
                                                  //                           .followingStatus ==
                                                  //                       2
                                                  //                   ? GestureDetector(
                                                  //                       onTap: () async {
                                                  //                         var userId =
                                                  //                             PreferenceUtils
                                                  //                                 .getString(
                                                  //                                     PreferenceKey
                                                  //                                         .userId);

                                                  //                         if (userId ==
                                                  //                             10106.toString()) {
                                                  //                           Utility
                                                  //                               .showAlertMessageForGuestUser(
                                                  //                                   context);
                                                  //                         } else {
                                                  //                           widget
                                                  //                               .author!
                                                  //                               .userEntity!
                                                  //                               .followingStatus = 3;
                                                  //                           // Call the remove function here

                                                  //                           doFollow(context,
                                                  //                               userId: userID,
                                                  //                               followRequestStatus:
                                                  //                                   3);
                                                  //                           setState(() {});
                                                  //                         }
                                                  //                       },
                                                  //                       child: TCard(
                                                  //                         radius: 6,
                                                  //                         border: true,
                                                  //                         borderColor: TAppColors
                                                  //                             .selectionColor,
                                                  //                         color: Colors.black,
                                                  //                         child: Padding(
                                                  //                           padding: EdgeInsets
                                                  //                               .symmetric(
                                                  //                                   horizontal: 8.w,
                                                  //                                   vertical: 2.h),
                                                  //                           child: TText(
                                                  //                             TLabelStrings
                                                  //                                 .unFollow,
                                                  //                             color: TAppColors
                                                  //                                 .selectionColor,
                                                  //                             fontSize:
                                                  //                                 MyFonts.size12,
                                                  //                             fontWeight:
                                                  //                                 FontWeight.w600,
                                                  //                             maxLines: 1,
                                                  //                           ),
                                                  //                         ),
                                                  //                       ),
                                                  //                     )
                                                  //                   : const SizedBox.shrink()
                                                  //       : const SizedBox.shrink(),
                                                  // ),
                                                ),
                                            ],
                                          ),
                                        )),
                                  ),

                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: InkWell(
                                  //     onTap: () async {},
                                  //     child: Stack(
                                  //       alignment: Alignment.center,
                                  //       children: [
                                  //         CircleAvatar(
                                  //           radius: 40,
                                  //           backgroundImage: NetworkImage(
                                  //             _.profileData?.userProfilePictureUrl ??
                                  //                 '',
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Flexible(
                                                child: TText(
                                                    _.profileData?.displayName ??
                                                        ('${_.profileData?.firstName ?? ""} ${_.profileData?.lastName ?? ""}'),
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
                                                    color: TAppColors.orange,
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(17))),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5, right: 5),
                                                  child: Center(
                                                    child: TText('Basic', fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              (_.profileData?.address ?? '').toString().isNotEmpty
                                                  ? TText(_.profileData?.address ?? '',
                                                      color: TAppColors.black, fontSize: 13)
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 6,
                                          ),
                                          Row(
                                            children: [
                                              InkWell(
                                                onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => FollowersScreen(
                                                                userFollowType: FollowType.follower,
                                                                data: _.profileData!,
                                                                userID: userID ?? '')))
                                                    .then((value) {}),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(color: Colors.white, width: 1),
                                                      color: Colors.white60,
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(8))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 6, vertical: 3),
                                                    child: Center(
                                                        child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 4, right: 3),
                                                          child: TText(
                                                              (_.profileData?.followersCount ?? '0')
                                                                  .toString(),
                                                              color: TAppColors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 12),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                            right: 4,
                                                          ),
                                                          child: TText(TLabelStrings.followers,
                                                              color: Colors.black87, fontSize: 12),
                                                        )
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => FollowersScreen(
                                                                userFollowType:
                                                                    FollowType.following,
                                                                userID: userID,
                                                                data: _.profileData!,
                                                              ))).then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border.all(color: Colors.white, width: 1),
                                                      color: Colors.white60,
                                                      borderRadius: const BorderRadius.all(
                                                          Radius.circular(8))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 6, vertical: 3),
                                                    child: Center(
                                                        child: Row(
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                              left: 4, right: 3),
                                                          child: TText(
                                                              (_.profileData?.followingCount ?? '0')
                                                                  .toString(),
                                                              color: TAppColors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 12),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(
                                                            right: 4,
                                                          ),
                                                          child: TText(TLabelStrings.following,
                                                              color: Colors.black87, fontSize: 12),
                                                        )
                                                      ],
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
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
                                    !isExpanded &&
                                            (_.profileData?.aboutUser ?? '').toString().length > 38
                                        ? Flexible(
                                            child: TText(
                                                '"${(_.profileData?.aboutUser ?? '').toString().substring(0, 38)}.."',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                color: TAppColors.black,
                                                fontSize: 14),
                                          )
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
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: GestureDetector(
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserphotoDetailsScreen(
                                        tag: 'userPhoto',
                                        userProfilePictureUrl: _.profileData?.userProfilePictureUrl,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: 'userPhoto',
                                  child: CachedCircularNetworkImageWidget(
                                      isWhiteBorder: true,
                                      image: _.profileData?.userProfilePictureUrl ?? '',
                                      size: 45),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Flexible(
                                    child: TText(
                                        _.profileData?.displayName ??
                                            ('${_.profileData?.firstName ?? ""} ${_.profileData?.lastName ?? ""}'),
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
                                        color: TAppColors.orange,
                                        borderRadius: BorderRadius.all(Radius.circular(17))),
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      child: Center(
                                        child: TText('Basic', fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                  const SizedBox(height: 10),
                  Flexible(child: Consumer(
                    builder: (context, ref, child) {
                      final _ = ref.read(userprofileCtr);
                      final ctr = ref.read(profileCtr);
                      return TCard(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            child: Stack(
                              children: [
                                _.stories != null && _.stories!.isNotEmpty
                                    ? ProfileMap(
                                        key: map,
                                        stories: _.stories!,
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Image.asset(TImageName.notripgif),
                                            // Text('No Trips or Events Found')
                                          ),
                                          const Text(
                                            'Events Not Found',
                                            style: TextStyle(fontSize: 16),
                                          )
                                        ],
                                      ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isMapshowFullScreen = !isMapshowFullScreen;
                                    });
                                  },
                                  child: Container(
                                    height: 88,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                      TAppColors.black.withOpacity(0.20),
                                      const Color(0xffB0B0B0).withOpacity(0.20),
                                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              isMapshowFullScreen = !isMapshowFullScreen;
                                            });
                                          },
                                          child: Container(
                                            height: 20 - 8.h,
                                            child: Center(
                                              child: TCard(
                                                  height: 5.h,
                                                  width: 50.h,
                                                  color: Colors.grey.withOpacity(0.3)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: _.stories != null && _.stories!.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom:
                                                    // _.isOtherProfile ? 28 :
                                                    16),
                                            child: SizedBox(
                                              height: 0.22.sh,
                                              width: dwidth,
                                              child: ListView.separated(
                                                  scrollDirection: Axis.horizontal,
                                                  controller: ctr.scrollController,
                                                  itemBuilder: (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          left: index == 0 ? 16 : 0,
                                                          right: index == (_.stories!.length - 1)
                                                              ? 16
                                                              : 0),
                                                      child: (_.stories![index].eventTypeMasterId ??
                                                                  0) ==
                                                              0
                                                          ? CommonStoryCard(
                                                              screenName: 'userProfile',
                                                              data: _.stories![index],
                                                              titleTopPadding: 14.h,
                                                              titleFontSize: 16.sp,
                                                              width: 0.34.sw,
                                                              proFileHeight: 30.h,
                                                              proFileDateSize: 10.sp,
                                                              proFileNameSize: 14.sp,
                                                              iconSize: 16.h,
                                                              isCurrant:
                                                                  ctr.userProCurrPage == index,
                                                              height: 0.22.sh,
                                                              onTab: () {
                                                                userID = widget.userID ??
                                                                    (PreferenceUtils.getString(
                                                                                PreferenceKey
                                                                                    .userId) ==
                                                                            ''
                                                                        ? PreferenceUtils.getString(
                                                                            PreferenceKey
                                                                                .serveruserId)
                                                                        : PreferenceUtils.getString(
                                                                            PreferenceKey.userId));
                                                                final hostType =
                                                                    isHostedSelected == true
                                                                        ? 1
                                                                        : 3;
                                                                profileModel.guestType = hostType;
                                                                _.getMyStory(profileModel, context,
                                                                    isLoader: false);
                                                              },
                                                              index: index)
                                                          : SizedBox(
                                                              width: 0.34.sw,
                                                              height: 0.22.sh,
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    // border: ctr.userProCurrPage ==
                                                                    //         index
                                                                    //     ? Border.all(
                                                                    //         color: TAppColors.orange,
                                                                    //         width: 5)
                                                                    //     : Border.all(
                                                                    //         color: Colors.transparent,
                                                                    //         width: 0),
                                                                    // borderRadius: ctr
                                                                    //             .userProCurrPage ==
                                                                    //         index
                                                                    //     ? BorderRadius.circular(18)
                                                                    //     : BorderRadius.zero,
                                                                    ),
                                                                child: CommonOccasionCard(
                                                                    screenName: 'userProfile',
                                                                    data: _.stories![index],
                                                                    height: 0.22.sh,
                                                                    width: 0.34.sw,
                                                                    proFileHeight: 30.h,
                                                                    iconSize: 16.h,
                                                                    proFileDateSize: 10.sp,
                                                                    proFileNameSize: 14.sp,
                                                                    titleTopPadding: 14.h,
                                                                    titleFontSize: 16.sp,
                                                                    isCurrant:
                                                                        ctr.userProCurrPage ==
                                                                            index,
                                                                    onTab: (value) {
                                                                      widget.author?.userEntity!
                                                                          .followingStatus = value;
                                                                      userID = widget.userID ??
                                                                          (PreferenceUtils.getString(
                                                                                      PreferenceKey
                                                                                          .userId) ==
                                                                                  ''
                                                                              ? PreferenceUtils
                                                                                  .getString(
                                                                                      PreferenceKey
                                                                                          .serveruserId)
                                                                              : PreferenceUtils
                                                                                  .getString(
                                                                                      PreferenceKey
                                                                                          .userId));
                                                                      final hostType =
                                                                          isHostedSelected == true
                                                                              ? 1
                                                                              : 3;

                                                                      profileModel.guestType =
                                                                          hostType;
                                                                      _.getMyStory(
                                                                          profileModel, context,
                                                                          isLoader: false);
                                                                    },
                                                                    index: index),
                                                              ),
                                                            ),
                                                    );
                                                  },
                                                  separatorBuilder: (context, index) {
                                                    return Image.asset(
                                                      TImageName.linkImage,
                                                      width: 25.w,
                                                      color: TAppColors.appColor,
                                                    );
                                                  },
                                                  itemCount: _.stories!.length),
                                            ),
                                          )
                                        : null),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Container(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        height: 20.h,
                                        width: 130.w,
                                        decoration: BoxDecoration(
                                          color:
                                              TAppColors.white, // Background color for the toggle
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding:
                                            const EdgeInsets.all(1.5), // Spacing around the buttons
                                        child: Row(
                                          children: [
                                            // Hosted Button
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _.stories?.clear();
                                                  profileModel.guestType = 1;
                                                  _.getMyStory(profileModel, context,
                                                      isLoader: true);
                                                  setState(() {
                                                    isHostedSelected = true;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: isHostedSelected
                                                        ? TAppColors.orange
                                                        : TAppColors.transparent,
                                                    borderRadius: const BorderRadius.only(
                                                        bottomLeft: Radius.circular(30),
                                                        topLeft: Radius.circular(30)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: TText("Hosted",
                                                      color: isHostedSelected
                                                          ? TAppColors.white
                                                          : TAppColors.black,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10.sp,
                                                      latterSpacing: 0),
                                                ),
                                              ),
                                            ),
                                            // Attended Button
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _.stories?.clear();
                                                  profileModel.guestType = 3;
                                                  _.getMyStory(profileModel, context,
                                                      isLoader: true);
                                                  setState(() {
                                                    isHostedSelected = false;
                                                  });
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: !isHostedSelected
                                                          ? TAppColors.orange
                                                          : TAppColors.white,
                                                      borderRadius: const BorderRadius.only(
                                                          bottomRight: Radius.circular(30),
                                                          topRight: Radius.circular(30)),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: TText("Attended",
                                                        color: !isHostedSelected
                                                            ? TAppColors.white
                                                            : TAppColors.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10.sp,
                                                        latterSpacing: 0)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ));
                    },
                  ))
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  Widget visibilityWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: TCard(
            height: 40,
            border: true,
            borderColor: TAppColors.greyText,
            child: Row(
              children: [
                Expanded(
                  child: TBounceAction(
                    onPressed: () {
                      setState(() {
                        selectedVisibility = visibilityList[0].value;
                      });
                    },
                    child: TCard(
                        color: selectedVisibility != visibilityList[0].value
                            ? TAppColors.white
                            : TAppColors.selectionColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: TText('Stories',
                                  fontSize: MyFonts.size14,
                                  color: selectedVisibility != visibilityList[0].value
                                      ? TAppColors.greyText
                                      : null)),
                        )),
                  ),
                ),
                Container(
                  width: 0.7,
                  height: 40,
                  color: TAppColors.greyText,
                ),
                Expanded(
                  child: TBounceAction(
                    onPressed: () {
                      setState(() {
                        selectedVisibility = visibilityList[1].value;
                      });
                    },
                    child: TCard(
                        color: selectedVisibility != visibilityList[1].value
                            ? TAppColors.white
                            : TAppColors.selectionColor,
                        borderRadius: BorderRadius.circular(0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TText('fav',
                                color: selectedVisibility != visibilityList[1].value
                                    ? TAppColors.greyText
                                    : null,
                                fontSize: MyFonts.size14),
                          ),
                        )),
                  ),
                ),
                Container(
                  width: 0.7,
                  height: 40,
                  color: TAppColors.greyText,
                ),
                Expanded(
                  child: TBounceAction(
                    onPressed: () {
                      setState(() {
                        selectedVisibility = visibilityList[2].value;
                      });
                    },
                    child: TCard(
                        color: selectedVisibility != visibilityList[2].value
                            ? TAppColors.white
                            : TAppColors.selectionColor,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TText('fun',
                                color: selectedVisibility != visibilityList[2].value
                                    ? TAppColors.greyText
                                    : null,
                                fontSize: MyFonts.size16,
                                maxLines: 1),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
