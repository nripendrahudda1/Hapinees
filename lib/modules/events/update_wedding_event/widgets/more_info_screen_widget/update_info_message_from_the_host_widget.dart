import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/update_wedding_event/controllers/common_update_event_more_info_expanded_controller.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/custom_textfield.dart';

class UpdateInfoMessageFromTheHostWidget extends ConsumerStatefulWidget {
  final String about;
  final Function(String about) aboutText;

  const UpdateInfoMessageFromTheHostWidget( {
    super.key,
    required this.about,
    required this.aboutText,
  });

  @override
  ConsumerState<UpdateInfoMessageFromTheHostWidget> createState() =>
      _UpdateInfoMessageFromTheHostWidgetState();
}

class _UpdateInfoMessageFromTheHostWidgetState
    extends ConsumerState<UpdateInfoMessageFromTheHostWidget>
{
  final aboutCtr = TextEditingController();

  @override
  void initState() {
    init();
    aboutCtr.text = widget.about ?? '';
    super.initState();
  }

  init(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(updateEventMoreInfoExpandedCtr).setMessageFromHostUnExpanded();
    });
    }

  @override
  void dispose() {
    aboutCtr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if (ref.watch(updateEventMoreInfoExpandedCtr).messageFromHostExpanded) {
      ref.watch(updateEventMoreInfoExpandedCtr).setMessageFromHostUnExpanded();
    } else {
      ref.watch(updateEventMoreInfoExpandedCtr).setMessageFromHostExpanded();
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
                ref.watch(updateEventMoreInfoExpandedCtr).messageFromHostExpanded
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
                  title: ref.watch(updateEventMoreInfoExpandedCtr).messageFromHostExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Message from the Host",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            //SizedBox(height: 8.h,)
                          ],
                        )
                      : aboutCtr.text.isNotEmpty
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
                                  aboutCtr.text,
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
                if(ref.watch(updateEventMoreInfoExpandedCtr).messageFromHostExpanded)
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 10.h, right: 10.w, left: 10.w),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: aboutCtr,
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
                        maxLength: 500,
                        maxLines: 20,
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
