
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Happinest/common/widgets/app_card.dart';
import 'package:Happinest/common/widgets/appbar.dart';
import 'package:Happinest/utility/constants/constants.dart';
import 'package:Happinest/utility/constants/strings/label_strings.dart';

import '../../../common/common_functions/topPadding.dart';
import '../../../common/widgets/app_bounce.dart';
import '../../../common/widgets/app_text.dart';
import '../../../common/widgets/app_text_field.dart';
import '../../../common/widgets/iconButton.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/font_manager.dart';
import '../../../utility/constants/images/image_name.dart';
import '../Controllers/home_controller.dart';
import 'home_popular_author.dart';
import 'occasion_card.dart';

class HomeSearchPage extends ConsumerWidget {
  const HomeSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(homectr);
    return Scaffold(
      backgroundColor: TAppColors.cardBg,
      body: Column(
        children: [
          Container(color: TAppColors.white,child: Column(
            children: [
              topPadding(topPadding: 8.h,offset: 30.h),
              CustomAppBar(title: "Search",hasSuffix: false,
                prefixWidget: iconButton(
                bgColor: TAppColors.text4Color,
                iconPath: TImageName.back,
                  radius: 24.h,
                onPressed: () {
                  _.searchPopularAuthor = [];
                  _.searchEvents = [];
                  // _.searchTrips = [];
                  _.searchController.clear();
                  Navigator.pop(context);
                },
              ),),
            ],
          ),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TCard(
                      height: 40.h,
                      shadow: true,
                      color: TAppColors.white.withOpacity(0.9),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _.isSearching = true;
                                _.onSearch(context,isLoader: true);
                              },
                              child: Image.asset(
                                TImageName.search,
                                height: 20.h,
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CTTextField(
                                isAutoFocus: true,
                                maxLines: 1,
                                hint: 'Search Authors, Stories or Locations',
                                fontSize: 14,
                                focusNode: _.searchFieldFocus,
                                controller: _.searchController,
                                onTapOutside: (p0) {
                                  FocusScope.of(context).unfocus();
                                },
                                onEditingComplete: () {
                                  FocusScope.of(context).unfocus();
                                  _.isSearching = true;
                                  _.onSearch(context,isLoader: true);
                                },
                              ),
                            )),
                          ],
                        ),
                      )),
                  !(_.searchPopularAuthor.isEmpty &&
                          _.searchEvents.isEmpty &&
                          _.searchController.text.isNotEmpty)
                      ? Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12.h, bottom: bottomSfarea + 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HomePopularAuthors(
                                      listOfAuthors: _.searchPopularAuthor,
                                      isFollowShow: true,
                                      isSearch: true,
                                      authorsColor: TAppColors.text1Color,
                                      authorsname: TLabelStrings.exploreAuthors),
                                  _.searchEvents.isNotEmpty
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15),
                                              child: TText(
                                                  TLabelStrings
                                                      .exploreStoryCollection,
                                                  fontSize: MyFonts.size18,
                                                  color:
                                                  TAppColors.text1Color,
                                                  fontWeight:
                                                  FontWeightManager
                                                      .bold),
                                            ),
                                            // _.storyCategoryList != null
                                            //     ? Column(
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment.start,
                                            //         children: [
                                            //           Padding(
                                            //             padding: const EdgeInsets
                                            //                 .symmetric(
                                            //                 horizontal: 15),
                                            //             child: TText(
                                            //                 TLabelStrings
                                            //                     .exploreStoryCollection,
                                            //                 fontSize: MyFonts.size18,
                                            //                 color:
                                            //                     TAppColors.text1Color,
                                            //                 fontWeight:
                                            //                     FontWeightManager
                                            //                         .bold),
                                            //           ),
                                            //           /*SizedBox(height: 15.h),
                                            //           SizedBox(
                                            //             height: 96.h,
                                            //             child: ListView.separated(
                                            //                 shrinkWrap: true,
                                            //                 scrollDirection:
                                            //                     Axis.horizontal,
                                            //                 itemBuilder:
                                            //                     (context, index) {
                                            //                   return Padding(
                                            //                     padding: EdgeInsets.only(
                                            //                         left: index == 0
                                            //                             ? 15
                                            //                             : 0,
                                            //                         right: index ==
                                            //                                 _.storyCategoryList!.eventGroupMasterList!
                                            //                                         .length -
                                            //                                     1
                                            //                             ? 15
                                            //                             : 0),
                                            //                     child: TBounceAction(
                                            //                       onPressed: () {
                                            //                         _.searchSelectedStoryCollection =
                                            //                             index;
                                            //                         _.notifyListeners();
                                            //                       },
                                            //                       child: TCard(
                                            //                           shadow: true,
                                            //                           shadowPadding:
                                            //                               true,
                                            //                           border:
                                            //                               _.searchSelectedStoryCollection ==
                                            //                                       index
                                            //                                   ? true
                                            //                                   : false,
                                            //                           borderColor:
                                            //                               TAppColors
                                            //                                   .lightBorderColor,
                                            //                           color:
                                            //                               TAppColors
                                            //                                   .white,
                                            //                           height: 96.h,
                                            //                           width: 90.w,
                                            //                           child: Center(
                                            //                             child: Column(
                                            //                               mainAxisAlignment:
                                            //                                   MainAxisAlignment
                                            //                                       .start,
                                            //                               crossAxisAlignment:
                                            //                                   CrossAxisAlignment
                                            //                                       .center,
                                            //                               mainAxisSize:
                                            //                                   MainAxisSize
                                            //                                       .min,
                                            //                               children: [
                                            //                                 Image
                                            //                                     .asset(
                                            //                                   TImageName.icTravel,
                                            //                                   *//*_
                                            //                                       .storyCategoryList!
                                            //                                       .eventGroupMasterList![index]
                                            //                                       .icon
                                            //                                       .toString(),*//*
                                            //                                   color: TAppColors
                                            //                                       .orange,
                                            //                                   height:
                                            //                                       32,
                                            //                                   width:
                                            //                                       32,
                                            //                                   fit: BoxFit
                                            //                                       .fill,
                                            //                                 ),
                                            //                                 Padding(
                                            //                                   padding: const EdgeInsets
                                            //                                       .only(
                                            //                                       top:
                                            //                                           8),
                                            //                                   child:
                                            //                                       TText(
                                            //                                     _.storyCategoryList!.eventGroupMasterList![index]
                                            //                                         .eventGroupName
                                            //                                         .toString(),
                                            //                                     fontSize:
                                            //                                         MyFonts.size14,
                                            //                                     fontWeight: _.searchSelectedStoryCollection == index
                                            //                                         ? FontWeightManager.bold
                                            //                                         : FontWeightManager.regular,
                                            //                                     color:
                                            //                                         TAppColors.text1Color,
                                            //                                   ),
                                            //                                 ),
                                            //                               ],
                                            //                             ),
                                            //                           )),
                                            //                     ),
                                            //                   );
                                            //                 },
                                            //                 separatorBuilder:
                                            //                     (context, index) {
                                            //                   return SizedBox(
                                            //                     width: 10.w,
                                            //                   );
                                            //                 },
                                            //                 itemCount: _
                                            //                     .storyCategoryList!
                                            //                     .eventGroupMasterList!
                                            //                     .length),
                                            //           )*/
                                            //         ],
                                            //       )
                                            //     : const SizedBox(),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            GridView.builder(
                                                      padding:
                                                          const EdgeInsets.all(0),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          _.searchEvents.length,
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                              mainAxisSpacing:
                                                                  10.h,
                                                              crossAxisSpacing:
                                                                  8.w,
                                                              childAspectRatio:
                                                                  0.75,
                                                              crossAxisCount: 2),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return OccasionCard(
                                                          occasionData:
                                                              _.searchEvents[
                                                                  index],
                                                          index: index,
                                                          onTab: (){
                                                            _.onEventSearch(context, isLoader: false);
                                                          },
                                                        );
                                                      },
                                                    )
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                        )
                      : _.isSearching
                          ? const SizedBox()
                          : Expanded(
                              child: Center(
                                child: TText('No Data Found', color: Colors.black),
                              ),
                            )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
