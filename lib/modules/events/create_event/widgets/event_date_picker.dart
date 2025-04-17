import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../../../common/common_imports/common_imports.dart';

Future<DateTime?> eventDatePicker({
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
            // primarySwatch: Colors.grey,
            // splashColor: Colors.white,
            // colorScheme: const ColorScheme.light(
            //     primary: TAppColors.appColor,
            //     onSecondary: Colors.black,
            //     onPrimary: Colors.white,
            //     surface: Colors.black,
            //     onSurface: Colors.black,
            //     secondary: Colors.black),

            primarySwatch: Colors.grey,
            splashColor: Colors.black,
            //   colorScheme: const ColorScheme.light(
            //     background: Colors.white,
            //       primary: TAppColors.white,
            //       onSecondary: Colors.black,
            //       onPrimary: Colors.white,
            //       surface: Colors.black,
            //        onSurface: TAppColors.white,
            //  ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const Text(""),
        );
      },
      initialDate: selctedDate,
      firstDate: firstDate ?? DateTime(2000),
      //lastDate: DateTime.now()
      // context: context,
      // initialDate: selectedDate,
      // firstDate: DateTime(2000),
      lastDate: lastDate ?? DateTime(2030),
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
                        child: Text(TButtonLabelStrings.cancel,
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              color: TAppColors.appColor,
                              fontSize: MyFonts.size16,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    CupertinoButton(
                      child: Text(TButtonLabelStrings.Done,
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
                    initialDateTime: firstDate ?? tempPickedDate,
                    // minimumDate: tempPickedDate,
                    // minimumYear: tempPickedDate.year,
                    minimumDate: (firstDate != null) ? firstDate : null,
                    minimumYear: DateTime(2000).year,
                    maximumDate: (lastDate != null) ? lastDate : DateTime(2030),
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
