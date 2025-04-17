import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../common_imports/common_imports.dart';

Future<DateTime?> showPlatformDatePicker({
  required BuildContext context,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? selctedDate,
}) async {
  DateTime selectedDate = DateTime.now();
  if (selctedDate != null) {
    selectedDate = selctedDate;
  }

  DateTime? pickedDate;

  if (Platform.isAndroid) {
    pickedDate = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            primarySwatch: Colors.grey,
            splashColor: Colors.black,
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const Text(""),
        );
      },
      initialDate: selctedDate,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
    );
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
                    initialDateTime: tempPickedDate,
                    minimumDate: firstDate ?? DateTime(1900),

                    maximumDate: lastDate ?? DateTime.now(),
                    mode: CupertinoDatePickerMode.date,
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
