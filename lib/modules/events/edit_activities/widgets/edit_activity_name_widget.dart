import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';

class EditActivityNameWidget extends ConsumerStatefulWidget {
  const EditActivityNameWidget({
    required this.eventName,
    required this.eventNameFunc,
    required this.eventId,
    required this.styleId,
    super.key,
  });

  final Function(String eventName ) eventNameFunc;
  final String eventName;
  final String eventId;
  final String styleId;
  @override
  ConsumerState<EditActivityNameWidget> createState() => _EditActivityNameWidgetState();
}

class _EditActivityNameWidgetState extends ConsumerState<EditActivityNameWidget> {
  // final activityNameCtr = TextEditingController();

  @override
  void initState() {
    // activityNameCtr.text = widget.eventName;
    // widget.eventNameFunc(activityNameCtr.text);
    // initiallize();
    super.initState();
  }
  //
  // initiallize(){
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
  //     /*await ref.read(personalOthersActivityCtr).fetchWeddingRitualsModel(
  //        ref: ref,
  //        context: context,
  //        weddingStyleMasterId: widget.styleId
  //    );*/
  //   });
  // }

  @override
  void dispose() {
    // activityNameCtr.dispose();
    super.dispose();
  }

  // void _toggleExpansion() {
  //   if(ref.watch(editActivityExpandedCtr).activityNameExpanded){
  //     ref.watch(editActivityExpandedCtr).setActivityNameUnExpanded();
  //   }else{
  //     ref.watch(editActivityExpandedCtr).setActivityNameExpanded();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
    decoration: BoxDecoration(
    color: TAppColors.disabledTxtField, //  TAppColors.containerColor
        borderRadius: BorderRadius.circular(10.r),
        border:
        Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
        boxShadow: [
          /*ref.watch(editActivityExpandedCtr).activityNameExpanded
                    ? BoxShadow(
                  color: TAppColors.text1Color.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(2.w, 4.h),
                )
                    : BoxShadow(
                  color: TAppColors.text1Color.withOpacity(0.25),
                  blurRadius: 2,
                  offset: const Offset(0, 0),
                )*/
          BoxShadow(
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
                  title: ref.watch(editActivityExpandedCtr).activityNameExpanded
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activity",
                        style: getRegularStyle(
                            fontSize: MyFonts.size16, color: TAppColors.text2Color),
                      ),
                      //SizedBox(height: 8.h,)
                    ],
                  )
                      : widget.eventName.isNotEmpty //activityNameCtr.text.isNotEmpty
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Activity",
                        style: getRegularStyle(
                            fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        widget.eventName,// activityNameCtr.text,
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
                      "Activity",
                      style: getRegularStyle(
                          fontSize: MyFonts.size14, color: TAppColors.text2Color),
                    ),
                  ),
                  // onTap: _toggleExpansion,
                ),
                /*if(ref.watch(editActivityExpandedCtr).activityNameExpanded)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: activityNameCtr,
                          onFieldSubmitted: (val) {
                            _toggleExpansion();
                          },
                          topPadding: 0.h,
                          onChanged: (val) {},
                          height: 32.h,
                          hintText: widget.eventName,
                          minLines: 1,
                          maxLines: 1,
                          obscure: false,
                        ),
                      ],
                    ),
                  ),*/
              ],
            ),
          ),
        ),
      ],
    );
  }
}