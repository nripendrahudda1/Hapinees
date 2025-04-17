import 'dart:io';
import 'dart:math' as math;

import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/modules/events/e-card/controllers/personal_event_ecard_controller.dart';
import 'package:Happinest/modules/events/e-card/views/personal_event/personal_event_ecard_image_picker_screen.dart';
import 'package:Happinest/modules/events/event_homepage/personal_event/controller/personal_event_home_controller.dart';
import 'package:flutter/services.dart';

import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/common_imports/apis_commons.dart';
import '../../../../../common/common_imports/common_imports.dart';
import '../../../../../common/widgets/cached_retangular_network_image.dart';
import '../../../../../common/widgets/iconButton.dart';
import '../../../../../utility/constants/constants.dart';
import '../../widgets/custom_ecard_row.dart';
import '../wedding_event/wedding_ecard_screen.dart';

class PersonalEventECardScreen extends ConsumerStatefulWidget {
  bool isSingleImage;
  PersonalEventECardScreen({
    super.key,
    required this.isSingleImage,
  });

  @override
  ConsumerState<PersonalEventECardScreen> createState() => _PersonalEventECardScreenState();
}

class _PersonalEventECardScreenState extends ConsumerState<PersonalEventECardScreen> {
  final globalKey = GlobalKey();
  TextEditingController noteController = TextEditingController();
  bool isEdit = false;
  int count = 1;
  String deeplink = ApiUrl.baseURL;
  String? currImage;
  double postRatio = 14 / 9;
  FocusNode focusNode = FocusNode();
  ScrollController scr = ScrollController();
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    currImage = ref.read(personalEventECardCtr).currentImage;
  }

  Future<String> getRandomItems(List<String> list) async {
    math.Random random = math.Random();
    int randomIndex = random.nextInt(list.length);
    return list[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          isEdit
              ? Container(
                  color: TAppColors.white,
                  height: Platform.isAndroid
                      ? null
                      : topSfarea > 20.h
                          ? topSfarea + 40.h
                          : 40.h,
                  child: CustomSafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(
                          top: Platform.isAndroid
                              ? 0
                              : topSfarea > 20
                                  ? topSfarea - 5
                                  : 5,
                          bottom: 5.h),
                      child: SizedBox(
                        height: 30.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconButton(
                              bgColor: TAppColors.text4Color,
                              iconPath: TImageName.back,
                              radius: 24.h,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Preview Post',
                                  style: getSemiBoldStyle(
                                    color: TAppColors.text1Color,
                                    fontSize: MyFonts.size22,
                                  ),
                                ),
                              ),
                            ),
                            iconButton(
                              iconPath: TImageName.doneMark,
                              padding: 0,
                              radius: 24.h,
                              onPressed: () async {
                                setState(() {
                                  isEdit = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  color: TAppColors.white,
                  height: Platform.isAndroid
                      ? null
                      : topSfarea > 20.h
                          ? topSfarea + 40.h
                          : 40.h,
                  child: CustomSafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(15).copyWith(
                          top: Platform.isAndroid
                              ? 0
                              : topSfarea > 20
                                  ? topSfarea - 5
                                  : 5,
                          bottom: 5.h),
                      child: SizedBox(
                        height: 30.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconButton(
                              bgColor: TAppColors.text4Color,
                              iconPath: TImageName.back,
                              radius: 24.h,
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Preview Post',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: getSemiBoldStyle(
                                    color: TAppColors.text1Color,
                                    fontSize: MyFonts.size22,
                                  ),
                                ),
                              ),
                            ),
                            iconButton(
                                bgColor: TAppColors.text4Color,
                                iconPath: TImageName.edit,
                                radius: 24.h,
                                onPressed: () async {
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    scr.jumpTo(
                                      scr.position.maxScrollExtent,
                                      // duration:
                                      //     const Duration(milliseconds: 250),
                                      // curve: Easing.linear
                                    );
                                  });
                                }),
                            SizedBox(width: 6.w),
                            iconButton(
                                bgColor: TAppColors.text4Color,
                                iconPath: TImageName.shareEpostIcon,
                                radius: 24.h,
                                onPressed: () async {
                                  shareWidgets(
                                      globalKey: globalKey,
                                      shareText:
                                          'Explore "${ref.watch(personalEventHomeController).homePersonalEventDetailsModel?.title ?? ''}" by ${ref.watch(personalEventHomeController).homePersonalEventDetailsModel?.createdBy?.displayName! ?? ""} on Happinest.\n$deeplink\n#Happinest');
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          Flexible(
            child: SingleChildScrollView(
              controller: scr,
              child: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: ShareScreenshotAsImage(
                  globalKey: globalKey,
                  child: SizedBox(
                    width: dwidth!,
                    height: postRatio * dwidth!,
                    child: Stack(
                      children: [
                        ref.watch(personalEventECardCtr).selectedImage != null
                            ? SizedBox(
                                width: dwidth!,
                                height: postRatio * dwidth!,
                                child: ref.watch(personalEventECardCtr).selectedImage,
                              )
                            : CachedRectangularNetworkImageWidget(
                                image: ref.watch(personalEventECardCtr).currentImage ?? '',
                                width: dwidth!,
                                height: postRatio * dwidth!),
                        Container(
                          height: 80.h,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.5),
                                Colors.transparent
                              ])),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: (postRatio * dwidth!) * 0.25 + 50,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent
                                ])),
                          ),
                        ),
                        isEdit && widget.isSingleImage == false
                            ? Center(
                                child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PersonalEventEcardImagePickerScreen(
                                                onImageUpload: () {},
                                              ))).then((value) {
                                    setState(() {
                                      isEdit = true;
                                    });
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 24,
                                  backgroundColor: TAppColors.text4Color,
                                  child: SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: Image.asset(
                                        TImageName.cameraIcon,
                                        fit: BoxFit.contain,
                                      )),
                                ),
                              ))
                            : const SizedBox.shrink(),
                        SizedBox(
                          height: postRatio * dwidth!,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TText(
                                    ref
                                            .watch(personalEventHomeController)
                                            .homePersonalEventDetailsModel
                                            ?.title ??
                                        '',
                                    color: TAppColors.white,
                                    fontSize: MyFonts.size30,
                                    fontWeight: FontWeight.bold),
                                ref
                                                .watch(personalEventHomeController)
                                                .homePersonalEventDetailsModel
                                                ?.venueAddress !=
                                            '' &&
                                        ref
                                                .watch(personalEventHomeController)
                                                .homePersonalEventDetailsModel
                                                ?.venueAddress !=
                                            null
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          CustomEcardRow(
                                            title: ref
                                                    .watch(personalEventHomeController)
                                                    .homePersonalEventDetailsModel
                                                    ?.venueAddress ??
                                                '',
                                            imagePath: TImageName.locationMarker,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  height: 10.h,
                                ),
                                CustomEcardRow(
                                  title: formatDateLong(ref
                                          .watch(personalEventHomeController)
                                          .homePersonalEventDetailsModel!
                                          .startDateTime!),
                                  imagePath: TImageName.calenderOutlinePngIcon,
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: (postRatio * dwidth!) * 0.25,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4)
                                        .copyWith(bottom: 8.h),
                                    child: isEdit
                                        ? SizedBox(
                                            height: (postRatio * dwidth!) * 0.25,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(right: 20, bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      const Spacer(),
                                                      TText('${noteController.text.length}/130',
                                                          color: TAppColors.white),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TCard(
                                                    border: true,
                                                    borderColor: TAppColors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(
                                                          horizontal: 10, vertical: 0),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: CTTextField(
                                                                isAutoFocus: true,
                                                                focusNode: focusNode,
                                                                maxLines: 50,
                                                                controller: noteController,
                                                                textInputFormatter: [
                                                                  LengthLimitingTextInputFormatter(
                                                                      130)
                                                                ],
                                                                onChanged: (p0) {
                                                                  setState(
                                                                      () {}); // Triggers rebuild to update counter
                                                                },
                                                                onTapOutside: (p0) {
                                                                  FocusScope.of(context).unfocus();
                                                                },
                                                                hintTextColor: TAppColors.white,
                                                                hint: TLabelStrings.abountLocation,
                                                                fontSize: MyFonts.size14,
                                                                fontColor: TAppColors.white,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        // ? SizedBox(
                                        //     height: (postRatio * dwidth!) * 0.25,
                                        //     child: StatefulBuilder(
                                        //       builder: (context, setState) => Column(
                                        //         mainAxisAlignment: MainAxisAlignment.start,
                                        //         crossAxisAlignment: CrossAxisAlignment.start,
                                        //         mainAxisSize: MainAxisSize.max,
                                        //         children: [
                                        //           Expanded(
                                        //             child: TCard(
                                        //                 child: Padding(
                                        //                   padding: const EdgeInsets.symmetric(
                                        //                       horizontal: 10, vertical: 0),
                                        //                   child: Column(
                                        //                     children: [
                                        //                       Expanded(
                                        //                         child: Padding(
                                        //                           padding:
                                        //                               const EdgeInsets.all(8.0),
                                        //                           child: CTTextField(
                                        //                               isAutoFocus: true,
                                        //                               focusNode: focusNode,
                                        //                               maxLines: 50,
                                        //                               controller: noteController,
                                        //                               // maxLength: 200,
                                        //                               textInputFormatter: [
                                        //                                 LengthLimitingTextInputFormatter(
                                        //                                     130)
                                        //                               ],
                                        //                               onChanged: (p0) {
                                        //                                 setState(() {});
                                        //                               },
                                        //                               onTapOutside: (p0) {
                                        //                                 FocusScope.of(context)
                                        //                                     .unfocus();
                                        //                               },
                                        //                               hintTextColor:
                                        //                                   TAppColors.white,
                                        //                               hint: TLabelStrings
                                        //                                   .abountLocation,
                                        //                               fontSize: MyFonts.size14,
                                        //                               fontColor: TAppColors.white),
                                        //                         ),
                                        //                       ),
                                        //                     ],
                                        //                   ),
                                        //                 ),
                                        //                 border: true,
                                        //                 borderColor: TAppColors.white),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   )
                                        : Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              noteController.text.isNotEmpty
                                                  ? TText(noteController.text,
                                                      color: TAppColors.white,
                                                      textAlign: TextAlign.left,
                                                      fontWeight: FontWeight.w600)
                                                  : const SizedBox(),
                                              // SizedBox(height: 5.h),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    TImageName.logoPngIcon, //appLogoWhite,
                                                    height: 30.h,
                                                    fit: BoxFit.cover,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
