
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/get_all_wedding_event_invited_users_model.dart';
import '../controller/wedding_invite_guests_controller.dart';
import 'not_accepted_invites_widget.dart';

class NotAcceptedGesutsWidget extends StatefulWidget {
  const NotAcceptedGesutsWidget({
    super.key,
  });

  @override
  State<NotAcceptedGesutsWidget> createState() => _NotAcceptedGesutsWidgetState();
}

class _NotAcceptedGesutsWidgetState extends State<NotAcceptedGesutsWidget> {
  bool isExpanded = false;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 15.0.w),
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final inviteCtr = ref.watch(weddingEventGuestInviteController);
          List<WeddingInviteList> pending = [];
          if(inviteCtr.getAllInvitedUsers != null &&
              inviteCtr.getAllInvitedUsers!.weddingInviteList != null &&
              inviteCtr.getAllInvitedUsers!.weddingInviteList!.isNotEmpty) {
            inviteCtr.getAllInvitedUsers?.weddingInviteList?.forEach((
                guest) {
              if (guest.inviteStatus == 0) {
                pending.add(guest);
              }
            });
          }
          return pending.isNotEmpty ?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                // onTap: (){
                //   setState(() {
                //     isExpanded = !isExpanded;
                //   });
                // },
                child: Row(
                  children: [
                    Text(
                      'No (${pending.length})  ',
                      style: getSemiBoldStyle(
                          fontSize: MyFonts.size12, color:TAppColors.greyText),
                    ),
                    // SizedBox(width: 40.w,),
                    // isExpanded ?  Icon(Icons.keyboard_arrow_down , size: 18.sp,color:theme.colors.greyText):
                    // Icon( Icons.keyboard_arrow_right , size: 18.sp,color:theme.colors.greyText),
                  ],
                ),
              ),
              // isExpanded ?
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: pending.isEmpty ?
                // Center(
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 20.h),
                //     child: Text('Invite not accepted yet!', style: getMediumStyle(
                //         color: TAppColors.themeColor,
                //         fontSize: MyFonts.size12
                //     ),),
                //   ),
                // ):
                 ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      WeddingInviteList model = pending[index];
                      return NotAcceptedWidget(
                        coHostName: model.inviteTo != null  &&
                            model.inviteTo?.displayName != null ?
                        model.inviteTo!.displayName! :
                        model.email != null ?  model.email! :
                        "Guest",
                        imageUrl: model.inviteTo?.profileImageUrl,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(height: 20.h,);
                    },
                    itemCount: pending.length) : const SizedBox()
              )
              // ): SizedBox(height: 15.h,),
            ],
          ) : const SizedBox();
        },

      ),
    );
  }
}
