import 'package:Happinest/theme/theme_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/create_event/controllers/create_event_expanded_controller.dart';
import 'package:Happinest/modules/events/create_event/controllers/wedding_controllers/wedding_activity_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/create_event_controller.dart';
import '../controllers/title_controller.dart';
import 'add_title_field.dart';

class WeddingTitleWidget extends ConsumerStatefulWidget {
  const WeddingTitleWidget({
    super.key,
  });

  @override
  ConsumerState<WeddingTitleWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<WeddingTitleWidget> {
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   title.text = 'Bride Weds Groom';
    //   ref.read(weddingTitleCtr).setTitleName(title.text);
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      title.text = ref.watch(eventTitleCtr).title;
      setState(() {});
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(createEventExpandedCtr).titleExpanded) {
      ref.watch(createEventExpandedCtr).setTitleUnExpanded();
      title.text = ref.watch(eventTitleCtr).title;
    } else {
      ref.watch(createEventExpandedCtr).setTitleExpanded();
      title.text = ref.watch(eventTitleCtr).title;
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
                ref.watch(createEventExpandedCtr).titleExpanded
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
                  title: ref.watch(createEventExpandedCtr).titleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ref.watch(createEventController).selectOccassionId == 1
                                  ? "Wedding Title"
                                  : "Event Title",
                              style: getEventFieldTitleStyle(
                                  color: customColors.text2Color, fontSize: 16),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(eventTitleCtr).title != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Title",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref
                                      .read(weddingActivityCtr)
                                      .concatenateList([ref.read(eventTitleCtr).title]),
                                  style: getBoldStyle(
                                      fontSize: MyFonts.size14, color: customColors.label),
                                ),
                              ],
                            )
                          : Text(
                              "Title",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: customColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(createEventExpandedCtr).titleExpanded)
                  Consumer(
                    builder: (BuildContext context, WidgetRef ref, Widget? child) {
                      final coupleCtr = ref.watch(eventTitleCtr);
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35.h,
                              child: AddTitleField(
                                controller: title,
                                onFieldSubmitted: (val) {
                                  coupleCtr.setTitleName(val);
                                  _toggleExpansion();
                                },
                                onChanged: (val) {
                                  coupleCtr.setTitleName(val);
                                },
                                hintText: ref.watch(createEventController).selectOccassionId == 1
                                    ? "Wedding Title"
                                    : "Event Title",
                                obscure: false,
                                maxLength: 30,
                              ),
                            ),
                            // SizedBox(
                            //   height: 10.h,
                            // ),
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
