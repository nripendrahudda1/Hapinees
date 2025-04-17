import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/e_top_backbutton.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/wedding_event/event_details_screen.dart';
import '../../../../common/common_functions/datetime_functions.dart';
import '../../../../common/widgets/e_top_editbutton.dart';
import '../../../../core/enums/user_role_enum.dart';
import '../../update_wedding_event/controllers/wedding_event/update_wedding_couple_controller.dart';
import '../../update_wedding_event/controllers/common_update_event_dates_controller.dart';
import '../../update_wedding_event/controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../update_wedding_event/controllers/wedding_event/update_wedding_style_controller.dart';
import '../../update_wedding_event/controllers/common_update_event_title_controller.dart';
import '../controller/moment_and_detail_provider.dart';
import '../event_moments/views/home_screen/personal_event_moments_home_screen.dart';
import '../event_moments/views/home_screen/wedding_event_moments_home_screen.dart';
import 'event_details/personal_event/personal_event_details_screen.dart';

class EventDetailsAndMomentsScreen extends ConsumerStatefulWidget {
  EventDetailsAndMomentsScreen({super.key, required this.isPersonalEvent});
  bool isPersonalEvent = false;

  @override
  ConsumerState<EventDetailsAndMomentsScreen> createState() => _EventDetailsAndMomentsScreenState();
}

class _EventDetailsAndMomentsScreenState extends ConsumerState<EventDetailsAndMomentsScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> _weddingPages = [
    const WeddingEventMomentsHomeScreen(),
    const WeddingEventDetailsScreen(),
  ];
  final List<Widget> _personalPages = [
    const PersonalEventMomentsHomeScreen(),
    const PersonalEventDetailsScreen(),
  ];
  List<String> tabNames = [TButtonLabelStrings.momentsButton, TButtonLabelStrings.eventDetail];
  late TabController _tabController;
  @override
  void initState() {
    
    final tabProvider = ref.read(momentAndDetailProvider);
    if (!widget.isPersonalEvent) {
      final weddingEventCtr = ref.read(weddingEventHomeController);
      if (weddingEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type) {
        setState(() {
          tabNames.removeLast();
          _weddingPages.removeLast();
        });
      }
    } else {
      final personalEventCtr = ref.read(personalEventHomeController);
      if (personalEventCtr.userRoleEnum.type == UserRoleEnum.PublicUser.type) {
        setState(() {
          tabNames.removeLast();
          _personalPages.removeLast();
        });
       
      }
    }
    _tabController = TabController(
        length: tabNames.length, vsync: this, initialIndex: tabProvider.getInitialIndex);
    super.initState();
  }

  setTabIndex(int index) {
    setState(() {
      _tabController.index = index;
    });
    final tabProvider = ref.read(momentAndDetailProvider);
    tabProvider.setInitialIndex(initialndex: index);
  }

  setForUpdate(WidgetRef ref) {
    final manageStylesCtr = ref.read(updateWeddingStylesCtr);
    final wedStylesCtr = ref.read(weddingEventHomeController);
    manageStylesCtr.addFirstSelectedStyle(wedStylesCtr.homeWeddingDetails?.weddigStyleName ?? '');

    final ritualsCtr = ref.read(updateWeddingRitualsCtr);
    ritualsCtr.addFirstSelectedRituals(ritualsCtr.weddingRitualss[0]);
    ritualsCtr.addFirstSelectedRituals(ritualsCtr.weddingRitualss[1]);
    ritualsCtr.addFirstSelectedRituals(ritualsCtr.weddingRitualss[3]);

    final coupleCtr = ref.read(updateWeddingCoupleCtr);
    coupleCtr.setCouple1Name("Jane Doe");
    coupleCtr.setCouple2Name("John Doe");

    final coupleTitleCtr = ref.read(updateEventTitleCtr);
    coupleTitleCtr.setTitleName("Jane weds John");

    final dateCtr = ref.read(updateEventDatesCtr);
    dateCtr.setStatusOfDays(true);
    dateCtr.setDate1(formatDateShort(DateTime.now()));
    dateCtr.setDate1Time(DateTime.now().add(const Duration(days: 1)));
    dateCtr.setDate2(formatDateLong(DateTime.now().add(const Duration(days: 1))));
  }

  /// Page transition with slide down animation
  Route _createSlideDownRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => const Scaffold(
        backgroundColor: Colors.transparent, // Keep it transparent
        body: SizedBox(), // Empty Widget as we only care about animation
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0), // Start at normal position
            end: const Offset(0, 1), // Move to bottom (exit)
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabProvider = ref.watch(momentAndDetailProvider);
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // Swipe Down Detected
          _createSlideDownRoute();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: TAppColors.eventScaffoldColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, 1.sh * 0.07, 16, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ETopBackButton(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Consumer(builder: (context, ref, child) {
                        final personalEventCtr = ref.read(personalEventHomeController);
                        final weddingEventCtr = ref.read(weddingEventHomeController);
                        final dataStatus = compareDate(
                            personalEventCtr.homePersonalEventDetailsModel?.startDateTime);
                        return Row(
                          children: [
                            if ((widget.isPersonalEvent &&
                                    personalEventCtr.userRoleEnum.type ==
                                        UserRoleEnum.PublicUser.type) ||
                                (widget.isPersonalEvent == false &&
                                    weddingEventCtr.userRoleEnum.type ==
                                        UserRoleEnum.PublicUser.type))
                              Container(
                                width: 250.w, // Adjust width as needed
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.grey, width: 1.w),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setTabIndex(0);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _tabController.index == 0
                                            ? TAppColors.selectedTabBarBgColor
                                            : Colors.transparent,
                                      ),
                                      height: 36.h,
                                      alignment: Alignment.center,
                                      child: Text(
                                        TButtonLabelStrings.momentsButton,
                                        textAlign: TextAlign.center,
                                        style: _tabController.index == 0
                                            ? getSemiBoldStyle(
                                                fontSize: MyFonts.size14,
                                                color: TAppColors.selectionColor)
                                            : getRegularStyle(
                                                fontSize: MyFonts.size14, color: TAppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if ((widget.isPersonalEvent &&
                                    (personalEventCtr.userRoleEnum.type ==
                                            UserRoleEnum.PublicUser.type) ==
                                        false) ||
                                (widget.isPersonalEvent == false &&
                                    (weddingEventCtr.userRoleEnum.type ==
                                            UserRoleEnum.PublicUser.type) ==
                                        false))
                              Container(
                                width: 250.w, // Adjust width as needed
                                height: 36.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(color: Colors.grey, width: 1.w),
                                  borderRadius: BorderRadius.circular(18.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              setTabIndex(0);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: _tabController.index == 0
                                                  ? TAppColors.selectedTabBarBgColor
                                                  : Colors.transparent,
                                            ),
                                            height: 36.h,
                                            alignment: Alignment.center,
                                            child: Text(
                                              TButtonLabelStrings.momentsButton,
                                              textAlign: TextAlign.center,
                                              style: _tabController.index == 0
                                                  ? getSemiBoldStyle(
                                                      fontSize: MyFonts.size14,
                                                      color: TAppColors.selectionColor)
                                                  : getRegularStyle(
                                                      fontSize: MyFonts.size14,
                                                      color: TAppColors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: dataStatus == false
                                            ? 2.w
                                            : 0.0, // Adjust the width of the divider
                                        height: 40.h, // Adjust the height of the divider
                                        color: Colors.grey,
                                      ),
                                      dataStatus == false
                                          ? Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setTabIndex(1);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: _tabController.index == 1
                                                        ? TAppColors.selectedTabBarBgColor
                                                        : Colors.transparent,
                                                  ),
                                                  height: 36.h,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    TButtonLabelStrings.eventDetail,
                                                    textAlign: TextAlign.center,
                                                    style: _tabController.index == 1
                                                        ? getSemiBoldStyle(
                                                            fontSize: MyFonts.size14,
                                                            color: TAppColors.selectionColor)
                                                        : getRegularStyle(
                                                            fontSize: MyFonts.size14,
                                                            color: TAppColors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                      if (tabProvider.getInitialIndex == 1)
                        Consumer(builder: (context, ref, child) {
                          return SizedBox(
                            width: 22.w,
                            child: ETopEditButton(
                              onTap: () {
                                if (widget.isPersonalEvent) {
                                  Navigator.pushNamed(context, Routes.updatePersonalEventScreen,
                                      arguments: {
                                        'homeModel': ref
                                            .watch(personalEventHomeController)
                                            .homePersonalEventDetailsModel
                                      });
                                } else {
                                  // setForUpdate(ref);
                                  Navigator.pushNamed(context, Routes.updateWeddingEventScreen,
                                      arguments: {
                                        'homeModel':
                                            ref.watch(weddingEventHomeController).homeWeddingDetails
                                      });
                                }
                              },
                            ),
                          );
                        }),
                      if (tabProvider.getInitialIndex != 1)
                        SizedBox(
                          width: 22.w,
                        )
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: !widget.isPersonalEvent ? _weddingPages : _personalPages,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
