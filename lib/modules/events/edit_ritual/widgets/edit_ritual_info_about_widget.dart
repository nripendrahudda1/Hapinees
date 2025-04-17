import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../controllers/edit_ritual_expanded_controller.dart';

class EditRitualInfoAboutWidget extends ConsumerStatefulWidget {
  const EditRitualInfoAboutWidget({required this.aboutEvent,
    required this.eventName,
    required this.isPersonalEvent,
    required this.updateAbout,
    super.key,
  });
  final String eventName;
  final bool isPersonalEvent;
  final String aboutEvent;
  final Function(String about) updateAbout;
  @override
  ConsumerState<EditRitualInfoAboutWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<EditRitualInfoAboutWidget> {
  final aboutCtr = TextEditingController();

  @override
  void initState() {
    init();
    aboutCtr.text=widget.aboutEvent;
    widget.updateAbout(aboutCtr.text);
    super.initState();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(editActivityExpandedCtr).setActivityAboutUnExpanded();
      ref.watch(editRitualExpandedCtr).setRitualsAboutUnExpanded();
    });
    }

  @override
  void dispose() {
    aboutCtr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if(widget.isPersonalEvent) {
      if (ref
          .watch(editActivityExpandedCtr)
          .activityAboutExpanded) {
        ref.watch(editActivityExpandedCtr).setActivityAboutUnExpanded();
      } else {
        ref.watch(editActivityExpandedCtr).setActivityAboutExpanded();
      }
    } else {
      if (ref
          .watch(editRitualExpandedCtr)
          .ritualsAboutExpanded) {
        ref.watch(editRitualExpandedCtr).setRitualsAboutUnExpanded();
      } else {
        ref.watch(editRitualExpandedCtr).setRitualsAboutExpanded();
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
              border:
              Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).activityAboutExpanded : ref.watch(editRitualExpandedCtr).ritualsAboutExpanded)
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
                  title: (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).activityAboutExpanded : ref.watch(editRitualExpandedCtr).ritualsAboutExpanded)
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About The ${widget.eventName}",
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
                        "About The ${widget.eventName}",
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
                      "About The ${widget.eventName}",
                      style: getRegularStyle(
                          fontSize: MyFonts.size14,
                          color: TAppColors.text2Color),
                    ),
                  ),
                  onTap: _toggleExpansion,
                ),
                if(widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).activityAboutExpanded : ref.watch(editRitualExpandedCtr).ritualsAboutExpanded)
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
                          widget.updateAbout(aboutCtr.text);
                        },
                        height: 120,
                        hintText: "Write more about ${widget.eventName} activities...",
                        minLines: 20,
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

// class EditRitualInfoAboutWidget extends ConsumerStatefulWidget {
//   const EditRitualInfoAboutWidget({required this.aboutEvent,
//     required this.eventName,
//     super.key,
//   });
//   final String eventName;
//   final String aboutEvent;
//   @override
//   ConsumerState<EditRitualInfoAboutWidget> createState() =>
//       _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState
//     extends ConsumerState<EditRitualInfoAboutWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool isExpanded = false;
//   final aboutCtr = TextEditingController();
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
//     aboutCtr.text=widget.aboutEvent;
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     aboutCtr.dispose();
//     super.dispose();
//   }
//
//   void _toggleExpansion() {
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
//               border:
//                   Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
//               boxShadow: [
//                 isExpanded
//                     ? BoxShadow(
//                         color: TAppColors.text1Color.withOpacity(0.25),
//                         blurRadius: 4,
//                         offset: Offset(2.w, 4.h),
//                       )
//                     : BoxShadow(
//                         color: TAppColors.text1Color.withOpacity(0.25),
//                         blurRadius: 2,
//                         offset: const Offset(0, 0),
//                       )
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
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   title: isExpanded
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "About The ${widget.eventName}",
//                               style: getRegularStyle(
//                                   fontSize: MyFonts.size16,
//                                   color: TAppColors.text2Color),
//                             ),
//                             //SizedBox(height: 8.h,)
//                           ],
//                         )
//                       : aboutCtr.text.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "About The ${widget.eventName}",
//                                   style: getRegularStyle(
//                                       fontSize: MyFonts.size14,
//                                       color: TAppColors.selectionColor),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 Text(
//                                   aboutCtr.text,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: getBoldStyle(
//                                     fontSize: MyFonts.size14,
//                                   ),
//                                 ),
//                               ],
//                             )
//                           : Container(
//                               constraints: BoxConstraints(maxWidth: 311.w),
//                               child: Text(
//                                 "About The ${widget.eventName}",
//                                 style: getRegularStyle(
//                                     fontSize: MyFonts.size14,
//                                     color: TAppColors.text2Color),
//                               ),
//                             ),
//                   onTap: _toggleExpansion,
//                 ),
//                 SizeTransition(
//                     sizeFactor: _animation,
//                     axisAlignment: -1.0,
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                           bottom: 10.h, right: 10.w, left: 10.w),
//                       child: Column(
//                         children: [
//                           CustomTextField(
//                             controller: aboutCtr,
//                             onFieldSubmitted: (val) {
//                               _toggleExpansion();
//                             },
//                             topPadding: 20.h,
//                             onChanged: (val) {},
//                             height: 120,
//                             hintText: "Write more about ${widget.eventName} activities...",
//                             minLines: 20,
//                             maxLines: 20,
//                             obscure: false,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                         ],
//                       ),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
