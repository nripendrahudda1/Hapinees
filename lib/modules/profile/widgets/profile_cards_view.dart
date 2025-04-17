import 'package:Happinest/modules/home/widget/Shimmer_widget.dart';
import 'package:Happinest/modules/profile/model/setProfile_user_model.dart';

import '../../../common/common_imports/apis_commons.dart';
import '../../../common/common_imports/common_imports.dart';
import '../../../utility/constants/constants.dart';
import '../../home/widget/home_popular_author.dart';
import '../controller/profile_controller.dart';
import '../../../common/widgets/common_occasion_card.dart';
import '../../../common/widgets/common_story_card.dart';

class ProfileCardsView extends ConsumerStatefulWidget {
  ProfileCardsView(
      {super.key,
      required this.selectedSegmentIndex,
      this.isHostedSelected,
      required this.profileModel});
  final int selectedSegmentIndex;
  final bool? isHostedSelected;
  SetProfileModel profileModel;

  @override
  ConsumerState<ProfileCardsView> createState() => _ProfileCardsViewState();
}

class _ProfileCardsViewState extends ConsumerState<ProfileCardsView> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final _ = ref.read(profileCtr);
      return Stack(
        children: [
          Visibility(
            visible: widget.selectedSegmentIndex == 0,
            child: Align(alignment: Alignment.bottomCenter, child: eventCardViewWidget()),
          ),
          Visibility(
            visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 1,
            child: Align(alignment: Alignment.bottomCenter, child: favEventCardViewWidget()),
          ),
          Visibility(
            visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 2,
            child: Align(alignment: Alignment.bottomCenter, child: favLocationCardViewWidget()),
          ),
          Visibility(
              visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _.authorsList != null
                    ? SizedBox(
                        height: 0.230.sh,
                        width: dwidth,
                        child: HomePopularAuthors(
                          listOfAuthors: _.authorsList?.authors ?? [],
                          authorsname: "",
                          isFollowShow: false,
                          authorsColor: TAppColors.text1Color,
                          isProfile: true,
                        ))
                    : const SizedBox(),
              )),
          Visibility(
            visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 3,
            child: Align(alignment: Alignment.bottomCenter, child: favPostCardViewWidget()),
          ),
        ],
      );
    });
  }

  // Widget eventCardViewWidget() {
  //   final _ = ref.read(profileCtr);
  //   return _.isLoading == true
  //       ? ShimmerBox(height: 200.h, width: double.infinity) // Show shimmer while loading
  //       : _.stories != null && _.stories!.isNotEmpty
  //           ? Padding(
  //               padding: const EdgeInsets.only(bottom: 16),
  //               child: SizedBox(
  //                 height: 0.22.sh,
  //                 width: dwidth,
  //                 child: ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   controller: _.eventController,
  //                   itemBuilder: (context, index) {
  //                     return Padding(
  //                       padding: EdgeInsets.only(
  //                         left: index == 0 ? 16 : 0,
  //                         right: index == (_.stories!.length - 1) ? 16 : 0,
  //                       ),
  //                       child: (_.stories![index].eventTypeMasterId ?? 0) == 0
  //                           ? SizedBox(
  //                               width: 0.34.sw,
  //                               height: 0.22.sh,
  //                               child: CommonStoryCard(
  //                                 data: _.stories![index],
  //                                 titleTopPadding: 14.h,
  //                                 screenName: 'profile',
  //                                 titleFontSize: 14.sp,
  //                                 width: 0.34.sw,
  //                                 height: 0.22.sh,
  //                                 proFileHeight: 30.h,
  //                                 proFileDateSize: 8.sp,
  //                                 proFileNameSize: 10.sp,
  //                                 isCurrant: _.currEventPage == index,
  //                                 iconSize: 16.h,
  //                                 onTab: () {
  //                                   final hostType = widget.isHostedSelected == true ? 1 : 3;
  //                                   widget.profileModel.guestType = hostType;
  //                                   widget.profileModel.userId = getUserID().toString();
  //                                   _.getMyStory(widget.profileModel, context, false);
  //                                 },
  //                                 index: index,
  //                               ),
  //                             )
  //                           : SizedBox(
  //                               width: 0.34.sw,
  //                               height: 0.22.sh,
  //                               child: CommonOccasionCard(
  //                                 data: _.stories![index],
  //                                 height: 0.22.sh,
  //                                 width: 0.34.sw,
  //                                 screenName: 'profile',
  //                                 proFileHeight: 30.h,
  //                                 iconSize: 16.h,
  //                                 proFileDateSize: 8.sp,
  //                                 proFileNameSize: 10.sp,
  //                                 titleTopPadding: 14.h,
  //                                 titleFontSize: 14.sp,
  //                                 isCurrant: _.currEventPage == index,
  //                                 onTab: (value) {
  //                                   final hostType = widget.isHostedSelected == true ? 1 : 3;
  //                                   widget.profileModel.guestType = hostType;
  //                                   widget.profileModel.userId = getUserID().toString();
  //                                   _.getMyStory(widget.profileModel, context, false);
  //                                 },
  //                                 index: index,
  //                               ),
  //                             ),
  //                     );
  //                   },
  //                   separatorBuilder: (context, index) {
  //                     return Image.asset(
  //                       TImageName.linkImage,
  //                       width: 25.w,
  //                       color: TAppColors.appColor,
  //                     );
  //                   },
  //                   itemCount: _.stories?.length ?? 0,
  //                 ),
  //               ),
  //             )
  //           : Image.asset(
  //               TImageName.noEventFound,
  //               width: dwidth! * 0.8,
  //             );
  // }

  Widget eventCardViewWidget() {
    final _ = ref.read(profileCtr);
    return _.isLoading != true
        ? _.stories != null && _.stories!.isNotEmpty
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
                      controller: _.eventController,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.only(
                                left: index == 0 ? 16 : 0,
                                right: index == (_.stories!.length - 1) ? 16 : 0),
                            child: (_.stories![index].eventTypeMasterId ?? 0) == 0
                                ? SizedBox(
                                    width: 0.34.sw,
                                    height: 0.22.sh,
                                    child: CommonStoryCard(
                                        data: _.stories![index],
                                        titleTopPadding: 14.h,
                                        screenName: 'profile',
                                        titleFontSize: 14.sp,
                                        width: 0.34.sw,
                                        height: 0.22.sh,
                                        proFileHeight: 30.h,
                                        proFileDateSize: 8.sp,
                                        proFileNameSize: 10.sp,
                                        isCurrant: _.currEventPage == index,
                                        iconSize: 16.h,
                                        onTab: () {
                                          final hostType = widget.isHostedSelected == true ? 1 : 3;
                                          widget.profileModel.guestType = hostType;
                                          widget.profileModel.userId = getUserID().toString();
                                          _.getMyStory(widget.profileModel, context, false);
                                        },
                                        index: index),
                                  )
                                : SizedBox(
                                    width: 0.34.sw,
                                    height: 0.22.sh,
                                    child: Container(
                                      // decoration:  BoxDecoration(
                                      //     // border: _.currEventPage == index ? Border.all(color: TAppColors.orange, width: 5) : Border.all(color: Colors.transparent,width: 0),
                                      //     // borderRadius: _.currEventPage == index ? BorderRadius.circular(18) : BorderRadius.zero,
                                      //     ),
                                      child: CommonOccasionCard(
                                          data: _.stories![index],
                                          height: 0.22.sh,
                                          width: 0.34.sw,
                                          screenName: 'profile',
                                          proFileHeight: 30.h,
                                          iconSize: 16.h,
                                          proFileDateSize: 8.sp,
                                          proFileNameSize: 10.sp,
                                          titleTopPadding: 14.h,
                                          titleFontSize: 14.sp,
                                          isCurrant: _.currEventPage == index,
                                          onTab: (value) {
                                            final hostType =
                                                widget.isHostedSelected == true ? 1 : 3;
                                            widget.profileModel.guestType = hostType;
                                            widget.profileModel.userId = getUserID().toString();
                                            _.getMyStory(widget.profileModel, context, false);
                                          },
                                          index: index),
                                    ),
                                  ));
                      },
                      separatorBuilder: (context, index) {
                        return Image.asset(
                          TImageName.linkImage,
                          width: 25.w,
                          color: TAppColors.appColor,
                        );
                      },
                      itemCount: _.stories?.length ?? 0),
                ),
              )
            : Image.asset(
                TImageName.noEventFound,
                width: dwidth! * 0.8,
              )
        : const SizedBox();
  }

  Widget favEventCardViewWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
                bottom:
                    // _.isOtherProfile ? 28 :
                    16),
            child: SizedBox(
              height: 0.22.sh,
              width: dwidth,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: _.favEventsController,
                      itemBuilder: (context, index) {
                        return (_.stories![index].eventTypeMasterId ?? 0) == 0
                            ? SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonStoryCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    iconSize: 16.h,
                                    isCurrant: _.currFavEventsPage == index,
                                    height: 0.22.sh,
                                    onTab: () {},
                                    index: index),
                              )
                            : SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonOccasionCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    height: 0.22.sh,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    iconSize: 16.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    isCurrant: _.currFavEventsPage == index,
                                    onTab: (value) {},
                                    index: index),
                              );
                      },
                      separatorBuilder: (context, index) {
                        return Image.asset(
                          TImageName.linkImage,
                          width: 35.w,
                          color: TAppColors.appColor,
                        );
                      },
                      itemCount: _.stories!.length)),
            ),
          )
        : Image.asset(
            TImageName.noEventFound,
            width: dwidth! * 0.8,
          );
  }

  Widget favLocationCardViewWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
                bottom:
                    // _.isOtherProfile ? 28 :
                    16),
            child: SizedBox(
              height: 0.22.sh,
              width: dwidth,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: _.favLocationController,
                      itemBuilder: (context, index) {
                        return (_.stories![index].eventTypeMasterId ?? 0) == 0
                            ? SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonStoryCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    iconSize: 16.h,
                                    height: 0.22.sh,
                                    isCurrant: _.currFavLocationPage == index,
                                    onTab: () {},
                                    index: index),
                              )
                            : SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonOccasionCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    height: 0.22.sh,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    iconSize: 16.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    isCurrant: _.currFavLocationPage == index,
                                    onTab: (value) {},
                                    index: index),
                              );
                      },
                      separatorBuilder: (context, index) {
                        return Image.asset(
                          TImageName.linkImage,
                          width: 35.w,
                          color: TAppColors.appColor,
                        );
                      },
                      itemCount: _.stories!.length)),
            ),
          )
        : Image.asset(
            TImageName.noEventFound,
            width: dwidth! * 0.8,
          );
  }

  Widget favPostCardViewWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(
                bottom:
                    // _.isOtherProfile ? 28 :
                    16),
            child: SizedBox(
              height: 0.22.sh,
              width: dwidth,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      controller: _.favPostController,
                      itemBuilder: (context, index) {
                        return (_.stories![index].eventTypeMasterId ?? 0) == 0
                            ? SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonStoryCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    iconSize: 16.h,
                                    height: 0.22.sh,
                                    isCurrant: _.currFavPostPage == index,
                                    onTab: () {},
                                    index: index),
                              )
                            : SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                child: CommonOccasionCard(
                                    screenName: 'profile',
                                    data: _.stories![index],
                                    height: 0.22.sh,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    iconSize: 16.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    titleTopPadding: 14.h,
                                    titleFontSize: 16.sp,
                                    isCurrant: _.currFavPostPage == index,
                                    onTab: (value) {},
                                    index: index),
                              );
                      },
                      separatorBuilder: (context, index) {
                        return Image.asset(
                          TImageName.linkImage,
                          width: 35.w,
                          color: TAppColors.appColor,
                        );
                      },
                      itemCount: _.stories!.length)),
            ),
          )
        : Image.asset(
            TImageName.noEventFound,
            width: dwidth! * 0.8,
          );
  }
}
