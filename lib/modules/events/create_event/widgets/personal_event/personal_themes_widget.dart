import 'package:Happinest/modules/events/create_event/controllers/personal_event_controller/baby_shower_visibility_controller.dart';
import 'package:Happinest/modules/events/create_event/widgets/removeable_style_tile.dart';
import 'package:Happinest/modules/events/create_event/widgets/styles_shimmer.dart';
import 'package:Happinest/modules/events/create_event/widgets/personal_event/write_theme_widget.dart';
import 'package:Happinest/theme/theme_manager.dart';

import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../models/create_event_models/create_wedding_models/post_models/personal_event_theme_model.dart';
import '../../controllers/personal_event_controller/baby_shower_themes_controller.dart';
import '../../controllers/create_event_expanded_controller.dart';
import '../../controllers/personal_event_controller/personal_event_activity_controller.dart';
import '../../controllers/wedding_controllers/wedding_create_event_visibility_controller.dart';
import 'baby_shower_theme_tile.dart';

class PersonalThemesWidget extends ConsumerStatefulWidget {
  const PersonalThemesWidget({super.key});

  @override
  ConsumerState<PersonalThemesWidget> createState() => _PersonalThemesWidgetState();
}

class _PersonalThemesWidgetState extends ConsumerState<PersonalThemesWidget> {
  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).themeExpanded) {
      ref.watch(createEventExpandedCtr).setThemeUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setThemeExpanded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: customColors.containerColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(createEventExpandedCtr).ritualsExpanded
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
                  title: ref.watch(createEventExpandedCtr).themeExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Select ${ref.watch(weddingCreateEventVisibilityCtr).selectedTitle} Theme",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color, fontSize: 16),
                            ),
                            SizedBox(
                              height: 5.h,
                            )
                          ],
                        )
                      : ref.read(personalEventThemesCtr).selectedTheme != ""
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
                                  ref.read(personalEventThemesCtr).selectedTheme,
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : ref.read(personalEventThemesCtr).writeByHandThemes != ""
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
                                      ref.read(personalEventThemesCtr).writeByHandThemes,
                                      style: getBoldStyle(
                                          fontSize: MyFonts.size14, color: customColors.label),
                                    ),
                                  ],
                                )
                              : Text(
                                  // "Select  ${ref.watch(weddingCreateEventVisibilityCtr).selectedTitle} Theme",
                                  "Theme",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: customColors.text2Color),
                                ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).themeExpanded)
                  Padding(
                      padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref, Widget? child) {
                          final manageThemesCtr = ref.watch(personalEventThemesCtr);
                          return Column(
                            children: [
                              manageThemesCtr.isLoading
                                  ? const StylesShimmer()
                                  : manageThemesCtr.eventThemeModel == null ||
                                          manageThemesCtr
                                                  .eventThemeModel?.personalEventThemeMasterList ==
                                              null ||
                                          manageThemesCtr.eventThemeModel
                                                  ?.personalEventThemeMasterList?.length ==
                                              0
                                      ? const Text('No styles found!')
                                      : GridView.builder(
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 4,
                                              crossAxisSpacing: 0,
                                              mainAxisSpacing: 0.w),
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: manageThemesCtr.eventThemeModel
                                              ?.personalEventThemeMasterList?.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            String interest = manageThemesCtr.eventThemes[index];
                                            PersonalEventThemeMasterList selectedWeddingStyle =
                                                manageThemesCtr.eventThemeModel!
                                                    .personalEventThemeMasterList![index];

                                            return BabyShowerThemeTile(
                                              onTap: () async {
                                                manageThemesCtr.addSelectedTheme(interest);
                                                manageThemesCtr.removeWriteByHandTheme();
                                                manageThemesCtr.setThemeMasterId(
                                                    selectedWeddingStyle.personalEventThemeId
                                                        ?.toString());
                                                final eventActivityCtr =
                                                    await ref.watch(personalEventActivityCtr);
                                                eventActivityCtr.fetchPersonalEventActivityModel(
                                                    ref: ref,
                                                    context: context,
                                                    personalEventThemeMasterId:
                                                        selectedWeddingStyle.personalEventThemeId ??
                                                            0);
                                                _toggleExpansion();
                                                ref
                                                    .read(personalEventVisibilityCtr.notifier)
                                                    .setThemesSelected();
                                              },
                                              interestName: interest,
                                            );
                                          },
                                        ),
                              manageThemesCtr.writeByHandThemes == ""
                                  ? WriteThemesWidget(
                                      getCall: () {
                                        _toggleExpansion();
                                      },
                                    )
                                  : GridView.builder(
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 4,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0.w),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
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
