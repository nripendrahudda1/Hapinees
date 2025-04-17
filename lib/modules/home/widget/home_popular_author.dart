import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/core/enums/user_role_enum.dart';
import 'package:Happinest/modules/home/widget/follow_button_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:Happinest/modules/profile/User_profile/User_profile.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/widgets/loading_images_shimmer.dart';
import '../../../models/popular_authors_model.dart';
import '../../profile/controller/profile_controller.dart';

class HomePopularAuthors extends ConsumerWidget {
  HomePopularAuthors({
    super.key,
    required this.listOfAuthors,
    required this.authorsname,
    required this.authorsColor,
    required this.isFollowShow,
    this.isSearch,
    this.isProfile,
    this.onDataUpdated,
  });
  final List<Authors> listOfAuthors;
  final String? authorsname;
  final Color authorsColor;
  bool isFollowShow;
  final bool? isSearch;
  final bool? isProfile;
  final VoidCallback? onDataUpdated;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(homectr);
    return listOfAuthors.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isFollowShow
                  ? Padding(
                      padding: const EdgeInsets.only(right: 15, top: 8, left: 15),
                      child: TText(authorsname!,
                          fontSize: MyFonts.size18,
                          color: authorsColor,
                          fontWeight: FontWeightManager.bold),
                    )
                  : const SizedBox(),
              SizedBox(
                height: 15.h,
              ),
              // listOfAuthors.isEmpty
              //     ? Shimmer.fromColors(
              //         baseColor: Colors.grey[300]!,
              //         highlightColor: Colors.grey[100]!,
              //         child: Container(
              //           height: 85.h,
              //           width: 85.h,
              //           decoration: const BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.white,
              //           ),
              //         ),
              //       )
              //     : 
              Center(
                      child: SizedBox(
                        height: 150.h,
                        child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: index == 0 ? 15 : 0, right: index == 9 ? 15 : 0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OtherUserprofilescreen(
                                                  userID: listOfAuthors[index]
                                                      .userEntity!
                                                      .userId
                                                      .toString(),
                                                  author: listOfAuthors[index],
                                                ))).then((value) async {
                                      print("isSearch *************** $isSearch");
                                      final followStatus =
                                          listOfAuthors[index].userEntity?.followingStatus ?? 0;
                                      final buttonType = getFollowButtonType(followStatus);
                                      if (isSearch == true) {
                                        _.isSearching = true;
                                        _.onSearch(context, isLoader: true);
                                      } else if (isProfile == true) {
                                        final proCtr = ref.read(profileCtr);
                                        proCtr.getFavAuthors(context);
                                      } else if (isSearch == null && isProfile == null) {
                                        await _.getUserDetails(context);
                                      }
                                    });
                                  },
                                  child: SizedBox(
                                    width: 124.w,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          child: TCard(
                                              shadowPadding: true,
                                              // shadowColor:
                                              //     Colors.black.withOpacity(0.3),
                                              blurRadius: 5,
                                              shadow: true,
                                              width: 116.w,
                                              height: 100.h,
                                              color: TAppColors.white,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8)
                                                    .copyWith(top: 42.h, bottom: 6.h),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Flexible(
                                                      child: TText(
                                                          listOfAuthors[index]
                                                                  .userEntity
                                                                  ?.displayName ??
                                                              '',
                                                          fontSize: MyFonts.size16,
                                                          maxLines: 1,
                                                          minFontSize: MyFonts.size16,
                                                          overflow: TextOverflow.ellipsis,
                                                          fontWeight: FontWeightManager.medium,
                                                          color: TAppColors.text1Color),
                                                    ),
                                                    SizedBox(
                                                      width: 100.w,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceAround,
                                                        children: [
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Image.asset(
                                                                TImageName.users,
                                                                height: 14.h,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 4),
                                                                child: TText(
                                                                    listOfAuthors[index]
                                                                        .followers
                                                                        .toString(),
                                                                    fontSize: MyFonts.size16,
                                                                    fontWeight:
                                                                        FontWeightManager.regular,
                                                                    color: TAppColors.text1Color),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Image.asset(
                                                                TImageName.worldBook,
                                                                height: 14.h,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 4),
                                                                child: TText(
                                                                    listOfAuthors[index]
                                                                        .events
                                                                        .toString(),
                                                                    fontSize: MyFonts.size16,
                                                                    fontWeight:
                                                                        FontWeightManager.regular,
                                                                    color: TAppColors.text1Color),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: 85.h,
                                            width: 85.h,
                                            child: Stack(
                                              children: [
                                                /*CachedCircularNetworkImageWidget(
                                                isWhiteBorder: true,
                                                image: listOfAuthors[index]
                                                    .userEntity!
                                                    .profileImageUrl
                                                    .toString(),
                                                size: 85),*/
                                                listOfAuthors[index]
                                                            .userEntity!
                                                            .profileImageUrl
                                                            .toString() ==
                                                        ''
                                                    ? Initicon(
                                                        text: "",
                                                        backgroundColor:
                                                            TAppColors.textImageBgColor,
                                                        borderRadius: BorderRadius.circular(100),
                                                        style: getRobotoMediumStyle(
                                                            fontSize: MyFonts.size12,
                                                            color: TAppColors.greyText),
                                                        size: 85.h,
                                                      )
                                                    : SizedBox(
                                                        width: 85.w,
                                                        height: 85.h,
                                                        child: CachedNetworkImage(
                                                          imageUrl: listOfAuthors[index]
                                                              .userEntity!
                                                              .profileImageUrl
                                                              .toString(),
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                  width: 2.5,
                                                                  color: TAppColors.white),
                                                              image: DecorationImage(
                                                                  image: imageProvider,
                                                                  fit: BoxFit.cover),
                                                            ),
                                                          ),
                                                          placeholder: (context, url) => Center(
                                                            child: ShimmerWidget(
                                                              border: 100.r,
                                                            ),
                                                          ),
                                                          errorWidget: (context, url, error) =>
                                                              Center(
                                                            child: Initicon(
                                                              text: "",
                                                              backgroundColor:
                                                                  TAppColors.textImageBgColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(100),
                                                              style: getRobotoMediumStyle(
                                                                  fontSize: MyFonts.size12,
                                                                  color: TAppColors.greyText),
                                                              size: 85.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                Visibility(
                                                  visible: (listOfAuthors[index]
                                                                  .userEntity
                                                                  ?.userId
                                                                  ?.toInt() ==
                                                              int.parse(myProfileData?.userId
                                                                      .toString() ??
                                                                  PreferenceUtils.getString(
                                                                      PreferenceKey.userId))) ==
                                                          false
                                                      ? isFollowShow
                                                      : false,
                                                  child: Align(
                                                    alignment: Alignment.bottomCenter,
                                                    child: buildFollowActionButton(
                                                      context: context,
                                                      followingStatus: listOfAuthors[index]
                                                          .userEntity!
                                                          .followingStatus!,
                                                      onFollow: () async {
                                                        var userId = getUserID();
                                                        if (userId == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await _.doFollow(
                                                            context,
                                                            userId: listOfAuthors[index]
                                                                .userEntity!
                                                                .userId
                                                                .toString(),
                                                            followRequestStatus: 1,
                                                          );
                                                          if (response == true) {
                                                            listOfAuthors[index]
                                                                .userEntity!
                                                                .followingStatus = 1;
                                                            onDataUpdated!();
                                                          }
                                                        }
                                                      },
                                                      onUnfollow: () async {
                                                        var userId = PreferenceUtils.getString(
                                                            PreferenceKey.userId);
                                                        if (userId == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await _.doFollow(
                                                            context,
                                                            userId: listOfAuthors[index]
                                                                .userEntity!
                                                                .userId
                                                                .toString(),
                                                            followRequestStatus: 3,
                                                          );
                                                          if (response == true) {
                                                            listOfAuthors[index]
                                                                .userEntity!
                                                                .followingStatus = 3;
                                                            onDataUpdated!();
                                                          }
                                                        }
                                                      },
                                                      onRemove: () async {
                                                        var userId = PreferenceUtils.getString(
                                                            PreferenceKey.userId);
                                                        if (userId == "10106") {
                                                          Utility.showAlertMessageForGuestUser(
                                                              context);
                                                        } else {
                                                          final response = await _.doFollow(
                                                            context,
                                                            userId: listOfAuthors[index]
                                                                .userEntity!
                                                                .userId
                                                                .toString(),
                                                            followRequestStatus: 4,
                                                          );
                                                          if (response == true) {
                                                            listOfAuthors[index]
                                                                .userEntity!
                                                                .followingStatus = 4;
                                                            onDataUpdated!();
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ),

                                                  //Align(
                                                  //     alignment: Alignment.bottomCenter,
                                                  //     child: SizedBox(
                                                  //         child: listOfAuthors[index]
                                                  //                         .userEntity!
                                                  //                         .followingStatus ==
                                                  //                     0 ||
                                                  //                 listOfAuthors[index]
                                                  //                         .userEntity!
                                                  //                         .followingStatus ==
                                                  //                     3 ||
                                                  //                 listOfAuthors[index]
                                                  //                         .userEntity!
                                                  //                         .followingStatus ==
                                                  //                     4
                                                  //             ? GestureDetector(
                                                  //                 onTap: () async {
                                                  //                   var userId = getUserID();

                                                  //                   if (userId ==
                                                  //                       10106.toString()) {
                                                  //                     Utility
                                                  //                         .showAlertMessageForGuestUser(
                                                  //                             context);
                                                  //                   } else {
                                                  //                     listOfAuthors[index]
                                                  //                         .userEntity!
                                                  //                         .followingStatus = 0;
                                                  //                     final response = await _
                                                  //                         .doFollow(context,
                                                  //                             userId:
                                                  //                                 listOfAuthors[
                                                  //                                         index]
                                                  //                                     .userEntity!
                                                  //                                     .userId
                                                  //                                     .toString(),
                                                  //                             followRequestStatus:
                                                  //                                 1);
                                                  //                     if (response == true ||
                                                  //                         response == null) {
                                                  //                       listOfAuthors[index]
                                                  //                           .userEntity!
                                                  //                           .followingStatus = 1;
                                                  //                       onDataUpdated!();
                                                  //                     }
                                                  //                   }
                                                  //                 },
                                                  //                 child: TCard(
                                                  //                     radius: 6,
                                                  //                     border: true,
                                                  //                     borderColor: TAppColors
                                                  //                         .selectionColor,
                                                  //                     color: Colors.black,
                                                  //                     child: Padding(
                                                  //                       padding:
                                                  //                           EdgeInsets.symmetric(
                                                  //                               horizontal: 8.w,
                                                  //                               vertical: 2.h),
                                                  //                       child: TText(
                                                  //                           TLabelStrings.follow,
                                                  //                           color: TAppColors
                                                  //                               .selectionColor,
                                                  //                           fontSize:
                                                  //                               MyFonts.size12,
                                                  //                           fontWeight:
                                                  //                               FontWeight.w600),
                                                  //                     )),
                                                  //               )
                                                  //             : listOfAuthors[index]
                                                  //                         .userEntity!
                                                  //                         .followingStatus ==
                                                  //                     2
                                                  //                 ? GestureDetector(
                                                  //                     onTap: () async {
                                                  //                       var userId =
                                                  //                           PreferenceUtils
                                                  //                               .getString(
                                                  //                                   PreferenceKey
                                                  //                                       .userId);
                                                  //                       print(
                                                  //                           "user is =====================>$userId ➡️➡️➡️➡️➡️ ");
                                                  //                       if (userId ==
                                                  //                           10106.toString()) {
                                                  //                         Utility
                                                  //                             .showAlertMessageForGuestUser(
                                                  //                                 context);
                                                  //                       } else {
                                                  //                         listOfAuthors[index]
                                                  //                             .userEntity!
                                                  //                             .followingStatus = 2;
                                                  //                         final response = await _.doFollow(
                                                  //                             context,
                                                  //                             userId:
                                                  //                                 listOfAuthors[
                                                  //                                         index]
                                                  //                                     .userEntity!
                                                  //                                     .userId
                                                  //                                     .toString(),
                                                  //                             followRequestStatus:
                                                  //                                 0);

                                                  //                         if (response == true ||
                                                  //                             response == null) {
                                                  //                           listOfAuthors[index]
                                                  //                               .userEntity!
                                                  //                               .followingStatus = 0;
                                                  //                           onDataUpdated!();
                                                  //                         }
                                                  //                       }
                                                  //                     },
                                                  //                     child: TCard(
                                                  //                         radius: 6,
                                                  //                         border: true,
                                                  //                         borderColor: TAppColors
                                                  //                             .selectionColor,
                                                  //                         color: Colors.black,
                                                  //                         child: Padding(
                                                  //                           padding: EdgeInsets
                                                  //                               .symmetric(
                                                  //                                   horizontal:
                                                  //                                       8.w,
                                                  //                                   vertical:
                                                  //                                       2.h),
                                                  //                           child: TText(
                                                  //                               TLabelStrings
                                                  //                                   .unFollow,
                                                  //                               color: TAppColors
                                                  //                                   .selectionColor,
                                                  //                               fontSize: MyFonts
                                                  //                                   .size12,
                                                  //                               fontWeight:
                                                  //                                   FontWeight
                                                  //                                       .w600),
                                                  //                         )),
                                                  //                   )
                                                  //                 : listOfAuthors[index]
                                                  //                             .userEntity!
                                                  //                             .followingStatus ==
                                                  //                         1
                                                  //                     ? GestureDetector(
                                                  //                         onTap: () async {
                                                  //                           var userId = PreferenceUtils
                                                  //                               .getString(
                                                  //                                   PreferenceKey
                                                  //                                       .userId);
                                                  //                           print(
                                                  //                               "user is =====================>$userId ➡️➡️➡️➡️➡️ ");
                                                  //                           if (userId ==
                                                  //                               10106
                                                  //                                   .toString()) {
                                                  //                             Utility
                                                  //                                 .showAlertMessageForGuestUser(
                                                  //                                     context);
                                                  //                           } else {
                                                  //                             listOfAuthors[index]
                                                  //                                 .userEntity!
                                                  //                                 .followingStatus = 1;
                                                  //                             final response = await _.doFollow(
                                                  //                                 context,
                                                  //                                 userId: listOfAuthors[
                                                  //                                         index]
                                                  //                                     .userEntity!
                                                  //                                     .userId
                                                  //                                     .toString(),
                                                  //                                 followRequestStatus:
                                                  //                                     4);

                                                  //                             if (response ==
                                                  //                                     true ||
                                                  //                                 response ==
                                                  //                                     null) {
                                                  //                               listOfAuthors[
                                                  //                                       index]
                                                  //                                   .userEntity!
                                                  //                                   .followingStatus = 4;
                                                  //                               onDataUpdated!();
                                                  //                             } // 4
                                                  //                           }
                                                  //                         },
                                                  //                         child: TCard(
                                                  //                             radius: 6,
                                                  //                             border: true,
                                                  //                             borderColor: TAppColors
                                                  //                                 .selectionColor,
                                                  //                             color: Colors.black,
                                                  //                             child: Padding(
                                                  //                               padding: EdgeInsets
                                                  //                                   .symmetric(
                                                  //                                       horizontal:
                                                  //                                           8.w,
                                                  //                                       vertical:
                                                  //                                           2.h),
                                                  //                               child: TText(
                                                  //                                   TLabelStrings
                                                  //                                       .remove,
                                                  //                                   color: TAppColors
                                                  //                                       .selectionColor,
                                                  //                                   fontSize:
                                                  //                                       MyFonts
                                                  //                                           .size12,
                                                  //                                   fontWeight:
                                                  //                                       FontWeight
                                                  //                                           .w600,
                                                  //                                   maxLines: 1),
                                                  //                             )),
                                                  //                       )
                                                  //                     : const SizedBox.shrink()
                                                  //                     )
                                                  //                     )
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 4.w,
                              );
                            },
                            itemCount: listOfAuthors.length),
                      ),
                    ),
            ],
          )
        : const SizedBox();
  }
}
