import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../common_imports/common_imports.dart';
import 'datetime_functions.dart';

Future<DateTime?> showPlatformTimePicker({
  required BuildContext context,
  DateTime? firstDate,
}) async {
  DateTime selectedDate = DateTime.now();
  if (firstDate != null) {
    selectedDate = firstDate;
  }

  DateTime? pickedDate;

  if (Platform.isAndroid) {
    TimeOfDay? pickedTime = await showTimePicker(
        initialTime: dateTimeToTimeOfDay(selectedDate),
        context: context,
        initialEntryMode: TimePickerEntryMode.dialOnly);

    if (pickedTime != null) {
      pickedDate = timeOfDayToDateTime(pickedTime);
    }
  } else if (Platform.isIOS) {
    pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (context) {
        DateTime tempPickedDate = selectedDate;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 250.h,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                        child: Text('Cancel',
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              color: TAppColors.appColor,
                              fontSize: MyFonts.size16,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    CupertinoButton(
                      child: Text('Done',
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                            color: TAppColors.appColor,
                            fontSize: MyFonts.size16,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    initialDateTime: selectedDate,
                    maximumDate: DateTime(2101),
                    mode: CupertinoDatePickerMode.time,
                    // maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  return pickedDate;
}
