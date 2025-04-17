
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_functions/datetime_functions.dart';
import '../../create_event/widgets/date_widget.dart';
import '../controllers/common_update_event_dates_controller.dart';
import '../../../../common/common_functions/common_date_picker.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/wedding_event/update_wedding_event_expanded_controller.dart';

class UpdateEventDatesWidget extends ConsumerStatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isPersonalEvent;
  const UpdateEventDatesWidget({
    super.key,
    this.startDate,
    this.endDate,
    required this.isPersonalEvent,
  });

  @override
  ConsumerState<UpdateEventDatesWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<UpdateEventDatesWidget> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiallize();
  }

  initiallize(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(updateEventExpandedCtr).setDatesUnExpanded();
      final dateCtr = ref.watch(updateEventDatesCtr);
      if(widget.startDate!= null){
        dateCtr.setDate1(formatDateShort(widget.startDate!));
      }
      if(widget.endDate!= null){
        dateCtr.setDate2(formatDateLong(widget.endDate!));
      }
    });
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).datesExpanded) {
      ref.watch(updateEventExpandedCtr).setDatesUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setDatesExpanded();
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
                ref.watch(updateEventExpandedCtr).datesExpanded
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
                  title: ref.watch(updateEventExpandedCtr).datesExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isPersonalEvent ? "Event Dates" : "Wedding Dates",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(updateEventDatesCtr).date1 != "Start Date" ||
                              ref.read(updateEventDatesCtr).date2 != "End Date"
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  ref.read(updateEventDatesCtr).isMultipleDay
                                      ? "Dates"
                                      : "Date",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                ref.read(updateEventDatesCtr).isMultipleDay
                                    ? Text(
                                        "${convertDateFormat(ref.read(updateEventDatesCtr).date1)} - ${ref.read(updateEventDatesCtr).date2}",
                                        style: getBoldStyle(
                                          fontSize: MyFonts.size14,
                                        ),
                                      )
                                    : Text(
                                        ref.read(updateEventDatesCtr).date1,
                                        style: getBoldStyle(
                                          fontSize: MyFonts.size14,
                                        ),
                                      ),
                              ],
                            )
                          : Text(
                              "Dates",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if(ref.watch(updateEventExpandedCtr).datesExpanded)
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final dateCtr = ref.watch(updateEventDatesCtr);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 10.h),
                          child: dateCtr.isMultipleDay
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DateWidget(
                                      text: dateCtr.date1,
                                      isSingle: false,
                                      onTap: () async {
                                        DateTime? selectedDate =
                                            await showPlatformDatePicker(
                                                context: context);
                                        if (selectedDate != null) {
                                          dateCtr.setDate1(formatDateShort(
                                              selectedDate));
                                          dateCtr.setDate2(formatDateShort(
                                              selectedDate.add(const Duration(
                                                      days: 1))));
                                          dateCtr.setDate1Time(
                                              selectedDate.add(
                                                  const Duration(days: 1)));
                                        }
                                      },
                                    ),
                                    DateWidget(
                                      isSingle: false,
                                      text: dateCtr.date2,
                                      onTap: () async {
                                        DateTime? selectedDate =
                                            await showPlatformDatePicker(
                                                context: context,
                                                firstDate: dateCtr.time);
                                        if (selectedDate != null) {
                                          dateCtr.setDate2(
                                              formatDateLong(selectedDate));
                                        }
                                      },
                                    ),
                                  ],
                                )
                              : DateWidget(
                                  text: dateCtr.date1 == "Start Date"
                                      ? widget.isPersonalEvent ? "Event Date" : "Wedding Date"
                                      : dateCtr.date1,
                                  onTap: () async {
                                    DateTime? selectedDate =
                                        await showPlatformDatePicker(
                                            context: context);
                                    if (selectedDate != null) {
                                      dateCtr.setDate1(
                                          formatDateLong(selectedDate));
                                      dateCtr.setDate1Time(selectedDate);
                                    }
                                  },
                                  isSingle: true,
                                ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(4.r))),
                              value: dateCtr.isMultipleDay,
                              onChanged: (val) {
                                if (val != null) {
                                  dateCtr.setStatusOfDays(val);
                                }
                              },
                            ),
                            Text(
                              'Multiple Days Event',
                              style: getRegularStyle(
                                  fontSize: MyFonts.size12,
                                  color: TAppColors.text2Color),
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
