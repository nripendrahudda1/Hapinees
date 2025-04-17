import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:Happinest/modules/profile/followers_sreen.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../../common/common_default_apis.dart';
import '../../common/widgets/cached_circular_network_image.dart';
import '../../common/widgets/custom_dialog.dart';
import '../../utility/API/fetch_api.dart';
import '../account/usermodel/usermodel.dart';
import 'model/follow_user_model.dart';

class FollowingScreen extends StatefulWidget {
  final String userID;
  final UserModel data;
  const FollowingScreen({super.key, required this.userID, required this.data});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  List<FollowUserModel> data = [];
  List<FollowUserModel> originalData = [];
  TextEditingController search = TextEditingController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      getFollowingList();
    });
    super.initState();
  }

  Future doFollow(String userID) async {
    var url =
        '${ApiUrl.authentication}$userID/${ApiUrl.followUser}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      isLoader: false,
      onSuccess: (res) {},
    );
  }

  Future deleteRequest(String userID) async {
    var url =
        '${ApiUrl.authentication}$userID/${ApiUrl.deleteFollowerUser}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      isLoader: false,
      get: true,
      onSuccess: (res) {},
    );
  }

  Future getFollowingList() async {
    var url =
        '${ApiUrl.authentication}${widget.userID}/${ApiUrl.getFollowingDetails}';
    await ApiService.fetchApi(
      context: context,
      url: url,
      get: true,
      onSuccess: (res) {
        setState(() {
          List userList = res['followings'] ?? [];
          originalData = [];
          for (var element in userList) {
            originalData.add(FollowUserModel.fromJson(element));
          }
          data = originalData;
        });
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
              top: topSfarea > 0 ? topSfarea : 50,
              left: 10.w,
              right: 10.w,
              bottom: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5.w,),
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
                                  fontSize: 17,overflow: TextOverflow.ellipsis,maxLines: 2),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: TAppColors.orange,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(17))),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 5, right: 5),
                                child: Center(
                                  child: TText('Basic', fontSize: 10.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FollowersScreen(
                                         userFollowType: FollowType.follower,
                                          data: widget.data,
                                          userID: widget.userID))),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white54,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1.3),
                                    borderRadius: const BorderRadius.all(Radius.circular(13))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                  child: Center(
                                      child: Row(
                                    children: [
                                      TText(
                                          (widget.data.followersCount ?? '0')
                                              .toString(),
                                          color: TAppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      TText(' Followers',
                                          color: Colors.black87, fontSize: 12)
                                    ],
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w,),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 1.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(13))),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                child: Center(
                                    child: Row(
                                  children: [
                                    TText(
                                        data.length //(widget.data.followingCount ?? '0')
                                            .toString(),
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                    TText(' Following',
                                        color: Colors.white, fontSize: 12)
                                  ],
                                )),
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
                        data = originalData;
                      } else {
                        data = originalData.where((user) {
                          return user.userDetail?.displayName
                                      ?.toLowerCase()
                                      .contains(text.toLowerCase()) ==
                                  true ||
                              user.userDetail?.email
                                      ?.toLowerCase()
                                      .contains(text.toLowerCase()) ==
                                  true ||
                              user.userDetail?.contactNumber?.contains(text) ==
                                  true;
                        }).toList();
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
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUserprofilescreen(
                                                  userID: data[index]
                                                      .userDetail
                                                      ?.userId
                                                      .toString(),
                                                )))
                                    .then((value) => setState(() {}));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    CachedCircularNetworkImageWidget(
                                        isWhiteBorder: false,
                                        image: data[index]
                                            .userDetail
                                            ?.profileImageUrl ??
                                            '',
                                        size: 40),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: TText(
                                          data[index]
                                                  .userDetail
                                                  ?.displayName ??
                                              "",
                                          color: TAppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5),
                                    ),
                                    if (myProfileData!.userId ==
                                        widget.data.userId)
                                      SizedBox(
                                        child: data[index].userDetail?.userId !=
                                                myProfileData?.userId
                                            ? data[index]
                                                        .userDetail
                                                        ?.followingStatus ==
                                                    2
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        data[index]
                                                            .userDetail
                                                            ?.followingStatus = 3;
                                                      });
                                                      doFollow(data[index]
                                                              .userDetail
                                                              ?.userId
                                                              .toString() ??
                                                          '');
                                                    },
                                                    child: TCard(
                                                        radius: 6,
                                                        border: true,
                                                        borderColor: TAppColors
                                                            .selectionColor,
                                                        color:
                                                            Colors.transparent,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      8.w,
                                                                  vertical:
                                                                      2.h),
                                                          child: TText(
                                                              TLabelStrings
                                                                  .follow,
                                                              color: TAppColors
                                                                  .selectionColor,
                                                              fontSize: MyFonts
                                                                  .size12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )),
                                                  )
                                                : data[index]
                                                            .userDetail
                                                            ?.followingStatus ==
                                                        1
                                                    ? GestureDetector(
                                                        onTap: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return TDialog(
                                                                title:
                                                                    'UNFOLLOW?',
                                                                bodyText:
                                                                    'Are You Sure You Wants to Unfollow?',
                                                                onActionPressed:
                                                                    () async {
                                                                  setState(() {
                                                                    data[index]
                                                                        .userDetail
                                                                        ?.followingStatus = 2;
                                                                  });
                                                                  widget.data
                                                                      .followingCount = widget
                                                                              .data
                                                                              .followingCount !=
                                                                          null
                                                                      ? widget.data
                                                                              .followingCount! -
                                                                          1
                                                                      : 0;
                                                                  deleteRequest(data[
                                                                              index]
                                                                          .userDetail
                                                                          ?.userId
                                                                          .toString() ??
                                                                      '');
                                                                },
                                                                actionButtonText:
                                                                    'UNFOLLOW',
                                                              );
                                                            },
                                                          );
                                                        },
                                                        child: TCard(
                                                            radius: 6,
                                                            border: true,
                                                            borderColor: TAppColors
                                                                .transparent,
                                                            color: Colors.white,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8.w,
                                                                      vertical:
                                                                          4.h),
                                                              child: TText(
                                                                  TLabelStrings
                                                                      .unFollow,
                                                                  color: TAppColors
                                                                      .greyText,
                                                                  fontSize:
                                                                      MyFonts
                                                                          .size12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )),
                                                      )
                                                    : data[index]
                                                                .userDetail
                                                                ?.followingStatus ==
                                                            3
                                                        ? GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return TDialog(
                                                                    title:
                                                                        'Cancle request?',
                                                                    bodyText:
                                                                        'Are You Sure You Wants to cancle this request?',
                                                                    onActionPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        data[index]
                                                                            .userDetail
                                                                            ?.followingStatus = 2;
                                                                      });
                                                                      deleteRequest(data[index]
                                                                              .userDetail
                                                                              ?.userId
                                                                              .toString() ??
                                                                          '');
                                                                    },
                                                                    actionButtonText:
                                                                        'Cancle request',
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: TCard(
                                                                radius: 6,
                                                                border: true,
                                                                borderColor:
                                                                    TAppColors
                                                                        .selectionColor,
                                                                color: Colors
                                                                    .white,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8.w,
                                                                      vertical:
                                                                          4.h),
                                                                  child: TText(
                                                                      'Cancel Request',
                                                                      color: TAppColors
                                                                          .selectionColor,
                                                                      fontSize:
                                                                          MyFonts
                                                                              .size12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                )),
                                                          )
                                                        : const SizedBox
                                                            .shrink()
                                            : const SizedBox.shrink(),
                                      )
                                  ],
                                ),
                              ),
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
