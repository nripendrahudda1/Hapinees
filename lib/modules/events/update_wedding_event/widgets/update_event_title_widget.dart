import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../create_event/widgets/add_title_field.dart';
import '../controllers/wedding_event/update_wedding_event_expanded_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/common_update_event_title_controller.dart';

class UpdateEventTitleWidget extends ConsumerStatefulWidget {
  final String eventTitle;
  final bool isPersonalEvent;
  const UpdateEventTitleWidget( {
    super.key,
    required this.eventTitle,
    required this.isPersonalEvent,
  });

  @override
  ConsumerState<UpdateEventTitleWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<UpdateEventTitleWidget> {
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(updateEventExpandedCtr).setTitleUnExpanded();
      final wedTitleCtr = ref.watch(updateEventTitleCtr);
      title.text = widget.eventTitle;
      wedTitleCtr.setTitleName(title.text);
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventExpandedCtr).titleExpanded) {
      ref.watch(updateEventExpandedCtr).setTitleUnExpanded();
      title.text =  ref.watch(updateEventTitleCtr).title;
    } else {
      ref.watch(updateEventExpandedCtr).setTitleExpanded();
      title.text =  ref.watch(updateEventTitleCtr).title;
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
                ref.watch(updateEventExpandedCtr).titleExpanded
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
                  title: ref.watch(updateEventExpandedCtr).titleExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isPersonalEvent ? "Event Title" : "Wedding Title",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : ref.read(updateEventTitleCtr).title != ""
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Title",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.watch(updateEventTitleCtr).title,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Title",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14,
                                  color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref.watch(updateEventExpandedCtr).titleExpanded)
                  Consumer(
                    builder:
                        (BuildContext context, WidgetRef ref, Widget? child) {
                      final coupleCtr = ref.watch(updateEventTitleCtr);
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 10.h, right: 10.w, left: 10.w),
                        child: Column(
                          children: [
                            AddTitleField(
                              controller: title,
                              onFieldSubmitted: (val) {
                                coupleCtr.setTitleName(val);
                                _toggleExpansion();
                              },
                              maxLength: 30,
                              onChanged: (val) {
                                coupleCtr.setTitleName(val);
                              },
                              hintText: "",
                              obscure: false,
                            ),
                            SizedBox(
                              height: 10.h,
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
