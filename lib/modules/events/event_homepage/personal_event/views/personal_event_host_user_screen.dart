import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/widgets/personal_event_comments_card.dart';
import 'package:flutter/scheduler.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/common_comments_header_view.dart';
import '../../../../../common/widgets/event_t_card.dart';
import '../../../../../models/create_event_models/create_personal_event_models/get_all_personal_event_invited_users_model.dart';
import '../../../../../models/create_event_models/create_personal_event_models/personal_event_comment_model.dart';
import '../../../../../utility/constants/constants.dart';
import '../widgets/personal_event_HostList_card.dart';

class PersonalEventHostUserSection extends ConsumerStatefulWidget {
  final String personalEventHeaderId;
  final List<PersonalEventInviteList>? personalEventInviteList;

  const PersonalEventHostUserSection({
    super.key,
    required this.personalEventHeaderId,
    this.personalEventInviteList,
  });

  @override
  ConsumerState<PersonalEventHostUserSection> createState() => _PersonalEventHostUserSectionState();
}

class _PersonalEventHostUserSectionState extends ConsumerState<PersonalEventHostUserSection> {
  FocusNode focusNode = FocusNode();
  bool isKeyBoardFocus = false;
  TextEditingController commentController = TextEditingController();
  String selectedFilter = '';
  ScrollController scrollController = ScrollController();
  int? replyIndex;
  int? replyParantsID;

  bool isFav = false;

  favClick() {
    setState(() {
      isFav = !isFav;
    });
  }

  @override
  void initState() {
    selectedFilter = commonCommentFilterList[0];
    super.initState();

    commentController.addListener(() {
      setState(() {}); // Update UI when search input changes
    });
    //  initiallize();
    focusNode.addListener(_onFocusChange);
    // getComments(true);
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      print("isPopular ************* $isPopular");
      await ref.read(personalEventHomeController).getAllPersonalEventComments(
            personalEventHeaderId: widget.personalEventHeaderId,
            shortByPopular: isPopular,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );
    });
  }

  void _onFocusChange() {
    setState(() {
      isKeyBoardFocus = focusNode.hasFocus;
      !isKeyBoardFocus ? replyIndex = null : null;
    });
  }

  doCommentAgain({
    int? parentCommentID,
    required int personalEventHeaderId,
    required String comment,
  }) async {
    focusNode.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      commentController.clear();
      await ref.read(personalEventHomeController).writePersonalEventComment(
          personalEventHeaderId: personalEventHeaderId,
          parentCommentId: replyParantsID,
          comment: comment,
          commentedOn: DateTime.now(),
          ref: ref,
          context: context);
      bool isPopular = commonCommentFilterList.indexOf(selectedFilter) == 1 ? true : false;
      await ref.read(personalEventHomeController).getPersonalEventAllCommentsSecondTime(
            personalEventHeaderId: widget.personalEventHeaderId,
            shortByPopular: isPopular,
            offset: 0,
            noOfRecords: 1000,
            ref: ref,
            context: context,
          );
      setState(() {
        replyParantsID = null;
      });
    });
  }

  @override
  void dispose() {
    commentController.clear();
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.transparent,
      body: Container(
        color: TAppColors.black.withOpacity(0.30),
        child: Padding(
          padding: EdgeInsets.fromLTRB(14.w, 6.sh * 0.03, 14.w, 0),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.0.w, right: 2.w),
                  child: Column(
                    children: [
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          return Row(
                            children: [
                              Text(
                                "Guests",
                                style:
                                    getBoldStyle(fontSize: MyFonts.size14, color: TAppColors.white),
                              ),
                              SizedBox(width: 6.w),
                              EventTCard(
                                  color: Colors.white,
                                  radius: 12,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                                    child: TText(
                                        (widget.personalEventInviteList?.length ?? 0).toString(),
                                        color: TAppColors.text1Color,
                                        fontSize: MyFonts.size12,
                                        fontWeight: FontWeight.w800),
                                  )),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      EventTCard(
                          height: 35.h,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: SizedBox(
                                    child: Image.asset(
                                      TImageName.search,
                                      height: 24.h,
                                      width: 24.h,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: CTTextField(
                                    hint: 'Find People...',
                                    controller: commentController,
                                    focusNode: focusNode,
                                    onTap: () {
                                      SchedulerBinding.instance.addPostFrameCallback((_) {
                                        scrollController.animateTo(
                                          scrollController.position.minScrollExtent,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeInOut,
                                        );
                                      });
                                    },
                                    onTapOutside: (p0) {
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 8.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          // final evetnCtr = ref.watch(personalEventHomeController);
                          // evetnCtr.personalEventLikeUsersModel

                          // Filter the invite list based on search text
                          List<PersonalEventInviteList> filteredList = widget
                                  .personalEventInviteList
                                  ?.where((guest) =>
                                      guest.inviteTo?.displayName
                                          ?.toLowerCase()
                                          .contains(commentController.text.toLowerCase()) ??
                                      false)
                                  .toList() ??
                              [];

                          return Expanded(
                            child: ListView.separated(
                              controller: scrollController,
                              padding: EdgeInsets.zero,
                              itemCount: filteredList.length,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (context, index) {
                                PersonalEventInviteList model = filteredList[index];
                                return PersonalEventHostListCard(
                                  indexNumber: index,
                                  inviteModel: model,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                    height: replyIndex == null
                                        ? 6
                                        : replyIndex == index
                                            ? 6
                                            : 0);
                              },
                            ),
                          );
                        },
                      ),
                      TCard(
                          radius: 14,
                          color: Colors.white.withOpacity(0.1),
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.w, top: 5.w),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  TImageName.arrowUpPngIcon,
                                  height: 16.h,
                                  width: 16.h,
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Text(
                                  "Hide",
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size12, color: TAppColors.white),
                                )
                              ],
                            ),
                          )),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
