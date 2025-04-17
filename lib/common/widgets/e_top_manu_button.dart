import '../common_imports/common_imports.dart';

class ETopManuButton extends StatelessWidget {
  ETopManuButton({super.key, required this.editMemories, required this.deleteMemories});

  void Function()? editMemories;
  void Function()? deleteMemories;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        offset: const Offset(-5, 25),
        onSelected: (String value) {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 2,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Edit',
                onTap: editMemories,
                height: 30.h,
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  children: [
                    Image.asset(
                      TImageName.editOutlinedIcon,
                      width: 18.w,
                      height: 18.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Edit',
                      style: getRegularStyle(color: TAppColors.black, fontSize: MyFonts.size14),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Delete',
                onTap: deleteMemories,
                height: 30.h,
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  children: [
                    Image.asset(TImageName.deleteOutlineIcon, width: 18.w, height: 18.h),
                    SizedBox(width: 8.w),
                    Text(
                      'Delete',
                      style: getRegularStyle(color: TAppColors.black, fontSize: MyFonts.size14),
                    ),
                  ],
                ),
              ),
            ],
        child: Image.asset(
          TImageName.moreVertIcon,
          width: 22.w,
          height: 22.h,
          color: TAppColors.white,
        ));
  }
}
