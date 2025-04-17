import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/wedding_event/about_card_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/wedding_event/detail_about_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/wedding_event/detail_schedule_screen.dart';
import 'package:Happinest/modules/events/event_details_moments/views/event_details/wedding_event/detail_venue_screen.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';

class WeddingEventDetailsScreen extends ConsumerStatefulWidget {
  const WeddingEventDetailsScreen({super.key});

  @override
  ConsumerState<WeddingEventDetailsScreen> createState() => _WeddingEventDetailsScreenState();
}

class _WeddingEventDetailsScreenState extends ConsumerState<WeddingEventDetailsScreen>
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
    final weddingEventCtr = ref.read(weddingEventHomeController);
    bool isCardShow = weddingEventCtr.homeWeddingDetails?.invitationUrl != null && weddingEventCtr.homeWeddingDetails?.invitationUrl.toString() != '';
    if(isCardShow == false) {
      tabNames.removeAt(3);
      _pages.removeAt(3);
    }
    bool isScheduleShow = weddingEventCtr.homeWeddingDetails?.weddingRitualList != null && (weddingEventCtr.homeWeddingDetails?.weddingRitualList?.isNotEmpty ?? weddingEventCtr.homeWeddingDetails?.weddingRitualList?.length != 0);
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
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
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
        return const WeddingEventDetailAboutScreen();
      case 1:
        return const WeddingEventDetailVenueScreen();
      case 2:
        return const WeddingEventDetailScheduleScreen();
      case 3:
        return const WeddingEventDetailCardScreen();
    }
  }

  final List<Widget> _pages = [
    const WeddingEventDetailAboutScreen(),
    const WeddingEventDetailVenueScreen(),
    const WeddingEventDetailScheduleScreen(),
    const WeddingEventDetailCardScreen(),
  ];

  void _animateToPage(int page) {
    _tabController.animateTo(
      page,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
    setState(() {
      currentIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 0.85.sw),
          child: Text(
            "Jane weds John",
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
