import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/models/create_event_models/create_personal_event_models/post_models/send_personal_event_invite_post_model.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../../../../models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import '../../../../../utility/constants/images/image_url.dart';
import '../../../../../utility/constants/strings/parameter.dart';
import '../../../../profile/User_profile/User_profile.dart';
import '../../../Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import '../views/personal_event_host_user_screen.dart';

class PersonalEventHomePageNameAndInviteWidget extends StatefulWidget {
  const PersonalEventHomePageNameAndInviteWidget({
    super.key,
    required this.title,
    required this.stopPlayer,
    this.inviteCallback,
  });
  final String title;
  final Function() stopPlayer;
  final Function(bool)? inviteCallback;

  @override
  State<PersonalEventHomePageNameAndInviteWidget> createState() =>
      _PersonalEventHomePageNameAndInviteWidgetState();
}

class _PersonalEventHomePageNameAndInviteWidgetState
    extends State<PersonalEventHomePageNameAndInviteWidget> {
  bool isFollowed = false;
  bool isAttending = true;

  apiCalltheUpdateInviteStatus(int inviteStatus, WidgetRef ref, BuildContext context) async {
    final personalEventCtr = ref.read(personalEventHomeController).homePersonalEventDetailsModel;
    final inviteCtr = ref.watch(personalEventGuestInviteController);
    SendPersonalEventInvitePostModel model = SendPersonalEventInvitePostModel(
      personalEventHeaderId: personalEventCtr?.personalEventHeaderId ?? 0,
      personalEventInvites: [
        PersonalEventInvite(
          email: "", // widget.authorModel.email,
          inviteTo: getUserID(),
          mobile: "", // widget.authorModel.contactNumber ?? '',
        )
      ],
      inviteStatus: inviteStatus,
      invitedBy: personalEventCtr?.createdBy?.userId ?? 0,
      personalEventInviteId: personalEventCtr?.personalEventInviteId ?? 0,
      invitedOn: DateTime.now(),
    );
    await inviteCtr.sendPersonalEventInvite(
        sendPersonalEventInvitePostModel: model, ref: ref, context: context);
    widget.inviteCallback!(true);
    // await ref.read(personalEventHomeController).updatePersonalEventStatus(
    //     personalEventInviteId: result!.personalEventInviteId.toString(),
    //    P inviteStatus: inviteStatus,
    //     context: context,
    //     ref: ref);
    // if (ref.read(personalEventHomeController).genralModelResponse?.statusCode == 1) {
    //   widget.inviteCallback!();
    // }
  }

  Future<dynamic> hostUserList(
      {required BuildContext context,
      required String personalEventHeaderId,
      List<PersonalEventInviteList>? personalEventInviteList}) {
    return showModalBottomSheet(
      enableDrag: true,
      backgroundColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return PersonalEventHostUserSection(
          personalEventHeaderId: personalEventHeaderId,
          personalEventInviteList: personalEventInviteList,
        );
      },
    );
  }

  // int getFollowActionValue(int followStatus) {
  //   if (followStatus == 0 || followStatus == 3 || followStatus == 4) return 1;
  //   if (followStatus == 1) return 4;
  //   if (followStatus == 2) return 3;
  //   return 0;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final personalEventCtr = ref.watch(personalEventHomeController);

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
                                      userID: personalEventCtr
                                          .homePersonalEventDetailsModel?.createdBy?.userId
                                          .toString(),
                                      author: null,
                                    )));
                      },
                      child: CircleAvatar(
                        backgroundColor: TAppColors.white,
                        radius: 18.r,
                        child: CircleAvatar(
                          radius: 17.r,
                          backgroundColor: (personalEventCtr.homePersonalEventDetailsModel
                                          ?.createdBy?.profileImageUrl ==
                                      null ||
                                  personalEventCtr.homePersonalEventDetailsModel?.createdBy
                                          ?.profileImageUrl ==
                                      TPParameters.defaultUserProfile)
                              ? TAppColors.cerulean // Change to your desired background color
                              : TAppColors.white,
                          child: personalEventCtr.homePersonalEventDetailsModel?.createdBy
                                          ?.profileImageUrl ==
                                      TPParameters.defaultUserProfile ||
                                  personalEventCtr.homePersonalEventDetailsModel?.createdBy
                                          ?.profileImageUrl ==
                                      null
                              ? Text(
                                  getDisplayName(
                                      0,
                                      personalEventCtr.homePersonalEventDetailsModel?.createdBy!
                                              .displayName ??
                                          ""), // Show the first letter of the name or 'A' as default
                                  style: getMediumStyle(
                                    fontSize: MyFonts.size12,
                                    color: TAppColors.white,
                                  ),
                                )
                              : CachedCircularNetworkImageWidget(
                                  image: personalEventCtr.homePersonalEventDetailsModel?.createdBy
                                          ?.profileImageUrl ??
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
                      personalEventCtr.homePersonalEventDetailsModel?.createdBy?.displayName ?? "",
                      style:
                          getRobotoSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                    ),
                  ],
                ),
                personalEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type && !isFollowed
                    ? GestureDetector(
                        onTap: () async {
                          final followStatus = personalEventCtr
                                  .homePersonalEventDetailsModel?.createdBy?.followingStatus ??
                              0;

                          final followValue = getFollowActionValue(followStatus);

                          print(
                              'Follower ID: ${personalEventCtr.homePersonalEventDetailsModel?.createdBy?.userId.toString()}');
                          await ref.watch(weddingEventHomeController).followUser(
                                followerId: personalEventCtr
                                        .homePersonalEventDetailsModel?.createdBy?.userId
                                        .toString() ??
                                    '',
                                ref: ref,
                                context: context,
                                followStatus: followValue,
                              );

                          personalEventCtr.homePersonalEventDetailsModel?.createdBy
                              ?.followingStatus = followValue;
                          widget.inviteCallback!(false);
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
                              child: TText(
                                getFollowActionLabel(personalEventCtr
                                    .homePersonalEventDetailsModel?.createdBy?.followingStatus),
                                // Status 2 defaults to "Unfollow"
                                color: TAppColors.selectionColor,
                                fontSize: MyFonts.size12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
            final personalEventCtr = ref.watch(personalEventHomeController);
            int? loginUserId = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));
            final dataStatus =
                compareDate(personalEventCtr.homePersonalEventDetailsModel?.startDateTime);
            List<PersonalEventInviteList> allGuests =
                personalEventCtr.homePersonalEventDetailsModel?.personalEventInviteList ?? [];
            // List<PersonalEventInviteList> accepted =
            //     allGuests.where((guest) => guest.inviteStatus == 2).toList();
            List<PersonalEventInviteList> accepted = allGuests.where((guest) {
              // Ensure guest.inviteStatus is accepted (2)
              bool isAccepted = guest.inviteStatus == 2;
              // Ensure inviteTo is not the current user
              bool isNotCurrentUser = guest.inviteTo?.userId != loginUserId;
              return isAccepted && isNotCurrentUser;
            }).toList();

            bool isHostOrGuest = personalEventCtr.userRoleEnum.type == UserRoleEnum.Host.type ||
                personalEventCtr.userRoleEnum.type == UserRoleEnum.CoHost.type;
            isAttending = personalEventCtr.homePersonalEventDetailsModel?.inviteStatus == 2;
            return Row(
              children: [
                if (accepted.isNotEmpty || isHostOrGuest)
                  Text(
                    "Guests",
                    style: getSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                  ),
                SizedBox(width: 10.w),
                accepted.isEmpty
                    ? const SizedBox()
                    : Stack(
                        children: [
                          SizedBox(
                            width: accepted.length == 1
                                ? 45.w
                                : accepted.length == 2
                                    ? 80.w
                                    : accepted.length == 3
                                        ? 110.w
                                        : 120.w,
                            height: 36.h,
                          ),
                          ...List.generate(
                            accepted.length > 3 ? 3 : accepted.length,
                            (index) => Positioned(
                              left: isHostOrGuest ? index * 25.5.w : 10.w + (index * 30.w),
                              child: CircleAvatar(
                                backgroundColor: TAppColors.white,
                                radius: 18.r,
                                child: GestureDetector(
                                  onTap: () {
                                    print("Circle Avatar Tapped!");
                                    if (personalEventCtr
                                            .homePersonalEventDetailsModel?.guestVisibility ==
                                        true) {
                                      hostUserList(
                                        personalEventHeaderId: personalEventCtr
                                                .homePersonalEventDetailsModel!
                                                .personalEventHeaderId
                                                .toString() ??
                                            '',
                                        personalEventInviteList: accepted,
                                        context: context,
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 17.r,
                                    backgroundColor: (accepted[index].inviteTo?.profileImageUrl ==
                                                TPParameters.defaultUserProfile ||
                                            accepted[index].inviteTo!.profileImageUrl!.isEmpty)
                                        ? TAppColors.cerulean
                                        : TAppColors.white,
                                    child: accepted[index].inviteTo?.profileImageUrl ==
                                                TPParameters.defaultUserProfile ||
                                            accepted[index].inviteTo!.profileImageUrl!.isEmpty
                                        ? Text(
                                            getDisplayName(
                                                index, accepted[index].inviteTo?.displayName ?? ""),
                                            style: getMediumStyle(
                                              fontSize: MyFonts.size12,
                                              color: TAppColors.white,
                                            ),
                                          )
                                        : CachedCircularNetworkImageWidget(
                                            image: accepted[index].inviteTo?.profileImageUrl ?? '',
                                            size: 35,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (accepted.length > 3)
                            Positioned(
                              left: isHostOrGuest ? 76.w : 5.w + (3 * 30.w),
                              child: CircleAvatar(
                                backgroundColor: TAppColors.white,
                                radius: 18.r,
                                child: GestureDetector(
                                  onTap: () {
                                    print("Circle Avatar Tapped!");
                                    if (personalEventCtr
                                            .homePersonalEventDetailsModel?.guestVisibility ==
                                        true) {
                                      hostUserList(
                                        personalEventHeaderId: personalEventCtr
                                                .homePersonalEventDetailsModel!
                                                .personalEventHeaderId
                                                .toString() ??
                                            '',
                                        personalEventInviteList: accepted,
                                        context: context,
                                      );
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: TAppColors.blackShadow,
                                    radius: 17.r,
                                    child: Text(
                                      "+${personalEventCtr.homePersonalEventDetailsModel!.personalEventInviteList!.length - 3}",
                                      style: getMediumStyle(
                                        fontSize: MyFonts.size10,
                                        color: TAppColors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                SizedBox(width: 5.w),
                if (isHostOrGuest)
                  GestureDetector(
                    onTap: () async {
                      await widget.stopPlayer();
                      Navigator.pushNamed(context, Routes.personalEventInvitedGuestScreen,
                          arguments: {"title": widget.title}).then(
                        (value) {
                          ref.watch(personalEventHomeController).setHomePersonalEventInviteModel(ref
                              .read(personalEventGuestInviteController)
                              .getAllInvitedUsers
                              ?.personalEventInviteList);
                        },
                      );
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
                        ),
                      ),
                    ),
                  ),
                if (personalEventCtr.homePersonalEventDetailsModel?.selfRegistration == true &&
                    !isHostOrGuest)
                  const Spacer(),
                if (personalEventCtr.homePersonalEventDetailsModel?.selfRegistration == true &&
                    !isHostOrGuest)
                  Padding(
                    padding: EdgeInsets.only(right: 10.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Aligns text and switch on opposite sides
                      children: [
                        Text(
                          dataStatus ? TLabelStrings.eventAttended : TLabelStrings.eventAttending,
                          style:
                              getSemiBoldStyle(fontSize: MyFonts.size12, color: TAppColors.white),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.2, // Increase switch size (Adjust as needed)
                              child: Switch(
                                  value: isAttending,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      isAttending = newValue;
                                    });
                                    if (isAttending) {
                                      personalEventCtr.homePersonalEventDetailsModel?.inviteStatus =
                                          2;
                                      apiCalltheUpdateInviteStatus(2, ref, context);
                                    } else {
                                      apiCalltheUpdateInviteStatus(3, ref, context);
                                      personalEventCtr.homePersonalEventDetailsModel?.inviteStatus =
                                          3;
                                    }
                                  },
                                  activeColor: TAppColors.white,
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: Colors.grey,
                                  activeTrackColor: TAppColors.selectionColor),
                            ),
                            Positioned(
                              left: isAttending ? 3 : 30, // Adjust position based on state
                              child: Text(
                                isAttending ? "Yes" : "No",
                                style: getSemiBoldStyle(
                                  color:
                                      isAttending ? Colors.white : Colors.white, // White text color
                                  fontSize: MyFonts.size12,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
              ],
            );
          },
        ),
        // Consumer(
        //   builder: (BuildContext context, WidgetRef ref, Widget? child) {
        //     final personalEventCtr = ref.watch(personalEventHomeController);
        //     List<PersonalEventInviteList> allGuests =
        //         personalEventCtr.homePersonalEventDetailsModel?.personalEventInviteList ??
        //             []; // ALL Users
        //     List<PersonalEventInviteList> accepted =
        //         allGuests.where((guest) => guest.inviteStatus == 2).toList();
        //     return personalEventCtr.userRoleEnum.type == UserRoleEnum.Host.type ||
        //             personalEventCtr.userRoleEnum.type == UserRoleEnum.Guest.type
        //         ? Row(
        //             children: [
        //               Text(
        //                 "Guests",
        //                 style: getSemiBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
        //               ),
        //               SizedBox(
        //                 width: 10.w,
        //               ),

        //               // ignore: prefer_is_empty
        //               accepted.length == 0
        //                   ? const SizedBox()
        //                   : Stack(
        //                       children: [
        //                         SizedBox(
        //                           width: accepted.length == 1
        //                               ? 30.w
        //                               : accepted.length == 2
        //                                   ? 60.w
        //                                   : accepted.length == 3
        //                                       ? 90.w
        //                                       : 120.w,
        //                           height: 36.h,
        //                         ),
        //                         CircleAvatar(
        //                           backgroundColor: TAppColors.white,
        //                           radius: 18.r,
        //                           child: CircleAvatar(
        //                             radius: 17.r,
        //                             child: const CachedCircularNetworkImageWidget(
        //                               image: TImageUrl.personImgUrl,
        //                               size: 35,
        //                             ),
        //                           ),
        //                         ),
        //                         ...List.generate(
        //                           accepted.length > 3
        //                               ? 3
        //                               : accepted.length ??
        //                                   0, // Replace numberOfAvatars with the actual number you want
        //                           (index) => Positioned(
        //                             left: index *
        //                                 25.5.w, // Adjust the spacing between avatars as needed
        //                             child: CircleAvatar(
        //                               backgroundColor: TAppColors.white,
        //                               radius: 18.r,
        //                               child: GestureDetector(
        //                                 onTap: () {
        //                                   print("Circle Avatar Tapped!");
        //                                   if (personalEventCtr
        //                                           .homePersonalEventDetailsModel!.guestVisibility ==
        //                                       true) {
        //                                     hostUserList(
        //                                       personalEventHeaderId: personalEventCtr
        //                                               .homePersonalEventDetailsModel!
        //                                               .personalEventHeaderId
        //                                               .toString() ??
        //                                           '',
        //                                       personalEventInviteList: accepted,
        //                                       context: context,
        //                                     );
        //                                   }
        //                                 },
        //                                 child: CircleAvatar(
        //                                   radius: 17.r,
        //                                   backgroundColor: (accepted[index]
        //                                                   .inviteTo
        //                                                   ?.profileImageUrl ==
        //                                               TPParameters.defaultUserProfile ||
        //                                           accepted[index]
        //                                               .inviteTo!
        //                                               .profileImageUrl!
        //                                               .isEmpty)
        //                                       ? TAppColors
        //                                           .cerulean // Change to your desired background color
        //                                       : TAppColors.white,
        //                                   child: accepted[index].inviteTo?.profileImageUrl ==
        //                                               TPParameters.defaultUserProfile ||
        //                                           accepted[index].inviteTo!.profileImageUrl!.isEmpty
        //                                       ? Text(
        //                                           getDisplayName(
        //                                               index,
        //                                               accepted[index].inviteTo?.displayName ??
        //                                                   ""), // Show the first letter of the name or 'A' as default
        //                                           style: getMediumStyle(
        //                                             fontSize: MyFonts.size12,
        //                                             color: TAppColors.white,
        //                                           ),
        //                                         )
        //                                       : CachedCircularNetworkImageWidget(
        //                                           image:
        //                                               accepted[index].inviteTo?.profileImageUrl ??
        //                                                   '',
        //                                           size: 35,
        //                                         ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ),
        //                         accepted.length > 3
        //                             ? Positioned(
        //                                 left: 76.w,
        //                                 child: CircleAvatar(
        //                                   backgroundColor: TAppColors.white,
        //                                   radius: 18.r,
        //                                   child: GestureDetector(
        //                                       onTap: () {
        //                                         print("Circle Avatar Tapped!");
        //                                         if (personalEventCtr.homePersonalEventDetailsModel!
        //                                                 .guestVisibility ==
        //                                             true) {
        //                                           hostUserList(
        //                                             personalEventHeaderId: personalEventCtr
        //                                                     .homePersonalEventDetailsModel!
        //                                                     .personalEventHeaderId
        //                                                     .toString() ??
        //                                                 '',
        //                                             personalEventInviteList: accepted,
        //                                             context: context,
        //                                           );
        //                                         }
        //                                         // Add your action here, e.g., navigate to another screen or show a dialog
        //                                       },
        //                                       child: CircleAvatar(
        //                                         backgroundColor: TAppColors.blackShadow,
        //                                         radius: 17.r,
        //                                         child: Text(
        //                                           "+${personalEventCtr.homePersonalEventDetailsModel!.personalEventInviteList!.length}",
        //                                           style: getMediumStyle(
        //                                             fontSize: MyFonts.size10,
        //                                             color: TAppColors.white,
        //                                           ),
        //                                         ),
        //                                       )),
        //                                 ),
        //                               )
        //                             : const SizedBox(),
        //                       ],
        //                     ),
        //               SizedBox(
        //                 // ✅ Adjusted spacing before Invite button
        //                 width: 5.w,
        //               ),
        //               GestureDetector(
        //                 onTap: () async {
        //                   // EasyLoading.showError("Coming Soon");
        //                   await widget.stopPlayer();
        //                   Navigator.pushNamed(context, Routes.personalEventInvitedGuestScreen,
        //                       arguments: {"title": widget.title}).then(
        //                     (value) {
        //                       // ref.read(personalEventGuestInviteController)
        //                       //     .getPersonalEventInvites(
        //                       //     eventHeaderId: personalEventCtr.homePersonalEventDetailsModel?.personalEventHeaderId.toString() ?? '',
        //                       //     isLoaderShow: false,
        //                       //     ref: ref, context: context);
        //                       ref
        //                           .watch(personalEventHomeController)
        //                           .setHomePersonalEventInviteModel(ref
        //                               .read(personalEventGuestInviteController)
        //                               .getAllInvitedUsers
        //                               ?.personalEventInviteList);
        //                     },
        //                   );
        //                 },
        //                 child: CircleAvatar(
        //                   backgroundColor: TAppColors.white,
        //                   radius: 18.r,
        //                   child: CircleAvatar(
        //                       backgroundColor: TAppColors.davyGrey,
        //                       radius: 17.r,
        //                       child: Center(
        //                         child: Image.asset(
        //                           TImageName.invitePngIcon,
        //                           width: 20.w,
        //                           height: 20.h,
        //                         ),
        //                       )),
        //                 ),
        //               ),
        //             ],
        //           )
        //         : Stack(
        //             children: [
        //               SizedBox(
        //                 width: accepted.length == 1
        //                     ? 30.w
        //                     : accepted.length == 2
        //                         ? 60.w
        //                         : accepted.length == 3
        //                             ? 90.w
        //                             : 120.w,
        //                 height: 36.h,
        //               ),
        //               Container(
        //                 color: Colors.amber,
        //                 child: CircleAvatar(
        //                   backgroundColor: TAppColors.white,
        //                   radius: 18.r,
        //                   child: CircleAvatar(
        //                     radius: 17.r,
        //                     child: const CachedCircularNetworkImageWidget(
        //                       image: TImageUrl.personImgUrl,
        //                       size: 35,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               ...List.generate(
        //                 accepted.length > 3
        //                     ? 3
        //                     : accepted
        //                         .length, // Replace numberOfAvatars with the actual number you want
        //                 (index) => Positioned(
        //                   left: 0, // Adjust the spacing between avatars as needed
        //                   child: CircleAvatar(
        //                     backgroundColor: TAppColors.greyText,
        //                     radius: 18.r,
        //                     child: GestureDetector(
        //                       onTap: () {
        //                         print("Circle Avatar Tapped!");
        //                         if (personalEventCtr
        //                                 .homePersonalEventDetailsModel!.guestVisibility ==
        //                             true) {
        //                           hostUserList(
        //                             personalEventHeaderId: personalEventCtr
        //                                     .homePersonalEventDetailsModel!.personalEventHeaderId
        //                                     .toString() ??
        //                                 '',
        //                             personalEventInviteList: accepted,
        //                             context: context,
        //                           );
        //                         }
        //                       },
        //                       child: CircleAvatar(
        //                         radius: 17.r,
        //                         backgroundColor: (accepted[index].inviteTo?.profileImageUrl ==
        //                                     TPParameters.defaultUserProfile ||
        //                                 accepted[index].inviteTo!.profileImageUrl!.isEmpty)
        //                             ? TAppColors.cerulean // Change to your desired background color
        //                             : TAppColors.white,
        //                         child: accepted[index].inviteTo?.profileImageUrl ==
        //                                     TPParameters.defaultUserProfile ||
        //                                 accepted[index].inviteTo!.profileImageUrl!.isEmpty
        //                             ? Text(
        //                                 getDisplayName(
        //                                     index,
        //                                     accepted[index].inviteTo?.displayName ??
        //                                         ""), // Show the first letter of the name or 'A' as default
        //                                 style: getMediumStyle(
        //                                   fontSize: MyFonts.size12,
        //                                   color: TAppColors.white,
        //                                 ),
        //                               )
        //                             : CachedCircularNetworkImageWidget(
        //                                 image: accepted[index].inviteTo?.profileImageUrl ?? '',
        //                                 size: 35,
        //                               ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           );
        //   },
        // ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}
