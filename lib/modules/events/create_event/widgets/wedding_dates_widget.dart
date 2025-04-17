import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/datetime_functions.dart';
import 'package:Happinest/modules/events/create_event/controllers/event_dates_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../utility/show_alert.dart';
import '../controllers/create_event_controller.dart';
import '../controllers/create_event_expanded_controller.dart';
import 'date_widget.dart';
import 'event_date_picker.dart';

class WeddingDatesWidget extends ConsumerStatefulWidget {
  const WeddingDatesWidget({
    super.key,
  });

  @override
  ConsumerState<WeddingDatesWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<WeddingDatesWidget> {
  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).datesExpanded) {
      ref.watch(createEventExpandedCtr).setDatesUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setDatesExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: customColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(createEventExpandedCtr).datesExpanded
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(createEventExpandedCtr).datesExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (ref.watch(createEventController).selectOccassionId == 1)
                                  ? "Wedding Dates"
                                  : "Event Dates",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: customColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(eventDatesCtr).date1 != "Start Date" ||
                              ref.read(eventDatesCtr).date2 != "End Date"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ref.read(eventDatesCtr).isMultipleDay ? "Dates" : "Date",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                ref.read(eventDatesCtr).isMultipleDay
                                    ? Text(
                                        "${convertDateFormat(ref.read(eventDatesCtr).date1)} - ${ref.read(eventDatesCtr).date2}",
                                        style: getBoldStyle(
                                            fontSize: MyFonts.size14, color: customColors.label),
                                      )
                                    : Text(
                                        ref.read(eventDatesCtr).date1,
                                        style: getBoldStyle(
                                            fontSize: MyFonts.size14, color: customColors.label),
                                      ),
                              ],
                            )
                          : Text(
                              "Dates",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).datesExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final dateCtr = ref.watch(eventDatesCtr);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                            child: dateCtr.isMultipleDay
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      DateWidget(
                                          text: dateCtr.date1,
                                          isSingle: false,
                                          onTap: () async {
                                            // DateTime? firstDate, lastDate;
                                            // if (dateCtr.date1Time != null) {
                                            //   DateTime todayDate = DateTime.now();
                                            //   bool isBefore = dateCtr.date1Time!.isBefore(todayDate);
                                            //   if (todayDate.day == dateCtr.date1Time?.day) {
                                            //     firstDate = dateCtr.date1Time;
                                            //   } else if (isBefore) {
                                            //     // firstDate = dateCtr.date1Time;
                                            //     lastDate = todayDate;
                                            //   } else {
                                            //     firstDate = dateCtr.date1Time;
                                            //   }
                                            // } else if (dateCtr.date2Time == null &&
                                            //     dateCtr.date1Time == null) {}
                                            // DateTime? selectedDate = await eventDatePicker(
                                            //     context: context,
                                            //     selctedDate: dateCtr.date1Time,
                                            //     firstDate: firstDate,
                                            //     lastDate: lastDate);
                                            // if (selectedDate != null) {
                                            //   print("here");
                                            //   dateCtr.setDate1(
                                            //       formatDateShort(selectedDate), selectedDate);
                                            //   dateCtr.setDate1Time(
                                            //       selectedDate.add(const Duration(days: 1)));
                                            //   dateCtr.setDate2(
                                            //       formatDateShort(
                                            //           selectedDate.add(const Duration(days: 1))),
                                            //       selectedDate.add(const Duration(days: 1)));
                                            //   ref
                                            //       .watch(createEventController)
                                            //       .dateBeforeCheck(selectedDate);
                                            // }
                                            DateTime? firstDate, lastDate;
                                            DateTime todayDate = DateTime.now();

// ✅ Ensure firstDate is set correctly to allow all past selections
                                            if (dateCtr.date1Time != null) {
                                              firstDate = firstDate;
                                              // Allow dates as early as 2000
                                              lastDate = DateTime(2030); // Keep a wide range
                                            } else {
                                              firstDate = DateTime(2025);
                                              lastDate = todayDate;
                                            }

                                            // print(
                                            //     "Before Picker - Start Date: $firstDate, End Date: $lastDate");

// ✅ Open the Date Picker with the correct range
                                            DateTime? selectedDate = await eventDatePicker(
                                              context: context,
                                              selctedDate: dateCtr
                                                  .date1Time, // ✅ Ensure this updates properly
                                              firstDate: firstDate,
                                              lastDate: lastDate,
                                            );

                                            if (selectedDate != null &&
                                                selectedDate != dateCtr.date1Time) {
                                              print("User Selected Date: $selectedDate");

                                              // ✅ Update the selected start date properly
                                              dateCtr.setDate1Time(selectedDate);
                                              dateCtr.setDate1(
                                                  formatDateShort(selectedDate), selectedDate);

                                              // ✅ If multiple days, update the end date too
                                              if (dateCtr.isMultipleDay) {
                                                DateTime newEndDate =
                                                    selectedDate.add(Duration(days: 1));
                                                dateCtr.setDate2(
                                                    formatDateShort(newEndDate), newEndDate);
                                                print("Updated End Date: $newEndDate");
                                              }

                                              // ✅ Ensure UI updates properly
                                              ref
                                                  .watch(createEventController)
                                                  .dateBeforeCheck(selectedDate);
                                            }

                                            // print("Final Start Date: ${dateCtr.date1Time}");
                                            // print("Final End Date: ${dateCtr.date2Time}");
                                          }),
                                      DateWidget(
                                        isSingle: false,
                                        text: dateCtr.date2,
                                        onTap: () async {
                                          DateTime? lastDate;
                                          if (dateCtr.date1Time != null) {
                                            DateTime todayDate = DateTime.now();
                                            bool isBefore = dateCtr.date1Time!.isBefore(todayDate);
                                            if (todayDate.day == dateCtr.date1Time?.day) {
                                            } else if (isBefore) {
                                              // firstDate = dateCtr.date1Time;
                                              lastDate = todayDate;
                                            }
                                            DateTime? selectedDate = await eventDatePicker(
                                                context: context,
                                                // isSecond: true,
                                                firstDate: dateCtr.date1Time,
                                                selctedDate: dateCtr.date2Time,
                                                lastDate: lastDate);
                                            if (selectedDate != null) {
                                              dateCtr.setDate2(
                                                  formatDateLong(selectedDate), selectedDate);
                                            }
                                          } else if (dateCtr.date2Time == null &&
                                              dateCtr.date1Time == null) {
                                            TMessaging.showSnackBar(context, 'Select Start Date!');
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                : DateWidget(
                                    text: dateCtr.date1 == "Start Date"
                                        ? "Select Date"
                                        : dateCtr.date1,
                                    onTap: () async {
                                      DateTime? selectedDate = await eventDatePicker(
                                          context: context, selctedDate: dateCtr.date1Time);
                                      if (selectedDate != null) {
                                        dateCtr.setDate1(
                                            formatDateLong(selectedDate), selectedDate);
                                        dateCtr.setDate1Time(
                                            selectedDate.add(const Duration(days: 1)));
                                        ref
                                            .watch(createEventController)
                                            .dateBeforeCheck(selectedDate);
                                        // dateCtr.setDate1Time(selectedDate);
                                      }
                                    },
                                    isSingle: true,
                                  ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4.r))),
                                value: dateCtr.isMultipleDay,
                                onChanged: (val) {
                                  if (val != null) {
                                    dateCtr.setStatusOfDays(val);
                                    if (val &&
                                        dateCtr.date1 != "Start Date" &&
                                        dateCtr.date1Time != null) {
                                      dateCtr.setDate2(
                                          formatDateShort(
                                              dateCtr.date1Time!.add(const Duration(days: 1))),
                                          dateCtr.date1Time!.add(const Duration(days: 1)));
                                    }
                                    // dateCtr.resetDate1();
                                  }
                                },
                              ),
                              Text(
                                'Multiple Days Event',
                                style: getRegularStyle(
                                    fontSize: MyFonts.size12, color: customColors.text2Color),
                              )
                            ],
                          )
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
