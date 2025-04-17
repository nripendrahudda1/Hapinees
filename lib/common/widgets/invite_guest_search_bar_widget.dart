import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import '../../modules/events/Invite_guest/personal_event/controller/personal_event_invite_guests_controller.dart';
import '../../modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../common_imports/apis_commons.dart';

class CommonInviteGuestSearchbarWidget extends ConsumerStatefulWidget {
  final String title;
  final bool isPersonal;
  CommonInviteGuestSearchbarWidget({super.key, required this.title, required this.isPersonal});

  @override
  ConsumerState<CommonInviteGuestSearchbarWidget> createState() =>
      _CommonInviteGuestSearchbarWidgetState();
}

class _CommonInviteGuestSearchbarWidgetState
    extends ConsumerState<CommonInviteGuestSearchbarWidget> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  initialize() {
    print('initialize *****');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(personalEventGuestInviteController).setSearchedPersonalEventInvitesModel(null);
    });
  }

  onSearch({required String val}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(personalEventGuestInviteController).getAllSearchedPersonalEventInviteUsers(
            personalEventHeaderId: widget.isPersonal
                ? ref
                        .read(personalEventHomeController)
                        .homePersonalEventDetailsModel
                        ?.personalEventHeaderId
                        .toString() ??
                    ''
                : ref
                        .read(weddingEventHomeController)
                        .homeWeddingDetails
                        ?.weddingHeaderId
                        .toString() ??
                    '',
            searchWord: val,
            offset: 0,
            noOfRecords: 10000,
            ref: ref,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, right: 10.w, top: 20.h),
      child: Consumer(builder: (context, ref, child) {
        final guestInviteCtr = ref.watch(personalEventGuestInviteController);
        if (guestInviteCtr.isFindGuest == false) {
          ref.watch(personalEventGuestInviteController).searchCtr.clear();
          // ref.watch(personalEventGuestInviteController).setSearchedPersonalEventInvitesModel(null);
        }
        return Row(
          children: [
            !guestInviteCtr.isFindGuest
                ? Expanded(
                    child: InkWell(
                      onTap: () {
                        if (widget.isPersonal) {
                          guestInviteCtr.setFindGuest(true);
                          // Navigator.pushNamed(
                          //   context, Routes.personalEventInviteGuestBySearchScreen,
                          // );
                        } else {
                          guestInviteCtr.setFindGuest(true);
                          // Navigator.pushNamed(
                          //   context, Routes.weddingEventInviteGuestBySearchScreen,
                          // );
                        }
                      },
                      child: Container(
                        color: TAppColors.white,
                        child: TCard(
                            height: 40.h,
                            border: true,
                            borderColor: TAppColors.greyText,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    TImageName.search,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "Find Guest",
                                    style: getRegularStyle(
                                        fontSize: MyFonts.size14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  )
                : Expanded(
                    child: TCard(
                        height: 40.h,
                        border: true,
                        borderColor: TAppColors.textFieldColor,
                        color: TAppColors.textFieldColor.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                TImageName.search,
                                height: 20,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: CTTextField(
                                controller: ref.watch(personalEventGuestInviteController).searchCtr,
                                hint: 'Find Guest',
                                fontSize: 14.sp,
                                isAutoFocus: true,
                                onChanged: (value) {
                                  if (value.length > 2) {
                                    onSearch(
                                        val: ref
                                            .watch(personalEventGuestInviteController)
                                            .searchCtr
                                            .text);
                                  }
                                },
                                onEditingComplete: () {
                                  onSearch(
                                      val: ref
                                          .watch(personalEventGuestInviteController)
                                          .searchCtr
                                          .text);
                                },
                                onTapOutside: (p0) {
                                  FocusScope.of(context).unfocus();
                                },
                              )),
                            ],
                          ),
                        )),
                  ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                if (widget.isPersonal) {
                  guestInviteCtr.setFindGuest(false);
                  Navigator.pushNamed(context, Routes.personalEventInviteGuestScreen,
                      arguments: {"title": widget.title});
                } else {
                  guestInviteCtr.setFindGuest(false);
                  Navigator.pushNamed(context, Routes.weddingEventInviteGuestScreen,
                      arguments: {"title": widget.title});
                }
              },
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration:
                      const BoxDecoration(color: TAppColors.selectionColor, shape: BoxShape.circle),
                  padding: EdgeInsets.all(4.r),
                  child: Image.asset(
                    TImageName.addPerson,
                    height: 16.h,
                    width: 16.w,
                  )),
            ),
            // iconButton(
            //   onPressed: () {
            //     Navigator.pushNamed(context, Routes.eventInviteGuestScreen);
            //   },
            //   radius: 20,
            //   padding: 10,
            //   bgColor: theme.colors.selectionColor,
            //   iconPath: TImageName.addPerson,
            // )
          ],
        );
      }),
    );
  }
}
