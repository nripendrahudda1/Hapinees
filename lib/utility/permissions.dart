import 'package:Happinest/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AllPermissions {
  static Future<void> request_permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.accessMediaLocation,
      Permission.notification,
    ].request();

    statuses.forEach((idx, val) async {
      if (val.isDenied || val.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        idx.value == 1 ? "All Alert Here " : null;
      }
    });
  }

  // ignore: long-method
  static Future<void> permissionsShowDialog(
    BuildContext context,
    void Function(String val) onCallBack,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Permissions',
            style: TextStyle(
              color: TAppColors.white,
              fontSize: 14,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'To allow access',
                  style: TextStyle(
                    color: TAppColors.white,
                    fontSize: 14,
                    height: 1.2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: TAppColors.orangeColor,
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                onCallBack('Cancel');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Go To Settings',
                style: TextStyle(
                  color: TAppColors.orangeColor,
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                onCallBack('Settings');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
