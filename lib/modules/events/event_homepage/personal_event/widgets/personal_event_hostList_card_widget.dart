import 'package:Happinest/models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../core/enums/user_role_enum.dart';
import '../../wedding_event/controller/wedding_event_home_controller.dart';
import '../controller/personal_event_home_controller.dart';

class CommonHostListCard extends StatefulWidget {
  const CommonHostListCard(
      {super.key, required this.hostModel, required this.userNumber, this.indexNumber});

  final PersonalEventInviteList hostModel;
  final String userNumber;
  final int? indexNumber;

  @override
  State<CommonHostListCard> createState() => _CommonHostListCardState();
}

class _CommonHostListCardState extends State<CommonHostListCard> {
  bool isFollowed = false; // Track like state

  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              widget.hostModel.inviteTo?.displayName ?? '',
              style: getSemiBoldStyle(fontSize: MyFonts.size12, color: TAppColors.white),
            ),
            widget.userNumber.isNotEmpty ? const SizedBox(height: 6) : const SizedBox.shrink(),
            // widget.userNumber.isNotEmpty
            //     ? Row(
            //         children: [
            //           const SizedBox(width: 6),
            //           Text(
            //             "",
            //             style: getRobotoRegularStyle(
            //                 fontSize: MyFonts.size12, color: TAppColors.appColor),
            //           )
            //         ],
            //       )
            //     : SizedBox.shrink(),
          ],
        ),

        // Like & Follow Row
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final personalEventCtr = ref.watch(personalEventHomeController);
          // print('Follower ID: ${widget.hostModel.inviteTo?.followingStatus}');
          return Row(
            children: [
              // Follow Button
              personalEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type && !isFollowed
                  ? GestureDetector(
                      onTap: () async {
                        if (widget.hostModel.inviteTo?.userId != getUserID()) {
                          final followStatus = widget.hostModel.inviteTo?.followingStatus ?? 0;
                          final followValue = getFollowActionValue(
                              followStatus); // Follow request sent → Not following
                          await ref.watch(weddingEventHomeController).followUser(
                              followerId: personalEventCtr
                                      .homePersonalEventDetailsModel?.createdBy?.userId
                                      .toString() ??
                                  '',
                              ref: ref,
                              context: context,
                              followStatus: followValue);

                          setState(() {
                            widget.hostModel.inviteTo?.followingStatus = followValue;
                            personalEventCtr.homePersonalEventDetailsModel?.createdBy
                                ?.followingStatus = followValue;
                            // isFollowed = !isFollowed;
                          });
                          await ref.read(personalEventHomeController).getEvents(
                              eventId: (personalEventCtr
                                          .homePersonalEventDetailsModel?.personalEventHeaderId ??
                                      0)
                                  .toString(),
                              context: context,
                              ref: ref);
                        }
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
                              getFollowActionLabel(widget.hostModel.inviteTo
                                  ?.followingStatus), // Status 2 defaults to "Unfollow"
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
        }),
      ],
    );
  }
}
