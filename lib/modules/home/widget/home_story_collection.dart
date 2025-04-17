import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:Happinest/modules/home/Models/setdashboard_data_model.dart';

// class HomePageStoryCollection extends ConsumerWidget {
//   const HomePageStoryCollection({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _ = ref.watch(homectr);
//     if (_.occasionTripData?.trendingOccasions == [] ||
//         _.occasionTripData?.trendingOccasions == null) {
//       return const SizedBox();
//     }
//     return _.storyCategoryList != null
//         ? Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: TText(TLabelStrings.exploreStoryCollection,
//                     fontSize: MyFonts.size18,
//                     color: TAppColors.white,
//                     fontWeight: FontWeightManager.bold),
//               ),
//               SizedBox(height: 15.h),
//               SizedBox(
//                 height: 96.h,
//                 child: ListView.separated(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(
//                             left: index == 0 ? 15 : 0,
//                             right: index == _.storyCategoryList!.eventGroupMasterList!.length - 1
//                                 ? 15
//                                 : 0),
//                         child: TBounceAction(
//                           onPressed: () {
//                             _.selectedStoryCollection = index;
//                             print(_.selectedStoryCollection);
//                             _.selectedStoryCollection == 0
//                                 ? null /*_.getTripData(context, isLoader: false)*/
//                                 : _.getStoryCategoryOccasion(context, true);
//                             _.notifyListeners();
//                           },
//                           child: TCard(
//                               shadow: true,
//                               shadowPadding: true,
//                               border: _.selectedStoryCollection == index ? true : false,
//                               borderColor: TAppColors.lightBorderColor,
//                               color: TAppColors.white,
//                               height: 96.h,
//                               width: 90.w,
//                               child: Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Image.network(
//                                       _.storyCategoryList?.eventGroupMasterList![index].icon ?? '',
//                                       color: _.selectedStoryCollection == index
//                                           ? TAppColors.orange
//                                           : TAppColors.themeColor,
//                                       height: 32,
//                                       width: 32,
//                                       fit: BoxFit.fill,
//                                     ),
//                                     // Image.asset(
//                                     //   TImageName.icTravel,
//                                     //   _.storyCategoryList
//                                     //       ?.eventGroupMasterList?[index].icon
//                                     //       .toString(),
//                                     //   color: _.selectedStoryCollection == index ? TAppColors.orange : TAppColors.themeColor,
//                                     //   height: 32,
//                                     //   width: 32,
//                                     //   fit: BoxFit.fill,
//                                     // ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 8),
//                                       child: TText(
//                                         _.storyCategoryList!.eventGroupMasterList![index]
//                                             .eventGroupName
//                                             .toString(),
//                                         fontSize: MyFonts.size14,
//                                         fontWeight: _.selectedStoryCollection == index
//                                             ? FontWeightManager.bold
//                                             : FontWeightManager.regular,
//                                         color: TAppColors.text1Color,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context, index) {
//                       return SizedBox(
//                         width: 10.w,
//                       );
//                     },
//                     itemCount: _.storyCategoryList!.eventGroupMasterList?.length ?? 0),
//               )
//             ],
//           )
//         : const SizedBox();
//   }
// }

class HomePageStoryCollection extends ConsumerWidget {
  final SetDashboardgetModel model;
  const HomePageStoryCollection({super.key, required this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(homectr);
    return _.storyCategoryList != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TText(TLabelStrings.exploreStoryCollection,
                    fontSize: MyFonts.size18,
                    color: TAppColors.white,
                    fontWeight: FontWeightManager.bold),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                height: 96.h,
                child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: index == 0 ? 15 : 0,
                            right:
                                index == (_.storyCategoryList?.modules?.length ?? 0) - 1 ? 15 : 0),
                        child: TBounceAction(
                          onPressed: () {
                            _.selectedStoryCollection = index;
                            model.noOfRecords = 10;
                            model.offset = 1;
                            model.moduleId = _.storyCategoryList?.modules?[index].moduleId;
                            _.resetTriggeredTypes();
                            // _.resetTriggeredTypesWithIndex(index);
                            _.getStoryCategoryOccasion(context, true, model);
                            _.notifyListeners();
                          },
                          child: TCard(
                              shadow: true,
                              shadowPadding: true,
                              border: _.selectedStoryCollection == index ? true : false,
                              borderColor: TAppColors.lightBorderColor,
                              color: TAppColors.white,
                              height: 96.h,
                              width: 90.w,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      // "https://primary-west.uk/happinestimages/EventTypeMaster/OccationsIcon_Blue\\wedding.png",
                                      _.storyCategoryList?.modules?[index].eventIconUnselected ??
                                          ''.toString(),
                                      color: _.selectedStoryCollection == index
                                          ? TAppColors.orange
                                          : TAppColors.themeColor,
                                      height: 32,
                                      width: 32,
                                      fit: BoxFit.fill,
                                    ),
                                    // Image.asset(
                                    //   TImageName.icTravel,
                                    //   _.storyCategoryList
                                    //       ?.eventGroupMasterList?[index].icon
                                    //       .toString(),
                                    //   color: _.selectedStoryCollection == index ? TAppColors.orange : TAppColors.themeColor,
                                    //   height: 32,
                                    //   width: 32,
                                    //   fit: BoxFit.fill,
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: TText(
                                        _.storyCategoryList?.modules?[index].moduleName
                                                .toString() ??
                                            "",
                                        fontSize: MyFonts.size14,
                                        fontWeight: _.selectedStoryCollection == index
                                            ? FontWeightManager.bold
                                            : FontWeightManager.regular,
                                        color: TAppColors.text1Color,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10.w,
                      );
                    },
                    itemCount: _.storyCategoryList?.modules?.length ?? 0),
              ),
              // if (_.isLoadingMore)
              //   const Padding(
              //     padding: const EdgeInsets.symmetric(vertical: 16),
              //     child: Center(
              //       child: CircularProgressIndicator(color: TAppColors.themeColor),
              //     ),
              //   ),
            ],
          )
        : const SizedBox();
  }
}
