import 'dart:core';
import 'dart:developer';
import 'dart:io' show File, Platform;
import 'package:Happinest/theme/app_colors.dart';
import 'package:Happinest/utility/constants/strings/label_strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:Happinest/common/common_default_apis.dart';
import 'package:Happinest/location/location/permission_handler.dart';
import 'package:Happinest/models/country_model.dart';
import 'package:Happinest/utility/preferenceutils.dart';
import '../common/widgets/custom_dialog.dart';
import '../modules/account/usermodel/usermodel.dart';
import 'constants/constants.dart';

class Utility {
  static Future<bool> requestLocationPermission() async {
    if (await Permission.locationAlways.serviceStatus.isEnabled) {
      return true;
    }
    if (await Permission.locationWhenInUse.serviceStatus.isDisabled) {
      return false;
    }
    return false;
  }

  //get address
  static Future<String> getAddress(double? lat, double? lang) async {
    if (lat == null || lang == null) return "";
    //  print("----lat----${lat}");
    //  print("----lang----${lang}");
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);
      print(placemarks);
      Placemark placemark = placemarks.first;

      String address = "";
      if ((placemark.name ?? "").isNotEmpty) {
        address = placemark.name ?? "";
      }
      if ((placemark.locality ?? "").isNotEmpty) {
        address =
            address.isEmpty ? placemark.locality ?? "" : '$address ${placemark.locality ?? ""}';
      }
      if ((placemark.country ?? "").isNotEmpty) {
        address = address.isEmpty ? placemark.country ?? "" : '$address ${placemark.country ?? ""}';
      }
      if ((placemark.postalCode ?? "").isNotEmpty) {
        address =
            address.isEmpty ? placemark.postalCode ?? "" : '$address ${placemark.postalCode ?? ""}';
      }

      return address;
    } catch (e) {
      print(':::: ${e.toString()}');

      return "";
    }
  }

  static saveData(UserModel userModel, BuildContext context, {bool? isUpdate}) {
    if (isUpdate != true) {
      print("Bearer ${userModel.token!}");
      userModel.token != null
          ? dio.options.headers["Authorization"] = "Bearer ${userModel.token!}"
          : null;
      userModel.token != null
          ? PreferenceUtils.setString(
              PreferenceKey.accessToken,
              userModel.token!,
            )
          : null;
    }
    String userID = userModel.userId.toString();
    PreferenceUtils.setString(
      PreferenceKey.userId,
      userID,
    );
    String serverID = userModel.serverUserId.toString();
    PreferenceUtils.setString(
      PreferenceKey.serveruserId,
      serverID,
    );
    PreferenceUtils.setBool(
      PreferenceKey.loggedIn,
      true,
    );
    PreferenceUtils.setString(
      PreferenceKey.email,
      userModel.email ?? '',
    );
  }

  // Devider --
  static Widget addDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Divider(
        height: 1,
        indent: 5,
        endIndent: 5,
        thickness: 0.5,
        color: Colors.black12,
      ),
    );
  }

  static actionBar(
    BuildContext context,
    String title,
  ) {
    return AppBar(
      backgroundColor: TAppColors.davyGrey,
      elevation: 1,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: TAppColors.appColor, //change your color here
      ),
      title: Text(
        title,
        style: TextStyle(
          color: TAppColors.fossilGrey,
          fontSize: 18,
          height: 1.2,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  ///toast method
  static Future<bool?> toast(
    String msg,
  ) {
    return Fluttertoast.showToast(
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      msg: msg,
    );
  }

  ///internet verify
  static Future<bool> verifyInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet);
  }

  // Get Device ID
  static Future<String> getDeveiceDetails() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor ?? ''; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
    return '';
  }

  String getCustomFormattedDateTime(String fromDate, String format) {
    final DateTime docDateTime = DateTime.parse(fromDate);
    return DateFormat(format).format(docDateTime);
  }

  ///Loading indicator
  static loadingIndicator(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 15.0,
            width: 15.0,
            child: Platform.isIOS
                ? CupertinoActivityIndicator(
                    color: color,
                    radius: 10,
                  )
                : CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      color,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  static void showAlertMessageForGuestUser(BuildContext context) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              actionButtonText: 'Ok',
              title: 'Action Restricted?',
              onActionPressed: () {
                Navigator.pop(context);
              },
              isBack: false,
              bodyText: 'Join our community to enjoy full access! Log in or create an account now',
            ));
  }
}

String formatNumber(int? number) {
  if (number != null) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      double result = number / 1000.0;
      String formattedResult = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1);
      return '${formattedResult.replaceAll(RegExp(r'\.0$'), '')}k';
    } else {
      double result = number / 1000000.0;
      String formattedResult = result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1);
      return '${formattedResult.replaceAll(RegExp(r'\.0$'), '')}M';
    }
  } else {
    return '0';
  }
}

String formatDate(String? dateString, BuildContext? context) {
  var dateFormat = DateFormat(datePattern);
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateFormat.format(dateTime);
  } else {
    return '';
  }
}

String formatDateddMMMyyyy(String? dateString, BuildContext? context, {String? format}) {
  var dateFormat = DateFormat(format ?? 'dd MMM yyyy');
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateFormat.format(dateTime);
  } else {
    return '';
  }
}

String formatDateDDMMMyy(String? dateString) {
  var dateFormat = DateFormat('dd MMM yy');
  if (dateString != null) {
    DateTime dateTime = DateTime.parse(dateString);
    return dateFormat.format(dateTime);
  } else {
    return '';
  }
}

CountryModel? getCountry(int? id) {
  if (id != null) {
    final country =
        countryData.firstWhere((element) => element.id == id, orElse: () => CountryModel());
    if (country.id != null) {
      return country;
    } else {
      return null;
    }
  } else {
    return null;
  }
}

String getTimeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  // if (difference.inDays > 0) {
  //   return '${difference.inDays}${difference.inDays > 1 ? 's' : ''}';
  // } else if (difference.inHours > 0) {
  //   return '${difference.inHours}${difference.inHours > 1 ? 's' : ''}';
  // } else
  if (difference.inMinutes > 0) {
    return '${difference.inMinutes}${difference.inMinutes > 1 ? '' : ''}';
  } else {
    return '0';
  }
}

int? getUserID() {
  // Create new DateTime instances with the time set to midnight

  String userIDString = PreferenceUtils.getString(PreferenceKey.userId);
  if (userIDString.isNotEmpty) {
    return int.tryParse(userIDString); // Safely convert to int
  }
  return 0; // Return null if userId is empty or invalid

  // Compare the date portions
}

/// Get Follow status
  int getFollowActionValue(int followStatus) {
    if (followStatus == 0 || followStatus == 3 || followStatus == 4) return 1;
    if (followStatus == 1) return 4;
    if (followStatus == 2) return 3;
    return 0;
  }

// Follow Status
  String getFollowActionLabel(int? followStatus) {
    switch (followStatus) {
      case 0:
      case 3:
      case 4:
        return TLabelStrings.follow;
      case 1:
        return TLabelStrings.remove;
      case 2:
        return TLabelStrings.unFollow;
      default:
        return TLabelStrings.follow;
    }
  }


String getCommentTimeAgo(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.isNegative) {
    // Future date
    int daysAhead = difference.inDays.abs();
    int monthsAhead = (daysAhead / 30).floor();

    if (daysAhead < 30) {
      return "in $daysAhead ${daysAhead == 1 ? 'day' : 'days'}";
    } else {
      return "in $monthsAhead ${monthsAhead == 1 ? 'month' : 'months'}";
    }
  } else {
    // Past date
    int secondsAgo = difference.inSeconds;
    int minutesAgo = difference.inMinutes;
    int hoursAgo = difference.inHours;
    int daysAgo = difference.inDays;
    int weeksAgo = (daysAgo / 7).floor();
    int monthsAgo = (daysAgo / 30).floor();
    int yearsAgo = (daysAgo / 365).floor();
    // print("------")

    if (secondsAgo < 60) {
      return "$secondsAgo ${secondsAgo == 1 ? "sec" : "secs"} ago";
    } else if (minutesAgo < 60) {
      return "$minutesAgo ${minutesAgo == 1 ? "min" : "mins"} ago";
    } else if (hoursAgo < 24) {
      return "$hoursAgo ${hoursAgo == 1 ? "hour" : "hours"} ago";
    } else if (daysAgo < 7) {
      return "$daysAgo ${daysAgo == 1 ? "day" : "days"} ago";
    } else if (weeksAgo < 4) {
      return "$weeksAgo ${weeksAgo == 1 ? "week" : "weeks"} ago";
    }
    // else if (monthsAgo < 12) {
    //   return "$monthsAgo ${monthsAgo == 1 ? "month" : "months"} ago";
    // }
    else {
      return DateFormat("MMM dd yyyy").format(dateTime); // Show full date for old events
    }
  }
}

String getDisplayName(int index, String userDispalyName) {
  String? displayName = userDispalyName;

  if (displayName.isNotEmpty && displayName.length > 2) {
    String firstLetter = displayName[0].toUpperCase(); // First letter (uppercase)
    String lastLetter = displayName[1].toUpperCase(); // Last letter (uppercase)

    return '$firstLetter$lastLetter'; // Concatenate first+last letter with full name
  } else {
    return ''; // Default when name is null/empty
  }
}

// String getCommentTimeAgo(DateTime dateTime) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(dateTime);

//   int secondsAgo = difference.inSeconds;
//   int minutesAgo = difference.inMinutes;
//   int hoursAgo = difference.inHours;
//   int daysAgo = difference.inDays;
//   int weeksAgo = (daysAgo / 7).floor(); // Approximate weeks
//   int monthsAgo = (daysAgo / 30).floor(); // Approximate months
//   int yearsAgo = (daysAgo / 365).floor(); // Approximate years

//   if(secondsAgo < 0 || secondsAgo == 0) {
//     return "in ";
//   } else if(secondsAgo > 0 && secondsAgo < 60) {
//     return "$secondsAgo sec ago";
//   } else if(minutesAgo > 0 && minutesAgo < 60) {
//     return "$minutesAgo min ago";
//   } else if(hoursAgo > 0 && hoursAgo < 24) {
//     return "$hoursAgo hour ago";
//   } else if(daysAgo > 0 && daysAgo < 7) {
//     return "$daysAgo day ago";
//   } else if(weeksAgo > 0 && weeksAgo < 4) {
//     return "$weeksAgo week ago";
//   } else if(monthsAgo > 0 && monthsAgo < 12) {
//     return "$monthsAgo month ago";
//   } else if(yearsAgo > 0){
//     return "$yearsAgo years ago";
//   } else {
//     return "$minutesAgo min ago";
//   }
// }
// String getCommentTimeAgo(DateTime dateTime) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(dateTime);

//   int secondsAgo = difference.inSeconds;
//   int minutesAgo = difference.inMinutes;
//   int hoursAgo = difference.inHours;
//   int daysAgo = difference.inDays;
//   int weeksAgo = (daysAgo / 7).floor();
//   int monthsAgo = (daysAgo / 30).floor();
//   int yearsAgo = (daysAgo / 365).floor();

//   if (secondsAgo <= 5) {
//     return "Just now";
//   } else if (secondsAgo < 60) {
//     return "$secondsAgo ${secondsAgo == 1 ? "second" : "seconds"} ago";
//   } else if (minutesAgo < 60) {
//     return "$minutesAgo ${minutesAgo == 1 ? "minute" : "minutes"} ago";
//   } else if (hoursAgo < 24) {
//     return "$hoursAgo ${hoursAgo == 1 ? "hour" : "hours"} ago";
//   } else if (daysAgo < 7) {
//     return "$daysAgo ${daysAgo == 1 ? "day" : "days"} ago";
//   } else if (weeksAgo < 4) {
//     return "$weeksAgo ${weeksAgo == 1 ? "week" : "weeks"} ago";
//   } else if (monthsAgo < 12) {
//     return "$monthsAgo ${monthsAgo == 1 ? "month" : "months"} ago";
//   } else {
//     return "$yearsAgo ${yearsAgo == 1 ? "year" : "years"} ago";
//   }
// }

// String getCommentTimeAgo(DateTime eventDateTime) {
//   DateTime now = DateTime.now();
//   Duration difference = now.difference(eventDateTime);

//   bool isFuture = difference.isNegative; // Check if it's a future event
//   difference = difference.abs(); // Get absolute difference

//   int seconds = difference.inSeconds;
//   int minutes = difference.inMinutes;
//   int hours = difference.inHours;
//   int days = difference.inDays;
//   int weeks = (days / 7).floor();
//   int months = (days / 30).floor();
//   int years = (days / 365).floor();

//   String suffix = isFuture ? "from now" : "ago";

//   if (seconds <= 5) {
//     return isFuture ? "Happening now" : "Just now";
//   } else if (seconds < 60) {
//     return "$seconds ${seconds == 1 ? "second" : "seconds"} $suffix";
//   } else if (minutes < 60) {
//     return "$minutes ${minutes == 1 ? "minute" : "minutes"} $suffix";
//   } else if (hours < 24) {
//     return "$hours ${hours == 1 ? "hour" : "hours"} $suffix";
//   } else if (days < 7) {
//     return "$days ${days == 1 ? "day" : "days"} $suffix";
//   } else if (weeks < 4) {
//     return "$weeks ${weeks == 1 ? "week" : "weeks"} $suffix";
//   } else if (months < 12) {
//     return "$months ${months == 1 ? "month" : "months"} $suffix";
//   } else {
//     return "$years ${years == 1 ? "year" : "years"} $suffix";
//   }
// }

bool areDatesEqual(DateTime date1, DateTime date2) {
  // Create new DateTime instances with the time set to midnight
  DateTime midnightDate1 = DateTime(date1.year, date1.month, date1.day);
  DateTime midnightDate2 = DateTime(date2.year, date2.month, date2.day);

  // Compare the date portions
  return midnightDate1.isAtSameMomentAs(midnightDate2);
}

String formatTimeOfDay(TimeOfDay timeOfDay) {
  // Format the TimeOfDay object as HH:mm
  String formattedHour = timeOfDay.hour.toString().padLeft(2, '0');
  String formattedMinute = timeOfDay.minute.toString().padLeft(2, '0');

  return '$formattedHour:$formattedMinute';
}

String nowutc({DateTime? date, required bool isLocal}) {
  var tmpDate = date?.toUtc();
  return isLocal
      ? DateTime.now().toIso8601String()
      : DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS'Z'").format(tmpDate ?? DateTime.now().toUtc());
}

DateTime tolocal(String date) {
  return DateTime.parse(
          DateFormat("yyyy-MM-ddTHH:mm:ss.SSSSSS'Z'").format(DateTime.parse(date.toString())))
      .toLocal();
}

String getTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'just now';
  }
}

saveTripLatandLong(Position position) {
  PreferenceUtils.setDouble(
    PreferenceKey.latitude,
    position.latitude,
  );
  PreferenceUtils.setDouble(
    PreferenceKey.longitude,
    position.longitude,
  );
  PreferenceUtils.setString(
    PreferenceKey.tripStartTime,
    nowutc(isLocal: true),
  );
  var updateLocationTime = PreferenceUtils.getString(PreferenceKey.tripStartTime);
  print("----updateLocationTime----$updateLocationTime");
}

clearTripData() {
  PreferenceUtils.dataClearFromKey(PreferenceKey.longitude);
  PreferenceUtils.dataClearFromKey(PreferenceKey.latitude);
  PreferenceUtils.dataClearFromKey(PreferenceKey.tripStartTime);
}

locationDialogue(BuildContext context) {
  showDialog<String>(
      context: context,
      builder: (context) => TDialog(
            actionButtonText: 'OPEN SETTING',
            bodyText:
                "Your Location is disabled, and you have running trip, please allow location for better performance",
            title: 'Location Enable',
            isBack: true,
            onActionPressed: () async {
              // Geolocator.openAppSettings();
              log("opeing setting");
              await Geolocator.openLocationSettings();
            },
          ));
}
