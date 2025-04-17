import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/common/widgets/custom_bottomsheet.dart';
import 'package:Happinest/modules/events/create_event/widgets/wedding_event/add_couple_textfield.dart';
import '../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../controllers/wedding_event/update_wedding_rituals_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/wedding_event/update_wedding_couple_controller.dart';
import '../controllers/common_update_event_title_controller.dart';

class UpdateCoupleWidget extends ConsumerStatefulWidget {
  final couple1;
  final couple2;
  const UpdateCoupleWidget({
    super.key,
    required this.couple1,
    required this.couple2,
  });

  @override
  ConsumerState<UpdateCoupleWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<UpdateCoupleWidget> {
  final partner1Ctr = TextEditingController();
  final partner2Ctr = TextEditingController();


  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(updateEventExpandedCtr).setCoupleUnExpanded();
      final coupleCtr = ref.watch(updateWeddingCoupleCtr);
      partner1Ctr.text = widget.couple1;
      partner2Ctr.text = widget.couple2;
      coupleCtr.setCouple1Name(partner1Ctr.text);
      coupleCtr.setCouple2Name(partner2Ctr.text);
    });
  }


  @override
  void dispose() {
    partner1Ctr.dispose();
    partner2Ctr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).coupleExpanded) {
      ref.watch(updateEventExpandedCtr).setCoupleUnExpanded();
    } else {
      ref.watch(updateEventExpandedCtr).setCoupleExpanded();
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
              border:
                  Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                ref.watch(updateEventExpandedCtr).coupleExpanded
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
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  title: ref.watch(updateEventExpandedCtr).coupleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Couple In Love",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(updateWeddingCoupleCtr).couple1Name != "" &&
                              ref.read(updateWeddingCoupleCtr).couple2Name != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Couple",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref
                                      .read(updateWeddingRitualsCtr)
                                      .concatenateList([
                                    ref
                                        .read(updateWeddingCoupleCtr)
                                        .couple1Name,
                                    ref.read(updateWeddingCoupleCtr).couple2Name
                                  ]),
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Couple",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).coupleExpanded)
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      final coupleCtr = ref.watch(updateWeddingCoupleCtr);
                      final coupleTitleCtr = ref.watch(updateEventTitleCtr);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 10.h, right: 10.w, left: 10.w),
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
