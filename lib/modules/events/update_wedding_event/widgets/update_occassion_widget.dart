import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cached_retangular_network_image.dart';
import '../../create_event/widgets/occassion_container.dart';
import '../../../../common/common_imports/common_imports.dart';

class UpdateYourOccassionWidget extends ConsumerStatefulWidget {
  final bool isPersonalEvent;
  String? selectedName, iconPath;
  UpdateYourOccassionWidget({
    super.key,
    required this.isPersonalEvent,
    this.iconPath,
    this.selectedName,
  });

  @override
  ConsumerState<UpdateYourOccassionWidget> createState() => _ChoseYourOccassionWidgetState();
}

class _ChoseYourOccassionWidgetState extends ConsumerState<UpdateYourOccassionWidget> {
  String selected = 'Wedding';
  String iconPath = TImageName.weddingIcon;

  // void _toggleExpansion() {
  //   if (ref.watch(updateEventExpandedCtr).occasionExpanded) {
  //     ref.watch(updateEventExpandedCtr).setOccasionUnExpanded();
  //   } else {
  //     ref.watch(updateEventExpandedCtr).setOccasionExpanded();
  //   }
  // }
  //
  // void _toggleWithParams({
  //   required String text,
  //   required String iconPath,
  // }) {
  //   setState(() {
  //     selected = text;
  //     this.iconPath = iconPath;
  //     _toggleExpansion();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: TAppColors.disabledTxtField,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: TAppColors.lightBorderColor, width: 0.5.w),
              boxShadow: [
                /*ref.watch(updateEventExpandedCtr).occasionExpanded
                    ? BoxShadow(
                        color: TAppColors.text1Color.withOpacity(0.25),
                        blurRadius: 4,
                        offset: Offset(2.w, 4.h),
                      )
                    : */
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
                  title: SizedBox(
                    width: 200.w,
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.isPersonalEvent ? (widget.iconPath ?? '') : iconPath,
                          width: 30.w,
                          height: 30.h,
                          color: TAppColors.selectionColor,
                          errorWidget: (context, url, error) => Image.asset(
                            iconPath,
                            width: 30.w,
                            height: 30.h,
                            color: TAppColors.selectionColor,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          widget.isPersonalEvent ? (widget.selectedName ?? '') : selected,
                          style: getBoldStyle(
                              fontSize: MyFonts.size14, color: const Color(0xff959595)),
                        ),
                      ],
                    ),
                  ),
                  // onTap: _toggleExpansion,
                ),
                // if (ref.watch(updateEventExpandedCtr).occasionExpanded)
                //   Padding(
                //     padding:
                //         EdgeInsets.only(bottom: 10.h, right: 10.w, left: 10.w),
                //     child: Column(
                //       children: [
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Wedding",
                //                 iconPath: TImageName.weddingIcon,
                //               ),
                //               name: "Wedding",
                //               iconPath: TImageName.weddingIcon,
                //               isSelected: selected == "Wedding",
                //             ),
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Concert",
                //                 iconPath: TImageName.concertIcon,
                //               ),
                //               name: "Concert",
                //               iconPath: TImageName.concertIcon,
                //               isSelected: selected == "Concert",
                //             ),
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Sports",
                //                 iconPath: TImageName.supportIcon,
                //               ),
                //               name: "Sports",
                //               iconPath: TImageName.supportIcon,
                //               isSelected: selected == "Sports",
                //             ),
                //           ],
                //         ),
                //         SizedBox(
                //           height: 10.h,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Startup",
                //                 iconPath: TImageName.startupIcon,
                //               ),
                //               name: "Startup",
                //               iconPath: TImageName.startupIcon,
                //               isSelected: selected == "Startup",
                //             ),
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Tech",
                //                 iconPath: TImageName.techIcon,
                //               ),
                //               name: "Tech",
                //               iconPath: TImageName.techIcon,
                //               isSelected: selected == "Tech",
                //             ),
                //             OccassionContainer(
                //               onTap: () => _toggleWithParams(
                //                 text: "Premier",
                //                 iconPath: TImageName.premierIcon,
                //               ),
                //               name: "Premier",
                //               iconPath: TImageName.premierIcon,
                //               isSelected: selected == "Premier",
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ),
        // Container(
        //   height: 52.h,
        //   decoration: BoxDecoration(
        //       color: TAppColors.lightGrayColor.withOpacity(0.5),
        //       borderRadius: BorderRadius.circular(10.r),
        //   ),
        // )
      ],
    );
  }
}
