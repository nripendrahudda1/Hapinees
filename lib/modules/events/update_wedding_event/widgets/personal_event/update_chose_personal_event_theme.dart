import 'dart:developer';

import 'package:Happinest/models/create_event_models/create_wedding_models/post_models/personal_event_theme_model.dart';
import 'package:Happinest/models/create_event_models/home/home_personal_event_details_model.dart';
import 'package:Happinest/modules/events/create_event/widgets/styles_shimmer.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_persoanl_event_theme_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/personal_event/update_personal_event_activities_controller.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_personal_event_theme_tile.dart';
import 'package:Happinest/modules/events/update_wedding_event/widgets/personal_event/update_write_theme_widget.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../create_event/widgets/removeable_style_tile.dart';
import '../../controllers/wedding_event/update_wedding_event_expanded_controller.dart';

class UpdatePersonalEventThemeWidget extends ConsumerStatefulWidget {
  final HomePersonalEventDetailsModel? homeModel;
  const UpdatePersonalEventThemeWidget({
    required this.homeModel,
    super.key,
  });

  @override
  ConsumerState<UpdatePersonalEventThemeWidget> createState() =>
      _UpdatePersonalEventThemeWidgetState();
}

class _UpdatePersonalEventThemeWidgetState extends ConsumerState<UpdatePersonalEventThemeWidget> {
  @override
  void initState() {
    super.initState();
    final manageThemeCtr = ref.read(updatePersonalEventThemCtr);
    manageThemeCtr.fetchPersonalEventThemesModel(
      eventTypeMasterId: widget.homeModel?.eventTypeId ?? 0,
      onSuccess: () {
        initialize(); // will run once theme data is fetched
      },
    );
  }

  initialize() async {
    final manageThemeCtr = ref.read(updatePersonalEventThemCtr);
    final manageActivitiesCtr = ref.read(updatePersonalEventActivitiesCtr);
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    ref.watch(updateEventExpandedCtr).setPersonalEventThemeUnExpanded();
    // ref.read(updateEventExpandedCtr).setOccasionUnExpanded();
    manageThemeCtr.addFirstSelectedTheme(manageThemeCtr.selectedThemes != ''
        ? manageThemeCtr.selectedThemes
        : widget.homeModel?.personalEventThemeName ?? '');
    int themeId = 0;
    print(
        "manageThemeCtr.personalEventThemeModel *** ${manageThemeCtr.personalEventThemeModel != null}");
    manageThemeCtr.personalEventThemeModel?.personalEventThemeMasterList?.forEach((element) {
      if (element.personalEventThemeName?.toLowerCase() ==
          widget.homeModel?.personalEventThemeName?.toLowerCase()) {
        setState(() {
          print("manageThemeCtr.personalEventThemeModel 1 *** ${element.personalEventThemeId}");
          themeId = element.personalEventThemeId ?? 0;
        });
      }
    });

    await manageActivitiesCtr.fetchPersonalEventActivityMaster(
      ref: ref,
      context: context,
      personalEventThemeMasterId: themeId,
    );

    await manageActivitiesCtr.fetchPersonalEventActivityModel(
      ref: ref,
      context: context,
      personalEventThemeMasterId: themeId,
    );

    print("manageThemeCtr.personalEventThemeModel *** ${themeId}");
    // widget.onSuccess!();
    initialActivity(model: widget.homeModel);

    //  });
  }
  // final manageThemeCtr = ref.read(updatePersonalEventThemCtr);
  // final manageActivitiesCtr = ref.read(updatePersonalEventActivitiesCtr);
  // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //   ref.watch(updateEventExpandedCtr).setPersonalEventThemeUnExpanded();
  //   // ref.read(updateEventExpandedCtr).setOccasionUnExpanded();
  //   manageThemeCtr.addFirstSelectedTheme(manageThemeCtr.selectedThemes != ''
  //       ? manageThemeCtr.selectedThemes
  //       : widget.homeModel?.personalEventThemeName ?? '');
  //   int themeId = 0;
  //   print(
  //       "manageThemeCtr.personalEventThemeModel *** ${manageThemeCtr.personalEventThemeModel != null}");

  //   manageThemeCtr.personalEventThemeModel?.personalEventThemeMasterList?.forEach((element) {
  //     if (element.personalEventThemeName?.toLowerCase() ==
  //         widget.homeModel?.personalEventThemeName?.toLowerCase()) {
  //       setState(() {
  //         print("manageThemeCtr.personalEventThemeModel 1 *** ${element.personalEventThemeId}");
  //         themeId = element.personalEventThemeId ?? 0;
  //       });
  //     }
  //   });
  //   print("manageThemeCtr.personalEventThemeModel *** ${themeId}");
  //   await manageActivitiesCtr.fetchPersonalEventActivityMaster(
  //     ref: ref,
  //     context: context,
  //     personalEventThemeMasterId: themeId,
  //   );

  //   await manageActivitiesCtr.fetchPersonalEventActivityModel(
  //     ref: ref,
  //     context: context,
  //     personalEventThemeMasterId: themeId,
  //   );
  //   initialActivity(model: widget.homeModel);
  // });

  initialActivity({required HomePersonalEventDetailsModel? model}) {
    final manageActivitiesCtr = ref.read(updatePersonalEventActivitiesCtr);
    List<String> activity = [];
    List<String> activityIds = [];
    model?.personalEventActivityList?.forEach((element) {
      log("personal event activity id name and ids == personalEventActivityId : ${element.personalEventActivityId} & personalEventActivityMasterId : ${element.personalEventActivityMasterId} & activityName : ${element.activityName}");
      activity.add(element.activityName ?? '');
      activityIds.add(element.personalEventActivityId.toString());
      print('activity ID: ${element.personalEventActivityId.toString()}');
    });
    manageActivitiesCtr.setInitialActivities(activity, activityIds);
    // manageRitualsCtr.setInitialRitualIds(ritualIds);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).personalEventThemeExpanded) {
      ref.watch(updateEventExpandedCtr).setPersonalEventThemeUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setPersonalEventThemeExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: TAppColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventExpandedCtr).personalEventThemeExpanded
                    ? BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      )
              ]),
          child: ListTileTheme(
            contentPadding: EdgeInsets.zero,
            dense: true,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(updateEventExpandedCtr).personalEventThemeExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select ${widget.homeModel?.eventTypeCode} Theme",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 5.h,
                            )
                          ],
                        )
                      : ref.read(updatePersonalEventThemCtr).selectedThemes != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Theme",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(updatePersonalEventThemCtr).selectedThemes,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : ref.read(updatePersonalEventThemCtr).writeByHandThemes != ""
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Theme",
                                      style: getRegularStyle(
                                          fontSize: MyFonts.size14,
                                          color: TAppColors.selectionColor),
                                    ),
                                    Text(
                                      ref.read(updatePersonalEventThemCtr).writeByHandThemes,
                                      style: getBoldStyle(
                                        fontSize: MyFonts.size14,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  "Theme",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.text2Color),
                                ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).personalEventThemeExpanded)
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final manageThemesCtr = ref.watch(updatePersonalEventThemCtr);
                          return manageThemesCtr.isLoading
                              ? const StylesShimmer()
                              : manageThemesCtr.personalEventThemeModel == null ||
                                      manageThemesCtr.personalEventThemeModel
                                              ?.personalEventThemeMasterList ==
                                          null ||
                                      manageThemesCtr.personalEventThemeModel
                                              ?.personalEventThemeMasterList?.length ==
                                          0
                                  ? const Text('No Themes found!')
                                  : Column(
                                      children: [
                                        GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 4,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0.w),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: manageThemesCtr.personalEventThemeModel
                                              ?.personalEventThemeMasterList?.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            String interest =
                                                manageThemesCtr.personalEventTheme[index];
                                            PersonalEventThemeMasterList
                                                selectedPersonalEventTheme = manageThemesCtr
                                                    .personalEventThemeModel!
                                                    .personalEventThemeMasterList![index];

                                            return UpdatePersonalEventThemeTile(
                                              onTap: () {
                                                WidgetsBinding.instance
                                                    .addPostFrameCallback((timeStamp) async {
                                                  manageThemesCtr.addSelectedTheme(
                                                      selectedPersonalEventTheme
                                                              .personalEventThemeName ??
                                                          '');
                                                  manageThemesCtr.removeWriteByHandTheme();
                                                  manageThemesCtr.setPersonalEventThemeMasterId(
                                                      selectedPersonalEventTheme
                                                          .personalEventThemeId
                                                          ?.toString());
                                                  await ref
                                                      .watch(updatePersonalEventActivitiesCtr)
                                                      .setPersonalEventActivities([]);
                                                  await ref
                                                      .watch(updatePersonalEventActivitiesCtr)
                                                      .setPersonalEventActivitiesMasterIds([]);
                                                  _toggleExpansion();
                                                  await ref
                                                      .read(updatePersonalEventActivitiesCtr)
                                                      .fetchPersonalEventActivityMaster(
                                                          ref: ref,
                                                          context: context,
                                                          personalEventThemeMasterId:
                                                              selectedPersonalEventTheme
                                                                      .personalEventThemeId ??
                                                                  0
                                                          // weddingHeaderId: widget.homeModel.weddingStyleMasterId?.toString() ?? ''
                                                          );
                                                });
                                                // initialRituals(model: widget.homeModel);
                                              },
                                              interestName: selectedPersonalEventTheme
                                                      .personalEventThemeName ??
                                                  '',
                                            );
                                          },
                                        ),
                                        // Align(
                                        //   alignment: Alignment.topLeft,
                                        //   child: Wrap(
                                        //     alignment: WrapAlignment.start,
                                        //     children: List.generate(
                                        //       manageStylesCtr.weddingStyles.length,
                                        //           (index){
                                        //         String interest = manageStylesCtr.weddingStyles[index];
                                        //         return UpdateWeddingStyleTile(
                                        //           onTap: (){
                                        //             manageStylesCtr.addSelectedStyle(interest);
                                        //             manageStylesCtr.removeWriteByHandStyle();
                                        //            _toggleExpansion();
                                        //           },
                                        //           interestName: interest,
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        manageThemesCtr.writeByHandThemes == ""
                                            ? UpdateWriteThemeWidget(
                                                getCall: () {
                                                  _toggleExpansion();
                                                },
                                              )
                                            : GridView.builder(
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 2,
                                                        childAspectRatio: 4,
                                                        crossAxisSpacing: 0,
                                                        mainAxisSpacing: 0.w),
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemCount: 1,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return RemoveableInterestTile(
                                                    onTap: () {
                                                      manageThemesCtr.removeWriteByHandTheme();
                                                    },
                                                    interestName: manageThemesCtr.writeByHandThemes,
                                                  );
                                                },
                                              )
                                        // Align(
                                        //   alignment: Alignment.topLeft,
                                        //   child: RemoveableInterestTile(
                                        //     onTap: (){
                                        //       manageStylesCtr.removeWriteByHandStyle();
                                        //     },
                                        //     interestName: manageStylesCtr.writeByHandStyles,
                                        //   ),
                                        // ),
                                      ],
                                    );
                        },
                      )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
