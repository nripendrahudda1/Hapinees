
import 'package:Happinest/modules/explore/explore_google_map.dart';
import 'package:Happinest/modules/explore/search_location/search_location_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/constants/constants.dart';
import '../../common/widgets/common_occasion_card.dart';
import '../../common/widgets/common_story_card.dart';
import '../../common/widgets/select_event_type_widget.dart';
import 'explore_controller.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  GlobalKey<MapScreenState> map = GlobalKey<MapScreenState>();
  double maxPixel = 0;
  ScrollController scrollOfDays = ScrollController();
  double scrollPosition = 0;
  int currIndex = 0;
  String selectedLocation = "No location selected";
  var userID;

  @override
  void initState() {
    // TODO: implement initState
    final _ = ref.read(exploreCtr);
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    _.getMyStory(userID, context);
    _.scrollController.addListener(onScroll);
    _.selectedSubEventType = 0;
    _.selectedEventType = 0;
    super.initState();
  }

  onScroll() {
    final _ = ref.read(exploreCtr);
    // Calculate the current index based on the scroll position
    double offset = _.scrollController.offset;
    double itemWidth = 0.34.sw;
    double separatorWidth = 20.w;
    int index = (offset / (itemWidth + separatorWidth)).floor();

    // Update the index if it has changed
    if (index > 0) {
      setState(() {
        _.currPage = index;
      });
    }
  }

  Future<void> openSearchLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchLocationScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedLocation = result['description'];
        print("****************** selectedLocation ******************");
        print(result.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.white,
      body: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final exCtr = ref.watch(exploreCtr);
            exCtr.locationAdd("Chicago, IL USA");
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: topSfarea > 0 ? topSfarea + 0.05.sh : 0.1.sh,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Image.asset(
                                TImageName.exploreLocationMarker,
                                width: 32.w,
                                height: 32.h,
                              ),
                              SizedBox(width: 10.w,),
                              GestureDetector(
                                onTap: (){
                                  // searchLocationScreen(context);
                                  openSearchLocationScreen();
                                },
                                child: Row(
                                  children: [
                                    TText(exCtr.locationSearch,color: TAppColors.black,fontSize: 14.w,fontWeight: FontWeight.w400),
                                    SizedBox(width: 10.w,),
                                    const Icon(Icons.search,color: TAppColors.text4Color,),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                      ],
                    ),
                  ),
                  CommonEventTypeWidget(
                    onTap: (index) {
                      exCtr.selectedEventType = index;
                      exCtr.selectedSubEventType = 0;
                      exCtr.notifyListeners();
                      },
                    subOnTap: (index) {
                      exCtr.selectedSubEventType = index;
                      exCtr.notifyListeners();
                    },
                    selectedEventType: exCtr.selectedEventType,
                    selectedSubEventType: exCtr.selectedSubEventType,
                    subEventTypeList: exCtr.subEventTypeList,),
                  // exCtr.stories != null && exCtr.stories!.isNotEmpty
                  //     ?
                  Expanded(child: ExploreMap(stories: exCtr.stories ?? [],key: map,))
                      // : const SizedBox(),
                ],
              ),
              Positioned(
                bottom: (bottomSfarea > 6.h
                    ? bottomSfarea + 0.07.sh
                    : 0.075.sh) -
                    2.h,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: exCtr.stories != null &&
                      exCtr.stories!.isNotEmpty
                      ? Padding(
                    padding: const EdgeInsets.only(
                        bottom:
                        // _.isOtherProfile ? 28 :
                        16),
                    child: SizedBox(
                      height: 0.22.sh,
                      width: dwidth,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          controller: exCtr.scrollController,
                            itemBuilder: (context, index) {
                              return (exCtr.stories![index]
                                  .eventTypeMasterId ??
                                  0) ==
                                  0
                                  ? SizedBox(
                                width: 0.34.sw,
                                height: 0.22.sh,
                                    child: CommonStoryCard(
                                        screenName: 'explore',
                                        data: exCtr.stories![index],
                                        titleTopPadding: 14.h,
                                        titleFontSize: 16.sp,
                                        width: 0.34.sw,
                                        proFileHeight: 30.h,
                                        proFileDateSize: 10.sp,
                                        proFileNameSize: 14.sp,
                                        isCurrant: exCtr.currPage == index,
                                        iconSize: 16.h,
                                        height: 0.22.sh,
                                    onTab: (){
                                      String userID = PreferenceUtils.getString(PreferenceKey.userId);
                                      exCtr.getMyStory(userID, context);
                                    },
                                    index: index),
                                  )
                                  : SizedBox(
                                height: 0.22.sh,
                                width: 0.34.sw,
                                child: CommonOccasionCard(
                                    screenName: 'explore',
                                    data:
                                    exCtr.stories![
                                    index],
                                    height: 0.22.sh,
                                    width: 0.34.sw,
                                    proFileHeight: 30.h,
                                    iconSize: 16.h,
                                    proFileDateSize: 10.sp,
                                    proFileNameSize: 14.sp,
                                    titleTopPadding: 14.h,
                                    isCurrant: exCtr.currPage == index,
                                    titleFontSize: 16.sp,
                                    onTab: (value){
                                      String userID = PreferenceUtils.getString(PreferenceKey.userId);
                                      exCtr.getMyStory(userID, context);
                                    },
                                    index: index),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 20.w,
                              );
                            },
                            itemCount: exCtr.stories!.length)
                      ),
                    ),
                  )
                      : Image.asset(
                                        TImageName.noEventFound,
                                        width: dwidth! * 0.8,
                                      ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}