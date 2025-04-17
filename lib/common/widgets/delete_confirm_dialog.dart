import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_imports/common_imports.dart';

class CommonDeleteConfirmDialog extends StatelessWidget {
  const CommonDeleteConfirmDialog({
    super.key,
    required this.onTap,
    required this.title,
    this.isRitual = false,
    this.isEvent = false,
  });
  final Function() onTap;
  final String title;
  final bool isRitual;
  final bool isEvent;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(15.h),
        decoration: BoxDecoration(
          color: TAppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              // spreadRadius: 12,
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delete $title',
                  style: getSemiBoldStyle(
                      color: TAppColors.black, fontSize: MyFonts.size18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset(TImageName.crossPngIcon,
                      width: 16.w, height: 16.h),
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              'Are you sure want to delete $title${isRitual ? ' Ritual' : ""}${isEvent ? ' Event' : ""}?',
              style: getBoldStyle(
                  color: TAppColors.black, fontSize: MyFonts.size14),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              '$title Data will be lost once you delete.',
              style: getRegularStyle(
                  color: TAppColors.black, fontSize: MyFonts.size12),
            ),
            SizedBox(
              height: 25.h,
            ),
            Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                return TButton(
                  onPressed: (){
                    onTap();
                    Navigator.pop(context);
                  },
                  title: 'DELETE ${title.toUpperCase()}',
                  buttonBackground: TAppColors.buttonRed,
                  fontSize: MyFonts.size14,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
