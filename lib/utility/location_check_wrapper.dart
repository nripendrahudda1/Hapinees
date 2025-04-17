// import 'package:flutter/material.dart';

// import '../location/location/permission_handler.dart';

// class LocationCheckWrapper extends StatelessWidget {
//   final Widget child;
//   const LocationCheckWrapper({Key? key, required this.child}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Permission.locationWhenInUse.status,
//       builder: (context, AsyncSnapshot<PermissionStatus> snapshot) {
//         if (!snapshot.hasData) {
//           return Container(); // Return an empty container while permission status is loading
//         }
//         if (snapshot.data!.isPermanentlyDenied) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             openAppSettings(); // Redirect to app settings
//           });
//         }
//         return Stack(
//           children: [
//             child,
//             if (snapshot.data!.isDenied || snapshot.data!.isPermanentlyDenied)
//               RedOverlay(),
//           ],
//         );
//       },
//     );
//   }
// }

// class RedOverlay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.red.withOpacity(0.5),
//     );
//   }
// }
