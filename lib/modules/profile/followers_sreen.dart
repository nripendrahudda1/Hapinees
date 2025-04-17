import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/profile/followers_widget.dart';
import 'package:Happinest/modules/profile/following_widget.dart';
import 'package:Happinest/utility/constants/strings/parameter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/custom_dialog.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:Happinest/utility/constants/constants.dart';
import '../../common/common_default_apis.dart';
import '../../common/widgets/cached_circular_network_image.dart';
import '../../common/widgets/iconButton.dart';
import '../../utility/API/fetch_api.dart';
import '../account/usermodel/usermodel.dart';
import 'model/follow_user_model.dart';
import 'following_screen.dart';

class FollowersScreen extends StatefulWidget {
  final String userID;
  final UserModel data;
  final FollowType userFollowType;
  const FollowersScreen(
      {super.key, required this.userID, required this.data, required this.userFollowType});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  List<FollowUserModel> data = [];
  List<FollowUserModel> followers = [];
  List<FollowUserModel> following = [];
  TextEditingController search = TextEditingController();
  FollowType userFollowType = FollowType.follower;
  @override
  void initState() {
    userFollowType = widget.userFollowType;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getFollowingList();
    });
    super.initState();
  }

  Future followAction(num followRequestStatus, int index, bool isFollow) async {
    final userId = data[index].userDetail?.userId;
    final loginUserID = getUserID();
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
        EasyLoading.dismiss();
        if (userFollowType == FollowType.following) {
          data.removeAt(index);
          following.removeAt(index);
        } else {
          if (followRequestStatus == 2) {
            if (isFollow) {
              data[index].userDetail?.followerStatus = followRequestStatus;
              data[index].userDetail?.followingStatus = followRequestStatus;
            } else {
              data[index].userDetail?.followerStatus = followRequestStatus;
            }
          } else {
            data[index].userDetail?.followerStatus = 3;
          }
        }

        setState(() {});
        print("----onSuccess-----${res}");
        if (res == true) {
          return true;
        }
        return false;
      },
      onError: (res) {
        EasyLoading.dismiss();
      },
    );
    // await ApiService.fetchApi(
    //   context: context, // Nripendra Today
    //   url: "url",
    //   isLoader: true,
    //   params: {
    //     "requestId": data[index].requestId,
    //     "isAccepted": isAccepted,
    //     "acceptedDate": nowutc(isLocal: true)
    //   },
    //   onSuccess: (res) {
    //     if (isAccepted) {
    //       setState(() {
    //         data[index].userDetail?.followerStatus = 1;
    //         widget.data.followersCount = (widget.data.followersCount ?? 0) + 1;
    //       });
    //     } else {
    //       res['responseStatus']
    //           ? setState(() {
    //               data.removeAt(index);
    //               widget.data.followersCount =
    //                   widget.data.followersCount != null ? (widget.data.followersCount!) - 1 : 0;
    //             })
    //           : EasyLoading.showError('Something Went Wrong, Please try again later!',
    //               duration: const Duration(seconds: 6));
    //     }
    //   },
    // );
  }

  // Future deleteRequest(String userID, int index) async {
  //   var url =
  //       '${ApiUrl.authentication}$userID/${dotenv.get('API_DeleteFollowerUser')}';
  //   await ApiService.fetchApi(
  //     context: context,
  //     url: url,
  //     isLoader: true,
  //     get: true,
  //     onSuccess: (res) {
  //       res
  //           ? setState(() {
  //               data.removeAt(index);
  //             })
  //           : EasyLoading.showError(
  //               'Something Went Wrong, Please try again later!');
  //     },
  //   );
  // }

  Future getFollowingList() async {
    var url = '${ApiUrl.authentication}${ApiUrl.getFollowersDetails}?userId=${widget.userID}';
    EasyLoading.show();
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      onSuccess: (res) {
        EasyLoading.dismiss();
        setState(() {
          List followersUserList = res['followers'] ?? [];
          List followingsUserList = res['followings'] ?? [];
          followers = [];
          following = [];
          for (var element in followersUserList) {
            followers.add(FollowUserModel.fromJson(element));
          }

          for (var element in followingsUserList) {
            following.add(FollowUserModel.fromJson(element));
          }
        });
        final loginUserID = getUserID();
        List<FollowUserModel> currentlyFollowing =
            following.where((item) => item.userDetail?.followingStatus == 2).toList();
        List<FollowUserModel> currentlyFollower =
            followers.where((item) => item.userDetail?.userId != loginUserID).toList();
        following = currentlyFollowing;
        followers = currentlyFollower;
        if (userFollowType == FollowType.follower) {
          data = followers;
        } else {
          data = following;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
              top: topSfarea > 0 ? topSfarea : 50, left: 10.w, right: 10.w, bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5.w,
                  ),
                  iconButton(
                    bgColor: TAppColors.text4Color,
                    iconPath: TImageName.back,
                    radius: 24.h,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            CachedCircularNetworkImageWidget(
                                isWhiteBorder: true,
                                image: widget.data.userProfilePictureUrl ?? '',
                                size: 40),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: TText(widget.data.displayName ?? '',
                                  color: TAppColors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2),
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
                                  child: TText('Basic', fontSize: 10.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => {
                                userFollowType = FollowType.follower,
                                data = followers,
                                setState(() {}),
                              },
                              child: Container(
                                height: 28.h,
                                decoration: BoxDecoration(
                                    color: userFollowType == FollowType.follower
                                        ? Colors.orange
                                        : Colors.white54,
                                    border: Border.all(color: Colors.white, width: 1.3),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Center(
                                      child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 3),
                                        child: TText(
                                            followers.length //(widget.data.followersCount ?? '0')
                                                .toString(),
                                            color: userFollowType == FollowType.following
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MyFonts.size16),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: TText(TLabelStrings.followers,
                                            color: userFollowType == FollowType.following
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: MyFonts.size16),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            InkWell(
                              onTap: () => {
                                userFollowType = FollowType.following,
                                data = following,
                                setState(() {}),
                              },
                              child: Container(
                                height: 28.h,
                                decoration: BoxDecoration(
                                    color: userFollowType == FollowType.following
                                        ? Colors.orange
                                        : Colors.white54,
                                    border: Border.all(color: Colors.white, width: 1.3),
                                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                  child: Center(
                                      child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 3),
                                        child: TText((following.length).toString(),
                                            color: userFollowType == FollowType.follower
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 4,
                                        ),
                                        child: TText(TLabelStrings.following,
                                            color: userFollowType == FollowType.follower
                                                ? Colors.black87
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
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
                  const SizedBox(width: 28)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TTextField(
                  height: 35.h,
                  controller: search,
                  hintText: 'Search Users',
                  inputboxBoder: TAppColors.white,
                  icon: TImageName.search,
                  onChanged: (text) {
                    setState(() {
                      if (text.isEmpty) {
                        if (userFollowType == FollowType.follower) {
                          data = followers;
                        } else {
                          data = following;
                        }
                      } else {
                        if (userFollowType == FollowType.follower) {
                          data = followers.where((user) {
                            return user.userDetail?.displayName
                                        ?.toLowerCase()
                                        .contains(text.toLowerCase()) ==
                                    true ||
                                user.userDetail?.email
                                        ?.toLowerCase()
                                        .contains(text.toLowerCase()) ==
                                    true ||
                                user.userDetail?.contactNumber?.contains(text) == true;
                          }).toList();
                        } else {
                          data = following.where((user) {
                            return user.userDetail?.displayName
                                        ?.toLowerCase()
                                        .contains(text.toLowerCase()) ==
                                    true ||
                                user.userDetail?.email
                                        ?.toLowerCase()
                                        .contains(text.toLowerCase()) ==
                                    true ||
                                user.userDetail?.contactNumber?.contains(text) == true;
                          }).toList();
                        }
                      }
                    });
                  },
                  onTapOutside: (p0) {
                    FocusScope.of(context).unfocus();
                  },
                  iconPadding: EdgeInsets.symmetric(vertical: 6.h)),
              const SizedBox(
                height: 10,
              ),
              data.isNotEmpty
                  ? Expanded(
                      child: ListView.separated(
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: userFollowType == FollowType.follower
                                  ? FollowersUserListWidget(
                                      isMyProfile: 
                                          widget.userID == getUserID().toString() ? true : false,
                                      index: index,
                                      userData: data[index],
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OtherUserprofilescreen(
                                                      userID:
                                                          data[index].userDetail?.userId.toString(),
                                                    ))).then((value) => setState(() {}));
                                      },
                                      onAcceptTap: () {
                                        followAction(2, index, false);
                                      },
                                      onRejectTap: () {
                                        followAction(3, index, false);
                                      },
                                      onFollowTap: () {
                                        followAction(2, index, true);
                                      },
                                      onFollowingTap: () {},
                                    )
                                  : FollowingUserRowWidget(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => OtherUserprofilescreen(
                                                      userID:
                                                          data[index].userDetail?.userId.toString(),
                                                    ))).then((value) => setState(() {}));
                                      },
                                      userData: data[index],
                                      isMyProfile:
                                          widget.userID == getUserID().toString() ? true : false,
                                      onUnfollowTap: () {
                                        followAction(4, index, false);
                                      },
                                    ),
                              // Row(
                              //   children: [

                              //     CachedCircularNetworkImageWidget(
                              //         isWhiteBorder: false,
                              //         image: data[index].userDetail?.profileImageUrl ?? '',
                              //         size: 40),
                              //     const SizedBox(
                              //       width: 20,
                              //     ),
                              //     Expanded(
                              //       child: TText(data[index].userDetail?.displayName ?? "",
                              //           color: TAppColors.black,
                              //           fontWeight: FontWeight.bold,
                              //           overflow: TextOverflow.ellipsis,
                              //           maxLines: 1,
                              //           fontSize: 15),
                              //     ),
                              //     const SizedBox(width: 10),
                              //     SizedBox(
                              //       child: data[index].userDetail?.userId == getUserID()
                              //           ? data[index].userDetail?.followerStatus == 2 &&  data[index].userDetail?.followingStatus == 2
                              //               ? GestureDetector(
                              //                   onTap: () async {},
                              //                   child: TCard(
                              //                       radius: 6,
                              //                       border: true,
                              //                       borderColor: TAppColors.transparent,
                              //                       color: Colors.white,
                              //                       child: Padding(
                              //                         padding: EdgeInsets.symmetric(
                              //                             horizontal: 8.w, vertical: 4.h),
                              //                         child: TText('Following',
                              //                             color: TAppColors.greyText,
                              //                             fontSize: MyFonts.size12,
                              //                             fontWeight: FontWeight.w600),
                              //                       )),
                              //                 )
                              //               : data[index].userDetail?.followerStatus == 1
                              //                   ? GestureDetector(
                              //                       onTap: () async {
                              //                         followAction(2, index);
                              //                       },
                              //                       child: TCard(
                              //                           radius: 6,
                              //                           border: true,
                              //                           borderColor: TAppColors.selectionColor,
                              //                           color: Colors.white,
                              //                           child: Padding(
                              //                             padding: EdgeInsets.symmetric(
                              //                                 horizontal: 8.w, vertical: 4.h),
                              //                             child: TText('Accept',
                              //                                 color: TAppColors.selectionColor,
                              //                                 fontSize: MyFonts.size12,
                              //                                 fontWeight: FontWeight.w600),
                              //                           )),
                              //                     )
                              //                   : const SizedBox.shrink()
                              //           : const SizedBox.shrink(),
                              //     ),
                              //     SizedBox(width: 4.w),
                              //     // widget.userID == widget.data.userId.toString()
                              //     myProfileData!.userId != widget.data.userId
                              //         ? const SizedBox()
                              //         : GestureDetector(
                              //             onTap: () async {
                              //               showDialog(
                              //                 context: context,
                              //                 builder: (context) {
                              //                   return TDialog(
                              //                     title: 'Reject request?',
                              //                     bodyText:
                              //                         'Are you sure you want to reject this request?',
                              //                     onActionPressed: () async {
                              //                       if (userFollowType == FollowType.following) {
                              //                         followAction(3, index);
                              //                       } else {
                              //                         followAction(4, index);
                              //                       }
                              //                     },
                              //                     actionButtonText: 'Reject request',
                              //                   );
                              //                 },
                              //               );
                              //             },
                              //             child: Image.asset(
                              //               data[index].userDetail?.followerStatus == 1
                              //                   ? TImageName.deleteRequestOrange
                              //                   : TImageName.deleteRequest,
                              //               height: data[index].userDetail?.followerStatus == 4
                              //                   ? 24.h
                              //                   : 30.h,
                              //               width: data[index].userDetail?.followerStatus == 1
                              //                   ? 30.h
                              //                   : 24.h,
                              //             ),
                              //           )
                              //   ],
                              // ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: TAppColors.text4Color.withOpacity(0.50),
                              indent: 60.w,
                              thickness: 1,
                            );
                          },
                          itemCount: data.length),
                    )
                  : const Center(child: Text('No User Found'))
            ],
          ),
        ),
      ),
    );
  }
}
