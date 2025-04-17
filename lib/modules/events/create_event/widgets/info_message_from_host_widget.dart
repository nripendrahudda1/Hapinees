import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../controllers/event_more_info_controller/create_event_more_info_expanded_controller.dart';

class InfoMessageFromHostWidget extends ConsumerStatefulWidget {
  final Function(String about) aboutText;
  const InfoMessageFromHostWidget( {
    super.key,
    required this.aboutText,
  });

  @override
  ConsumerState<InfoMessageFromHostWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<InfoMessageFromHostWidget> {
    final messageCtr = TextEditingController();

  void _toggleExpansion() {
    if (ref.watch(createEventMoreInfoExpandedCtr).messageFromHostExpanded) {
      ref.watch(createEventMoreInfoExpandedCtr).setMessageFromHostUnExpanded();
    } else {
      ref.watch(createEventMoreInfoExpandedCtr).setMessageFromHostExpanded();
    }
  }

  @override
  void dispose() {
    messageCtr.dispose();
    super.dispose();
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
                ref.watch(createEventMoreInfoExpandedCtr).messageFromHostExpanded
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
                  title: ref
                          .watch(createEventMoreInfoExpandedCtr)
                          .messageFromHostExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Message from the Host",
                              style: getEventFieldTitleStyle(color: TAppColors.text2Color,fontSize: 16,fontWidth: FontWeightManager.regular),
                            ),
                            //SizedBox(height: 8.h,)
                          ],
                        )
                      : messageCtr.text.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Message from the Host",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  messageCtr.text,
                                  overflow: TextOverflow.ellipsis,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              constraints: BoxConstraints(maxWidth: 311.w),
                              child: Text(
                                "Message from the Host (Optional)",
                                style: getRegularStyle(
                                    fontSize: MyFonts.size14,
                                    color: TAppColors.text2Color),
                              ),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (ref
                    .watch(createEventMoreInfoExpandedCtr)
                    .messageFromHostExpanded)
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: messageCtr,
                          onFieldSubmitted: (val) {
                            _toggleExpansion();
                          },
                          topPadding: 20.h,
                          onChanged: (val) {
                            widget.aboutText(val);
                          },
                          height: 311,
                          hintText: "Write about the event",
                          minLines: 20,
                          maxLines: 20,
                          maxLength: 500,
                          obscure: false,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
