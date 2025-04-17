import 'package:Happinest/common/common_imports/common_imports.dart';

import '../../../../../common/widgets/cached_circular_network_image.dart';
import '../../../../../utility/constants/images/image_url.dart';

class PersonalInviteActionBanner extends StatelessWidget {
  final String userName;
  final String userTitle;
  final String profileUrl;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const PersonalInviteActionBanner({
    Key? key,
    required this.userName,
    required this.userTitle,
    required this.profileUrl,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h), // Reduced padding for better fit
      child: Container(
        height: 60.h, // Ensuring the height stays exactly 60
        margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 18.r,
              backgroundImage: profileUrl != null && profileUrl.isNotEmpty
                  ? NetworkImage(profileUrl) // Use NetworkImage for a URL
                  : const AssetImage(TImageUrl.personImgUrl)
                      as ImageProvider, // Default placeholder
            ),
            SizedBox(width: 8.w), // Reduced for better spacing

            // User Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp, // Reduced font size to fit
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    userTitle,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12.sp, // Adjusted for proper fit
                    ),
                  ),
                ],
              ),
            ),

            // Accept Button
            SizedBox(
              height: 32.h, // Ensures the button fits within 60 height
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    side: const BorderSide(color: Colors.orange),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  minimumSize: Size(60.w, 30.h),
                ),
                child: Text("Accept", style: TextStyle(fontSize: 12.sp)),
              ),
            ),
            SizedBox(width: 6.w),

            // Decline Button
            SizedBox(
              height: 32.h, // Keeps button within height limit
              child: TextButton(
                onPressed: onDecline,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  minimumSize: Size(60.w, 30.h),
                ),
                child: Text("Decline", style: TextStyle(color: Colors.red, fontSize: 12.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
