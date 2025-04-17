import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/custom_bottomsheet.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../controllers/wedding_controllers/wedding_couple_controller.dart';
import '../../controllers/create_event_expanded_controller.dart';
import '../../controllers/title_controller.dart';
import 'add_couple_textfield.dart';

class CoupleWidget extends ConsumerStatefulWidget {
  const CoupleWidget({
    super.key,
  });

  @override
  ConsumerState<CoupleWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<CoupleWidget> {
  final partner1Ctr = TextEditingController();
  final partner2Ctr = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    partner1Ctr.dispose();
    partner2Ctr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).coupleExpanded) {
      ref.watch(createEventExpandedCtr).setCoupleUnExpanded();
    } else {
      ref.watch(createEventExpandedCtr).setCoupleExpanded();
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
                ref.watch(createEventExpandedCtr).coupleExpanded
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
                  title: ref.watch(createEventExpandedCtr).coupleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Couple In Love",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(weddingCoupleCtr).couple1Name != "" &&
                              ref.read(weddingCoupleCtr).couple2Name != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Couple",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(weddingActivityCtr).concatenateList([
                                    ref.read(weddingCoupleCtr).couple1Name,
                                    ref.read(weddingCoupleCtr).couple2Name
                                  ]),
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Text(
                              "Couple",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).coupleExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final coupleCtr = ref.watch(weddingCoupleCtr);
                      final coupleTitleCtr = ref.watch(eventTitleCtr);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            AddCoupleTextField(
                              controller: partner1Ctr,
                              onFieldSubmitted: (val) {
                                coupleCtr.setCouple1Name(val);
                                if (coupleCtr.couple1Name.isNotEmpty &&
                                    coupleCtr.couple2Name.isNotEmpty) {
                                  coupleTitleCtr.setTitleName(
                                      "${coupleCtr.couple1Name.capitalize()} Weds ${coupleCtr.couple2Name.capitalize()}");
                                }
                              },
                              onChanged: (val) {
                                coupleCtr.setCouple1Name(val);
                                if (coupleCtr.couple1Name.isNotEmpty &&
                                    coupleCtr.couple2Name.isNotEmpty) {
                                  coupleTitleCtr.setTitleName(
                                      "${coupleCtr.couple1Name.capitalize()} Weds ${coupleCtr.couple2Name.capitalize()}");
                                }
                              },
                              hintText: "Partner 1",
                              maxLength: 30,
                              obscure: false,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            AddCoupleTextField(
                              controller: partner2Ctr,
                              onFieldSubmitted: (val) {
                                coupleCtr.setCouple2Name(val);
                                if (coupleCtr.couple1Name.isNotEmpty &&
                                    coupleCtr.couple2Name.isNotEmpty) {
                                  coupleTitleCtr.setTitleName(
                                      "${coupleCtr.couple1Name.capitalize()} Weds ${coupleCtr.couple2Name.capitalize()}");
                                }
                                _toggleExpansion();
                              },
                              onChanged: (val) {
                                coupleCtr.setCouple2Name(val);
                                if (coupleCtr.couple1Name.isNotEmpty &&
                                    coupleCtr.couple2Name.isNotEmpty) {
                                  coupleTitleCtr.setTitleName(
                                      "${coupleCtr.couple1Name.capitalize()} Weds ${coupleCtr.couple2Name.capitalize()}");
                                }
                              },
                              hintText: "Partner 2",
                              maxLength: 30,
                              obscure: false,
                            ),
                          ],
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
