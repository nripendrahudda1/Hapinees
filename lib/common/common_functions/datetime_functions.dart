import 'dart:ffi';

import 'package:intl/intl.dart';

import '../common_imports/common_imports.dart';

String formatDateShort(DateTime dateTime) {
  final formatter = DateFormat('MMM d y');
  return formatter.format(dateTime);
}

String formatDateLong(DateTime dateTime) {
  final formatter = DateFormat('MMM d y');
  return formatter.format(dateTime);
}

String formatTime(DateTime dateTime) {
  final formatter = DateFormat('hh:mm a');
  return formatter.format(dateTime);
}

String convertDateFormat(String dateString) {
  // Define the expected date format
  final dateFormat = DateFormat('MMM d y', 'en_US');

  final formatter = DateFormat('MMM d');
  return formatter.format(dateFormat.parse(dateString));
}

DateTime convertStringToDateTime(String dateString) {
  final formatter = DateFormat('MMM d y');
  return formatter.parse(dateString);
}

String formatDateTimeToCustomFormat(DateTime? startDate, DateTime? endDate) {
  if (startDate == endDate) {
    if (startDate != null) {
      final formatter = DateFormat('dd MMM y');
      return formatter.format(startDate);
    } else {
      return "12-13 OCT 2023";
    }
  } else {
    if (startDate != null && endDate != null) {
      final formatter = DateFormat('MMM y');
      return "${startDate.day}-${endDate.day} ${formatter.format(startDate)}";
    } else {
      return "12-13 OCT 2023";
    }
  }
}

String timeUntil(String dateTimeString) {
  DateTime targetDate = DateTime.parse(dateTimeString);
  DateTime now = DateTime.now();

  Duration difference = targetDate.difference(now);
  int days = difference.inDays;
  if (days == 0) return "today";
  if (days == 1) return "in 1 day";
  if(days < 0) return "";
  if(days < 30) return "in $days days";
  // if (days > 1) return "in $days days";
  // if (days == -1) return "1 day ago";
  // return "${days.abs()} days ago";
  return "";
}

bool compareDate(DateTime? startDate) {
  if (startDate == null) return false; // Handle null case
  DateTime currentDate = DateTime.now();
  if (currentDate.year == startDate.year &&
      currentDate.month == startDate.month &&
      currentDate.day == startDate.day) {
    return false;
  } else {
    return startDate.isBefore(currentDate);
  }
}


String formatDateTimeToCustomFormat2(DateTime? dateTime) {
  if (dateTime != null) {
    final formatter = DateFormat('dd MMM - hh:mm a');
    return formatter.format(dateTime);
  } else {
    return "12-13 OCT 2023";
  }
}

String dateTimeToStringTimeForApi(DateTime date) {
  final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  return formatter.format(date);
}

String formatDateTimeToISOString(DateTime dateTime) {
  final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  return formatter.format(dateTime.toUtc());
}

TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
  DateTime currentDateTime = dateTime;
  TimeOfDay currentTime = TimeOfDay.fromDateTime(currentDateTime);
  return currentTime;
}

DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  return dateTime;
}
