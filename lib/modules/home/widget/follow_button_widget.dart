

import 'package:Happinest/common/common_imports/common_imports.dart';

Widget buildFollowActionButton({
  required BuildContext context,
  required num followingStatus,
  required VoidCallback onFollow,
  required VoidCallback onUnfollow,
  required VoidCallback onRemove,
}) {
  String label;
  VoidCallback onTap;

  switch (followingStatus) {
    case 0:
    case 3:
    case 4:
      label = TLabelStrings.follow;
      onTap = onFollow;
      break;
    case 2:
      label = TLabelStrings.unFollow;
      onTap = onUnfollow;
      break;
    case 1:
      label = TLabelStrings.remove;
      onTap = onRemove;
      break;
    default:
      return const SizedBox.shrink();
  }

  return GestureDetector(
    onTap: onTap,
    child: TCard(
      radius: 6,
      border: true,
      borderColor: TAppColors.selectionColor,
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
        child: TText(
          label,
          color: TAppColors.selectionColor,
          fontSize: MyFonts.size12,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
