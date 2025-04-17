import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/update_visible_who_can_post_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/appbar.dart';
import '../../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../../controllers/wedding_event/update_wedding_style_controller.dart';
import '../../controllers/common_update_event_title_controller.dart';
import '../../../../../common/widgets/common_delete_event_dialouge.dart';
import '../../widgets/update_couple_widget.dart';
import '../../widgets/update_occassion_widget.dart';
import '../../widgets/wedding_event/update_chose_wedding_style.dart';
import '../../widgets/wedding_event/update_rituals_widget.dart';
import '../../widgets/update_visible_to_widget.dart';
import '../../widgets/update_event_dates_widget.dart';
import '../../widgets/update_event_title_widget.dart';

class UpdateWeddingEventScreen extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel? homeModel;
  const UpdateWeddingEventScreen({
    super.key,
    required this.homeModel,
  });

  @override
  ConsumerState<UpdateWeddingEventScreen> createState() => _UpdateWeddingEventScreenState();
}

class _UpdateWeddingEventScreenState extends ConsumerState<UpdateWeddingEventScreen> {
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(updateWeddingStylesCtr).fetchWeddingStylesModel(ref: ref, context: context);
    });
  }

  Future<void> delete(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CommonDeleteEventDialouge(
          onTap: () async {
            await ref.read(updateWeddingRitualsCtr).deleteWedding(
                weddingHeaderId: widget.homeModel?.weddingHeaderId.toString() ?? '', ref: ref);
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushNamedAndRemoveUntil(context, Routes.homeRoute, (route) => false);
            });
          },
          title: 'Wedding',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.white,
      body: CustomSafeArea(
        child: Column(
          children: [
            // topPadding(topPadding: 0.h, offset: 30.h),
            CustomAppBar(
              onTap: () {
                Navigator.pop(context);
                ref.read(updateWeddingRitualsCtr).clearRitualss();
              },
              title: 'Update Event',
              subtitle: ref.watch(updateEventTitleCtr).title,
              hasSubTitle: true,
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                  child: Column(
                    children: [
                      UpdateYourOccassionWidget(
                        isPersonalEvent: false,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateWeddingStyleWidget(
                        homeModel: widget.homeModel,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      const UpdateRitualsWidget(),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateCoupleWidget(
                        couple1: widget.homeModel?.partner1,
                        couple2: widget.homeModel?.partner2,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateEventTitleWidget(
                        isPersonalEvent: false,
                        eventTitle: widget.homeModel?.title ?? '',
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateEventDatesWidget(
                        isPersonalEvent: false,
                        startDate: widget.homeModel?.startDateTime,
                        endDate: widget.homeModel?.endDateTime,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateVisibleToWidget(
                        visibility: widget.homeModel?.visibility ?? 3,
                        selfRegistration: widget.homeModel?.selfRegistration,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      UpdateWhoCanPostVisibleToWidget(
                        contributor: widget.homeModel?.contributor ?? 3,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.updateWeddingEventMoreInfoScreen,
                                arguments: {'homeModel': widget.homeModel});
                          },
                          title: TButtonLabelStrings.nextButton,
                          fontSize: MyFonts.size14,
                          buttonBackground: TAppColors.themeColor),
                      SizedBox(
                        height: 5.h,
                      ),
                      TextButton(
                          onPressed: () {
                            delete(context);
                          },
                          child: Text(
                            TButtonLabelStrings.deleteEventButton,
                            style: getRobotoBoldStyle(
                                fontSize: MyFonts.size14, color: TAppColors.buttonRed),
                          )),
                      SizedBox(
                        height: 55.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
