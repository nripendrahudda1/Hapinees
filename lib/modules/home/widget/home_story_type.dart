import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';

class HomePageStoryType extends ConsumerWidget {
  const HomePageStoryType({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(homectr);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 45.h,
        child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return TBounceAction(
                  onPressed: () {
                    _.selectedStoryType = index;
                    _.notifyListeners();
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: TText(
                          _.storyCategoryList?.eventFilters?[index] ?? '',
                          fontSize: MyFonts.size14,
                          fontWeight: _.selectedStoryType == index
                              ? FontWeightManager.semiBold
                              : FontWeightManager.regular,
                          color: _.selectedStoryType == index
                              ? TAppColors.orange
                              : TAppColors.text1Color,
                        ),
                      ),
                      _.selectedStoryType == index
                          ? TCard(height: 2.5, width: 50.w, color: TAppColors.orange)
                          : const SizedBox.shrink()
                    ],
                  ));
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 20.w,
              );
            },
            itemCount: _.storyCategoryList?.eventFilters?.length ?? 0),
      ),
    );
  }
}
