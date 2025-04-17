import 'package:Happinest/common/common_imports/common_imports.dart';

void removePhotoToRitualBottomSheet(
    {required BuildContext context,
    required String ritual,
    required Function() onTap,
    double horizontalPadding = 20,
    bool isDismissible = true,
    bool adjustSizeOnOpenKeyboard = true}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    enableDrag: isDismissible,
    isDismissible: isDismissible,
    useRootNavigator: true,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => isDismissible,
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.fromLTRB(horizontalPadding.w, 14.h, horizontalPadding.w, 30.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.w),
                topRight: Radius.circular(20.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Save Photo to Acivity",
                      style: getSemiBoldStyle(fontSize: MyFonts.size20, color: TAppColors.black),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Image.asset(
                          TImageName.crossOrangeIcon,
                          color: TAppColors.greyText,
                          width: 16.w,
                          height: 16.h,
                        ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ritual,
                        style: getRegularStyle(fontSize: MyFonts.size14, color: TAppColors.black),
                      ),
                      Row(
                        children: [
                          Text(
                            "Added",
                            style: getRegularStyle(
                                fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onTap();
                              },
                              icon: Image.asset(
                                TImageName.cross,
                                color: TAppColors.text4Color,
                                width: 20.w,
                                height: 20.h,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
