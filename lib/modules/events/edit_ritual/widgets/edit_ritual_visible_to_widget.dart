import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/edit_ritual/controllers/edit_ritual_visibility_controller.dart';
import 'package:Happinest/modules/events/edit_ritual/widgets/edit_ritual_select_visibility.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../controllers/edit_ritual_expanded_controller.dart';

class EditRitualsVisibleToWidget extends ConsumerStatefulWidget {
  final int visibilityIndex;
  final bool isPersonalEvent;
  final Function(int visibility) visibilityFunc;
  const EditRitualsVisibleToWidget( {
    super.key,
    required this.visibilityIndex,
    required this.isPersonalEvent,
    required this.visibilityFunc,
  });

  @override
  ConsumerState<EditRitualsVisibleToWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualsVisibleToWidget> {

  bool isExpanded = false;
  bool firstTime = true;
  final title = TextEditingController();

  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(editActivityExpandedCtr).setGuestVisibilityUnExpanded();
      ref.watch(editRitualExpandedCtr).setGuestVisibilityUnExpanded();

      final visiblityCtr = ref.watch(editRitualVisibilityCtr);
      if(widget.visibilityIndex == 1){
        visiblityCtr.setPublic();
        widget.visibilityFunc(1);
      }
      if(widget.visibilityIndex == 2){
        visiblityCtr.setPrivate();
        widget.visibilityFunc(2);
      }
      if(widget.visibilityIndex == 3){
        visiblityCtr.setGuest();
        widget.visibilityFunc(3);
      }
    });
  }

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    firstTime = true;
    if(widget.isPersonalEvent) {
      if (ref
          .watch(editActivityExpandedCtr)
          .guestVisibilityExpanded) {
        ref.watch(editActivityExpandedCtr).setGuestVisibilityUnExpanded();
      } else {
        ref.watch(editActivityExpandedCtr).setGuestVisibilityExpanded();
      }
    } else {
      if (ref
          .watch(editRitualExpandedCtr)
          .guestVisibilityExpanded) {
        ref.watch(editRitualExpandedCtr).setGuestVisibilityUnExpanded();
      } else {
        ref.watch(editRitualExpandedCtr).setGuestVisibilityExpanded();
      }
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
                (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).guestVisibilityExpanded : ref.watch(editRitualExpandedCtr).guestVisibilityExpanded)
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
                  title: (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).guestVisibilityExpanded : ref.watch(editRitualExpandedCtr).guestVisibilityExpanded)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Visible to",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16, color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : firstTime == true
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Visibility",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14, color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  ref.read(editRitualVisibilityCtr).private
                                      ? TPlaceholderStrings.visibilityyprivate
                                      : ref.read(editRitualVisibilityCtr).public
                                          ? TPlaceholderStrings.visibilitypublic
                                          : TPlaceholderStrings.visibilityguests,
                                  style: getBoldStyle(
                                    fontSize: MyFonts.size14,
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              "Visibility",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size14, color: TAppColors.text2Color),
                            ),
                  onTap: _toggleExpansion,
                ),
                if(widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).guestVisibilityExpanded : ref.watch(editRitualExpandedCtr).guestVisibilityExpanded)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 0.h),
                      child: EditRitualSelectVisibility(
                        visibilityFunc: widget.visibilityFunc,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//
// class EditRitualsVisibleToWidget extends ConsumerStatefulWidget {
//   const EditRitualsVisibleToWidget({
//     super.key,
//   });
//
//   @override
//   ConsumerState<EditRitualsVisibleToWidget> createState() => _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualsVisibleToWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool isExpanded = false;
//   bool firstTime = true;
//
//   final title = TextEditingController();
//
//   @override
//   void initState() {
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     title.dispose();
//     super.dispose();
//   }
//
//   void _toggleExpansion() {
//     firstTime = true;
//     setState(() {
//       isExpanded = !isExpanded;
//       if (isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//               color: TAppColors.containerColor,
//               borderRadius: BorderRadius.circular(10.r),
//               border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
//               boxShadow: [
//                 isExpanded
//                     ? BoxShadow(
//                   color: TAppColors.text1Color.withOpacity(0.25),
//                   blurRadius: 4,
//                   offset: Offset(2.w, 4.h),
//                 )
//                     : BoxShadow(
//                   color: TAppColors.text1Color.withOpacity(0.25),
//                   blurRadius: 2,
//                   offset: const Offset(0, 0),
//                 )
//               ]),
//           child: ListTileTheme(
//             contentPadding: EdgeInsets.zero,
//             dense: true,
//             horizontalTitleGap: 0,
//             minLeadingWidth: 0,
//             minVerticalPadding: 0,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: <Widget>[
//                 ListTile(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   title: isExpanded
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Visible to",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size16, color: TAppColors.text2Color),
//                       ),
//                       SizedBox(
//                         height: 8.h,
//                       )
//                     ],
//                   )
//                       : firstTime == true
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Visibility",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size14, color: TAppColors.selectionColor),
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         ref.read(editRitualVisibilityCtr).private
//                             ? TPlaceholderStrings.visibilityyprivate
//                             : ref.read(editRitualVisibilityCtr).public
//                             ? TPlaceholderStrings.visibilitypublic
//                             : TPlaceholderStrings.visibilityguests,
//                         style: getBoldStyle(
//                           fontSize: MyFonts.size14,
//                         ),
//                       ),
//                     ],
//                   )
//                       : Text(
//                     "Visibility",
//                     style: getRegularStyle(
//                         fontSize: MyFonts.size14, color: TAppColors.text2Color),
//                   ),
//                   onTap: _toggleExpansion,
//                 ),
//                 SizeTransition(
//                     sizeFactor: _animation,
//                     axisAlignment: -1.0,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 0.h),
//                           child: const EditRitualSelectVisibility(),
//                         ),
//                         SizedBox(
//                           height: 15.h,
//                         ),
//                       ],
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
