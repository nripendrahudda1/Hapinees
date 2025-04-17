import 'package:Happinest/modules/events/edit_activities/controllers/edit_activity_expanded_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../common/common_imports/common_imports.dart';
import '../../../../common/widgets/custom_textfield.dart';
import '../controllers/edit_ritual_expanded_controller.dart';

class EditRitualInfoVenueWidget extends ConsumerStatefulWidget {
  const EditRitualInfoVenueWidget({
    required this.venue,
    required this.isPersonalEvent,
    required this.venueFunc,
    super.key,
  });

  final String venue;
  final bool isPersonalEvent;
  final Function(String venue) venueFunc;

  @override
  ConsumerState<EditRitualInfoVenueWidget> createState() =>
      _ChoseWeddingStyleWidgetState();
}

class _ChoseWeddingStyleWidgetState
    extends ConsumerState<EditRitualInfoVenueWidget> {
  final venueCtr = TextEditingController();

  @override
  void initState() {
    venueCtr.text = widget.venue;
    widget.venueFunc(venueCtr.text );
    super.initState();
  }

  init() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.watch(editActivityExpandedCtr).setVenueUnExpanded();
      ref.watch(editRitualExpandedCtr).setVenueUnExpanded();
    });
    }

  @override
  void dispose() {
    venueCtr.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    if(widget.isPersonalEvent) {
      if (ref
          .watch(editActivityExpandedCtr)
          .venueExpanded) {
        ref.watch(editActivityExpandedCtr).setVenueUnExpanded();
      } else {
        ref.watch(editActivityExpandedCtr).setVenueExpanded();
      }
    } else {
      if (ref
          .watch(editRitualExpandedCtr)
          .venueExpanded) {
        ref.watch(editRitualExpandedCtr).setVenueUnExpanded();
      } else {
        ref.watch(editRitualExpandedCtr).setVenueExpanded();
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
                (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).venueExpanded : ref.watch(editRitualExpandedCtr).venueExpanded)
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
                  title: (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).venueExpanded : ref.watch(editRitualExpandedCtr).venueExpanded)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Venue",
                              style: getRegularStyle(
                                  fontSize: MyFonts.size16,
                                  color: TAppColors.text2Color),
                            ),
                            SizedBox(
                              height: 8.h,
                            )
                          ],
                        )
                      : venueCtr.text.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Venue",
                                  style: getRegularStyle(
                                      fontSize: MyFonts.size14,
                                      color: TAppColors.selectionColor),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  venueCtr.text,
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
                                "Venue",
                                style: getRegularStyle(
                                    fontSize: MyFonts.size14,
                                    color: TAppColors.text2Color),
                              ),
                            ),
                  onTap: _toggleExpansion,
                ),
                if (widget.isPersonalEvent ? ref.watch(editActivityExpandedCtr).venueExpanded : ref.watch(editRitualExpandedCtr).venueExpanded)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        CustomTextField(
                          height: 32.h,
                          controller: venueCtr,
                          onFieldSubmitted: (val) {
                            _toggleExpansion();
                          },
                          tailingIcon: IconButton(
                              onPressed: () {
                                _toggleExpansion();
                              },
                              icon: Image.asset(
                                TImageName.tickIcon,
                                width: 24.w,
                                height: 24.h,
                              )),
                          onChanged: (val) {
                            widget.venueFunc(venueCtr.text);
                          },
                          hintText: TPlaceholderStrings.addresHint,
                          obscure: false,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                            height: 303.h,
                            width: 309.w,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset(
                                  TImageName.mapImage,
                                  fit: BoxFit.cover,
                                ))),
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

// class EditRitualInfoVenueWidget extends ConsumerStatefulWidget {
//   const EditRitualInfoVenueWidget({
//     required this.venue,
//     super.key,
//   });
//
//   final String venue;
//
//   @override
//   ConsumerState<EditRitualInfoVenueWidget> createState() => _ChoseWeddingStyleWidgetState();
// }
//
// class _ChoseWeddingStyleWidgetState extends ConsumerState<EditRitualInfoVenueWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   bool isExpanded = false;
//   final venueCtr = TextEditingController();
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
//     venueCtr.text = widget.venue;
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     venueCtr.dispose();
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
//                               "Venue",
//                               style: getRegularStyle(
//                                   fontSize: MyFonts.size16, color: TAppColors.text2Color),
//                             ),
//                             SizedBox(
//                               height: 8.h,
//                             )
//                           ],
//                         )
//                       : venueCtr.text.isNotEmpty
//                           ? Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Venue",
//                                   style: getRegularStyle(
//                                       fontSize: MyFonts.size14, color: TAppColors.selectionColor),
//                                 ),
//                                 SizedBox(
//                                   height: 4.h,
//                                 ),
//                                 Text(
//                                   venueCtr.text,
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
//                                 "Venue",
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
//                       padding: EdgeInsets.symmetric(horizontal: 10.w),
//                       child: Column(
//                         children: [
//                           CustomTextField(
//                             height: 32.h,
//                             controller: venueCtr,
//                             onFieldSubmitted: (val) {
//                               _toggleExpansion();
//                             },
//                             tailingIcon: IconButton(
//                                 onPressed: () {
//                                   _toggleExpansion();
//                                 },
//                                 icon: Image.asset(
//                                   TImageName.tickIcon,
//                                   width: 24.w,
//                                   height: 24.h,
//                                 )),
//                             onChanged: (val) {},
//                             hintText: TPlaceholderStrings.addresHint,
//                             obscure: false,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           SizedBox(
//                               height: 303.h,
//                               width: 309.w,
//                               child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.r),
//                                   child: Image.asset(
//                                     TImageName.mapImage,
//                                     fit: BoxFit.cover,
//                                   ))),
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
