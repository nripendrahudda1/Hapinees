import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/common_time_picker.dart';
import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/modules/events/create_event/widgets/date_widget.dart';
import '../../../../common/common_functions/common_date_picker.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/edit_ritual_expanded_controller.dart';
import '../controllers/edit_ritual_schedule_controller.dart';

class ScheduleWidget extends ConsumerStatefulWidget {
  final DateTime initialDateAndTime;
  final bool isPersonalEvent;
  final Function(DateTime dateTime) selectedDateAndTime;

  const ScheduleWidget({
    super.key,
    required this.isPersonalEvent,
    required this.initialDateAndTime,
    required this.selectedDateAndTime,
  });

  @override
  ConsumerState<ScheduleWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<ScheduleWidget> {
  DateTime? selectedDate;
  DateTime? selectedTime;

  @override
  void initState() {
    // Future.delayed(const Duration(milliseconds: 100), () {
      setInitialSchedule();
    // });
    super.initState();
  }

  setInitialSchedule() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(editActivityExpandedCtr).setActivityScheduleUnExpanded();
      selectedDate = widget.initialDateAndTime;
      ref
          .read(editRitualScheduleCtr.notifier)
          .setDate1(formatDateShort(selectedDate!));

      selectedTime = selectedDate;
      // selectedTime = DateTime(2023, 1, 1, 12, 00);
      ref
          .read(editRitualScheduleCtr.notifier)
          .setEventTime(formatTime(selectedTime!));
      setState(() {
      });
      widget.selectedDateAndTime(selectedDate!);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpansion() {
    if(widget.isPersonalEvent) {
      if (ref
          .watch(editActivityExpandedCtr)
          .activityScheduleExpanded) {
        ref.watch(editActivityExpandedCtr).setActivityScheduleUnExpanded();
      } else {
        ref.watch(editActivityExpandedCtr).setActivityScheduleExpanded();
      }
    } else {
      if (ref
          .watch(editRitualExpandedCtr)
          .ritualScheduleExpanded) {
        ref.watch(editRitualExpandedCtr).setRitualScheduleUnExpanded();
      } else {
        ref.watch(editRitualExpandedCtr).setRitualScheduleExpanded();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: TAppColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border:
                  Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).activityScheduleExpanded : ref.watch(editRitualExpandedCtr).ritualScheduleExpanded)
                    ? BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      )
              ]),
          child: ListTileTheme(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).activityScheduleExpanded : ref.watch(editRitualExpandedCtr).ritualScheduleExpanded)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Schedule",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(editRitualScheduleCtr).date != "MM/DD/YYYY" ||
                              ref.read(editRitualScheduleCtr).eventTime !=
                                  "00:00 AM/PM"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Schedule",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "${ref.read(editRitualScheduleCtr).date} - ${ref.read(editRitualScheduleCtr).eventTime}",
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                )
                              ],
                            )
                          : Text(
                              "Schedule",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if(widget.isPersonalEvent ?ref.watch(editActivityExpandedCtr).activityScheduleExpanded : ref.watch(editRitualExpandedCtr).ritualScheduleExpanded)
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final dateCtr = ref.watch(editRitualScheduleCtr);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, right: 10.w, bottom: 10.h),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                DateWidget(
                                  text: dateCtr.date,
                                  isSingle: false,
                                  onTap: () async {

                                    DateTime? selectDate =
                                        await showPlatformDatePicker(
                                            context: context,
                                            firstDate: selectedDate);
                                    if (selectDate != null) {
                                      dateCtr.setDate1(
                                          formatDateShort(selectDate));
                                      setState(() {
                                        selectedDate = selectDate;
                                      });
                                      widget.selectedDateAndTime(selectedDate!);
                                    }
                                  },
                                ),
                                DateWidget(
                                  isSingle: false,
                                  isTime: true,
                                  text: dateCtr.eventTime,
                                  onTap: () async {
                                    DateTime? selectDate =
                                        await showPlatformTimePicker(
                                            context: context,
                                            firstDate: selectedTime);

                                    if (selectDate != null) {
                                      dateCtr.setEventTime(
                                          formatTime(selectDate));
                                      setState(() {
                                        selectedTime = selectDate;
                                      });
                                      widget.selectedDateAndTime(DateTime(
                                        selectedTime!.year,
                                        selectedTime!.month,
                                        selectedTime!.day,
                                        selectedTime!.hour,
                                        selectedTime!.minute,
                                      ));

                                    }
                                  },
                                ),
                              ],
                            )),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
// class ScheduleWidget extends ConsumerStatefulWidget {
//   const ScheduleWidget({
//     super.key,
//   });
//
//   @override
//   ConsumerState<ScheduleWidget> createState() =>
//       _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState extends ConsumerState<ScheduleWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool isExpanded = false;
//   DateTime? selectedDate;
//   DateTime? selectedTime;
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//     Future.delayed(const Duration(milliseconds: 100), () {
//       setInitialSchedule();
//     });
//
//     super.initState();
//   }
//
//   setInitialSchedule() {
//     print("here");
//     selectedDate = DateTime.now();
//     ref
//         .read(editRitualScheduleCtr.notifier)
//         .setDate1(formatDateShort(selectedDate!));
//
//     selectedTime = DateTime(2023, 1, 1, 12, 00);
//     ref
//         .read(editRitualScheduleCtr.notifier)
//         .setEventTime(formatTime(selectedTime!));
//     setState(() {
//     });
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   void _toggleExpansion() {
//     setState(() {
//       isExpanded = !isExpanded;
//       if (isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: TAppColors.containerColor,
//               borderRadius: BorderRadius.circular(10.r),
//               border:
//               Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
//               boxShadow: [
//                 isExpanded
//                     ? BoxShadow(
//                   color: TAppColors.text1Color.withOpacity(0.25),
//                   blurRadius: 4,
//                   offset: Offset(2.w, 4.h),
//                 )
//                     : BoxShadow(
//                   color: TAppColors.text1Color.withOpacity(0.25),
//                   blurRadius: 2,
//                   offset: const Offset(0, 0),
//                 )
//               ]),
//           child: ListTileTheme(
//             contentPadding: EdgeInsets.zero,
//             dense: true,
//             horizontalTitleGap: 0,
//             minLeadingWidth: 0,
//             minVerticalPadding: 0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ListTile(
//                   contentPadding:
//                   EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   title: isExpanded
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Schedule",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size16,
//                             color: TAppColors.text2Color),
//                       ),
//                       SizedBox(
//                         height: 8.h,
//                       )
//                     ],
//                   )
//                       : ref.read(editRitualScheduleCtr).date != "MM/DD/YYYY" ||
//                       ref.read(editRitualScheduleCtr).eventTime !=
//                           "00:00 AM/PM"
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Schedule",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size14,
//                             color: TAppColors.selectionColor),
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         "${ref.read(editRitualScheduleCtr).date} - ${ref.read(editRitualScheduleCtr).eventTime}",
//                         style: getBoldStyle(
//                           fontSize: MyFonts.size14,
//                         ),
//                       )
//                     ],
//                   )
//                       : Text(
//                     "Schedule",
//                     style: getRegularStyle(
//                         fontSize: MyFonts.size14,
//                         color: TAppColors.text2Color),
//                   ),
//                   onTap: _toggleExpansion,
//                 ),
//                 SizeTransition(
//                     sizeFactor: _animation,
//                     axisAlignment: -1.0,
//                     child: Consumer(
//                       builder:
//                           (BuildContext context, WidgetRef ref, Widget? child) {
//                         final dateCtr = ref.watch(editRitualScheduleCtr);
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                                 padding: EdgeInsets.only(
//                                     left: 10.w, right: 10.w, bottom: 10.h),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     DateWidget(
//                                       text: dateCtr.date,
//                                       isSingle: false,
//                                       onTap: () async {
//                                         DateTime? selectDate =
//                                         await showPlatformDatePicker(
//                                             context: context,
//                                             firstDate: selectedDate);
//                                         if (selectDate != null) {
//                                           dateCtr.setDate1(
//                                               formatDateShort(selectDate));
//                                           setState(() {
//                                             selectedDate = selectDate;
//                                           });
//                                         }
//                                       },
//                                     ),
//                                     DateWidget(
//                                       isSingle: false,
//                                       isTime: true,
//                                       text: dateCtr.eventTime,
//                                       onTap: () async {
//                                         DateTime? selectDate =
//                                         await showPlatformTimePicker(
//                                             context: context,
//                                             firstDate: selectedTime);
//
//                                         if (selectDate != null) {
//                                           dateCtr.setEventTime(
//                                               formatTime(selectDate));
//                                           setState(() {
//                                             selectedTime = selectDate;
//                                           });
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 )),
//                           ],
//                         );
//                       },
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }