import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/apis_commons.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/events/event_details_moments/controller/occasion_event_memories_controller.dart';

import '../../../../../../models/create_event_models/moments/occasion_event_moments/occasion_event_all_moment_model.dart';
import '../../widgets/wedding_event/wedding_event_moment_post_widget.dart';
import '../../widgets/moments_expandable_post_button.dart';
import '../../widgets/moments_filter_widget.dart';

class WeddingEventMomentsHomeScreen extends ConsumerStatefulWidget {
  const WeddingEventMomentsHomeScreen({super.key});

  @override
  ConsumerState<WeddingEventMomentsHomeScreen> createState() => _EventMomentsScreenState();
}

class _EventMomentsScreenState extends ConsumerState<WeddingEventMomentsHomeScreen> {
  int selectedIndex = 0; // Default selected index
  String selectedRitual = ''; // Default selected index
  List<String> types = [
    'All',
    'My Feed',
    'Sangeet',
    'Mehandi',
    'Baraat',
    'Jamila'
  ];
  final _key = GlobalKey<ExpandableFabState>();


  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize(){
    print(ref.read(personalEventHomeController).homePersonalEventDetailsModel?.personalEventHeaderId);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      await ref.read(occasionEventMemoriesController).getAllMemories(
          token: PreferenceUtils.getString(PreferenceKey.accessToken),
          weddingHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId?.toString() ?? '',
          eventTypeMasterId: '1',
          ref: ref,
          context: context
      );
      final memoriesCtr = ref.watch(occasionEventMemoriesController);
      List<String> tempRituals = ['All'];
      memoriesCtr.eventAllMemoriesModel?.ritualFilters?.forEach((element) {
        tempRituals.add(element.ritualName?? '');
      });
      types = tempRituals;
      selectedRitual = types[0];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.eventScaffoldColor,
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: MomentsExpandablePostButton(
        isPersonalEvent: false,
        fabKey: _key,
        token: PreferenceUtils.getString(PreferenceKey.accessToken),
        eventTitle: ref.read(weddingEventHomeController).homeWeddingDetails?.title,
        eventHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId,),
      body: Column(children: [
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final eventCtr = ref.watch(weddingEventHomeController);
            return Container(
              constraints: BoxConstraints(maxWidth: 0.85.sw),
              child: Text(
                eventCtr.homeWeddingDetails?.title ?? '',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                    fontSize: MyFonts.size16, color: TAppColors.white),
              ),
            );
          },
        ),
        SizedBox(
          height: 2.h,
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final memoriesCtr = ref.watch(occasionEventMemoriesController);
            return MomentsFilterWidget(
              types: types,
              selectedIndex: selectedIndex,
              isPersonalEvent: false,
              onTap: (int index) {
                setState(() {
                  selectedIndex = index;
                  selectedRitual = types[index];
                  memoriesCtr.filteredMomentsPosts(selectedRitual);
                  print(selectedRitual);
                });
              },
            );
          },
        ),
        Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final memoriesCtr = ref.watch(occasionEventMemoriesController);
            return memoriesCtr.posts.isNotEmpty?
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Post model = memoriesCtr.posts[index];

                  return WeddingEventMomentPostWidget(
                    postModel: model,
                    hasDesc:
                    model.postNote == null || model.postNote == '' ? false: true,
                    // index%4==0 ?true:false,
                    token: PreferenceUtils.getString(PreferenceKey.accessToken),
                    eventHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId,
                    hasBookMark: false,
                    isTextPost:
                    model.postMedias?.length == 0?true:false,
                    // index%3==0 && index!=0?true:false,
                    description: model.postNote ?? '',
                  );
                },
                itemCount: memoriesCtr.posts.length,
              ),
            ):
              memoriesCtr.eventAllMemoriesModel == null ||
              memoriesCtr.eventAllMemoriesModel?.posts == null ||
              memoriesCtr.eventAllMemoriesModel?.posts?.length == 0 ?
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 100.h,),
                    Text('No Memories Found!', style: getMediumStyle(
                  fontSize: MyFonts.size16,
                      color: TAppColors.containerColor
                    ),)
                  ],
                ),
              ):
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    Post model = memoriesCtr.eventAllMemoriesModel!.posts![index];

                    return WeddingEventMomentPostWidget(
                      postModel: model,
                        hasDesc:
                        model.postNote == null || model.postNote == '' ? false: true,
                      // index%4==0 ?true:false,
                        hasBookMark: false,
                        eventHeaderId: ref.read(weddingEventHomeController).homeWeddingDetails?.weddingHeaderId,
                        token: PreferenceUtils.getString(PreferenceKey.accessToken),
                        isTextPost:
                        model.postMedias?.length == 0?true:false,
                        // index%3==0 && index!=0?true:false,
                      description: model.postNote ?? '',
                    );
                  },
                  itemCount: memoriesCtr.eventAllMemoriesModel?.posts?.length,
              ),
            );
          },
        ),
      ]),
    );
  }
}
