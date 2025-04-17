
import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../utility/constants/images/image_url.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';

class PersonalEventDetailAboutScreen extends ConsumerStatefulWidget {
  const PersonalEventDetailAboutScreen({super.key});

  @override
  ConsumerState<PersonalEventDetailAboutScreen> createState() => _PersonalEventDetailAboutScreenState();
}

class _PersonalEventDetailAboutScreenState extends ConsumerState<PersonalEventDetailAboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final personalEventCtr = ref.watch(personalEventHomeController);
        return Stack(
          children: [
            const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
            CachedRectangularNetworkImageWidget(
              image: TImageUrl.eventHomeBgUrl,
              width: 1.sw,
              height: 0.33.sh,
              radius: 0,
            ),
            Container(
              width: 1.sw,
              height: 0.33.sh,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    //AppColors.black.withOpacity(0.8),
                    TAppColors.transparent,
                    TAppColors.eventScaffoldColor.withOpacity(0.8),
                    TAppColors.eventScaffoldColor
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 0.2.sh,
                  ),
                  Text(
                    personalEventCtr.homePersonalEventDetailsModel?.title ??  '',
                    style: getBoldStyle(
                        color: TAppColors.white, fontSize: MyFonts.size18),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                    personalEventCtr.homePersonalEventDetailsModel?.aboutThePersonalEvent ?? '.',
                    style: getRegularStyle(
                        color: TAppColors.white, fontSize: MyFonts.size16),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}