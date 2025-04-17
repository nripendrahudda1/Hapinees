import '../../../common/common_imports/apis_commons.dart';
import '../../../common/common_imports/common_imports.dart';
import '../../../utility/constants/constants.dart';
import '../controller/profile_controller.dart';
import '../profile_screen.dart';
import 'package:Happinest/modules/profile/widgets/profile_event_google_map.dart' as event;
import 'package:Happinest/modules/profile/widgets/profile_fav_event_google_map.dart' as fav_event;
import 'package:Happinest/modules/profile/widgets/profile_post_google_map.dart' as post;
import 'package:Happinest/modules/profile/widgets/profie_fav_location_google_map.dart' as location;
import 'package:Happinest/modules/profile/widgets/profile_authors_google_map.dart' as author;

class ProfileCommonMapView extends ConsumerStatefulWidget {
  const ProfileCommonMapView({super.key, required this.selectedSegmentIndex, required this.mapKey});
  final int selectedSegmentIndex;
  final Key mapKey;

  @override
  ConsumerState<ProfileCommonMapView> createState() => _ProfileCommonMapViewState();
}

class _ProfileCommonMapViewState extends ConsumerState<ProfileCommonMapView> {
  @override
  Widget build(BuildContext context) {
    final _ = ref.read(profileCtr);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 140.h),
          child: Visibility(
            visible: widget.selectedSegmentIndex == 1,
            child: const ProfileFavTypeWidget(),
          ),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 0,
          child: eventMapWidget(),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 0,
          child: favAuthorMapWidget(),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 1,
          child: favEventMapWidget(),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 2,
          child: favLocationMapWidget(),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 1 && _.selectedFavType == 3,
          child: favPostMapWidget(),
        ),
        Visibility(
          visible: widget.selectedSegmentIndex == 2,
          child: funWidget(),
        ),
      ],
    );
  }

  Widget eventMapWidget() {
    final _ = ref.read(profileCtr);
    return _.isLoading != true
        ? _.stories != null && _.stories!.isNotEmpty
            ? Expanded(
                child: event.ProfileEventMap(
                  key: widget.key,
                  stories: _.stories!,
                ),
              )
            : Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(TImageName.notripgif),
                      // Text('No Trips or Events Found')
                    ),
                    const Text(
                      'No Events Found',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              )
        : const SizedBox();
  }

  Widget favEventMapWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Expanded(
            child: fav_event.ProfileFavEventMap(
              key: widget.key,
              stories: _.stories!,
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(TImageName.notripgif),
                  // Text('No Trips or Events Found')
                ),
                const Text(
                  'No Events Found',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
  }

  Widget favLocationMapWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Expanded(
            child: location.ProfileFavLocationMap(
              key: widget.key,
              stories: _.stories!,
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(TImageName.notripgif),
                  // Text('No Trips or Events Found')
                ),
                const Text(
                  'No Location Found',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
  }

  Widget favPostMapWidget() {
    final _ = ref.read(profileCtr);
    return _.stories != null && _.stories!.isNotEmpty
        ? Expanded(
            child: post.ProfilePostMap(
              key: widget.key,
              stories: _.stories!,
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(TImageName.notripgif),
                  // Text('No Trips or Events Found')
                ),
                const Text(
                  'No Posts Found',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
  }

  Widget favAuthorMapWidget() {
    final _ = ref.read(profileCtr);
    return _.authorsList != null && _.authorsList?.authors != []
        ? Expanded(
            child: author.ProfileAuthorMap(
              key: widget.key,
              stories: _.authorsList?.authors ?? [],
            ),
          )
        : Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(TImageName.notripgif),
                  // Text('No Trips or Events Found')
                ),
                const Text(
                  'No Authors Found',
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          );
  }

  Widget funWidget() {
    final _ = ref.read(profileCtr);
    return Expanded(
        child: Container(
      color: TAppColors.greyText,
      alignment: Alignment.center,
      child: TCard(
          width: dwidth! * 0.9,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TText('Coming Soon!',
                    fontWeight: FontWeight.w700, fontSize: 20, color: Colors.black),
                // TText('“Fun” What’s happening around you',
                //     fontWeight: FontWeight.w400,
                //     fontSize: 14,
                //     color: Colors.black)
              ],
            ),
          )),
    ));
  }
}
