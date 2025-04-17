import 'package:Happinest/models/create_event_models/moments/personal_event_moments/personal_event_all_moment_model.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/personal_event_memories_controller.dart';
import 'package:Happinest/modules/events/event_details_moments/event_moments/widgets/personal_event/personal_event_moment_post_widget.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../core/enums/user_role_enum.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';
import '../../widgets/moments_expandable_post_button.dart';
import '../../widgets/moments_filter_widget.dart';

// class PersonalEventMomentsHomeScreen extends ConsumerStatefulWidget {
//   const PersonalEventMomentsHomeScreen({super.key});

//   @override
//   ConsumerState<PersonalEventMomentsHomeScreen> createState() =>
//       _PersonalEventMomentsHomeScreenState();
// }

// class _PersonalEventMomentsHomeScreenState extends ConsumerState<PersonalEventMomentsHomeScreen> {
//   int selectedIndex = 0;
//   String selectedRitual = '';
//   List<String> filterArray = ['All', 'My Feed'];
//   final _key = GlobalKey<ExpandableFabState>();
//   final ScrollController _scrollController = ScrollController();
//   ValueNotifier<bool> isFilterVisible = ValueNotifier<bool>(true);
//   double lastScrollOffset = 0.0;
//   var loginUserID = int.tryParse(PreferenceUtils.getString(PreferenceKey.userId));

//   @override
//   void initState() {
//     super.initState();
//     initiallize();
//     _scrollController.addListener(_handleScroll);
//   }

//   void _scrollToTop() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0.0,
//         duration: const Duration(milliseconds: 300), // Smooth scroll
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   initiallize() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await ref.read(personalEventMemoriesController).getAllMemories(
//           token: PreferenceUtils.getString(PreferenceKey.accessToken),
//           personalEventHeaderId: ref
//                   .read(personalEventHomeController)
//                   .homePersonalEventDetailsModel
//                   ?.personalEventHeaderId
//                   ?.toString() ??
//               '',
//           ref: ref,
//           context: context);
//       final memoriesCtr = ref.watch(personalEventMemoriesController);
//       // List<String> tempRituals = ['All'];
//       // memoriesCtr.personalEventAllMemoriesModel?.ritualFilters?.forEach((element) {
//       //   tempRituals.add(element.ritualName?? '');
//       // });
//       // types = tempRituals;
//       // // Scroll after data is fetched
//       selectedRitual = filterArray[0];
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

// // Hide and Show ALL and My Feed filter
//   void _handleScroll() {
//     _closeFab();
//     double currentOffset = _scrollController.offset;
//     if (currentOffset <= 0.0 || currentOffset <= 100) {
//       // At the top → Always show the filter
//       if (!isFilterVisible.value) {
//         isFilterVisible.value = true;
//       }
//     } else if (currentOffset > lastScrollOffset) {
//       // Scrolling down → Hide the filter
//       if (isFilterVisible.value) {
//         isFilterVisible.value = false;
//       }
//     }
//     lastScrollOffset = currentOffset; // Update last scroll position
//   }

// // Open  MomentsExpandablePostButton button
//   void _closeFab() {
//     if (_key.currentState?.isOpen ?? false) {
//       _key.currentState?.toggle(); // Close the FAB only if it's open
//     }
//   }

//   Route _createSlideDownRoute() {
//     return PageRouteBuilder(
//       transitionDuration: const Duration(milliseconds: 500),
//       pageBuilder: (context, animation, secondaryAnimation) => const Scaffold(
//         backgroundColor: Colors.transparent, // Keep it transparent
//         body: SizedBox(), // Empty Widget as we only care about animation
//       ),
//       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0, 0), // Start at normal position
//             end: const Offset(0, 1), // Move to bottom (exit)
//           ).animate(CurvedAnimation(
//             parent: animation,
//             curve: Curves.easeInOut,
//           )),
//           child: child,
//         );
//       },
//     );
//   }

//   bool enableFilter() {
//     final memoriesCtr = ref.watch(personalEventMemoriesController);
// // Extract user IDs from the posts
//     List<int?> userIds =
//         memoriesCtr.personalEventPosts.map((post) => post.createdBy?.userId).toList();
// // Check if the logged-in user ID exists in the list
//     bool isUserPresent = userIds.contains(loginUserID);
//     if (isUserPresent) {
//       return true;
//     } else {
//       return false;
//     }
//   }

// // Post Button status
//   bool enableMomentButton() {
//     final personalEventCtr = ref.watch(personalEventHomeController);
//     if (personalEventCtr.homePersonalEventDetailsModel?.createdBy?.userId == loginUserID) {
//       return true;
//     } else if ((personalEventCtr.contributorRoleEnum == ContributorType.public ||
//         personalEventCtr.contributorRoleEnum == ContributorType.guest)) {
//       return true;
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onVerticalDragEnd: (details) {
//         if (details.primaryVelocity! > 0) {
//           // Swipe Down Detected
//           _createSlideDownRoute();
//           Navigator.pop(context);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: TAppColors.eventScaffoldColor,
//         floatingActionButtonLocation: ExpandableFab.location,
//         floatingActionButton: enableMomentButton()
//             ? MomentsExpandablePostButton(
//                 onRefresh: () {
//                   _scrollToTop();
//                 },
//                 isPersonalEvent: true,
//                 fabKey: _key,
//                 token: PreferenceUtils.getString(PreferenceKey.accessToken),
//                 eventTitle:
//                     ref.read(personalEventHomeController).homePersonalEventDetailsModel?.title,
//                 eventHeaderId: ref
//                     .read(personalEventHomeController)
//                     .homePersonalEventDetailsModel
//                     ?.personalEventHeaderId,
//               )
//             : null,
//         body: Column(
//           children: [
//             Consumer(
//               builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                 final eventCtr = ref.watch(personalEventHomeController);
//                 return Container(
//                   constraints: BoxConstraints(maxWidth: 0.85.sw),
//                   child: Text(
//                     eventCtr.homePersonalEventDetailsModel?.title ?? '',
//                     maxLines: 1,
//                     textAlign: TextAlign.center,
//                     style: getRegularStyle(fontSize: MyFonts.size16, color: TAppColors.white),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 2.h),

//             /// Show My and ALL feed Tab (Visible based on scrolling)
//             ValueListenableBuilder<bool>(
//               valueListenable: isFilterVisible,
//               builder: (context, visible, child) {
//                 return AnimatedOpacity(
//                   duration: const Duration(milliseconds: 300),
//                   opacity: visible ? 1.0 : 0.0,
//                   child: Visibility(
//                     visible: visible,
//                     child: Consumer(
//                       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                         final memoriesCtr = ref.watch(personalEventMemoriesController);
//                         return MomentsFilterWidget(
//                           types: enableFilter() ? filterArray : [],
//                           selectedIndex: selectedIndex,
//                           isPersonalEvent: true,
//                           onTap: (int index) {
//                             _closeFab();
//                             setState(() {
//                               selectedIndex = index;
//                               memoriesCtr.filteredMomentsPosts(index == 1);
//                             });
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),

//             Expanded(
//               child: Consumer(
//                 builder: (BuildContext context, WidgetRef ref, Widget? child) {
//                   final memoriesCtr = ref.watch(personalEventMemoriesController);

//                   return RefreshIndicator(
//                       onRefresh: () async {
//                         initiallize();
//                       },
//                       child: memoriesCtr.personalEventPosts.isNotEmpty
//                           ? ListView.builder(
//                               controller: _scrollController,
//                               padding: const EdgeInsets.all(0),
//                               scrollDirection: Axis.vertical,
//                               physics: const BouncingScrollPhysics(),
//                               itemBuilder: (context, index) {
//                                 PersonalEventPost model = memoriesCtr.personalEventPosts[index];
//                                 return PersonalEventMomentPostWidget(
//                                   onRefresh: () {
//                                     _scrollToTop();
//                                   },
//                                   fabKey: _key,
//                                   postModel: model,
//                                   currentIndex: index,
//                                   hasDesc: model.aboutPost?.isNotEmpty ?? false,
//                                   token: PreferenceUtils.getString(PreferenceKey.accessToken),
//                                   personalEventHeaderId: ref
//                                       .read(personalEventHomeController)
//                                       .homePersonalEventDetailsModel
//                                       ?.personalEventHeaderId,
//                                   hasBookMark: false,
//                                   isTextPost: model.personalEventPhotos?.isEmpty ?? true,
//                                   description: model.aboutPost ?? '',
//                                 );
//                               },
//                               itemCount: memoriesCtr.personalEventPosts.length,
//                             )
//                           : Center(
//                               child: Column(
//                                 children: [
//                                   SizedBox(height: 100.h),
//                                   Text(
//                                     'No Memories Found!',
//                                     style: getMediumStyle(
//                                         fontSize: MyFonts.size16, color: TAppColors.containerColor),
//                                   ),
//                                 ],
//                               ),
//                             ));
//                 },
//               ),
//             ),

//             Container(
//               height: 20.h,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class PersonalEventMomentsHomeScreen extends ConsumerStatefulWidget {
  const PersonalEventMomentsHomeScreen({super.key});

  @override
  ConsumerState<PersonalEventMomentsHomeScreen> createState() =>
      _PersonalEventMomentsHomeScreenState();
}

class _PersonalEventMomentsHomeScreenState extends ConsumerState<PersonalEventMomentsHomeScreen> {
  int selectedIndex = 0;
  String selectedRitual = '';
  List<String> filterArray = ['All', 'My Feed'];
  final _key = GlobalKey<ExpandableFabState>();
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> isFilterVisible = ValueNotifier<bool>(true);
  double lastScrollOffset = 0.0;
  var loginUserID = getUserID();
  int pagecount = 0;
  var allPosts = [];

  @override
  void initState() {
    super.initState();
    initiallize(); // This ensures the UI builds first before calling the API
    _scrollController.addListener(_handleScroll);
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300), // Smooth scroll
        curve: Curves.easeInOut,
      );
    }
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(personalEventMemoriesController).getAllMemories(
          token: PreferenceUtils.getString(PreferenceKey.accessToken),
          pageCount: pagecount,
          personalEventHeaderId: ref
                  .read(personalEventHomeController)
                  .homePersonalEventDetailsModel
                  ?.personalEventHeaderId
                  ?.toString() ??
              '',
          ref: ref,
          context: context);
      allPosts = ref.watch(personalEventMemoriesController).personalEventPosts;
      selectedRitual = filterArray[0];
    });

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
    _scrollController.removeListener(_handleScroll);
  }

  // Hide and Show Filter on Scroll
  void _handleScroll() {
    _closeFab();
    double currentOffset = _scrollController.offset;
    if (currentOffset <= 0.0 || currentOffset <= 100) {
      if (!isFilterVisible.value) {
        isFilterVisible.value = true;
      }
    } else if (currentOffset > lastScrollOffset) {
      if (isFilterVisible.value) {
        isFilterVisible.value = false;
      }
    }
    lastScrollOffset = currentOffset;

    // if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 250 &&
    //     !ref.read(personalEventMemoriesController).isLoading) {
    //   pagecount = pagecount + 1;
    //   ref.read(personalEventMemoriesController).getAllMemories(
    //       token: PreferenceUtils.getString(PreferenceKey.accessToken),
    //       pageCount: pagecount,
    //       personalEventHeaderId: ref
    //               .read(personalEventHomeController)
    //               .homePersonalEventDetailsModel
    //               ?.personalEventHeaderId
    //               ?.toString() ??
    //           '',
    //       ref: ref,
    //       context: context);
    // }
  }

  void _closeFab() {
    if (_key.currentState?.isOpen ?? false) {
      _key.currentState?.toggle(); // Close the FAB only if it's open
    }
  }

  bool enableFilter() {
    final userIds = allPosts.map((post) => post.createdBy?.userId).whereType<int>().toSet();
    return userIds.contains(loginUserID) && userIds.length > 1;
  }
  // bool enableFilter() {
  //   final memoriesCtr = ref.watch(personalEventMemoriesController);
  //   // Check if any post is created by a different user
  //   return memoriesCtr.personalEventPosts.any(
  //     (post) => post.createdBy?.userId != loginUserID,
  //   );
  // }
  // bool enableFilter() {
  //   final memoriesCtr = ref.watch(personalEventMemoriesController);
  //   List<int?> userIds =
  //       memoriesCtr.personalEventPosts.map((post) => post.createdBy?.userId).toList();
  //   return !userIds.contains(loginUserID);
  // }

  bool enableMomentButton() {
    final personalEventCtr = ref.watch(personalEventHomeController);
    if (personalEventCtr.homePersonalEventDetailsModel?.createdBy?.userId == loginUserID) {
      return true;
    } else if (personalEventCtr.homePersonalEventDetailsModel?.isContributor == true) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          _scrollToTop();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: TAppColors.eventScaffoldColor,
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: enableMomentButton()
            ? MomentsExpandablePostButton(
                onRefresh: () {
                  _scrollToTop();
                },
                isPersonalEvent: true,
                fabKey: _key,
                token: PreferenceUtils.getString(PreferenceKey.accessToken),
                eventTitle:
                    ref.read(personalEventHomeController).homePersonalEventDetailsModel?.title,
                eventHeaderId: ref
                    .read(personalEventHomeController)
                    .homePersonalEventDetailsModel
                    ?.personalEventHeaderId,
              )
            : null,
        body: Column(
          children: [
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final eventCtr = ref.watch(personalEventHomeController);
                return Container(
                  constraints: BoxConstraints(maxWidth: 0.85.sw),
                  child: Text(
                    eventCtr.homePersonalEventDetailsModel?.title ?? '',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(fontSize: MyFonts.size16, color: TAppColors.white),
                  ),
                );
              },
            ),
            SizedBox(height: 2.h),

            // Scrollable List with Filter
            Expanded(
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  final memoriesCtr = ref.watch(personalEventMemoriesController);
                  return RefreshIndicator(
                    onRefresh: () async {
                      initiallize();
                    },
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Filter Widget (Added Inside List)
                        if (enableFilter())
                          SliverToBoxAdapter(
                            child: ValueListenableBuilder<bool>(
                              valueListenable: isFilterVisible,
                              builder: (context, visible, child) {
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 200),
                                  opacity: visible ? 1.0 : 0.0,
                                  child: Visibility(
                                    visible: visible,
                                    child: SizedBox(
                                      height: 50.h,
                                      // width: 50.h, // Increase this value as needed
                                      child: Consumer(
                                        builder:
                                            (BuildContext context, WidgetRef ref, Widget? child) {
                                          final memoriesCtr =
                                              ref.watch(personalEventMemoriesController);
                                          return MomentsFilterWidget(
                                            types: filterArray,
                                            selectedIndex: selectedIndex,
                                            isPersonalEvent: true,
                                            onTap: (int index) {
                                              _closeFab();
                                              setState(() {
                                                selectedIndex = index;
                                                memoriesCtr.filteredMomentsPosts(index == 1);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                        // List of Memories Posts
                        memoriesCtr.personalEventPosts.isNotEmpty
                            ? SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    PersonalEventPost model = memoriesCtr.personalEventPosts[index];
                                    return PersonalEventMomentPostWidget(
                                      onRefresh: () {
                                        _scrollToTop();
                                      },
                                      fabKey: _key,
                                      postModel: model,
                                      currentIndex: index,
                                      hasDesc: model.aboutPost?.isNotEmpty ?? false,
                                      token: PreferenceUtils.getString(PreferenceKey.accessToken),
                                      personalEventHeaderId: ref
                                          .read(personalEventHomeController)
                                          .homePersonalEventDetailsModel
                                          ?.personalEventHeaderId,
                                      hasBookMark: false,
                                      isTextPost: model.personalEventPhotos?.isEmpty ?? true,
                                      description: model.aboutPost ?? '',
                                    );
                                  },
                                  childCount: memoriesCtr.personalEventPosts.length,
                                ),
                              )
                            : SliverToBoxAdapter(
                                child: Center(
                                  child: Text(
                                    'No Memories Found!',
                                    style: getMediumStyle(
                                        fontSize: MyFonts.size16, color: TAppColors.containerColor),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
