import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_style_controller.dart';
import '../../../../models/create_event_models/create_wedding_models/event_types_model.dart';
import '../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import '../controllers/personal_event_controller/baby_shower_themes_controller.dart';
import '../controllers/create_event_controller.dart';
import '../controllers/create_event_expanded_controller.dart';
import 'event_shimmer.dart';
import 'occassion_container.dart';
import '../../../../common/common_imports/common_imports.dart';

class ChoseYourOccassionWidget extends ConsumerStatefulWidget {
  const ChoseYourOccassionWidget({
    super.key,
  });

  @override
  ConsumerState<ChoseYourOccassionWidget> createState() => _ChoseYourOccassionWidgetState();
}

class _ChoseYourOccassionWidgetState extends ConsumerState<ChoseYourOccassionWidget> {
  String selected = '';
  String iconPath = TImageName.weddingIcon;

  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).occasionExpanded) {
      ref.watch(createEventExpandedCtr).setOccasionUnExpanded();
    } else {
      selected = '';
      ref.watch(weddingCreateEventVisibilityCtr).resetSelection();
      ref.watch(createEventController).resetAllData();
      ref.watch(createEventExpandedCtr).setOccasionExpanded();
    }
  }

  void _toggleWithParams({
    required String text,
    required String iconPath,
  }) async {
    setState(() {
      selected = text;
      this.iconPath = iconPath;
      _toggleExpansion();
      ref.read(weddingCreateEventVisibilityCtr.notifier).setOccasionSelected(selected);
    });
    // if (ref.watch(createEventController).selectOccassionId == 1) {
    //   await ref.read(weddingStylesCtr).fetchWeddingStylesModel(ref: ref, context: context);
    //   ref.watch(createEventExpandedCtr).setWeddingStyleExpanded();
    // } else {
    ref.watch(createEventExpandedCtr).setThemeExpanded();
    if (ref.watch(createEventController).hasThemes) {
     await ref.watch(personalEventThemesCtr).fetchPersonalEventThemesModel(
            token: PreferenceUtils.getString(PreferenceKey.accessToken),
            eventTypeMasterId: ref.watch(createEventController).selectOccassionId,
          );
    }

    // }
    // if (ref.watch(createEventController).selectOccassionId == 2) {
    //   ref.watch(createEventExpandedCtr).setThemeExpanded();
    // } else if (ref.watch(createEventController).selectOccassionId == 3) {
    //   // Add New
    //   ref.watch(createEventExpandedCtr).setThemeExpanded();
    // } else if (ref.watch(createEventController).selectOccassionId == 4) {
    //   ref.watch(createEventExpandedCtr).setThemeExpanded();
    // } else if (ref.watch(createEventController).selectOccassionId == 11) {
    //   ref.watch(createEventExpandedCtr).setTitleExpanded();
    // }
  }

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(createEventController).fetchEventTypesModel(ref: ref, context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: ref.watch(createEventExpandedCtr).occasionExpanded
                  ? customColors.containerColor
                  : customColors.venueCardColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(createEventExpandedCtr).occasionExpanded
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
                  //contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(createEventExpandedCtr).occasionExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                              child: Text(
                                "Choose Your Occasion",
                                style: getEventFieldTitleStyle(
                                    color: customColors.text3Color, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 7.h,
                            )
                          ],
                        )
                      : SizedBox(
                          height: 50.h,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Image.network(
                                iconPath,
                                width: 30.w,
                                height: 30.h,
                                color: TAppColors.selectionColor,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                selected,
                                style: getBoldStyle(
                                    fontSize: MyFonts.size14, color: customColors.label),
                              ),
                            ],
                          ),
                        ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).occasionExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final weddingCtr = ref.watch(createEventController);
                      return weddingCtr.isLoading
                          ? const EventShimmer()
                          : weddingCtr.evenTypesModel == null ||
                                  weddingCtr.evenTypesModel?.eventTypeMasterList == null ||
                                  // ignore: prefer_is_empty
                                  weddingCtr.evenTypesModel?.eventTypeMasterList?.length == 0
                              ? const Text('No Events Found!')
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemCount:
                                        (weddingCtr.evenTypesModel!.eventTypeMasterList!.length / 3)
                                            .ceil(),
                                    itemBuilder: (BuildContext context, int index) {
                                      int startIndex = index * 3;
                                      int endIndex = (index + 1) * 3;
                                      if (endIndex >
                                          weddingCtr.evenTypesModel!.eventTypeMasterList!.length) {
                                        endIndex =
                                            weddingCtr.evenTypesModel!.eventTypeMasterList!.length;
                                      }
                                      List<EventTypeMasterList> currentRow = weddingCtr
                                          .evenTypesModel!.eventTypeMasterList!
                                          .sublist(startIndex, endIndex);

                                      return Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: currentRow.map((event) {
                                            return OccassionContainer(
                                              onTap: () {
                                                if (event.eventTypeMasterId == 1) {
                                                  ref.watch(createEventController).setOccassionID(
                                                      event.eventTypeMasterId ?? 0,
                                                      event.hasThemes ?? false,
                                                      event.eventTypeName ?? "Wedding");
                                                  _toggleWithParams(
                                                    text: event.eventTypeName ?? "",
                                                    iconPath: event.eventIconBlue ?? "",
                                                  );
                                                }
                                                /* weddingCtr.showReddemDialog(context, onTap: () {
                                      weddingCtr.redeemEventCode(
                                          redeemCode: weddingCtr.textFieldController.text,
                                          context: context,
                                          eventTypeMasterId: event.eventTypeMasterId ?? 0,
                                          userEmail: PreferenceUtils.getString(PreferenceKey.email)
                                      );

                                    },);*/
                                                // } else if (event.eventTypeMasterId == 2) {
                                                //   final eventThemeCtr =
                                                //       ref.watch(personalEventThemesCtr);
                                                //   eventThemeCtr.fetchPersonalEventThemesModel(
                                                //     token: PreferenceUtils.getString(
                                                //         PreferenceKey.accessToken),
                                                //     eventTypeMasterId: event.eventTypeMasterId ?? 0,
                                                //   );
                                                //   ref.watch(createEventController).setOccassionID(
                                                //       event.eventTypeMasterId ?? 0, true);
                                                //   _toggleWithParams(
                                                //     text: event.eventTypeName ?? "",
                                                //     iconPath: event.icon ?? '',
                                                //   );
                                                // } else if (event.eventTypeMasterId == 10) {
                                                //   ref.watch(createEventController).setOccassionID(
                                                //       event.eventTypeMasterId ?? 0,
                                                //       event.hasThemes ?? false);
                                                //   _toggleWithParams(
                                                //     text: event.eventTypeName ?? "",
                                                //     iconPath: event.icon ?? '',
                                                //   );
                                                // } else if (event.eventTypeMasterId == 3) {
                                                //   ref.watch(createEventController).setOccassionID(
                                                //       event.eventTypeMasterId ?? 0,
                                                //       event.hasThemes ?? false);
                                                //   _toggleWithParams(
                                                //     text: event.eventTypeName ?? "",
                                                //     iconPath: event.icon ?? '',
                                                //   );
                                                // } else if (event.eventTypeMasterId == 4) {
                                                //   ref.watch(createEventController).setOccassionID(
                                                //       event.eventTypeMasterId ?? 0,
                                                //       event.hasThemes ?? false);
                                                //   _toggleWithParams(
                                                //     text: event.eventTypeName ?? "",
                                                //     iconPath: event.icon ?? '',
                                                //   );
                                                // } else if (event.eventTypeMasterId == 11) {
                                                //   ref.watch(createEventController).setOccassionID(
                                                //       event.eventTypeMasterId ?? 0,
                                                //       event.hasThemes ?? false);
                                                //   _toggleWithParams(
                                                //     text: event.eventTypeName ?? "",
                                                //     iconPath: event.icon ?? '',
                                                //   );
                                                // }
                                                else {
                                                  ref.watch(createEventController).setOccassionID(
                                                      event.eventTypeMasterId ?? 0,
                                                      event.hasThemes ?? false,
                                                      event.eventModuleName ?? "Wedding");
                                                  _toggleWithParams(
                                                    text: event.eventTypeName ?? "",
                                                    iconPath: event.eventIconBlue ?? '',
                                                  );
                                                }
                                              },
                                              name: event.eventTypeName ?? "",
                                              iconPath: event.eventIconBlue ?? "",
                                              isSelected: ref
                                                      .watch(createEventController)
                                                      .selectOccassionId ==
                                                  event.eventTypeMasterId,
                                            );
                                          }).toList());
                                    },
                                  ),
                                );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
