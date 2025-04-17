import 'package:Happinest/modules/home/Models/setdashboard_data_model.dart';
import 'package:Happinest/modules/home/widget/story_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Happinest/modules/home/Controllers/home_controller.dart';
import 'package:Happinest/modules/home/widget/occasion_card.dart';

// class HomePageStoryTypeCollection extends StatelessWidget {
//   ScrollController? scrollController;
//   final SetDashboardgetModel model;
//   HomePageStoryTypeCollection({this.scrollController, super.key, required this.model});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final _ = ref.read(homectr);
//         final List data = _.occasionTripData?.trendingOccasions ?? []; // trendingOccasions
//         // if (_.selectedStoryCollection == 0) {
//         //   if (_.tripData != null) {
//         //     switch (_.selectedStoryType) {
//         //       case 0:
//         //         data = _.tripData!.trendingTrips ?? [];
//         //         break;
//         //       case 1:
//         //         data = _.tripData!.popularTrips ?? [];
//         //         break;
//         //       case 2:
//         //         data = _.tripData!.recommendedTrips ?? [];
//         //         break;
//         //       case 3:
//         //         data = _.tripData!.recentTrips ?? [];
//         //         break;
//         //     }
//         //   } else {
//         //     data = [];
//         //   }
//         // } else {
//         /*         if (_.occasionTripData != null) {
//             switch (_.selectedStoryType) {
//               case 0:
//                 data = _.occasionTripData!.trendingOccasions ?? [];
//                 break;
//               case 1:
//                 data = _.occasionTripData!.popularOccasions ?? [];
//                 break;
//               case 2:
//                 data = _.occasionTripData!.recommendedOccasions ?? [];
//                 break;
//               case 3:
//                 data = _.occasionTripData!.recentOccasions ?? [];
//                 break;
//             }
//           } else {
//             data = [];
//           }*/
//         // }
//         return
//             // data.isNotEmpty
//             //   ? _.selectedStoryCollection == 0
//             //       ? GridView.builder(
//             //           controller: scrollController,
//             //           padding: const EdgeInsets.all(0),
//             //           shrinkWrap: true,
//             //           itemCount: data.length,
//             //           physics: const ClampingScrollPhysics(),
//             //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             //               mainAxisSpacing: 10.h,
//             //               crossAxisSpacing: 5.w,
//             //               childAspectRatio: 0.75,
//             //               crossAxisCount: 2),
//             //           itemBuilder: (context, index) {
//             //             return StoryCard(
//             //               tripData: data[index],
//             //               index: index,
//             //             );
//             //           })
//             //       :
//             GridView.builder(
//           controller: scrollController,
//           padding: const EdgeInsets.all(0),
//           shrinkWrap: true,
//           itemCount: data.length,
//           physics: const ClampingScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               mainAxisSpacing: 10.h,
//               crossAxisSpacing: 8.w,
//               childAspectRatio: 0.75,
//               crossAxisCount: 2),
//           itemBuilder: (context, index) {
//             return OccasionCard(
//               occasionData: data[index],
//               index: index,
//               onTab: () {
//                 _.getStoryCategoryOccasion(
//                     context, _.occasionTripData == null ? true : false, model);
//               },
//             );
//           },
//         );
//         // : const SizedBox();
//       },
//     );
//   }
// }

class HomePageStoryTypeCollection extends StatelessWidget {
  ScrollController? scrollController;
  final SetDashboardgetModel model;
  HomePageStoryTypeCollection({this.scrollController, super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, value, child) {
        final _ = value.watch(homectr);
        late List data;

        if (_.occasionData != null) {
          switch (_.selectedStoryType) {
            case 0:
              data = _.occasionData?.trendingOccasions ?? [];
              if (!_.triggeredTypes.contains(0)) {
                _.resetTriggeredTypes();
                _.triggeredTypes.add(0);
                model.noOfRecords = 10;
                model.offset = 1;
                model.sortEventsBy = _.storyCategoryList?.eventFilters?[0] ?? '';
                _.getStoryCategoryOccasion(context, true, model);
              }
              break;
            case 1:
              data = _.occasionData?.popularOccasions ?? [];
              if (!_.triggeredTypes.contains(1)) {
                _.resetTriggeredTypes();
                _.triggeredTypes.add(1);
                model.noOfRecords = 10;
                model.offset = 1;
                model.sortEventsBy = _.storyCategoryList?.eventFilters?[1] ?? '';
                _.getStoryCategoryOccasion(context, true, model);
              }

              break;
            case 2:
              data = _.occasionData?.recommendedOccasions ?? [];
              if (!_.triggeredTypes.contains(2)) {
                _.resetTriggeredTypes();
                _.triggeredTypes.add(2);
                model.noOfRecords = 10;
                model.offset = 1;
                model.sortEventsBy = _.storyCategoryList?.eventFilters?[2] ?? '';
                _.getStoryCategoryOccasion(context, true, model);
              }

              break;
            case 3:
              data = _.occasionData?.recentOccasions ?? [];
              if (!_.triggeredTypes.contains(3)) {
                _.resetTriggeredTypes();
                _.triggeredTypes.add(3);
                model.noOfRecords = 10;
                model.offset = 1;
                model.sortEventsBy = _.storyCategoryList?.eventFilters?[3] ?? '';
                _.getStoryCategoryOccasion(context, true, model);
              }

              break;
          }
        } else {
          data = [];
        }
        return data.isNotEmpty
            ? GridView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: data.length,
                physics: const ClampingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10.h,
                    crossAxisSpacing: 8.w,
                    childAspectRatio: 0.75,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return OccasionCard(
                    occasionData: data[index],
                    index: index,
                    onTab: () {
                      _.getStoryCategoryOccasion(
                          context, _.occasionData == null ? true : false, model);
                    },
                  );
                },
              )
            : const SizedBox();
      },
    );
  }
}
