import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import '../../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../../widgets/schedule_widget.dart';

class WeddingEventDetailScheduleScreen extends StatefulWidget {
  const WeddingEventDetailScheduleScreen({super.key});

  @override
  State<WeddingEventDetailScheduleScreen> createState() => _WeddingEventDetailScheduleScreenState();
}

class _WeddingEventDetailScheduleScreenState extends State<WeddingEventDetailScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final weddingCtr = ref.watch(weddingEventHomeController);
        return Container(
          color: TAppColors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        weddingCtr
                                .homeWeddingDetails?.weddingRitualList?.length ??
                            0, (index) {
                      WeddingRitualList? model = weddingCtr
                          .homeWeddingDetails?.weddingRitualList?[index];

                      return ScheduleWidget(
                        eventName: model?.ritualName ?? '',
                        dateTime: model?.scheduleDate ?? DateTime.now(),
                        venue: model?.venueAddress == null
                            ? 'Address not provided!'
                            : model?.venueAddress == ''
                                ? 'Address not provided!'
                                : model?.venueAddress,
                        isLast: index ==
                            (weddingCtr.homeWeddingDetails?.weddingRitualList
                                        ?.length ??
                                    0) -
                                1,
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
