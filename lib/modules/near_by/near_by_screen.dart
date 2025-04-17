import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/common/widgets/select_event_type_widget.dart';
import 'package:Happinest/modules/near_by/widgets/near_by_map_widget.dart';

import '../../common/common_imports/apis_commons.dart';
import '../../common/common_imports/common_imports.dart';
import '../../common/widgets/common_occasion_card.dart';
import '../../common/widgets/common_story_card.dart';
import '../../utility/constants/constants.dart';
import '../explore/explore_google_map.dart';
import 'controller/near_by_controller.dart';

class NearByScreen extends ConsumerStatefulWidget {
  const NearByScreen({super.key});

  @override
  ConsumerState<NearByScreen> createState() => _NearByScreenState();
}

class _NearByScreenState extends ConsumerState<NearByScreen> {
  GlobalKey<MapScreenState> map = GlobalKey<MapScreenState>();
  var userID;
  @override
  void initState() {
    // TODO: implement initState
    final _ = ref.read(nearByCtr);
    userID = PreferenceUtils.getString(PreferenceKey.userId);
    _.getMyStory(userID, context);
    _.nearByCardController.addListener(onScroll);
    _.selectedSubEventType = 0;
    _.selectedEventType = 0;
    super.initState();
  }

  onScroll() {
    final _ = ref.read(nearByCtr);
    double offset = _.nearByCardController.offset;
    double itemWidth = 0.34.sw;
    double separatorWidth = 20.w;
    int index = (offset / (itemWidth + separatorWidth)).floor();
    if (index > 0) {
      setState(() {
        _.currPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.white,
      body: Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final nearCtr = ref.watch(nearByCtr);
        return Stack(
          children: [
            Column(
              children: [
                topPadding(topPadding: topSfarea + 8.h, offset: 5.h),
                CommonEventTypeWidget(
                  subEventTypeList: nearCtr.subEventTypeList,
                  selectedEventType: nearCtr.selectedEventType,
                  selectedSubEventType: nearCtr.selectedSubEventType,
                  onTap: (index) {
                    nearCtr.selectedEventType = index;
                    nearCtr.selectedSubEventType = 0;
                    nearCtr.notifyListeners();
                  },
                  subOnTap: (index) {
                    nearCtr.selectedSubEventType = index;
                    nearCtr.notifyListeners();
                  },
                ),
                // nearCtr.stories != null && nearCtr.stories!.isNotEmpty ?
                Expanded(
                    child: NearByMap(
                  stories: nearCtr.stories ?? [],
                  key: map,
                )), //: const SizedBox(),
              ],
            ),
            Positioned(
              bottom: (bottomSfarea > 6.h ? bottomSfarea + 0.07.sh : 0.075.sh) - 2.h,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: nearCtr.stories != null && nearCtr.stories!.isNotEmpty
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
                                  controller: nearCtr.nearByCardController,
                                  itemBuilder: (context, index) {
                                    return (nearCtr.stories![index].eventTypeMasterId ?? 0) == 0
                                        ? SizedBox(
                                            width: 0.34.sw,
                                            height: 0.22.sh,
                                            child: CommonStoryCard(
                                                screenName: 'nearBy',
                                                data: nearCtr.stories![index],
                                                titleTopPadding: 14.h,
                                                titleFontSize: 16.sp,
                                                width: 0.34.sw,
                                                proFileHeight: 30.h,
                                                proFileDateSize: 10.sp,
                                                proFileNameSize: 14.sp,
                                                iconSize: 16.h,
                                                isCurrant: nearCtr.currPage == index,
                                                height: 0.22.sh,
                                                onTab: () {
                                                  String userID = PreferenceUtils.getString(
                                                      PreferenceKey.userId);
                                                  nearCtr.getMyStory(userID, context);
                                                },
                                                index: index),
                                          )
                                        : SizedBox(
                                            height: 0.22.sh,
                                            width: 0.34.sw,
                                            child: CommonOccasionCard(
                                                screenName: 'nearBy',
                                                data: nearCtr.stories![index],
                                                height: 0.22.sh,
                                                width: 0.34.sw,
                                                proFileHeight: 30.h,
                                                iconSize: 16.h,
                                                proFileDateSize: 10.sp,
                                                proFileNameSize: 14.sp,
                                                titleTopPadding: 14.h,
                                                isCurrant: nearCtr.currPage == index,
                                                titleFontSize: 16.sp,
                                                onTab: (value) {
                                                  String userID = PreferenceUtils.getString(
                                                      PreferenceKey.userId);
                                                  nearCtr.getMyStory(userID, context);
                                                },
                                                index: index),
                                          );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 20.w,
                                    );
                                  },
                                  itemCount: nearCtr.stories!.length)),
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
      }),
    );
  }
}

/*
class NearByScreen extends StatelessWidget {
  const NearByScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.greyText,
      body: Center(
        child: TCard(
            width: dwidth! * 0.9,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TText('Coming Soon!',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.black),
                  TText('“Nearby” What’s happening around you',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black)
                ],
              ),
            )),
      ),
    );
  }
}*/
