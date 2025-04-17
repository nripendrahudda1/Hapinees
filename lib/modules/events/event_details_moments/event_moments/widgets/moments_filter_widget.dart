import '../../../../../common/common_imports/common_imports.dart';

class MomentsFilterWidget extends StatelessWidget {
  const MomentsFilterWidget({
    super.key,
    required this.types,
    required this.selectedIndex,
    required this.isPersonalEvent,
    required this.onTap,
  });

  final List<String> types;
  final int selectedIndex;
  final bool isPersonalEvent;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return isPersonalEvent
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: SizedBox(
              height: 23.h, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(
                  left: 15.w,
                ),
                itemCount: types.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onTap(index);
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 6.w),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? TAppColors.white
                            : TAppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: Center(
                        child: Text(types[index],
                            style: getRegularStyle(
                              fontSize: MyFonts.size14,
                              color: selectedIndex == index ? TAppColors.black : TAppColors.white,
                            )),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        : types.length <= 1
            ? types[0] == "All"
                ? SizedBox(
                    height: 5.h,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: SizedBox(
                      height: 22.h, // Adjust the height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.only(
                          left: 15.w,
                        ),
                        itemCount: types.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              onTap(index);
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 6.w),
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 1.h),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? TAppColors.white
                                    : TAppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: Center(
                                child: Text(types[index],
                                    style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: selectedIndex == index
                                          ? TAppColors.black
                                          : TAppColors.white,
                                    )),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
            : const SizedBox.shrink();
  }
}
