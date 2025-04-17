import 'dart:async';
import 'dart:math' as math;
import 'package:Happinest/core/api_urls.dart';
import 'package:Happinest/location/location_client.dart';
import 'package:flutter/services.dart';
import 'package:Happinest/common/common_imports/common_imports.dart';
import 'package:Happinest/utility/API/fetch_api.dart';


class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key, required this.onTap, required this.email});
  final String email;
  final Function(String otp) onTap;

  @override
  State<EmailVerifyPage> createState() => _EmailVerifyPageState();
}

class _EmailVerifyPageState extends State<EmailVerifyPage> {
  final GlobalKey<_EmailVerifyPageState> customWidgetKey = GlobalKey();
  bool isShowError = false;
  bool isExpired = false;
  late String errorMesage = '';
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    errorMesage = TMessageStrings.emptyFiled;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Error Message ---
  errorMessageFuction() async {
    setState(() {
      isShowError = true;
    });
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isShowError = false;
      });
    });
  }

  Future<bool> resendOtp() async {
    String url = ApiUrl.getOtp;
    late bool status;
    otpController.text = '';
    await ApiService.fetchApi(
        context: context,
        url: url,
        params: {'email': widget.email},
        onSuccess: (response) {
          status = true;
        },
        onError: (res) {
          status = false;
        });
    return status;
  }

  void showAlertMessage(
    BuildContext context,
  ) {
    showDialog<String>(
        context: context,
        builder: (context) => TDialog(
              title: "Alert!",
              actionButtonText: TButtonLabelStrings.yesButton,
              bodyText: "Are you sure want to Cancel Signup?",
              onActionPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, Routes.singupRoute, (routes) => false);
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            const Positioned.fill(
              child: TBackgroundImage(imageName: TImageName.appBackground),
            ),
            Positioned(
              top: 40, // Adjust vertical positioning if needed
              right: 16, // Align to the right side
              child: IconButton(
                icon: const Icon(Icons.cancel_outlined, color: TAppColors.white54, size: 28),
                onPressed: () {
                  if (mounted) {
                    showAlertMessage(context);
                    // Navigator.pushNamedAndRemoveUntil(
                    //     context, Routes.singupRoute, (routes) => false);
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 70.h, 16, height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TAppTopImage(),
                  TText(TLabelStrings.verify,
                      fontSize: MyFonts.size32, fontWeight: FontWeightManager.bold),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: TText(TLabelStrings.weSent,
                        fontSize: MyFonts.size16,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeightManager.medium),
                  ),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  if (isShowError) CustomErrorWidget(errorMessage: errorMesage),
                  TTextField(
                      controller: otpController,
                      hintText: 'Enter OTP',
                      onChanged: (p0) {
                        setState(() {});
                      },
                      onTapOutside: (p0) {
                        FocusScope.of(context).unfocus();
                      },
                      textInputType: TextInputType.number,
                      inputFormatter: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      inputboxBoder: TAppColors.white),
                  SizedBox(
                    height: 0.04.sh,
                  ),
                  !isExpired
                      ? Column(
                          children: [
                            SizedBox(
                              child: Stack(
                                children: [
                                  AnimatedCircle(
                                    key: customWidgetKey,
                                    session: (isSessionExpired) {
                                      setState(() {
                                        isExpired = isSessionExpired;
                                      });
                                    },
                                  ),
                                  ClipPath(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: TAppColors.white),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 0.04.sh,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TText(TLabelStrings.notReceived,
                                    fontSize: MyFonts.size16,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeightManager.medium),
                                GestureDetector(
                                  onTap: () {
                                    resendOtp().then((value) {
                                      if (value) {
                                        setState(() {
                                          isExpired = true;
                                        });
                                        WidgetsBinding.instance.addPostFrameCallback((_) {
                                          if (isExpired) {
                                            setState(() {
                                              isExpired = false;
                                            });
                                          }
                                        });
                                      }
                                    });
                                  },
                                  child: TText(TLabelStrings.reSend,
                                      decoration: TextDecoration.combine([
                                        TextDecoration.underline,
                                      ]),
                                      decorationColor: TAppColors.white,
                                      fontSize: MyFonts.size16,
                                      textAlign: TextAlign.center,
                                      fontWeight: FontWeightManager.bold),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TText(TLabelStrings.sessionExpried,
                                fontSize: MyFonts.size16,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeightManager.medium),
                            GestureDetector(
                              onTap: () {
                                resendOtp().then((value) {
                                  value
                                      ? setState(() {
                                          isExpired = false;
                                        })
                                      : null;
                                });
                              },
                              child: TText(TLabelStrings.reSend,
                                  decoration: TextDecoration.combine([
                                    TextDecoration.underline,
                                  ]),
                                  decorationColor: TAppColors.white,
                                  fontSize: MyFonts.size16,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeightManager.bold),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 0.03.sh,
                  ),
                  otpController.text.length < 6
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(TDimension.buttonCornerRadius),
                          child: ColorFiltered(
                            colorFilter: const ColorFilter.mode(
                                Colors.grey,
                                BlendMode
                                    .saturation), // Apply a grayscale filter for disabled state

                            child: TButton(
                              fontSize: MyFonts.size16,
                              onPressed: () {},
                              title: TButtonLabelStrings.continueText,
                              buttonBackground: TAppColors.selectionColor,
                            ),
                          ),
                        )
                      : TButton(
                          fontSize: MyFonts.size16,
                          onPressed: () {
                            widget.onTap(otpController.text);
                          },
                          title: TButtonLabelStrings.continueText,
                          buttonBackground: TAppColors.selectionColor,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedCircle extends StatefulWidget {
  const AnimatedCircle({super.key, required this.session});
  final Function(bool isSessionExpired) session;
  @override
  _AnimatedCircleState createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  bool isExpired = false;
  int second = 180;
  int currSecond = 180;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: second), // Adjust the duration as needed
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          currSecond = 0;
          _controller.stop();
          isExpired = true;
          widget.session(isExpired);
        }
      });

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        currSecond--;
        currSecond == 0 ? _timer.cancel() : null;
      });
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: CustomPaint(
        painter: CirclePainter(_animation.value * 360),
        child: Center(child: TText(currSecond.toString())),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    currSecond = 0;
    _controller.stop();
    isExpired = true;
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double percentage;

  CirclePainter(this.percentage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = TAppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    double startAngle = math.pi + (math.pi / 2);
    double endAngle = 2 * math.pi * (percentage / 360);

    canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height), startAngle, endAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
