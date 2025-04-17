import 'package:Happinest/modules/events/event_details_moments/views/event_details/personal_event/personal_event_about_card_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/personal_event/personal_event_detail_venue_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/personal_event/personal_event_details_about_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/personal_event/personal_evnt_details_schedule_screen.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';

class PersonalEventDetailsScreen extends ConsumerStatefulWidget {
  const PersonalEventDetailsScreen({super.key});

  @override
  ConsumerState<PersonalEventDetailsScreen> createState() => _PersonalEventDetailsScreenState();
}

class _PersonalEventDetailsScreenState extends ConsumerState<PersonalEventDetailsScreen>
    with TickerProviderStateMixin {
  List<String> tabNames = ['About', 'Venue', 'Schedule', 'Card'];
  late TabController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: tabNames.length, vsync: this);
    init();
    super.initState();
  }

  init() {
    final personalEventCtr = ref.read(personalEventHomeController);
    bool isCardShow = personalEventCtr.homePersonalEventDetailsModel?.invitationUrl != null && personalEventCtr.homePersonalEventDetailsModel?.invitationUrl.toString() != '';
    if(isCardShow == false) {
      tabNames.removeAt(3);
      _pages.removeAt(3);
    }
    bool isScheduleShow = personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList != null && (personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList?.isNotEmpty ?? personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList?.length != 0);
    if(isScheduleShow == false) {
      tabNames.removeAt(2);
      _pages.removeAt(2);
    }
    _tabController = TabController(length: tabNames.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    },);
  }

  buildTabRow(context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        controller: _tabController,
        tabs: tabNames.asMap().entries.map((icon) {
          return Tab(
            // Expand to fit
            iconMargin: EdgeInsets.zero,
            child: GestureDetector(
              // splashColor: Colors.transparent,
              // highlightColor: Colors.transparent,
              onTap: () {
                _animateToPage(icon.key);
              },
              child: Text(
                icon.value,
                maxLines: 1,
                style: icon.key == _tabController.index
                    ? getSemiBoldStyle(
                    fontSize: MyFonts.size12, color: TAppColors.selectionColor)
                    : getRegularStyle(
                    fontSize: MyFonts.size12,
                    color: TAppColors.white),
              ),
            ),
          );
        }).toList(),
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: TAppColors.selectionColor,
              width: 2.0,
            ),
          ),
        ),
        labelColor: TAppColors.selectionColor,
        unselectedLabelColor: TAppColors.white,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  handleTabPages(BuildContext context, int index) {
    switch (index) {
      case 0:
        return const PersonalEventDetailAboutScreen();
      case 1:
        return const PersonalEventDetailVenueScreen();
      case 2:
        return const PersonalEventDetailScheduleScreen();
      case 3:
        return const PersonalEventDetailCardScreen();
    }
  }

  final List<Widget> _pages = [
    const PersonalEventDetailAboutScreen(),
    const PersonalEventDetailVenueScreen(),
    const PersonalEventDetailScheduleScreen(),
    const PersonalEventDetailCardScreen(),
  ];

  void _animateToPage(int page) {
    setState(() {
      currentIndex = page;
    });
    _tabController.animateTo(
      page,
      duration:
      const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 0.85.sw),
          child: Text(
            ref.watch(personalEventHomeController).homePersonalEventDetailsModel?.title ?? '',
            maxLines: 1,
            textAlign: TextAlign.center,
            style: getRegularStyle(
                fontSize: MyFonts.size16, color: TAppColors.white),
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        buildTabRow(context),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _pages,
          ),
        ),
        // handleTabPages(context, currentIndex),
      ],
    );
  }
}