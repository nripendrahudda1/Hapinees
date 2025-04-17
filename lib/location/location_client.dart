import 'dart:developer';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/iconButton.dart';
import 'dart:async';

Future<LocationPermission> locationDialogboxForGeolocator(BuildContext context) async {
  final Location location = Location();
  var permissionStatus = await Geolocator.checkPermission();
  log("permisson status == $permissionStatus");
  if (permissionStatus == LocationPermission.denied ||
      permissionStatus == LocationPermission.deniedForever) {
    // Show dialog before requesting permission
    permissionStatus = await showDialog(
        context: context,
        builder: (context) => TDialog(
              actionButtonText: 'Ok',
              bodyText:
                  "To provide enhanced travel features, this app needs to access your location in the background.Your location data will be used to enhance location-based experiences and memories.",
              title: 'Location Discrimination',
              isBack: false,
              onActionPressed: () async {
                Navigator.pop(context);
                permissionStatus = await Geolocator.requestPermission();
                log("after tap == $permissionStatus");
                if (permissionStatus == LocationPermission.always) {
                  await location.enableBackgroundMode();
                  await location.changeNotificationOptions(
                    title: 'Geolocation',
                    subtitle: 'Geolocation detection',
                  );
                } else {
                  Geolocator.openLocationSettings();
                }
              },
            ));
  }
  if (permissionStatus == LocationPermission.always) {
    await location.enableBackgroundMode();
    await location.changeNotificationOptions(
      title: 'Geolocation',
      subtitle: 'Geolocation detection',
    );
  }
  return permissionStatus;
}

class LocationClient {
  final Location _location = Location();
  Stream<LatLng> get locationStream =>
      _location.onLocationChanged.map((event) => LatLng(event.latitude!, event.longitude!));
  void init(BuildContext context) async {
    await locationDialogbox(context);
    var permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.granted) {
      await _location.enableBackgroundMode();
      await _location.changeNotificationOptions(
        title: 'Geolocation',
        subtitle: 'Geolocation detection',
      );
    }
  }

  Future<bool> isServiceEnabled(BuildContext context) async {
    bool status = false;
    await showDialog<String>(
      context: context,
      builder: (context) => TDialog(
        actionButtonText: 'DELETE',
        bodyText:
            'Are you sure you want to delete your account? This action is irreversible, and all your data will be permanently lost',
        title: 'Delete Account?',
        isBack: false,
        onActionPressed: () async {
          status = await _location.serviceEnabled();
        },
      ),
    );
    return status;
  }
}

Future<PermissionStatus> locationDialogbox(BuildContext context) async {
  final Location location = Location();
  var permissionStatus = await location.hasPermission();
  log("permission status == $permissionStatus");

  if (Platform.isAndroid) {
    // Android-specific logic with dialog
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      // Show dialog before requesting permission on Android
      await showDialog(
        context: context,
        builder: (context) => TDialog(
          actionButtonText: 'Ok',
          bodyText:
              "To provide enhanced travel features, this app needs to access your location in the background. Your location data will be used to enhance location-based experiences and memories.",
          title: 'Location Discrimination',
          isBack: false,
          onActionPressed: () async {
            Navigator.pop(context);
            permissionStatus = await location.requestPermission();
            log("after tap == $permissionStatus");

            if (permissionStatus == PermissionStatus.granted) {
              await location.enableBackgroundMode();
              await location.changeNotificationOptions(
                title: 'Geolocation',
                subtitle: 'Geolocation detection',
              );
            }
          },
        ),
      );
    }

    if (permissionStatus == PermissionStatus.granted) {
      await location.enableBackgroundMode();
      await location.changeNotificationOptions(
        title: 'Geolocation',
        subtitle: 'Geolocation detection',
      );
    }
  } else if (Platform.isIOS) {
    // iOS-specific logic: request permission directly without showing dialog
    if (permissionStatus == PermissionStatus.denied ||
        permissionStatus == PermissionStatus.deniedForever) {
      permissionStatus = await location.requestPermission();
      log("iOS permission status == $permissionStatus");

      if (permissionStatus == PermissionStatus.granted) {
        // Enable background mode or other iOS-specific options
        await location.enableBackgroundMode();
        await location.changeNotificationOptions(
          title: 'Geolocation',
          subtitle: 'Geolocation detection',
        );
      }
    }
  }

  return permissionStatus;
}

class TDialog extends StatelessWidget {
  const TDialog({
    required this.title,
    required this.bodyText,
    required this.onActionPressed,
    required this.actionButtonText,
    this.isBack,
    this.showActionButton = true, // Default is true
    super.key,
    this.textField,
  });

  final String title;
  final Function() onActionPressed;
  final String bodyText;
  final String actionButtonText;
  final bool? isBack;
  final bool showActionButton; // New property
  final Widget? textField;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: TCard(
        color: TAppColors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SizedBox(width: 24.w, height: 24.h),
                  Expanded(
                    child: Center(
                      child: TText(
                        title,
                        fontSize: 17,
                        fontWeight: FontWeightManager.semiBold,
                        color: TAppColors.black,
                      ),
                    ),
                  ),
                  iconButton(
                    padding: 0,
                    radius: 28.w,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    iconPath: TImageName.cancelIcon,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: textField != null ? 0 : 20,
                  top: textField != null ? 0 : 20,
                ),
                child: TText(
                  bodyText,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.normal,
                  color: TAppColors.black,
                ),
              ),
              textField ?? const SizedBox(),

              // Conditionally show the action button
              if (showActionButton)
                TBounceAction(
                  onPressed: () async {
                    if (isBack ?? true) Navigator.pop(context);
                    await onActionPressed();
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: TCard(
                          radius: 100,
                          color: TAppColors.themeColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Center(
                              child: TText(
                                actionButtonText.toUpperCase(),
                                fontSize: 16,
                                fontWeight: FontWeightManager.semiBold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
