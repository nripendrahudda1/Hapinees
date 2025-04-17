import 'package:Happinest/common/widgets/custom_safearea.dart';
import 'package:Happinest/modules/events/event_homepage/wedding_event/controller/wedding_event_home_controller.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/common/widgets/cached_retangular_network_image.dart';
import 'package:Happinest/modules/events/e-card/controllers/wedding_event_ecard_controller.dart';
import 'package:Happinest/modules/events/e-card/views/wedding_event/wedding_ecard_image_picker_screen.dart';
import 'package:Happinest/modules/events/e-card/widgets/custom_ecard_row.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../../../../common/common_functions/datetime_functions.dart';
import '../../../../../common/widgets/iconButton.dart';
import '../../../../../core/api_urls.dart';
import '../../../../../utility/constants/constants.dart';

class WeddingECardScreen extends ConsumerStatefulWidget {
  const WeddingECardScreen(
      {super.key,
      });

  @override
  ConsumerState<WeddingECardScreen> createState() => _WeddingECardScreenState();
}

class _WeddingECardScreenState extends ConsumerState<WeddingECardScreen> {
  final globalKey = GlobalKey();
  TextEditingController noteController = TextEditingController();
  bool isEdit = false;
  int count = 1;
  String deeplink = ApiUrl.baseURL;
  String? currImage;
  double postRatio = 16 / 9;
  FocusNode focusNode = FocusNode();
  ScrollController scr = ScrollController();
  @override
  void initState() {
    super.initState();
    initiallize();
  }

  initiallize() async {
    currImage = ref.read(weddingEventECardCtr).weddingAllImagesModel?.weddingPhotoList?[0].imageUrl;
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
      body: Stack(
        children: [
          isEdit
              ? Container(
            color: TAppColors.white,
            height: Platform.isAndroid ? null : topSfarea > 20.h ? topSfarea + 40.h : 40.h,
            child: CustomSafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15).copyWith(
                    top: Platform.isAndroid ? 0 : topSfarea > 20 ? topSfarea - 5 : 5, bottom: 5.h
                ),
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
            height: Platform.isAndroid ? null : topSfarea > 20.h ? topSfarea + 40.h : 40.h,
            child: CustomSafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15).copyWith(
                    top: Platform.isAndroid ? 0 : topSfarea > 20 ? topSfarea - 5 : 5, bottom: 5.h
                ),
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
                          onPressed: () async {
                            setState(() {
                              isEdit = !isEdit;
                            });
                            Future.delayed(
                                const Duration(milliseconds: 500), () {
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
                          onPressed: () async {
                            shareWidgets(
                                globalKey: globalKey,
                                shareText:
                                'Explore "${ref.watch(weddingEventHomeController).homeWeddingDetails?.title ?? ''}" by ${ref.watch(weddingEventHomeController).homeWeddingDetails?.createdBy?.displayName! ?? ""} on Happinest.\n$deeplink\n#Happinest');
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: topSfarea > 20 ? topSfarea + 40.h : 40.h,
            ),
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
                        ref.watch(weddingEventECardCtr).selectedImage != null
                            ? SizedBox(
                          width: dwidth!,
                          height: postRatio * dwidth!,
                          child: ref.watch(weddingEventECardCtr).selectedImage ,
                        )
                            :
                        CachedRectangularNetworkImageWidget(
                            image: ref.watch(weddingEventECardCtr).currentImage ?? '',
                            width: dwidth!,
                            height: postRatio * dwidth!),
                        Container(
                          height: 100.h,
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
                        isEdit
                            ? Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WeddingEcardImagePickerScreen(
                                            onImageUpload: (){},
                                        ))).then(
                                        (value) {
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
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                TText(
                                    ref.watch(weddingEventHomeController).homeWeddingDetails?.title??
                                        '',
                                    color: TAppColors.white,
                                    fontSize: MyFonts.size30,
                                    fontWeight: FontWeight.bold),
                                ref.watch(weddingEventHomeController).homeWeddingDetails?.venueAddress!= '' &&
                                    ref.watch(weddingEventHomeController).homeWeddingDetails?.venueAddress!= null
                                    ?
                                Column(
                                  children: [
                                    SizedBox(height: 10.h,),
                                    CustomEcardRow(
                                      title: ref.watch(weddingEventHomeController).homeWeddingDetails?.venueAddress??
                                          '',
                                      imagePath: TImageName.locationMarker,
                                    ),
                                  ],
                                ): const SizedBox(),
                                SizedBox(height: 10.h,),
                                CustomEcardRow(
                                  title: ref.watch(weddingEventHomeController).homeWeddingDetails?.startDateTime != null ? formatDateLong(ref.watch(weddingEventHomeController).homeWeddingDetails!.startDateTime!)??
                                      '' : '',
                                  imagePath: TImageName.calenderOutlinePngIcon,
                                ),
                                const Spacer(),
                                SizedBox(
                                  height: (postRatio * dwidth!) * 0.25,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4)
                                        .copyWith(bottom: 8.h),
                                    child: isEdit
                                        ? SizedBox(
                                      height:
                                      (postRatio * dwidth!) * 0.25,
                                      child: StatefulBuilder(
                                        builder: (context, setState) =>
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: TCard(
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            10,
                                                            vertical: 0),
                                                        child: Column(
                                                          children: [
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    8.0),
                                                                child:
                                                                CTTextField(
                                                                    isAutoFocus:
                                                                    true,
                                                                    focusNode:
                                                                    focusNode,
                                                                    maxLines:
                                                                    50,
                                                                    controller:
                                                                    noteController,
                                                                    // maxLength: 200,
                                                                    textInputFormatter: [
                                                                      LengthLimitingTextInputFormatter(130)
                                                                    ],
                                                                    onChanged:
                                                                        (p0) {
                                                                      setState(() {});
                                                                    },
                                                                    onTapOutside:
                                                                        (p0) {
                                                                      FocusScope.of(context).unfocus();
                                                                        },
                                                                    hintTextColor: TAppColors
                                                                        .white,
                                                                    hint: TLabelStrings
                                                                        .abountLocation,
                                                                    fontSize: MyFonts
                                                                        .size14,
                                                                    fontColor:
                                                                    TAppColors.white),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Spacer(),
                                                                TText(
                                                                    '${noteController.text.length}/130',
                                                                    color: TAppColors
                                                                        .white),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      border: true,
                                                      borderColor:
                                                      TAppColors.white),
                                                ),
                                              ],
                                            ),
                                      ),
                                    )
                                        : Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        noteController.text.isNotEmpty
                                            ? TText(noteController.text,
                                            color: TAppColors.white,
                                            textAlign:
                                            TextAlign.center,
                                            fontWeight:
                                            FontWeight.w600)
                                            : const SizedBox(),
                                        // SizedBox(height: 5.h),
                                        Row(
                                          children: [
                                            const Spacer(),
                                            Image.asset(
                                              TImageName.appLogoWhite,
                                              height: 28.h,
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

Future<void> shareWidgets(
    {required GlobalKey globalKey, required String shareText}) async {
  EasyLoading.show();
  final RenderRepaintBoundary boundary =
  globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: 1.0);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  var file = File(
      '${(await getTemporaryDirectory()).path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
  file = await file.writeAsBytes(byteData!.buffer.asUint8List());
  EasyLoading.dismiss();
  // SocialShare.shareOptions(shareText, imagePath: file.path);
  /// TODO Share plus commented
  Share.shareXFiles(
    text: shareText,
    [XFile(file.path)],
  );
}

class ShareScreenshotAsImage extends StatelessWidget {
  final Widget child;
  final GlobalKey globalKey;

  const ShareScreenshotAsImage({
    super.key,
    required this.child,
    required this.globalKey,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(key: globalKey, child: Container(child: child));
  }
}
