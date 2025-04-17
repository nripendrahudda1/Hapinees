import 'dart:developer';
import 'dart:io';

import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/modules/home/widget/Shimmer_widget.dart';
import 'package:Happinest/modules/profile/model/setProfile_user_model.dart';
import 'package:Happinest/modules/profile/widgets/profile_cards_view.dart';
import 'package:Happinest/modules/profile/widgets/profile_common_map_view.dart';
import 'package:Happinest/modules/profile/widgets/profile_header_view.dart';
import 'package:Happinest/modules/profile/widgets/profile_toggle_button_view.dart';
import 'package:Happinest/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/profile/controller/profile_controller.dart';
import 'package:Happinest/modules/profile/widgets/profile_google_map.dart';
import 'package:Happinest/utility/constants/constants.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.userID});
  final String? userID;
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isMapshowFullScreen = true;
  int? selectedVisibility;
  GlobalKey<MapScreenState> map = GlobalKey<MapScreenState>();
  double maxPixel = 0;
  int selectedSegmentIndex = 0;
  bool isHostedSelected = true;
  var userID;
  SetProfileModel profileModel = SetProfileModel();
  @override
  void initState() {
    final _ = ref.read(profileCtr);
    _.currEventPage = 0;
    _.currFavPostPage = 0;
    _.currFavEventsPage = 0;
    _.currFavLocationPage = 0;
    print("Token ******** ${PreferenceUtils.getString(PreferenceKey.accessToken)} ********");

    userID = widget.userID ??
        (PreferenceUtils.getString(PreferenceKey.userId) == ''
            ? PreferenceUtils.getString(PreferenceKey.serveruserId)
            : getUserID().toString());
    _.stories?.clear();
    profileModel = SetProfileModel(
      userId: userID,
      deviceTime: DateTime.now().toIso8601String(),
      guestType: 1,
      isFavourite: false,
    );
    _.getUserDetails(context, userID);
    _.getMyStory(profileModel, context, true);
    _.getFavAuthors(context);
    // _.getCompanySettings(context, false);
    _.eventController.addListener(eventOnScroll);
    _.favEventsController.addListener(favEventOnScroll);
    _.favLocationController.addListener(favLocationOnScroll);
    _.favPostController.addListener(favPostOnScroll);
    if (selectedSegmentIndex == 0) {
      _.selectedFavType = 0;
    }

    super.initState();
  }

  eventOnScroll() {
    final _ = ref.read(profileCtr);

    if (_.isEventScrollingFromPinCLick == false) {
      double offset = _.eventController.offset;
      double itemWidth = 0.34.sw;
      double separatorWidth = 35.w;
      double totalItemWidth = itemWidth + separatorWidth;

      // Calculate the center position of the screen
      double centerPosition = offset + ((dwidth != null ? (dwidth!) : 0) / (2.5));

      // Find the index of the item at the center
      int index = (centerPosition / totalItemWidth).round();

      if (offset <= totalItemWidth * 0.5) {
        index = 0;
      }

      // Ensure index is within valid bounds
      index = index.clamp(0, (_.stories?.length ?? 1) - 1);

      // Update the current event page
      if (_.currEventPage != index) {
        setState(() {
          _.currEventPage = index;
        });
      }
    } else {
      _.updateMapScrollingAction(false);
    }
  }

  favEventOnScroll() {
    final _ = ref.read(profileCtr);
    // Calculate the current index based on the scroll position
    double offset = _.favEventsController.offset;
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double totalItemWidth = itemWidth + separatorWidth;

    // Calculate the center position of the screen
    double centerPosition = offset + ((dwidth != null ? (dwidth!) : 0) / (2.5));

    // Find the index of the item at the center
    int index = (centerPosition / totalItemWidth).round();

    if (offset <= totalItemWidth * 0.5) {
      index = 0;
    }

    // Ensure index is within valid bounds
    index = index.clamp(0, (_.stories?.length ?? 1) - 1);

    // Update the current event page
    if (_.currFavEventsPage != index) {
      setState(() {
        _.currFavEventsPage = index;
      });
    }
  }

  favLocationOnScroll() {
    final _ = ref.read(profileCtr);
    // Calculate the current index based on the scroll position
    double offset = _.favLocationController.offset;
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double totalItemWidth = itemWidth + separatorWidth;

    // Calculate the center position of the screen
    double centerPosition = offset + ((dwidth != null ? (dwidth!) : 0) / (2.5));

    // Find the index of the item at the center
    int index = (centerPosition / totalItemWidth).round();

    if (offset <= totalItemWidth * 0.5) {
      index = 0;
    }

    // Ensure index is within valid bounds
    index = index.clamp(0, (_.stories?.length ?? 1) - 1);

    // Update the current event page
    if (_.currFavLocationPage != index) {
      setState(() {
        _.currFavLocationPage = index;
      });
    }
  }

  favPostOnScroll() {
    final _ = ref.read(profileCtr);
    // Calculate the current index based on the scroll position
    double offset = _.favPostController.offset;
    double itemWidth = 0.34.sw;
    double separatorWidth = 35.w;
    double totalItemWidth = itemWidth + separatorWidth;

    // Calculate the center position of the screen
    double centerPosition = offset + ((dwidth != null ? (dwidth!) : 0) / (2.5));

    // Find the index of the item at the center
    int index = (centerPosition / totalItemWidth).round();

    if (offset <= totalItemWidth * 0.5) {
      index = 0;
    }

    // Ensure index is within valid bounds
    index = index.clamp(0, (_.stories?.length ?? 1) - 1);

    // Update the current event page
    if (_.currFavPostPage != index) {
      setState(() {
        _.currFavPostPage = index;
      });
    }
  }

  @override
  void dispose() {
    final _ = ref.read(profileCtr);

    // Remove listeners to prevent calling setState after dispose
    _.eventController.removeListener(eventOnScroll);
    _.favEventsController.removeListener(favEventOnScroll);
    _.favLocationController.removeListener(favLocationOnScroll);
    _.favPostController.removeListener(favPostOnScroll);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Consumer(
      builder: (context, ref, child) {
        final _ = ref.watch(profileCtr);
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
              top: Platform.isAndroid
                  ? topSfarea > 0
                      ? (topSfarea / 2)
                      : 0.03.sh
                  : topSfarea > 0
                      ? topSfarea
                      : 0.03.sh,
            ),
            child: CustomSafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeaderView(userID: userID, isMapshowFullScreen: isMapshowFullScreen),
                  SizedBox(height: 8.h),
                  Flexible(child: Consumer(
                    builder: (context, ref, child) {
                      final _ = ref.read(profileCtr);
                      // _.stories == null
                      //     ? ShimmerBox(
                      //         height: 1.sh, width: double.infinity) // Show shimmer while loading
                      //     :
                      return TCard(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                          child: ClipRRect(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                            child: Stack(
                              children: [
                                Stack(
                                  children: [
                                    ProfileCommonMapView(
                                      selectedSegmentIndex: selectedSegmentIndex,
                                      mapKey: map,
                                    ),
                                    if (_.stories != null && _.stories!.isNotEmpty)
                                      Column(
                                        children: [
                                          Container(
                                            height: 88,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [
                                                  TAppColors.black.withOpacity(0.20),
                                                  const Color(0xffB0B0B0).withOpacity(0.20),
                                                ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter)),
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      isMapshowFullScreen = !isMapshowFullScreen;
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    height: 40,
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
                                                              isMapshowFullScreen =
                                                                  !isMapshowFullScreen;
                                                            });
                                                          },
                                                          child: SizedBox(
                                                            height: 20 - 8.h,
                                                            child: Center(
                                                              child: TCard(
                                                                  height: 5.h,
                                                                  width: 50.h,
                                                                  color: Colors.white
                                                                      .withOpacity(0.3)),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        SizedBox(
                                                          height: 6.h,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 40,
                                                  padding:
                                                      const EdgeInsets.symmetric(horizontal: 15),
                                                  child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      height: 20.h,
                                                      width: 130.w,
                                                      decoration: BoxDecoration(
                                                        color: TAppColors
                                                            .white, // Background color for the toggle
                                                        borderRadius: BorderRadius.circular(30),
                                                      ),
                                                      padding: const EdgeInsets.all(
                                                          1.5), // Spacing around the buttons
                                                      child: Row(
                                                        children: [
                                                          // Hosted Button
                                                          Expanded(
                                                            child: GestureDetector(
                                                              onTap: () {
                                                                _.stories?.clear();
                                                                profileModel.guestType = 1;
                                                                _.getMyStory(
                                                                    profileModel, context, true);
                                                                setState(() {
                                                                  isHostedSelected = true;
                                                                });
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: isHostedSelected
                                                                      ? TAppColors.orange
                                                                      : TAppColors.transparent,
                                                                  borderRadius:
                                                                      const BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(30),
                                                                          topLeft:
                                                                              Radius.circular(30)),
                                                                ),
                                                                alignment: Alignment.center,
                                                                child: TText(TLabelStrings.hosted,
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
                                                                _.getMyStory(
                                                                    profileModel, context, true);
                                                                setState(() {
                                                                  isHostedSelected = false;
                                                                });
                                                              },
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                    color: !isHostedSelected
                                                                        ? TAppColors.orange
                                                                        : TAppColors.white,
                                                                    borderRadius:
                                                                        const BorderRadius.only(
                                                                            bottomRight:
                                                                                Radius.circular(30),
                                                                            topRight:
                                                                                Radius.circular(
                                                                                    30)),
                                                                  ),
                                                                  alignment: Alignment.center,
                                                                  child: TText(
                                                                      TLabelStrings.attended,
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
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 25),
                                              child: ProfileToggleButtonView(
                                                  selectedSegmentIndex: selectedSegmentIndex,
                                                  onPressed: (int index) {
                                                    if (index == 0) {
                                                      profileModel.isFavourite = false;
                                                      _.getMyStory(profileModel, context, true);
                                                    } else if (index == 1) {
                                                      profileModel.isFavourite = true;
                                                      _.getMyStory(profileModel, context, true);
                                                    }

                                                    setState(() {
                                                      selectedSegmentIndex = index;
                                                      if (index == 0) {
                                                        _.selectedFavType = 0;
                                                      } else if (index == 1) {
                                                        _.selectedFavType = 0;
                                                      }
                                                    });
                                                  })),
                                        ],
                                      ),
                                    _.stories == null
                                        ? ShimmerBox(
                                            height: 0.22.sh,
                                            width: double.infinity) // Show shimmer while loading
                                        : ProfileCardsView(
                                            selectedSegmentIndex: selectedSegmentIndex,
                                            isHostedSelected: isHostedSelected,
                                            profileModel: profileModel,
                                          )
                                  ],
                                ),
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
}

class ProfileFavTypeWidget extends ConsumerWidget {
  const ProfileFavTypeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(profileCtr);

    return Container(
      color: TAppColors.black50,
      height: 45.h,
      width: dwidth!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4.h),
          Expanded(
            child: Center(
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return TBounceAction(
                    onPressed: () {
                      _.currEventPage = 0;
                      _.selectedFavType = index;
                      _.notifyListeners();
                    },
                    child: Center(
                        child: TCard(
                            radius: 20,
                            color: _.selectedFavType == index
                                ? TAppColors.selectionColor
                                : TAppColors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              child: TText(_.favTypeList[index],
                                  color: _.selectedFavType == index
                                      ? TAppColors.white
                                      : TAppColors.text1Color),
                            ))),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },
                itemCount: _.favTypeList.length,
              ),
            ),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}
