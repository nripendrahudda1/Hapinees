import 'package:Happinest/theme/app_colors.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/location/custom_switch.dart';
import 'package:Happinest/utility/permissions.dart';

class AppPermissions extends StatefulWidget {
  const AppPermissions({super.key});

  @override
  State<AppPermissions> createState() => _AppPermissionsState();
}

class _AppPermissionsState extends State<AppPermissions> {
  bool status_location = false;
  bool status_camera = false;
  bool status_gallery = false;

  @override
  void initState() {
    super.initState();
    _loadSwitch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TAppColors.davyGrey,
      appBar: Utility.actionBar(context, "profile.permissions"),

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Location Permission',
                                style: TextStyle(
                                  color: TAppColors.red,
                                  fontSize: 14,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                           const  Spacer(),
                            CustomSwitch(
                              colorBackground:
                                  !status_location ? Colors.grey : TAppColors.appColor,
                              colorCircle: Colors.white,
                              value: status_location,
                              onChanged: (value) async {
                                _permissionsData(1, value, context);
                                setState(() {
                                  status_location = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Utility.addDivider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Camera Permission",
                                style: TextStyle(
                                  color: TAppColors.red,
                                  fontSize: 14,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomSwitch(
                              colorBackground: !status_camera ? Colors.grey : TAppColors.appColor,
                              colorCircle: Colors.white,
                              value: status_camera,
                              onChanged: (value) {
                                _permissionsData(2, value, context);
                                setState(() {
                                  status_camera = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Utility.addDivider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "GalleryPermission",
                                style: TextStyle(
                                  color: TAppColors.red,
                                  fontSize: 14,
                                  height: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            CustomSwitch(
                              colorBackground:
                                  !status_gallery ? Colors.grey : TAppColors.appColor,
                              colorCircle: Colors.white,
                              value: status_gallery,
                              onChanged: (value) {
                                _permissionsData(3, value, context);
                                setState(() {
                                  status_gallery = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  void onChangeCallBack(String value) async {
    if (value == 'Settings') {
    //  _openSettings();
    } else {
      _loadSwitch();
    }
  }

  // ignore: long-method
  void _permissionsData(
    int index,
    bool value,
    BuildContext context,
  ) async {
    switch (index) {
      case 1:
        if (value) {
          PermissionStatus status = await Permission.location.request();
          if (status.isGranted) {
            setState(() {
              status_location = true;
              _loadSwitch();
            });
            Utility.toast("Location permissions is granted!");
          } else {
            setState(() {
              status_location = false;
              _loadSwitch();
            });
            // ignore: use_build_context_synchronously
            AllPermissions.permissionsShowDialog(context, onChangeCallBack);
            Utility.toast("Location permissions is Denied!");
          }
        } else {
          AllPermissions.permissionsShowDialog(context, onChangeCallBack);
        }

        break;
      case 2:
        if (value) {
          PermissionStatus status = await Permission.camera.request();
          if (status.isGranted) {
            setState(() {
              status_camera = true;
              _loadSwitch();
            });
            Utility.toast("Camera permissions is granted!");
          } else {
            setState(() {
              status_camera = false;
              _loadSwitch();
            });
            AllPermissions.permissionsShowDialog(context, onChangeCallBack);
            Utility.toast("Camera permissions is Denied!");
          }
        } else {
          AllPermissions.permissionsShowDialog(context, onChangeCallBack);
        }

        break;
      case 3:
        if (value) {
          PermissionStatus status = await Permission.accessMediaLocation.request();
          if (status.isGranted) {
            setState(() {
              status_gallery = true;
              _loadSwitch();
            });
            Utility.toast("Gallery permissions is granted!");
          } else {
            setState(() {
              status_gallery = false;
              _loadSwitch();
            });
            AllPermissions.permissionsShowDialog(context, onChangeCallBack);
            Utility.toast("Gallery permissions is Denied!");
          }
        } else {
          AllPermissions.permissionsShowDialog(context, onChangeCallBack);
        }
        break;
    }
  }

  void _loadSwitch() async {
    PermissionStatus stLocation = await Permission.location.status;
    PermissionStatus stCamera = await Permission.camera.status;
    PermissionStatus stGallery = await Permission.accessMediaLocation.status;
    PermissionStatus stNotification = await Permission.notification.status;
    if (stLocation.isGranted) {
      setState(() {
        status_location = true;
      });
    } else {
      setState(() {
        status_location = false;
      });
    }

    if (stCamera.isGranted) {
      setState(() {
        status_camera = true;
      });
    } else {
      setState(() {
        status_camera = false;
      });
    }

    if (stGallery.isGranted) {
      setState(() {
        status_gallery = true;
      });
    } else {
      setState(() {
        status_gallery = false;
      });
    }

  }

  // void _openSettings() async {
  //   await openAppSettings();
  //   BasicMessageChannel<String?> lifecycleChannel = SystemChannels.lifecycle;
  //   lifecycleChannel.setMessageHandler((msg) async {
  //     print(':::: @#@# ${msg}');
  //     if (msg!.endsWith("resumed")) {
  //       _loadSwitch();
  //       lifecycleChannel.setMessageHandler(null);
  //     }
  //   });
  // }
}
