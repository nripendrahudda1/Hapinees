import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/event_details_moments/widgets/schedule_widget.dart';

import '../../../../../../common/common_imports/apis_commons.dart';
import '../../../../../../common/common_imports/common_imports.dart';
import '../../../../event_homepage/personal_event/controller/personal_event_home_controller.dart';

class PersonalEventDetailScheduleScreen extends ConsumerStatefulWidget {
  const PersonalEventDetailScheduleScreen({super.key});

  @override
  ConsumerState<PersonalEventDetailScheduleScreen> createState() => _PersonalEventDetailScheduleScreenState();
}

class _PersonalEventDetailScheduleScreenState extends ConsumerState<PersonalEventDetailScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final personalEventCtr = ref.watch(personalEventHomeController);
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
                        personalEventCtr
                            .homePersonalEventDetailsModel?.personalEventActivityList?.length ??
                            0, (index) {
                      PersonalEventActivityList? model = personalEventCtr
                          .homePersonalEventDetailsModel?.personalEventActivityList?[index];
                      return ScheduleWidget(
                        eventName: model?.activityName ?? '',
                        dateTime: model?.scheduleDate ?? DateTime.now(),
                        venue: model?.venueAddress == null
                            ? 'Address not provided!'
                            : model?.venueAddress == ''
                            ? 'Address not provided!'
                            : model?.venueAddress,
                        isLast: index ==
                            (personalEventCtr.homePersonalEventDetailsModel?.personalEventActivityList
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