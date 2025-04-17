import '../../modules/home/Controllers/home_controller.dart';
import '../../utility/constants/constants.dart';
import '../common_imports/apis_commons.dart';
import '../common_imports/common_imports.dart';

class CommonEventTypeWidget extends ConsumerWidget {
  const CommonEventTypeWidget({
    super.key,
    required this.subEventTypeList,
    required this.selectedEventType,
    required this.selectedSubEventType,
    required this.onTap,
    required this.subOnTap
  });
  final List<dynamic> subEventTypeList;
  final int selectedEventType;
  final int selectedSubEventType;
  final void Function(int) onTap;
  final void Function(int) subOnTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(homectr);
    // final ctr = ref.watch(exploreCtr);

    return Container(
      color: TAppColors.black50,
      height: selectedEventType != 0 ? 85.h : 46.h,
      width: dwidth!,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return TBounceAction(
                    onPressed: () {
                      onTap(index);
                    },
                    child: Center(
                        child: index != 0
                            ? TCard(
                            radius: 20,
                            color: selectedEventType == index
                                ? TAppColors.orange
                                : TAppColors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 1.h),
                              child: Text(_.eventTypeList[index - 1], style: selectedEventType == index
                                  ? getRobotoBoldStyle(color: TAppColors.white,fontSize: 14,)
                                  : getRobotoMediumStyle(color: TAppColors.text1Color,fontSize: 14,)),
                            ))
                            : TCard(
                            radius: 20,
                            color: selectedEventType == index
                                ? TAppColors.orange
                                : TAppColors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24.w, vertical: 1.h),
                              child: Text("All",style: selectedEventType == index
                                  ? getRobotoBoldStyle(color: TAppColors.white,fontSize: 14,)
                                  : getRobotoMediumStyle(color: TAppColors.text1Color,fontSize: 14,))
                            ))),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },
                itemCount: _.eventTypeList.length + 1,
              ),
            ),
          ),
          // const Spacer(),
          selectedEventType != 0 ?
          SizedBox(height: 10.h) : const SizedBox() ,
          selectedEventType != 0
              ? Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TBounceAction(
                        onPressed: () {subOnTap(index);},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TText(subEventTypeList[index],
                              fontSize: MyFonts.size14,
                              fontWeight:
                              selectedSubEventType == index
                                  ? FontWeightManager.semiBold
                                  : FontWeightManager.regular,
                              color: selectedSubEventType == index
                                  ? TAppColors.orange
                                  : TAppColors.white,
                            ),
                            const Spacer(),
                            selectedSubEventType == index
                                ? TCard(
                                height: 3,
                                width: 50.w,
                                color: TAppColors.orange)
                                : const SizedBox.shrink()
                          ],
                        ));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 16.w,
                    );
                  },
                  itemCount: subEventTypeList.length),
            ),
          )
              : const SizedBox()
        ],
      ),
    );
  }
}
