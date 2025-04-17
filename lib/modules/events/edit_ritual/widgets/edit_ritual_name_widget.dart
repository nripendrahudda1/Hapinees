import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Happinest/modules/events/edit_ritual/controllers/edit_ritual_expanded_controller.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';


class EditRitualNameWidget extends ConsumerStatefulWidget {
  const EditRitualNameWidget({
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
  ConsumerState<EditRitualNameWidget> createState() => _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualNameWidget> {
  // final ritualNameCtr = TextEditingController();
  //
  // @override
  // void initState() {
  //   ritualNameCtr.text = widget.eventName;
  //   widget.eventNameFunc(ritualNameCtr.text);
  //   initiallize();
  //   super.initState();
  // }
  //
  // initiallize(){
  //  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
  //    /*await ref.read(personalOthersActivityCtr).fetchWeddingRitualsModel(
  //        ref: ref,
  //        context: context,
  //        weddingStyleMasterId: widget.styleId
  //    );*/
  //  });
  // }
  //
  // @override
  // void dispose() {
  //   ritualNameCtr.dispose();
  //   super.dispose();
  // }
  //
  // void _toggleExpansion() {
  //   if(ref.watch(editRitualExpandedCtr).ritualNameExpanded){
  //     ref.watch(editRitualExpandedCtr).setRitualNameUnExpanded();
  //   }else{
  //     ref.watch(editRitualExpandedCtr).setRitualNameExpanded();
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
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                /*ref.watch(editRitualExpandedCtr).ritualNameExpanded
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
                  title: ref.watch(editRitualExpandedCtr).ritualNameExpanded
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
                      : widget.eventName.isNotEmpty
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
                        widget.eventName,// ritualNameCtr.text,
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
                /*if(ref.watch(editRitualExpandedCtr).ritualNameExpanded)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: ritualNameCtr,
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





//
// class EditRitualNameWidget extends ConsumerStatefulWidget {
//   const EditRitualNameWidget({
//     required this.eventName,
//     super.key,
//   });
//   final String eventName;
//   @override
//   ConsumerState<EditRitualNameWidget> createState() => _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualNameWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool isExpanded = false;
//   final ritualNameCtr = TextEditingController();
//
//   @override
//   void initState() {
//     ritualNameCtr.text = widget.eventName;
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
//     ritualNameCtr.dispose();
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
//               border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
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
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                   ),
//                   title: isExpanded
//                       ? Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Ritual",
//                               style: getRegularStyle(
//                                   fontSize: MyFonts.size16, color: TAppColors.text2Color),
//                             ),
//                             //SizedBox(height: 8.h,)
//                           ],
//                         )
//                       : ritualNameCtr.text.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Ritual",
//                                   style: getRegularStyle(
//                                       fontSize: MyFonts.size14, color: TAppColors.selectionColor),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 Text(
//                                   ritualNameCtr.text,
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
//                                 "Ritual",
//                                 style: getRegularStyle(
//                                     fontSize: MyFonts.size14, color: TAppColors.text2Color),
//                               ),
//                             ),
//                   onTap: _toggleExpansion,
//                 ),
//                 SizeTransition(
//                     sizeFactor: _animation,
//                     axisAlignment: -1.0,
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
//                       child: Column(
//                         children: [
//                           CustomTextField(
//                             controller: ritualNameCtr,
//                             onFieldSubmitted: (val) {
//                               _toggleExpansion();
//                             },
//                             topPadding: 0.h,
//                             onChanged: (val) {},
//                             height: 32.h,
//                             hintText: widget.eventName,
//                             minLines: 1,
//                             maxLines: 1,
//                             obscure: false,
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
//
//






///////New approach
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:Happinest/modules/events/edit_ritual/controllers/edit_ritual_expanded_controller.dart';
// import '../../../../common/common_imports/common_imports.dart';
// import '../../../../common/widgets/custom_textfield.dart';
//
// class EditRitualNameWidget extends ConsumerStatefulWidget {
//   const EditRitualNameWidget({required this.animationCtr, required this.animation,
//     required this.eventName,
//     super.key,
//   });
//   final String eventName;
//   final AnimationController animationCtr;
//   final Animation animation;
//
//   @override
//   ConsumerState<EditRitualNameWidget> createState() => _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualNameWidget> {
//   //late AnimationController _animationController;
//   //late Animation<double> _animation;
//   final ritualNameCtr = TextEditingController();
//
//   @override
//   void initState() {
//     ritualNameCtr.text = widget.eventName;
//     // _animationController = AnimationController(
//     //   vsync: this,
//     //   duration: const Duration(milliseconds: 300),
//     // );
//     // _animation = CurvedAnimation(
//     //   parent: _animationController,
//     //   curve: Curves.easeInOut,
//     // );
//     ref.watch(editRitualExpandedCtr).ritualNameExpanded;
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     //_animationController.dispose();
//     ritualNameCtr.dispose();
//     super.dispose();
//   }
//
//   void _toggleExpansion() {
//     if (ref.watch(editRitualExpandedCtr).ritualNameExpanded) {
//       widget.animationCtr.forward();
//       ref.watch(editRitualExpandedCtr).setRitualNameExpanded();
//     } else {
//       widget.animationCtr.reverse();
//       ref.watch(editRitualExpandedCtr).setRitualNameUnExpanded();
//     }
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
//                 ref.watch(editRitualExpandedCtr).ritualNameExpanded
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
//                   title: ref.watch(editRitualExpandedCtr).ritualNameExpanded
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Ritual",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size16, color: TAppColors.text2Color),
//                       ),
//                       //SizedBox(height: 8.h,)
//                     ],
//                   )
//                       : ritualNameCtr.text.isNotEmpty
//                       ? Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Ritual",
//                         style: getRegularStyle(
//                             fontSize: MyFonts.size14, color: TAppColors.selectionColor),
//                       ),
//                       SizedBox(
//                         height: 4.h,
//                       ),
//                       Text(
//                         ritualNameCtr.text,
//                         overflow: TextOverflow.ellipsis,
//                         style: getBoldStyle(
//                           fontSize: MyFonts.size14,
//                         ),
//                       ),
//                     ],
//                   )
//                       : Container(
//                     constraints: BoxConstraints(maxWidth: 311.w),
//                     child: Text(
//                       "Ritual",
//                       style: getRegularStyle(
//                           fontSize: MyFonts.size14, color: TAppColors.text2Color),
//                     ),
//                   ),
//                   onTap: _toggleExpansion,
//                 ),
//                 SizeTransition(
//                     sizeFactor: widget.animation as Animation<double>,
//                     axisAlignment: -1.0,
//                     child: Padding(
//                       padding: EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
//                       child: Column(
//                         children: [
//                           CustomTextField(
//                             controller: ritualNameCtr,
//                             onFieldSubmitted: (val) {
//                               _toggleExpansion();
//                             },
//                             topPadding: 0.h,
//                             onChanged: (val) {},
//                             height: 32.h,
//                             hintText: widget.eventName,
//                             minLines: 1,
//                             maxLines: 1,
//                             obscure: false,
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
