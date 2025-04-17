import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../../utility/constants/images/image_url.dart';

class WeddingEventDetailAboutScreen extends StatefulWidget {
  const WeddingEventDetailAboutScreen({super.key});

  @override
  State<WeddingEventDetailAboutScreen> createState() => _WeddingEventDetailAboutScreenState();
}

class _WeddingEventDetailAboutScreenState extends State<WeddingEventDetailAboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final weddingCtr = ref.watch(weddingEventHomeController);
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
                    weddingCtr.homeWeddingDetails?.title ??  '',
                    style: getBoldStyle(
                        color: TAppColors.white, fontSize: MyFonts.size18),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  Text(
                      weddingCtr.homeWeddingDetails?.aboutTheWedding ?? '.',
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
