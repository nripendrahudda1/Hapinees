import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:Happinest/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/topPadding.dart';
import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/update_ritual_post_model.dart';
import 'package:Happinest/modules/events/edit_ritual/controllers/update_ritual_controller.dart';
import 'package:Happinest/modules/events/edit_ritual/widgets/edit_ritual_name_widget.dart';
import 'package:Happinest/modules/events/edit_ritual/widgets/edit_rituals_photos_widget.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/event_app_bar.dart';
import '../../../../models/create_event_models/create_wedding_models/post_models/delete_wedding_ritual_post_model.dart';
import '../../../../models/create_event_models/home/home_wedding_details_model.dart';
import '../widgets/custom_dialouge_event.dart';
import '../widgets/edit_ritual_info_about_widget.dart';
import '../widgets/edit_ritual_info_venue_widget.dart';
import '../widgets/edit_ritual_visible_to_widget.dart';
import '../widgets/edit_ritual_schedule_widget.dart';

class EditRitualScreen extends ConsumerStatefulWidget {
  final HomeWeddingDetailsModel homeWeddingDetailsModel;
  final int ritualIndex;
  const EditRitualScreen({
    super.key,
    required this.homeWeddingDetailsModel,
    required this.ritualIndex,
  });

  @override
  ConsumerState<EditRitualScreen> createState() => _EditRitualScreenState();
}

class _EditRitualScreenState extends ConsumerState<EditRitualScreen> {
  WeddingRitualList? ritualModel;
  int index = 0;

  String? ritualName;
  DateTime? schedule;
  String? aboutVal;
  String? venueVal;
  int? visibility;

  @override
  void initState() {
    super.initState();
    index = widget.ritualIndex;
    ritualModel = widget.homeWeddingDetailsModel.weddingRitualList![index];
    ritualName = ritualModel?.ritualName;
    schedule = ritualModel?.scheduleDate;
    aboutVal = ritualModel?.aboutRitual;
    venueVal = ritualModel?.venueAddress;
    visibility = ritualModel?.visibility;
    print('Wedding Ritual Id: ${ritualModel?.weddingRitualId}');
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(updateRitualController).getRitualImages(
          weddingRitualId: ritualModel?.weddingRitualId.toString() ?? '20',
          context: context,
          ref: ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: TAppColors.white,
        body: Column(
          children: [
            topPadding(topPadding: 0.h, offset: 30.h),
            EventAppBar(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              title: TNavigationTitleStrings.editActivity,
              hasSubTitle: true,
              subtitle: widget.homeWeddingDetailsModel.title,
              prefixWidget: IconButton(
                  onPressed: () {
                    showAlertMessage(context);
                  },
                  icon: Image.asset(
                    TImageName.delete,
                    width: 20.w,
                    height: 20.h,
                  )),
            ),
            SizedBox(
              height: 10.h,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 5.h),
                  child: Column(
                    children: [
                      //  EditRitualNameWidget(
                      //   eventName: 'Sangeet', animationCtr:_animationController, animation: _animation,
                      // ),
                      EditRitualNameWidget(
                        eventName: ritualModel!.ritualName ?? 'Sangeet',
                        eventNameFunc: (String eventName) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              ritualName = eventName;
                            });
                          });
                        },
                        eventId: ritualModel!.weddingRitualId.toString(),
                        styleId: widget.homeWeddingDetailsModel.weddingStyleMasterId?.toString() ??
                            2.toString(),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      ScheduleWidget(
                        isPersonalEvent: false,
                        initialDateAndTime: ritualModel!.scheduleDate ?? DateTime.now(),
                        selectedDateAndTime: (DateTime time) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              schedule = time;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualInfoAboutWidget(
                        isPersonalEvent: false,
                        eventName: ritualModel!.ritualName ?? 'Sangeet',
                        aboutEvent: ritualModel!.aboutRitual ?? '',
                        updateAbout: (String about) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              aboutVal = about;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      // Photos Widget
                      EditRitualsPhotosWidget(
                        homeWeddingDetailsModel: widget.homeWeddingDetailsModel,
                        weddingRitualModel: ritualModel!,
                        bgImage: (String imgData) {},
                        bgExt: (String imgExtension) {},
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualInfoVenueWidget(
                        isPersonalEvent: false,
                        venue: ritualModel!.venueAddress ?? '',
                        venueFunc: (String venue) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              venueVal = venue;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      EditRitualsVisibleToWidget(
                        isPersonalEvent: false,
                        visibilityIndex: ritualModel!.visibility ?? 3,
                        visibilityFunc: (int val) {
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            setState(() {
                              visibility = val;
                            });
                          });
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ritualSkipWidget(),
                      SizedBox(
                        height: 5.h,
                      ),
                      Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final editRitualCtr = ref.watch(updateRitualController);
                          return TButton(
                              onPressed: () async {
                                UpdateRitualPostModel model = UpdateRitualPostModel(
                                  weddingRitualId: ritualModel!.weddingRitualId,
                                  weddingHeaderId: widget.homeWeddingDetailsModel.weddingHeaderId,
                                  scheduleDate: schedule,
                                  aboutRitual: aboutVal,
                                  venueAddress: venueVal,
                                  venueLat: '0.0',
                                  venueLong: '0.0',
                                  visibility: visibility,
                                  ritualName: ritualName,
                                  isActive: true,
                                  modifiedOn: DateTime.now(),
                                  weddingRitualMasterId: ritualModel?.weddingRitualMasterId,
                                );

                                print(ritualModel!.weddingRitualId);
                                print(
                                  widget.homeWeddingDetailsModel.weddingHeaderId,
                                );
                                print(ritualName);
                                print(visibility);
                                await editRitualCtr.updateRitual(
                                  weddingHeaderId:
                                      widget.homeWeddingDetailsModel.weddingHeaderId.toString(),
                                  updateRitualPostModel: model,
                                  context: context,
                                  ref: ref,
                                );
                              },
                              title: TButtonLabelStrings.saveButton,
                              fontSize: MyFonts.size14,
                              buttonBackground: TAppColors.themeColor);
                        },
                      ),
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

  void showAlertMessage(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (context) => CustomDialogEvent(
              title: "Delete Games",
              actionButtonText: "Delete $ritualName" /*TButtonLabelStrings.yesButton*/,
              bodyText: "$ritualName Data will be lost once you delete.",
              onActionPressed: () async {
                DeleteWeddingRitualPostModel model = DeleteWeddingRitualPostModel(
                  weddingHeaderId: widget.homeWeddingDetailsModel.weddingHeaderId ?? 0,
                  weddingRitualId: ritualModel?.weddingRitualId ?? 0,
                );
                await ref
                    .read(updateRitualController)
                    .deleteWeddingRitual(deleteWeddingRitualPostModel: model, ref: ref);
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                  await ref.read(weddingEventHomeController).getWedding(
                      weddingId: model.weddingHeaderId.toString(), context: context, ref: ref);
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
            ));
  }

  Row ritualSkipWidget() {
    return Row(
      children: [
        if (index > 0)
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.chevron_left_rounded, color: TAppColors.buttonBlue, size: 20),
              ),
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushNamed(context, Routes.editRitualScreen, arguments: {
                    'homeWeddingDetailsModel': widget.homeWeddingDetailsModel,
                    'ritualIndex': index - 1,
                  });
                },
                child: Text(
                  widget.homeWeddingDetailsModel.weddingRitualList![index - 1].ritualName ??
                      'MEHNDI',
                  style: getRobotoBoldStyle(fontSize: MyFonts.size14, color: TAppColors.buttonBlue),
                ),
              ),
            ],
          ),
        const Spacer(),
        if (index < widget.homeWeddingDetailsModel.weddingRitualList!.length - 1)
          Row(
            children: [
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Navigator.pushNamed(context, Routes.editRitualScreen, arguments: {
                    'homeWeddingDetailsModel': widget.homeWeddingDetailsModel,
                    'ritualIndex': index + 1,
                  });
                },
                child: Text(
                  widget.homeWeddingDetailsModel.weddingRitualList![index + 1].ritualName ??
                      'BARAAT',
                  style: getRobotoBoldStyle(fontSize: MyFonts.size14, color: TAppColors.buttonBlue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(Icons.chevron_right_rounded, color: TAppColors.buttonBlue, size: 20),
              ),
            ],
          )
      ],
    );
  }
}
